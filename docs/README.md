# 추출 기록 계산기 (PWA)

로그인 없이 열리고, 홈 화면에 앱처럼 추가되고, 첫 로딩 후에는 오프라인으로 동작합니다.

## 파일
- `index.html` — 앱 본체 (외부 리소스 0개)
- `manifest.webmanifest` — 앱 이름 / 아이콘 / 전체화면 설정
- `sw.js` — 서비스워커. 오프라인 캐시
- `icon-192.png`, `icon-512.png` — 홈 화면 아이콘
- `robots.txt` — 검색 노출 차단

## A. GitHub Pages
```
새 repo 생성 → 이 폴더의 파일 전부 업로드 → Settings → Pages
  Source: Deploy from a branch / Branch: main / 폴더: / (root)
```
주소: `https://<계정>.github.io/<repo>/`

무료 계정은 **public repo만** Pages를 쓸 수 있습니다. private repo로 배포하려면 유료 플랜이 필요합니다.

## B. Firebase Hosting (GCP)
```bash
npm i -g firebase-tools
firebase login
cd brew-calc-pwa
firebase init hosting      # public 디렉터리: . / SPA: No / 자동 빌드: No
firebase deploy
```
주소: `https://<프로젝트>.web.app`

무료 Spark 플랜으로 충분합니다(저장 10GB, 전송 360MB/일). HTTPS 자동 포함.

> Cloud Storage 정적 호스팅은 웹사이트 엔드포인트가 HTTP만 지원해서 PWA에 부적합합니다.
> HTTPS를 붙이려면 로드밸런서가 필요하고 유료입니다. GCP를 쓰실 거면 Firebase Hosting이 맞습니다.

## 아이폰에 앱으로 설치
1. **사파리**로 위 주소 열기 (크롬 아님 — 홈 화면 추가는 사파리에만 있음)
2. 공유 → **홈 화면에 추가**
3. 한 번 실행해두면 이후 **비행기 모드에서도** 동작

## 업데이트
`index.html`을 고친 뒤 `sw.js`의 `CACHE` 값을 `brewcalc-v2` 처럼 올리고 다시 배포하세요.
버전을 안 올리면 기기가 캐시된 옛 버전을 계속 씁니다.

## 기록 저장
기록은 기기 브라우저에 저장되며 **기기 간에 동기화되지 않습니다**.
옮기려면 앱의 **링크 복사** 버튼으로 주소를 복사해 다른 기기에서 열면 됩니다.
