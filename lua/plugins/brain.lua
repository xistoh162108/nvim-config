-- lua/plugins/brain.lua
-- Digital Brain: Unified Obsidian & PARA Knowledge Management
--   Philosophy: One spec to rule them all. Consolidates notes.lua, obsidian.lua, and custom project mappings.

local VAULT = "/Users/bagjimin/Documents/SecondBrain"

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "Saghen/blink.cmp",
    },
    opts = {
      workspaces = {
        {
          name = "SecondBrain",
          path = VAULT,
        },
      },

      -- Modern Commands (obsidian.nvim >= 3.x)
      legacy_commands = false,

      -- PARA Structure Standard
      notes_subdir = "Notes/00_Inbox",
      new_notes_location = "notes_subdir",

      -- Periodic Notes
      daily_notes = {
        folder      = "Notes/60_Periodic/a. Daily",
        date_format = "%Y-%m-%d",
        template    = "Daily.md",
      },

      -- Templates
      templates = {
        folder      = "Notes/80_Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },

      -- Attachments
      attachments = {
        folder = "Notes/99_Attachments",
      },

      -- Completion (Blink.cmp compatibility)
      completion = {
        nvim_cmp = false,
        min_chars = 2,
      },

      -- Metadata Management
      frontmatter = {
        enabled = true,
      },
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^%w%-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.date("%Y%m%d%H%M")) .. "-" .. suffix
      end,

      -- Telescope Picker Setup
      picker = {
        name = "telescope.nvim",
        note_mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
      },

      -- UI (Nerd Font Icons)
      ui = {
        enable = true,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "󰄲",  hl_group = "ObsidianDone" },
        },
        bullets = { char = "•", hl_group = "ObsidianBullet" },
      },
    },

    -- =========================================================================
    -- UNIFIED KEYMAPS (Strict Isolation: All <leader>o keys reside here)
    -- =========================================================================
    keys = {
      -- Note Operations
      { "<leader>on", "<cmd>Obsidian new<CR>",       desc = "Obsidian: New Note (Inbox)" },
      { "<leader>oi", "<cmd>Obsidian new<CR>",       desc = "Obsidian: New Inbox Note" },
      {
        "<leader>oN",
        function()
          local ok, obs = pcall(require, "core.obsidian_project")
          if not ok then return end
          local project_name, status = obs.get_current_project_info()
          if not project_name then
            vim.notify("🚫 프로젝트 관리 대상 폴더가 아닙니다.", vim.log.levels.WARN)
            return
          end
          local act_dir, arc_dir = obs.get_obsidian_dirs()
          -- Construct absolute path to the specific project subfolder
          -- e.g. ~/Documents/SecondBrain/Notes/10_Projects/26_10_FakeTTL
          local abs_target = (status == "archive" and arc_dir or act_dir) .. "/" .. project_name
          -- Ensure the subfolder exists
          vim.fn.mkdir(abs_target, "p")
          -- Ask for the new note title
          vim.ui.input({ prompt = "📝 노트 제목 (" .. project_name .. "): " }, function(title)
            if not title or title == "" then return end
            -- Generate note filename using the same ID scheme as brain.lua opts
            local id = os.date("%Y%m%d%H%M") .. "-" .. title:gsub(" ", "-"):gsub("[^%w%-]", ""):lower()
            local note_path = abs_target .. "/" .. id .. ".md"
            -- Write the new note file
            local lines = {
              "---",
              "title: " .. title,
              "date: " .. os.date("%Y-%m-%d"),
              "project: " .. project_name,
              "---",
              "",
              "# " .. title,
              "",
            }
            vim.fn.writefile(lines, note_path)
            -- Open it in Neovim
            vim.cmd("edit " .. vim.fn.fnameescape(note_path))
            vim.notify("📝 노트 생성: " .. project_name .. "/" .. id .. ".md", vim.log.levels.INFO)
          end)
        end,
        desc = "Obsidian: New Note in Project Folder",
      },
      { "<leader>os", "<cmd>Obsidian search<CR>",    desc = "Obsidian: Search Vault" },
      { "<leader>oS", "<cmd>Obsidian quick_switch<CR>", desc = "Obsidian: Quick Switch" },
      { "<leader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Obsidian: Backlinks" },
      { "<leader>ol", "<cmd>Obsidian links<CR>",     desc = "Obsidian: Outgoing Links" },
      { "<leader>ot", "<cmd>Obsidian tags<CR>",      desc = "Obsidian: Tags" },
      { "<leader>oT", "<cmd>Obsidian template<CR>",  desc = "Obsidian: Templates" },

      -- Periodic Notes
      { "<leader>od", "<cmd>Obsidian today<CR>",     desc = "Obsidian: Daily (Today)" },
      { "<leader>oD", "<cmd>Obsidian yesterday<CR>", desc = "Obsidian: Daily (Yesterday)" },

      -- Project Management (Role-based Integration via core.obsidian_project)
      {
        "<leader>op",
        function() require("core.obsidian_project").open_project_note() end,
        desc = "Obsidian: Project Note (Workspace)",
      },
      {
        "<leader>oe",
        function()
          local ok, obs = pcall(require, "core.obsidian_project")
          if not ok then return end
          local project_name, status = obs.get_current_project_info()
          if not project_name then
            vim.notify("🚫 프로젝트 관리 대상 폴더가 아닙니다.", vim.log.levels.WARN, { title = "Obsidian Explorer" })
            return
          end
          local act_dir, arc_dir = obs.get_obsidian_dirs()
          local target_dir = (status == "archive" and arc_dir or act_dir) .. "/" .. project_name
          local ok_oil, oil = pcall(require, "oil")
          if ok_oil then oil.open(target_dir) else vim.notify("oil.nvim not found", vim.log.levels.ERROR) end
        end,
        desc = "Obsidian: Project Explorer (Oil)",
      },
      {
        "<leader>of",
        function()
          local ok, obs = pcall(require, "core.obsidian_project")
          if not ok then return end
          local project_name, status = obs.get_current_project_info()
          if not project_name then
            vim.notify("🚫 프로젝트 관리 대상 폴더가 아닙니다.", vim.log.levels.WARN, { title = "Obsidian Finder" })
            return
          end
          local act_dir, arc_dir = obs.get_obsidian_dirs()
          local target_dir = (status == "archive" and arc_dir or act_dir) .. "/" .. project_name
          require("telescope.builtin").find_files({ search_dirs = { target_dir }, prompt_title = "Obsidian: " .. project_name })
        end,
        desc = "Obsidian: Project Finder (Telescope)",
      },
      {
        "<leader>oa",
        function()
          local ok, obs = pcall(require, "core.obsidian_project")
          if not ok then return end
          local project_name, status, code_root = obs.get_current_project_info()
          if not project_name or status == "archive" then
            vim.notify("🚫 아카이브할 수 없거나 이미 완료된 프로젝트입니다.", vim.log.levels.WARN)
            return
          end
          -- Confirmation Prompt
          vim.ui.select({"Yes", "No"}, { prompt = string.format("정말 '%s' 프로젝트를 동기화 아카이브 하시겠습니까?", project_name) }, function(choice)
            if choice == "Yes" then
              -- Explicit logic from keymaps.lua
              local act_obs, arc_obs = obs.get_obsidian_dirs()
              local act_code, arc_code = obs.get_code_dirs()
              local target_obs_dir = arc_obs .. "/" .. project_name
              local target_code_dir = arc_code .. "/" .. project_name
              local source_obs_dir = act_obs .. "/" .. project_name
              vim.cmd("wa")
              vim.cmd("%bd")
              vim.fn.chdir(vim.fn.expand("~"))
              vim.fn.mkdir(arc_code, "p")
              vim.fn.mkdir(arc_obs, "p")
              vim.fn.system(string.format("mv '%s' '%s'", code_root, target_code_dir))
              if vim.fn.isdirectory(source_obs_dir) == 1 then vim.fn.system(string.format("mv '%s' '%s'", source_obs_dir, target_obs_dir)) end
              vim.notify("📦 프로젝트 아카이브 완료!", vim.log.levels.INFO)
            end
          end)
        end,
        desc = "Obsidian: Archive Project",
      },

      -- Content Transfer (Visual Mode)
      {
        "<leader>os",
        function() require("core.obsidian_project").send_snippet() end,
        mode = "v",
        desc = "Obsidian: Send Snippet to Note",
      },

      -- Navigation
      {
        "gf",
        function()
          if require("obsidian").util.cursor_on_markdown_link() then
            return "<cmd>Obsidian follow_link<CR>"
          else
            return "gf"
          end
        end,
        noremap = false,
        expr = true,
        desc = "Obsidian: Follow Link",
      },
    },
  },
}
