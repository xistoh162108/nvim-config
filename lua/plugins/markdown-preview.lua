return {
  {
    "iamcco/markdown-preview.nvim",
    enabled = false,
    ft = { "markdown" },
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },

    -- 핵심: Vimscript 함수 호출은 문자열 build가 가장 안전한 편
    build = "cd app && npx --yes yarn install",

    init = function()
      -- markdown 파일에서만 명령 활성화
      vim.g.mkdp_filetypes = { "markdown" }

      -- 취향 설정 (VSCode 느낌으로 무난)
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_theme = "dark" -- "dark" | "light"
      vim.g.mkdp_combine_preview = 0

      -- 필요하면 브라우저 지정 (mac 기본 브라우저 쓰면 보통 비워둬도 됨)
      -- vim.g.mkdp_browser = "Google Chrome"

      -- 렌더 옵션 (기본값 + 자주 쓰는 것)
      vim.g.mkdp_preview_options = {
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {},
      }
    end,

    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview Toggle" },
      { "<leader>ms", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview Start" },
      { "<leader>mS", "<cmd>MarkdownPreviewStop<cr>", desc = "Markdown Preview Stop" },
    },
  },

  -- 에디터 내부 마크다운 가독성 향상 (선택이지만 추천)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    opts = {
      file_types = { "markdown", "Avante" },
    },
  },
}
