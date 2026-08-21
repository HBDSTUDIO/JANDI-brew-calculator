#!/bin/bash
# 사용법:  ./deploy.sh "커밋 메시지"
set -e
cd "$(dirname "$0")"

cur=$(sed -n 's/.*brewcalc-v\([0-9]\+\).*/\1/p' sw.js | head -1)
if [ -z "$cur" ]; then echo "sw.js 에서 캐시 버전을 찾지 못했습니다."; exit 1; fi
next=$((cur + 1))
sed -i '' "s/brewcalc-v$cur/brewcalc-v$next/g" sw.js
echo "서비스워커 캐시: v$cur -> v$next"

git add -A
if git diff --cached --quiet; then
  echo "변경 사항이 없습니다."
  exit 0
fi
git commit -m "${1:-update} (sw v$next)"
git push
echo
echo "완료. 1~2분 후 반영됩니다."
