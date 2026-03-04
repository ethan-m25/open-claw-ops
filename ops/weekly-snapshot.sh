#!/usr/bin/env bash
# weekly-snapshot.sh — kisame 每周日快照三代理 workspace 核心 MD 文件
# 触发：cron 每周日 09:00，或手动执行
# 产出：~/open-claw-ops/snapshots/YYYY-WW/

set -euo pipefail

REPO_DIR="$HOME/open-claw-ops"
WORKSPACE_BASE="$HOME/.openclaw"
WEEK=$(date +%Y-W%W)
SNAPSHOT_DIR="$REPO_DIR/snapshots/$WEEK"

echo "[weekly-snapshot] 开始快照 week=$WEEK"

mkdir -p "$SNAPSHOT_DIR/itachi" "$SNAPSHOT_DIR/kisame" "$SNAPSHOT_DIR/zetsu"

copy_if_exists() {
  local src="$1"
  local dst="$2"
  if [ -f "$src" ]; then
    cp "$src" "$dst"
    echo "  copied: $src → $dst"
  else
    echo "  skip (not found): $src"
  fi
}

# itachi
for f in SOUL.md TOOLS.md AGENTS.md ORCH.md; do
  copy_if_exists "$WORKSPACE_BASE/workspace-itachi/$f" "$SNAPSHOT_DIR/itachi/$f"
done

# kisame
for f in SOUL.md TOOLS.md AGENTS.md; do
  copy_if_exists "$WORKSPACE_BASE/workspace-kisame/$f" "$SNAPSHOT_DIR/kisame/$f"
done

# zetsu
for f in SOUL.md TOOLS.md AGENTS.md; do
  copy_if_exists "$WORKSPACE_BASE/workspace-zetsu/$f" "$SNAPSHOT_DIR/zetsu/$f"
done

echo "[weekly-snapshot] 快照完成 → $SNAPSHOT_DIR"

# 提交到 git
cd "$REPO_DIR"
if git diff --quiet && git diff --cached --quiet && [ -z "$(git status --porcelain snapshots/)" ]; then
  echo "[weekly-snapshot] 无变化，跳过 commit"
  exit 0
fi

git add "snapshots/$WEEK/"
git commit -m "ops: weekly snapshot $WEEK"
git push origin main
echo "[weekly-snapshot] 已推送到 GitHub"
