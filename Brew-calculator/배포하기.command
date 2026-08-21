#!/bin/bash
cd "$(dirname "$0")"
echo
echo "──────────────────────────────"
echo "   추출 계산기 배포"
echo "──────────────────────────────"
echo
echo "무엇을 바꿨는지 한 줄로 적어주세요."
echo "그냥 엔터를 누르면 날짜로 자동 기록됩니다."
echo
printf "> "
read -r msg
echo
./deploy.sh "$msg" || echo "실패했습니다. 위 메시지를 확인해주세요."
echo
echo "이 창은 닫으셔도 됩니다."
