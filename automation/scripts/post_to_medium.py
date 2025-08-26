#!/usr/bin/env python3
import os, sys, json, pathlib
from helpers import load_env, http_get, http_post

API_BASE = "https://api.medium.com/v1"

def get_user_id(token, provided_id):
    if provided_id:
        return provided_id
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json", "Accept": "application/json"}
    r = http_get(f"{API_BASE}/me", headers=headers)
    r.raise_for_status()
    return r.json()["data"]["id"]

def load_package(package_json_path):
    data = json.loads(pathlib.Path(package_json_path).read_text(encoding="utf-8"))
    html = pathlib.Path(data["body_html_path"]).read_text(encoding="utf-8")
    return data, html

def write_import_pack(data, html, out_path):
    payload = {
        "title": data["title"],
        "canonical_url": data.get("canonical_url") or "",
        "tags": data.get("tags", [])[:5],
        "html": html
    }
    pathlib.Path(out_path).write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
    print(out_path)

def main(package_json_path):
    load_env()
    token = os.getenv("MEDIUM_TOKEN", "").strip()
    user_id = os.getenv("MEDIUM_USER_ID", "").strip()
    data, html = load_package(package_json_path)
    out_pack = str(pathlib.Path(package_json_path).with_suffix(".medium.import.json"))
    if not token:
        write_import_pack(data, html, out_pack)
        sys.exit(0)
    try:
        uid = get_user_id(token, user_id)
        headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json", "Accept": "application/json"}
        payload = {
            "title": data["title"],
            "contentFormat": "html",
            "content": html,
            "publishStatus": "draft",
            "tags": data.get("tags", [])[:5],
        }
        if data.get("canonical_url"):
            payload["canonicalUrl"] = data["canonical_url"]
        r = http_post(f"{API_BASE}/users/{uid}/posts", headers=headers, json_body=payload)
        if r.status_code == 401:
            write_import_pack(data, html, out_pack)
            sys.exit(0)
        r.raise_for_status()
        print(r.text)
    except Exception:
        write_import_pack(data, html, out_pack)
        sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("usage: post_to_medium.py path/to/package.json")
    main(sys.argv[1])
