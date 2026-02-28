#!/usr/bin/env bash
set -euo pipefail

REMOTE="${1:-origin}"
BRANCH="${2:-main}"

# 1) 找最新 structural-* tag（按创建时间）
LATEST_TAG="$(git for-each-ref --sort=-creatordate --format '%(refname:short)' refs/tags/structural-* 2>/dev/null | head -n 1 || true)"
if [[ -z "${LATEST_TAG}" ]]; then
  echo "ERROR: 没找到 structural-* tag。"
  exit 1
fi

CURRENT="$(git rev-parse --short HEAD)"
TARGET="$(git rev-parse --short "${LATEST_TAG}")"

echo "Current HEAD: ${CURRENT}"
echo "Target tag : ${LATEST_TAG} (${TARGET})"
echo "Remote/Br  : ${REMOTE}/${BRANCH}"
echo
echo "DRY-RUN (不会真的回滚)："
echo "  git fetch ${REMOTE} ${BRANCH}"
echo "  git reset --hard ${LATEST_TAG}"
echo "  git push ${REMOTE} HEAD:${BRANCH} --force-with-lease"
echo
echo "如果你确认要执行真实回滚，请运行："
echo "  RUN=1 bash ops/rollback-to-latest-structural-tag.sh ${REMOTE} ${BRANCH}"
echo

if [[ "${RUN:-0}" != "1" ]]; then
  exit 0
fi

echo "=== EXECUTE ROLLBACK ==="
git fetch "${REMOTE}" "${BRANCH}"
git reset --hard "${LATEST_TAG}"
git push "${REMOTE}" "HEAD:${BRANCH}" --force-with-lease

echo "DONE ✅  已回滚到 ${LATEST_TAG}"
