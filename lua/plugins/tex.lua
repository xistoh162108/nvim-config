-- lua/plugins/tex.lua
-- vimtex: LaTeX 편집 올인원 (MacTeX 설치 확인됨)
--
-- 사전 준비 (최초 1회):
--   brew install --cask skim   ← PDF 뷰어 (SyncTeX 양방향 동기화 지원)
--   Skim > Preferences > Sync > Preset: "Custom"
--     Command: nvim
--     Arguments: --headless -c "VimtexInverseSearch %line '%file'"
--
-- 핵심 키맵 (vimtex 기본 제공, <localleader> = \):
--   \ll → 컴파일 시작 / 토글 (저장 시 자동 재컴파일)
--   \lv → PDF 뷰어에서 현재 위치로 포워드 검색 (nvim → Skim)
--   \le → 에러 목록 열기
--   \lc → 보조 파일 정리 (.aux, .log 등)
--   \lt → 목차(Table of Contents) 패널 열기
--   \lk → 컴파일 중지
--   Skim 에서 ⌘+Shift+클릭 → nvim 의 해당 줄로 역방향 이동

return {
  {
    "lervag/vimtex",
    lazy = false,  -- LazyVim 의 기본 lazy 설정을 override (vimtex 는 즉시 로드 필요)
    ft = { "tex", "bib" },
    init = function()
      -- 기본 LaTeX 플레이버 지정
      vim.g.tex_flavor = "latex"

      -- PDF 뷰어: Skim (macOS, SyncTeX 역방향 검색 최강)
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync    = 1  -- 포워드 검색 후 Skim 자동 포커스
      vim.g.vimtex_view_skim_activate = 1

      -- 컴파일러: latexmk (MacTeX 기본 포함)
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        build_dir  = "",  -- .tex 파일과 동일 디렉토리
        callback   = 1,
        continuous = 1,   -- 저장 시 자동 재컴파일
        executable = "latexmk",
        options    = {
          "-pdf",
          "-verbose",
          "-file-line-error",
          "-synctex=1",   -- SyncTeX 활성 (nvim ↔ Skim 양방향 이동)
          "-interaction=nonstopmode",
        },
      }

      -- quickfix 창: 에러/경고 시 자동으로 열지 않음 (수동 \le 로 확인)
      vim.g.vimtex_quickfix_mode = 0

      -- fold: vimtex 자체 fold 비활성 (Treesitter fold 와 충돌 방지)
      vim.g.vimtex_fold_enabled = 0

      -- 수식 동시 미리보기 (미니멀 팝업, 요구: xdotool / neovim-remote)
      vim.g.vimtex_syntax_conceal_disable = 0
    end,
  },
}
