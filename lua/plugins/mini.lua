-- lua/plugins/mini.lua
-- mini.nvim 생태계: 스크롤/커서 애니메이션 + 현재 스코프 시각화

return {
  -- mini.animate: 스크롤·커서 이동에 부드러운 애니메이션 적용
  --   scroll → 페이지 이동이 뚝뚝 끊기지 않고 매끄럽게 흐름
  --   cursor → 커서 점프 시 이동 경로를 잠깐 표시
  --   resize/open/close 는 OFF (창 조작 시 지연 방지)
  {
    "nvim-mini/mini.animate",
    version = false,
    enabled = false,
    event = "VeryLazy",
    config = function()
      local animate = require("mini.animate")
      animate.setup({
        scroll = {
          timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
        cursor = {
          timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
        },
        resize = { enable = false },
        open   = { enable = false },
        close  = { enable = false },
      })
    end,
  },

  -- mini.indentscope: 현재 커서가 위치한 스코프(함수/if/for)의
  --   들여쓰기 범위를 네온 수직선 + 부드러운 애니메이션으로 표시.
  --   기존 indent-blankline(정적 가이드)과 병존: ibl은 전체 들여쓰기 선,
  --   mini.indentscope는 현재 블록만 하이라이트.
  {
    "nvim-mini/mini.indentscope",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      -- 대시보드·파일트리·팝업 등에서 비활성화
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help", "alpha", "dashboard", "neo-tree",
          "Trouble", "trouble", "lazy", "mason",
          "snacks_dashboard", "toggleterm", "lazyterm",
          "notify", "aerial",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}
