#!/usr/bin/env python3
import json, time, hashlib
from pathlib import Path
from datetime import datetime
import subprocess

SHARED = Path("/Users/clawii/.openclaw/shared")
REQUESTS = SHARED / "requests"
APPROVALS = SHARED / "approvals"
OPS = SHARED / "ops"

# Whitelisted actions (owner-approved only)
WHITELIST = {
    "mirror_inbound_media": {
        "cmd": ["/bin/bash", "/Users/clawii/open-claw-ops/ops/mirror_inbound_media.sh"],
        "timeout": 120,
    }
}

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

def run_action(action_type: str):
    if action_type == "noop":
        return ("APPROVED_SEEN_NOOP", {})
    spec = WHITELIST.get(action_type)
    if not spec:
        return ("REJECTED_UNKNOWN_ACTION", {"action": action_type})

    try:
        r = subprocess.run(
            spec["cmd"],
            capture_output=True,
            text=True,
            timeout=spec.get("timeout", 120),
        )
        return ("EXECUTED_OK" if r.returncode == 0 else "EXECUTED_ERROR", {
            "action": action_type,
            "returncode": r.returncode,
            "stdout": (r.stdout or "")[-2000:],
            "stderr": (r.stderr or "")[-2000:],
        })
    except Exception as e:
        return ("EXECUTED_EXCEPTION", {"action": action_type, "error": str(e)})

def main():
    print(f"[watcher] start {now()}  requests={REQUESTS} approvals={APPROVALS} ops={OPS}", flush=True)
    REQUESTS.mkdir(parents=True, exist_ok=True)
    APPROVALS.mkdir(parents=True, exist_ok=True)

    while True:
        for req in sorted(REQUESTS.glob("*.json")):
            rid = req.stem
            approval = APPROVALS / f"{rid}.approved.json"
            if not approval.exists():
                continue

            try:
                req_obj = json.loads(req.read_text(encoding="utf-8"))
            except Exception as e:
                receipt = write_receipt(req, "REQUEST_INVALID_JSON", {"error": str(e), "approval": str(approval)})
            else:
                action_type = req_obj.get("type", "noop")
                status, detail = run_action(action_type)
                detail.update({"approval": str(approval), "request_type": action_type})
                receipt = write_receipt(req, status, detail)

            done_dir = REQUESTS / "_processed"
            done_dir.mkdir(exist_ok=True)
            req.rename(done_dir / req.name)
            print(f"[watcher] processed rid={rid} status={status} receipt={receipt}", flush=True)

        time.sleep(3)

if __name__ == "__main__":
    main()
