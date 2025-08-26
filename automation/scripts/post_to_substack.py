#!/usr/bin/env python3
import os, sys, json, pathlib, smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from helpers import load_env
def load_package(package_json_path):
    data = json.loads(pathlib.Path(package_json_path).read_text(encoding="utf-8"))
    html = pathlib.Path(data["body_html_path"]).read_text(encoding="utf-8")
    return data, html
def build_message(sender, recipient, subject, html_body):
    msg = MIMEMultipart("alternative")
    msg["From"] = sender
    msg["To"] = recipient
    msg["Subject"] = subject
    msg.attach(MIMEText(html_body, "html", "utf-8"))
    return msg
def main(package_json_path):
    load_env()
    substack_email = os.getenv("SUBSTACK_POST_EMAIL")
    smtp_host = os.getenv("SMTP_HOST")
    smtp_port = int(os.getenv("SMTP_PORT", "587"))
    smtp_user = os.getenv("SMTP_USER")
    smtp_pass = os.getenv("SMTP_PASSWORD")
    if not all([substack_email, smtp_host, smtp_user, smtp_pass]):
        raise SystemExit("Substack email or SMTP credentials missing")
    data, html = load_package(package_json_path)
    canonical = data.get("canonical_url") or ""
    title = data["title"]
    composed_html = f'<p><em>Canonical: <a href="{canonical}">{canonical}</a></em></p>{html}'
    sender = smtp_user
    recipient = substack_email
    msg = build_message(sender, recipient, title, composed_html)
    with smtplib.SMTP(smtp_host, smtp_port) as server:
        server.starttls()
        server.login(smtp_user, smtp_pass)
        server.sendmail(sender, [recipient], msg.as_string())
    print("OK")
if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("usage: post_to_substack.py path/to/package.json")
    main(sys.argv[1])
