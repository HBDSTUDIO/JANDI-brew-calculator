#!/bin/bash
# 사용법:  ./deploy.sh "커밋 메시지"
# 서비스워커 캐시 버전을 올리고 커밋 후 push 합니다.
set -e
cd "$(dirname "$0")"

cur=$(grep -o 'brewcalc-v[0-9][0-9]*' sw.js | head -1 | sed 's/.*v//')
if [ -z "$cur" ]; then
  echo "오류: sw.js 에서 'brewcalc-v<숫자>' 를 찾지 못했습니다."
  exit 1
fi
next=$((cur + 1))
sed -i '' "s/brewcalc-v${cur}\\([^0-9]\\)/brewcalc-v${next}\\1/g; s/brewcalc-v${cur}\$/brewcalc-v${next}/g" sw.js

check=$(grep -o 'brewcalc-v[0-9][0-9]*' sw.js | head -1 | sed 's/.*v//')
if [ "$check" != "$next" ]; then
  echo "오류: 버전 갱신 실패 (기대 v$next, 실제 v$check)"
  exit 1
fi
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
