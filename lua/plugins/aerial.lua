-- lua/plugins/aerial.lua
-- Architect's Code Map (Treesitter-powered Outline)

return {
  {
    "stevearc/aerial.nvim",
    event = "LazyFile",
    opts = {
      -- Outline 설정 (기존 outline.nvim과 동일한 레이아웃 유지)
      layout = {
        max_width = { 35, 0.2 },
        min_width = 35,
        default_direction = "right",
      },
      -- 보여줄 심볼들 (Architect 관점에서 핵심적인 것들)
      filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
      },
      -- 현재 위치 자동 추적 및 하이라이트
      highlight_on_hover = true,
      autojump = true,
      
      -- 상태줄 아이콘 (선택 사항)
      show_guides = true,
      guides = {
        mid_item = "├─",
        last_item = "└─",
        nested_top = "│ ",
        whitespace = "  ",
      },
    },
    -- <leader>O (기존 Outline 단축키 계승)
    keys = {
      { "<leader>O", "<cmd>AerialToggle!<cr>", desc = "Aerial (Code Map) Toggle" },
    },
  },
}
