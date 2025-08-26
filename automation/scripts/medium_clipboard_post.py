#!/usr/bin/env python3
import os, sys, json, pathlib, subprocess

def pbcopy(text):
    p = subprocess.Popen(['pbcopy'], stdin=subprocess.PIPE)
    p.communicate(input=text.encode('utf-8'))

def load_package(package_json_path):
    data = json.loads(pathlib.Path(package_json_path).read_text(encoding="utf-8"))
    html = pathlib.Path(data["body_html_path"]).read_text(encoding="utf-8")
    return data, html

def main(package_json_path):
    data, html = load_package(package_json_path)
    canon = data.get("canonical_url") or ""
    title = data.get("title") or ""
    pre = ""
    if canon:
        pre = f'<p><em>Canonical: <a href="{canon}">{canon}</a></em></p>'
    combined = f"{pre}\n{html}"
    pbcopy(combined)
    print("HTML copied to clipboard.")
    if canon:
        print(f"Canonical URL: {canon}")
    subprocess.run(["open", "https://medium.com/new-story"], check=False)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("usage: medium_clipboard_post.py automation/tmp/<slug>.json")
    main(sys.argv[1])
