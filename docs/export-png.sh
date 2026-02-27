#!/usr/bin/env bash
# ─────────────────────────────────────────────
# mousepad.html → mousepad.png (고화질 PNG)
# 출력: 590mm × 220mm @ ~288 DPI  (6684 × 2493 px)
# 실행: bash export-png.sh
# ─────────────────────────────────────────────

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HTML="$SCRIPT_DIR/mousepad.html"
OUT="$SCRIPT_DIR/mousepad.png"
PUPPETEER_DIR="/tmp/mousepad-export"

echo "🖼   출력 경로: $OUT"

# puppeteer 없으면 설치
if [[ ! -d "$PUPPETEER_DIR/node_modules/puppeteer" ]]; then
  echo "📦  puppeteer 설치 중..."
  npm install puppeteer --prefix "$PUPPETEER_DIR" --quiet
fi

node -e "
const puppeteer = require('$PUPPETEER_DIR/node_modules/puppeteer');
(async () => {
  const W = 2228, H = 831, SCALE = 3;
  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox','--disable-gpu','--hide-scrollbars'],
  });
  const page = await browser.newPage();
  await page.setViewport({ width: W, height: H, deviceScaleFactor: SCALE });
  await page.goto('file://$HTML', { waitUntil: ['networkidle0','load'], timeout: 30000 });
  await new Promise(r => setTimeout(r, 1500));
  await page.screenshot({ path: '$OUT', type: 'png', clip: { x:0, y:0, width: W, height: H } });
  await browser.close();
})().catch(e => { console.error(e); process.exit(1); });
"

echo "✅  저장 완료: $OUT"
echo "   $(file "$OUT")"
