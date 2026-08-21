#!/bin/bash
# 사용법:  ./deploy.sh              -> 메시지 자동(날짜)
#          ./deploy.sh "바꾼 내용"  -> 메시지 직접
set -e
cd "$(dirname "$0")"

msg="$1"
if [ -z "$msg" ]; then msg="$(date '+%Y-%m-%d %H:%M') 수정"; fi

cur=$(grep -o 'brewcalc-v[0-9][0-9]*' sw.js | head -1 | sed 's/.*v//')
if [ -z "$cur" ]; then echo "오류: sw.js 에서 'brewcalc-v<숫자>' 를 찾지 못했습니다."; exit 1; fi
next=$((cur + 1))
sed -i '' "s/brewcalc-v${cur}\\([^0-9]\\)/brewcalc-v${next}\\1/g; s/brewcalc-v${cur}\$/brewcalc-v${next}/g" sw.js
check=$(grep -o 'brewcalc-v[0-9][0-9]*' sw.js | head -1 | sed 's/.*v//')
if [ "$check" != "$next" ]; then echo "오류: 버전 갱신 실패 (기대 v$next, 실제 v$check)"; exit 1; fi

git add -A
if git diff --cached --quiet; then
  echo "바뀐 파일이 없습니다. 올릴 게 없어요."
  exit 0
fi
echo "서비스워커 캐시: v$cur -> v$next"
git commit -q -m "$msg (sw v$next)"
echo "기록: $msg"
git push
echo "GitHub 올림 완료"

# Firebase 가 설정돼 있으면 같이 배포
if [ -f .firebaserc ] && command -v firebase >/dev/null 2>&1; then
  echo
  echo "Firebase 배포 중..."
  firebase deploy --only hosting
  echo "Firebase 배포 완료"
fi

echo
echo "완료! 1~2분 뒤 아이폰에서 반영됩니다."
