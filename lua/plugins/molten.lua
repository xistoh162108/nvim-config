-- lua/plugins/molten.lua
-- molten-nvim + image.nvim: Nvim 안의 Jupyter Notebook (iTerm2 환경)
--
-- ┌── 시스템 사전 준비 (완료) ──────────────────────────────────────────┐
-- │  iTerm2 3.5+ → Kitty Graphics Protocol 지원 → ueberzugpp 불필요    │
-- │  /opt/homebrew/bin/pip3 install --break-system-packages \          │
-- │    pynvim jupyter_client cairosvg pnglatex plotly kaleido  ✓ 완료  │
-- └────────────────────────────────────────────────────────────────────┘
--
-- 설치 후 nvim 에서 :UpdateRemotePlugins 실행 필요 (자동 실행됨)
--
-- 핵심 사용법:
--   <leader>mi  → Python 커널 초기화 (MoltenInit python3)
--   <leader>ml  → 현재 줄 실행
--   <leader>mc  → 현재 셀(--- 구분) 재실행
--   <leader>mr  → Visual 선택 영역 실행
--   <leader>mo  → 출력 창으로 포커스 이동
--   <leader>md  → 현재 셀 결과 삭제

return {
  -- image.nvim: 터미널 이미지 렌더러
  --   kitty 백엔드 → iTerm2 3.5+ 가 Kitty Graphics Protocol 지원하므로 그대로 사용
  {
    "3rd/image.nvim",
    build = "rockspec",
    lazy = true,
    opts = {
      backend = "kitty",
      integrations = {
        markdown = { enabled = true, download_remote_images = true },
        neorg    = { enabled = false },
      },
      max_width  = 100,
      max_height = 12,
      -- 창 경계를 넘어서도 이미지 표시 허용
      max_height_window_percentage = math.huge,
      max_width_window_percentage  = math.huge,
      -- 다른 창과 겹칠 때 이미지 자동 지우기
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = {
        "cmp_menu", "cmp_docs", "scrollview", "scrollview_sign",
      },
      editor_only_render_when_focused = false,
    },
  },

  -- molten-nvim: Jupyter 커널 연결 + 인라인 출력 렌더링
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    dependencies = { "3rd/image.nvim" },
    init = function()
      -- 이미지 렌더러: image.nvim 사용 (ueberzugpp → iTerm2)
      vim.g.molten_image_provider = "image.nvim"

      -- 출력 창 최대 높이 (라인 수)
      vim.g.molten_output_win_max_height = 12

      -- 실행 즉시 출력 창 자동으로 열지 않음 (수동 <leader>mo 로 확인)
      vim.g.molten_auto_open_output = false

      -- 출력 텍스트 줄 바꿈
      vim.g.molten_wrap_output = true

      -- 가상 텍스트로 출력 미리보기 (창 열지 않고도 결과 힌트 표시)
      vim.g.molten_virt_text_output  = true
      vim.g.molten_virt_lines_off_by_1 = true

      -- 셀 구분자 하이라이트
      vim.g.molten_cell_highlight = "MoltenCell"
    end,
    keys = {
      {
        "<leader>mi",
        function()
          -- Python 3 커널로 초기화 (다른 커널: "julia-1.9", "R", 등)
          vim.cmd("MoltenInit python3")
        end,
        desc = "Molten: Python3 커널 초기화",
      },
      { "<leader>ml", "<cmd>MoltenEvaluateLine<CR>",   desc = "Molten: 현재 줄 실행" },
      { "<leader>mc", "<cmd>MoltenReevaluateCell<CR>", desc = "Molten: 셀 재실행" },
      { "<leader>md", "<cmd>MoltenDelete<CR>",          desc = "Molten: 셀 결과 삭제" },
      { "<leader>mo", "<cmd>MoltenEnterOutput<CR>",     desc = "Molten: 출력 창 포커스" },
      { "<leader>mh", "<cmd>MoltenHideOutput<CR>",      desc = "Molten: 출력 창 숨기기" },
      {
        "<leader>mr",
        ":<C-u>MoltenEvaluateVisual<CR>",
        mode = "v",
        desc = "Molten: 선택 영역 실행",
      },
    },
  },
}
