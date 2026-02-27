-- lua/plugins/session.lua
-- Automatic Session Management (auto-session)
--   Focus: Layout Stability & Zero-Corruption

return {
  {
    "rmagatti/auto-session",
    lazy = false, -- 세션 복원을 위해 시작 시 로드 필요
    config = function()
      local auto_session = require("auto-session")

      auto_session.setup({
        log_level = "error",
        auto_session_enable_last_session = false, -- 실수로 덮어쓰는 것 방지 (수동 or 디렉토리 기반 자동 선호)
        auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/", "/tmp" }, -- 안전장치
        
        -- 🌟 핵심 보완: 복원 대상 제외 (레이아웃 파괴 방어)
        bypass_session_save_file_types = {
          "neo-tree",
          "alpha",
          "dashboard",
          "snacks_dashboard",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "aerial",
          "Trouble",
          "trouble",
        },

        -- 🌟 핵심 보완: 저장 전 사이드바 자동 닫기 (Clean Snapshot)
        pre_save_cmds = {
          "Neotree close",
          "AerialClose",
          "Trouble close",
        },
        
        -- 복원 후 정리 (필요 시)
        post_restore_cmds = {
          "Neotree close", -- 복원 시점에 떠있을 수 있는 유령 트리 제거
        },

        -- 세션 렌더링 설정
        session_lens = {
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
      } )
    end,
    keys = {
      -- <leader>qs는 LazyVim 기본 세션 단축키와 조화롭게 사용
      { "<leader>wr", "<cmd>SessionRestore<cr>", desc = "Session: Restore" },
      { "<leader>ws", "<cmd>SessionSave<cr>", desc = "Session: Save" },
      { "<leader>wa", "<cmd>SessionToggleAutoSave<cr>", desc = "Session: Toggle Auto-save" },
    },
  },
}
