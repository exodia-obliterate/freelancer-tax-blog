#!/usr/bin/env python3
import os, sys, json, datetime, pathlib
from markdown import markdown
import yaml, toml
from bs4 import BeautifulSoup
from helpers import load_env, ensure_tmp, write_json, write_text
def split_front_matter(text):
    if text.startswith("---"):
        parts = text.split("---", 2)
        if len(parts) >= 3:
            return ("yaml", parts[1].strip(), parts[2].strip())
    if text.startswith("+++"):
        parts = text.split("+++", 2)
        if len(parts) >= 3:
            return ("toml", parts[1].strip(), parts[2].strip())
    raise SystemExit("No front matter found")
def parse_front_matter(kind, fm_text):
    if kind == "yaml":
        return yaml.safe_load(fm_text) or {}
    if kind == "toml":
        return toml.loads(fm_text) or {}
    return {}
def slug_from_path(path):
    return pathlib.Path(path).stem
def ensure_list(x):
    if x is None:
        return []
    if isinstance(x, list):
        return x
    return [str(x)]
def normalize_html(html):
    soup = BeautifulSoup(html, "html.parser")
    return str(soup)
def main(md_path):
    load_env()
    base = os.getenv("BLOG_BASE_URL", "").rstrip("/")
    default_tags = [t.strip() for t in os.getenv("DEFAULT_TAGS", "").split(",") if t.strip()]
    md_text = pathlib.Path(md_path).read_text(encoding="utf-8")
    kind, fm_text, body_md = split_front_matter(md_text)
    fm = parse_front_matter(kind, fm_text)
    title = fm.get("title") or fm.get("Title") or slug_from_path(md_path).replace("-", " ").title()
    date = fm.get("date") or datetime.datetime.utcnow().isoformat()
    tags = ensure_list(fm.get("tags") or fm.get("keywords") or fm.get("Keywords"))
    if not tags and default_tags:
        tags = default_tags
    slug = fm.get("slug") or slug_from_path(md_path)
    canonical_url = f"{base}/{slug}/" if base else ""
    html_body = markdown(body_md, extensions=["extra", "smarty", "toc"])
    html_body = normalize_html(html_body)
    tmp = ensure_tmp()
    write_text(tmp / f"{slug}.html", html_body)
    json_out = {
        "title": title,
        "date": str(date),
        "tags": tags,
        "slug": slug,
        "canonical_url": canonical_url,
        "body_html_path": str((tmp / f"{slug}.html").resolve()),
    }
    write_json(json_out, tmp / f"{slug}.json")
    print(str((tmp / f"{slug}.json").resolve()))
if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("usage: extract_post.py path/to/post.md")
    main(sys.argv[1])
