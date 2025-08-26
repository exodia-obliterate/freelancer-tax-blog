#!/usr/bin/env python3
import sys, subprocess, pathlib
ROOT = pathlib.Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / "scripts"
def run(cmd):
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    out, err = p.communicate()
    if p.returncode != 0:
        raise SystemExit(err.strip() or "failed")
    return out.strip()
def main(md_path, targets):
    extractor = str(SCRIPTS / "extract_post.py")
    package_path = run([extractor, md_path])
    if "medium" in targets:
        run([str(SCRIPTS / "post_to_medium.py"), package_path])
    if "substack" in targets:
        run([str(SCRIPTS / "post_to_substack.py"), package_path])
    print(package_path)
if __name__ == "__main__":
    if len(sys.argv) < 2:
        raise SystemExit("usage: crosspost.py content/posts/my-post.md [medium] [substack]")
    md = sys.argv[1]
    targets = sys.argv[2:] if len(sys.argv) > 2 else ["medium", "substack"]
    main(md, targets)
