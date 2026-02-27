#!/usr/bin/env node
/**
 * mousepad.html → mousepad.png (고화질, ~300 DPI)
 *
 * 실행:  node export-png.mjs
 * 의존:  npx puppeteer (자동 설치)
 *
 * 590mm × 220mm @ 96 dpi = 2228 × 831 px
 * deviceScaleFactor = 3  →  6684 × 2493 px (~300 DPI)
 */

import { fileURLToPath } from "url";
import { dirname, resolve } from "path";
import { existsSync } from "fs";
import { createRequire } from "module";

const __dirname = dirname(fileURLToPath(import.meta.url));
const HTML_PATH = resolve(__dirname, "mousepad.html");
const OUT_PATH  = resolve(__dirname, "mousepad.png");
const SCALE     = 3;   // 1 = 96dpi, 2 = 192dpi, 3 = 288dpi, 4 = 384dpi
const W         = 2228; // 590mm @ 96dpi
const H         = 831;  // 220mm @ 96dpi

// ── puppeteer 로드 (로컬 → 글로벌 순으로 시도) ──
async function loadPuppeteer() {
  const candidates = [
    "puppeteer",
    "puppeteer-core",
  ];
  for (const pkg of candidates) {
    try {
      const require = createRequire(import.meta.url);
      return require(pkg);
    } catch { /* try next */ }
  }
  return null;
}

async function main() {
  let puppeteer = await loadPuppeteer();

  if (!puppeteer) {
    console.log("📦  puppeteer를 설치합니다 (npx)...");
    const { execSync } = await import("child_process");
    execSync("npm install --prefix /tmp/mousepad-export puppeteer --quiet", {
      stdio: "inherit",
    });
    const require = createRequire(import.meta.url);
    puppeteer = require("/tmp/mousepad-export/node_modules/puppeteer");
  }

  console.log(`🌐  HTML  : ${HTML_PATH}`);
  console.log(`🖼   출력  : ${OUT_PATH}`);
  console.log(`📐  크기  : ${W * SCALE} × ${H * SCALE} px  (${SCALE}x / ~${Math.round(96 * SCALE)} DPI)`);

  const browser = await puppeteer.launch({
    headless: true,
    args: [
      "--no-sandbox",
      "--disable-setuid-sandbox",
      "--disable-gpu",
      "--hide-scrollbars",
    ],
  });

  const page = await browser.newPage();

  await page.setViewport({
    width: W,
    height: H,
    deviceScaleFactor: SCALE,
  });

  // 폰트 로딩 대기 포함
  await page.goto(`file://${HTML_PATH}`, {
    waitUntil: ["networkidle0", "load"],
    timeout: 30000,
  });

  // 웹폰트가 완전히 그려질 때까지 잠깐 대기
  await new Promise((r) => setTimeout(r, 1500));

  await page.screenshot({
    path: OUT_PATH,
    type: "png",
    clip: { x: 0, y: 0, width: W, height: H },
  });

  await browser.close();
  console.log(`✅  저장 완료!`);
}

main().catch((err) => {
  console.error("❌ 오류:", err.message);
  process.exit(1);
});
