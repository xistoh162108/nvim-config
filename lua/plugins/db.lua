-- lua/plugins/db.lua
-- vim-dadbod-ui: Nvim 안의 DB 클라이언트 (PostgreSQL / MySQL / SQLite)
--
-- 사용법:
--   <leader>D         → DBUI 사이드패널 토글
--   DBUI 창에서 'o'  → 연결 열기
--   DBUI 창에서 'R'  → 새로고침
--   SQL 버퍼에서 \S  → 쿼리 실행 (결과 하단 분할창)
--   SQL 버퍼에서 \S  → visual 선택 후 선택 영역만 실행
--
-- DB 연결 정보는 ~/.config/nvim/db_connections.json 또는
-- 환경변수 DB_URL 에 저장 권장 (설정 파일에 비밀번호 노출 방지).

return {
  -- vim-dadbod: 핵심 DB 엔진 (dadbod-ui 의 백엔드)
  {
    "tpope/vim-dadbod",
    lazy = true,
  },

  -- vim-dadbod-ui: 사이드패널 UI + 쿼리 버퍼 관리
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      -- SQL 자동완성: sql/mysql/plsql 파일타입에서만 로드
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
        lazy = true,
      },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "DBUI 토글" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts     = 1
      vim.g.db_ui_show_database_icon = 1
      -- 저장되지 않은 쿼리 파일을 ~/.local/share/db_ui/queries 에 자동 보관
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
    end,
  },

  -- 3) blink.cmp 와 vim-dadbod-completion 브릿지 (SQL 자동완성)
  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or { "lsp", "path", "snippets", "buffer" }
      -- dadbod 소스를 default 리스트에 추가
      if not vim.tbl_contains(opts.sources.default, "dadbod") then
        table.insert(opts.sources.default, "dadbod")
      end
      -- provider 객체에 dadbod 모듈 등록
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.dadbod = { 
        name = "Dadbod", 
        module = "vim_dadbod_completion.blink",
        score_offset = 80, -- 자동완성 우선순위 높임
      }
    end,
  },
}
