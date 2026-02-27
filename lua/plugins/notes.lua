-- lua/plugins/notes.lua
-- obsidian.nvim: Nvim 에서 Obsidian 볼트를 바로 편집
--
-- Vault 구조 (PARA + Zettelkasten):
--   00_Inbox / 10_Projects / 50_Zettelkasten / 80_Templates / 99_Attachments
--
-- 핵심 사용법:
--   <leader>od  → 오늘 데일리 노트 열기 / 없으면 생성
--   <leader>on  → 새 노트 생성 (Inbox 에 생성)
--   <leader>os  → 전체 볼트에서 노트 fuzzy 검색 (Telescope)  [Normal]
--   <leader>os  → 선택 코드 스니펫을 프로젝트 노트에 전송    [Visual]
--   <leader>ob  → 현재 노트를 링크하는 백링크 목록
--   <leader>ol  → 현재 노트에서 외부로 나가는 링크 목록
--   <leader>ot  → 태그로 노트 검색
--   <leader>op  → 현재 프로젝트(cwd) 노트 우측 분할로 열기
--   [[링크]]    → 노트 링크 자동완성 (blink.cmp 팝업)
--   gf          → [[링크]] 위에서 해당 노트로 이동

return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- lazy.nvim keys: global 등록 → which-key 에 항상 보임 + lazy-load 트리거
    keys = {
      { "<leader>od", "<cmd>ObsidianToday<CR>",    desc = "Obsidian: 오늘 데일리 노트" },
      { "<leader>on", "<cmd>ObsidianNew<CR>",       desc = "Obsidian: 새 노트" },
      { "<leader>os", "<cmd>ObsidianSearch<CR>",    desc = "Obsidian: 노트 검색" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<CR>", desc = "Obsidian: 백링크" },
      { "<leader>ol", "<cmd>ObsidianLinks<CR>",     desc = "Obsidian: 링크 목록" },
      { "<leader>ot", "<cmd>ObsidianTags<CR>",      desc = "Obsidian: 태그 목록" },
      -- 프로젝트 노트 열기 (Normal)
      {
        "<leader>op",
        function() require("core.obsidian_project").open_project_note() end,
        desc = "Obsidian: 프로젝트 노트 열기",
      },
      -- 스니펫 전송 (Visual) — Normal mode <leader>os = ObsidianSearch 와 모드 구분
      {
        "<leader>os",
        function() require("core.obsidian_project").send_snippet() end,
        mode = "v",
        desc = "Obsidian: 스니펫 → 프로젝트 노트",
      },
    },
    opts = {
      workspaces = {
        {
          name = "SecondBrain",
          path = "/Users/bagjimin/Documents/SecondBrain/Notes",
        },
      },

      -- 데일리 노트 설정
      daily_notes = {
        folder      = "60_Periodic/a. Daily",
        date_format = "%Y-%m-%d",
        template    = "Daily.md",
      },

      -- 새 노트 기본 생성 위치: Inbox
      new_notes_location = "notes_subdir",
      notes_subdir       = "00_Inbox",

      -- 템플릿 폴더 + 날짜·시간 포맷
      templates = {
        folder      = "80_Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },

      -- 이미지 첨부 위치
      attachments = {
        img_folder = "99_Attachments",
      },

      -- LazyVim 기본 completion: blink.cmp (nvim-cmp 아님)
      -- nvim_cmp = false 로 설정해야 'cmp' 모듈 not found 에러 방지
      completion = {
        nvim_cmp = false,
        min_chars = 2,
      },

      -- 노트 ID 생성 방식: 타임스탬프 + 제목 기반 slug
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^%w%-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

      -- gf 만 buffer-local (markdown 파일에서 [[링크]] 이동 오버라이드)
      -- 나머지 키맵은 위의 keys 테이블에서 global 로 등록
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
      },

      -- 체크박스 / 불릿 아이콘 (Nerd Font 필요)
      ui = {
        enable = true,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "",  hl_group = "ObsidianDone" },
          [">"] = { char = "",  hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        },
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text  = { hl_group = "ObsidianRefText" },
        highlight_text  = { hl_group = "ObsidianHighlightText" },
        tags            = { hl_group = "ObsidianTag" },
        hl_groups = {
          ObsidianTodo         = { bold = true, fg = "#f78c6c" },
          ObsidianDone         = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow   = { bold = true, fg = "#fc514e" },
          ObsidianTilde        = { bold = true, fg = "#ff5370" },
          ObsidianBullet       = { bold = true, fg = "#89ddff" },
          ObsidianRefText      = { underline = true, fg = "#c3e88d" },
          ObsidianExtLinkIcon  = { fg = "#c3e88d" },
          ObsidianTag          = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
        },
      },

      -- Telescope 연동 (검색 팝업)
      picker = {
        name = "telescope.nvim",
        note_mappings = {
          new        = "<C-x>",
          insert_link = "<C-l>",
        },
        tag_mappings = {
          tag_note   = "<C-x>",
          insert_tag = "<C-l>",
        },
      },
    },
  },
}
