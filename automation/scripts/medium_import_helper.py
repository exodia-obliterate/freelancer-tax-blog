#!/usr/bin/env python3
import os, sys, json, subprocess, pathlib

def pbcopy(text):
    p = subprocess.Popen(['pbcopy'], stdin=subprocess.PIPE)
    p.communicate(input=text.encode('utf-8'))

def main(package_json_path):
    data = json.loads(pathlib.Path(package_json_path).read_text(encoding="utf-8"))
    canon = data.get("canonical_url") or ""
    print(canon)
    if canon:
        pbcopy(canon)
        subprocess.run(["open", "https://medium.com/p/import"], check=False)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("usage: medium_import_helper.py path/to/package.json")
    main(sys.argv[1])
