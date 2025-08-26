import os, json, pathlib, requests
from dotenv import load_dotenv
ROOT = pathlib.Path(__file__).resolve().parents[1]
ENV_PATH = ROOT / ".env"
TMP_DIR = ROOT / "tmp"
def load_env():
    load_dotenv(ENV_PATH)
def ensure_tmp():
    TMP_DIR.mkdir(parents=True, exist_ok=True)
    return TMP_DIR
def write_json(obj, path):
    pathlib.Path(path).write_text(json.dumps(obj, ensure_ascii=False, indent=2), encoding="utf-8")
def read_text(path):
    return pathlib.Path(path).read_text(encoding="utf-8")
def write_text(path, text):
    pathlib.Path(path).write_text(text, encoding="utf-8")
def http_post(url, headers=None, json_body=None, data=None):
    return requests.post(url, headers=headers, json=json_body, data=data, timeout=60)
def http_get(url, headers=None, params=None):
    return requests.get(url, headers=headers, params=params, timeout=60)
