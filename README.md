# Neovim Config

**LazyVim** 기반 개인 설정. Leader = `Space`

## Stack

| 분류 | 내용 |
|------|------|
| 배포판 | [LazyVim](https://lazyvim.github.io) |
| 컬러스킴 | Cyberdream (기본) · rose-pine · tokyonight |
| LSP / 포맷 | mason-org/mason.nvim + LazyVim extras |
| AI | avante.nvim (Claude Sonnet) + Copilot |
| 완성 | blink.cmp |
| 파일 탐색 | neo-tree, Telescope, Harpoon2, Oil |
| 미니맵 | neominimap.nvim |
| 진단 UI | tiny-inline-diagnostic.nvim (실시간 체감형 가이드) |
| Git | LazyGit, Gitsigns, Fugit2, Diffview |
| DB | vim-dadbod-ui (PostgreSQL / MySQL / SQLite) |
| 노트 | obsidian.nvim · 볼트: `~/Documents/SecondBrain/Notes` (PARA + Zettelkasten) |
| Jupyter | molten-nvim + image.nvim (iTerm2 Kitty protocol) |
| LaTeX | vimtex + Skim PDF 뷰어 |
| Flutter | flutter-tools.nvim |
| 디버깅 | nvim-dap + nvim-dap-ui (codelldb, debugpy, js-debug) |
| 테스트 | neotest |

## 언어별 LSP (LazyVim extras)

Docker · Go · Rust · YAML · Markdown · TOML · Java · **Solidity** · **Scala** (Metals)
Bash/Shell (Mason: bash-language-server, shfmt, shellcheck)
Dart/Flutter (flutter-tools.nvim, SDK 자동 감지)
**C / C++** (clangd, clangd_extensions)
**JSON** (SchemaStore 지원)

## 파일 구조

```
lua/
  config/          # lazy.nvim 초기화, 옵션, 키맵
  plugins/         # 플러그인별 설정
    alpha.lua      # snacks 대시보드 + "xistoh162108" 사이버펑크 로고 + 시스템/마켓 위젯
    avante.lua     # AI 코딩 어시스턴트
    colorscheme.lua
    db.lua         # vim-dadbod-ui
    fun.lua        # cellular-automaton, codesnap
    lang.lua       # Bash/Shell, Flutter
    mini.lua       # mini.animate, mini.indentscope
    molten.lua     # Jupyter in Nvim
    notes.lua      # obsidian.nvim 설정
    neominimap.lua # 코드 미니맵
    tiny-inline-diagnostic.lua # 실시간 LSP 에러 시각화
    tex.lua        # vimtex
    ui.lua         # noice, notify, snacks, indent-blankline
    ...
  core/
    metrics.lua           # 대시보드 시스템(RAM/CPU/Swap)/마켓(BTC) 위젯 비동기 수집
    market.lua            # 마켓 위젯 플로팅 UI 및 데이터 핸들러
    telemetry.lua         # 키맵/커맨드 사용 통계 (:TelemetryReport)
    obsidian_project.lua  # 프로젝트 노트 전용 워크스페이스 (State Machine)
docs/
  cheatsheet.md   # 전체 키맵 치트시트 (최신화 완료)
```

## 빠른 참조

전체 키맵 → `docs/cheatsheet.md`
마우스패드 출력용 → `docs/mousepad.html`
레이아웃 복구 명령 → `:LayoutDefault`
마켓 위젯 → `<leader>M`
Obsidian 워크스페이스 → `<leader>op`
