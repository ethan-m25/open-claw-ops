#!/usr/bin/env python3
import json, time, hashlib
from pathlib import Path
from datetime import datetime

SHARED = Path("/Users/clawii/.openclaw/shared")
REQUESTS = SHARED / "requests"
APPROVALS = SHARED / "approvals"
OPS = SHARED / "ops"

def sha256_file(p: Path) -> str:
    h = hashlib.sha256()
    with p.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

def now() -> str:
    return datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")

def write_receipt(request_path: Path, status: str, detail: dict):
    OPS.mkdir(parents=True, exist_ok=True)
    rid = request_path.stem
    out = OPS / f"receipt.{rid}.{int(time.time())}.json"
    payload = {
        "time": now(),
        "request": str(request_path),
        "request_sha256": sha256_file(request_path),
        "status": status,
        "detail": detail,
    }
    out.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return out

def main():
    print(f"[watcher] start {now()}  requests={REQUESTS} approvals={APPROVALS} ops={OPS}")
    REQUESTS.mkdir(parents=True, exist_ok=True)
    APPROVALS.mkdir(parents=True, exist_ok=True)

    # Skeleton only: execution logic will be added after we define request/approval schema.
    while True:
        for req in sorted(REQUESTS.glob("*.json")):
            rid = req.stem
            approval = APPROVALS / f"{rid}.approved.json"
            if approval.exists():
                # Placeholder: do not execute anything yet.
                receipt = write_receipt(req, "APPROVED_SEEN_NOOP", {"approval": str(approval)})
                # Move request aside to avoid repeated processing
                done_dir = REQUESTS / "_processed"
                done_dir.mkdir(exist_ok=True)
                req.rename(done_dir / req.name)
                print(f"[watcher] NOOP processed rid={rid} receipt={receipt}")
        time.sleep(3)

if __name__ == "__main__":
    main()
