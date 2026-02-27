-- lua/plugins/alpha.lua
-- snacks.nvim 대시보드를 확장해 시스템/마켓 위젯을 삽입한다.
-- 위젯은 core.metrics 가 ANSI 컬러로 캐시 파일에 기록하고,
-- `section = "terminal"` 이 해당 파일을 cat 해서 렌더링한다.

local cache = vim.fn.stdpath("cache") .. "/nvim-metrics.txt"

return {
  {
    "folke/snacks.nvim",

    -- ── opts: sections 재정의 ──────────────────────────────
    opts = function(_, opts)
      -- TokyoNight Cyberpunk Hex Gradient
      vim.api.nvim_set_hl(0, "DashboardLogo1", { fg = "#7dcfff" }) -- Cyan
      vim.api.nvim_set_hl(0, "DashboardLogo2", { fg = "#7aa2f7" }) -- Blue
      vim.api.nvim_set_hl(0, "DashboardLogo3", { fg = "#9d7cd8" }) -- Purple
      vim.api.nvim_set_hl(0, "DashboardLogo4", { fg = "#bb9af7" }) -- Magenta
      vim.api.nvim_set_hl(0, "DashboardLogo5", { fg = "#ff9e64" }) -- Orange
      vim.api.nvim_set_hl(0, "DashboardLogo6", { fg = "#e0af68" }) -- Yellow/Gold

      opts.dashboard         = opts.dashboard or {}
      opts.dashboard.width   = opts.dashboard.width or 72

      opts.dashboard.sections = {
        {
          align = "center",
          text = {
            { " ▄▀▀▄ ▄▀▄  ▄▀▀█▄▄▄▄  ▄▀▀▀▀▄  ▄▀▀▄ ▄▀▀▄  ▄▀▀█▀▄    ▄▀▀▄ ▄▀▄ \n", hl = "DashboardLogo1" },
            { "█  █ ▀  █ ▐  ▄▀   ▐ █      █ █   █    █ █   ▄▀   █  █ ▀  █ \n", hl = "DashboardLogo2" },
            { "▐  █    █   █▄▄▄▄▄  █      █ ▐  █    █  ▐▄▄▄▀    ▐  █    █ \n", hl = "DashboardLogo3" },
            { "  █    █    █    ▌  ▀▄    ▄▀    █   ▄▀     █       █    █  \n", hl = "DashboardLogo3" },
            { "▄▀   ▄▀    ▄▀▄▄▄▄     ▀▀▀▀       ▀▄▀      ▄▀▄▄▄▄ ▄▀   ▄▀   \n", hl = "DashboardLogo4" },
            { "█    █     █    ▐                         █    ▐ █    █    \n", hl = "DashboardLogo5" },
            { "▐    ▐     ▐                              ▐      ▐    ▐    \n", hl = "DashboardLogo5" },
            { "                                                           \n", hl = "Normal"         }, 
            { "             b y   x i s t o h 1 6 2 1 0 8                 ", hl = "DashboardLogo6" },
          },
          padding = 1,
        },

        {
          icon  = "  ",
          title = "Keymaps",
          section = "keys",
          gap     = 1,
          padding = 1,
        },

        {
          icon    = "  ",
          title   = "Recent Files",
          section = "recent_files",
          indent  = 2,
          padding = 1,
        },

        {
          icon    = "  ",
          title   = "Projects",
          section = "projects",
          indent  = 2,
          padding = 1,
        },

        -- ── 시스템 위젯 ─────────────────────────────────────────
        -- core.metrics 의 snacks_lines() 가 네이티브 highlight 청크를 리턴함.
        -- 터미널 버퍼 재생성(깜빡임) 없이 텍스트 자체만 부드럽게 업데이트됨.
        function()
          local ok, m = pcall(require, "core.metrics")
          if ok and m.snacks_lines then
            local lines = m.snacks_lines()
            local sec = { align = "center", padding = 1 }
            for _, l in ipairs(lines) do table.insert(sec, l) end
            return sec
          end
          return {
            align   = "center",
            padding = 1,
            text    = { { { "  ⟳ metrics loading…", "Comment" } } },
          }
        end,

        { section = "startup" },
      }

      return opts
    end,

    -- ── init: VimEnter 에서 비동기 수집 시작 ──────────────
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        once     = true,
        callback = function()
          local ok, metrics = pcall(require, "core.metrics")
          if not ok then return end

          metrics.init(function()
            -- 비동기 수집 완료 → 캐시 파일은 이미 갱신됨.
            -- 현재 포커스가 대시보드인 경우에만 새로고침.
            -- defer_fn 으로 100ms 뒤 실행 → BufWipeout 충돌 방지.
            vim.defer_fn(function()
              if vim.bo.filetype == "snacks_dashboard"
                and Snacks and Snacks.dashboard
              then
                pcall(Snacks.dashboard.open)
              end
            end, 100)
          end)
        end,
      })
    end,
  },
}
