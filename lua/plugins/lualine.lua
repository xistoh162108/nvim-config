return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- AI 상태 가져오기 함수 (Avante 최신 버전에서 get_status API가 삭제되어 빈 문자열 반환)
      local function ai_status()
        return ""
      end

      -- 현재 함수/클래스 위치 (Treesitter)
      local function current_context()
        local ok, context = pcall(vim.fn['nvim_treesitter#statusline'], 160)
        if ok and context ~= "" then return " " .. context end
        return ""
      end

      require('lualine').setup({
        options = {
          theme = 'tokyonight', -- 사용 중인 테마에 맞춰 변경
          globalstatus = true,   -- 모든 창이 하단 바 하나를 공유
          section_separators = { left = '', right = '' },
          component_separators = { left = '┃', right = '┃' },
        },
        sections = {
          lualine_a = { 
            { 'mode', separator = { left = ' ' }, right_padding = 2 } 
          },
          lualine_b = { 
            'branch', 
            { 'diff', colored = true },
            { 'diagnostics', sources = { 'nvim_diagnostic' } } 
          },
          lualine_c = { 
            { 'filename', path = 1 }, -- 1: 상대 경로 표시
            { current_context, color = { fg = '#ff9e64' } } 
          },
          lualine_x = {
            { 
              function()
                local ok, obs = pcall(require, "core.obsidian_project")
                if not ok then return "" end
                local name, status = obs.get_current_project_info()
                if not name then return "" end
                if status == "archive" then
                  return "📦 " .. name
                end
                return "🚀 " .. name
              end, 
              color = { fg = '#bb9af7', bold = true } -- TokyoNight Purple
            },
            { ai_status, color = { fg = '#7aa2f7' } },
            'encoding', 
            'fileformat', 
            'filetype' 
          },
          lualine_y = {
            -- SSH 접속 중일 때만 호스트명 표시 (로컬/원격 구분)
            { 
              function() return " " .. vim.fn.hostname() end, 
              cond = function() return vim.env.SSH_CLIENT ~= nil end,
              color = { fg = '#e0af68' }
            },
            -- WakaTime async UI 
            { 
              function()
                if not _G.WakaTimeStatus then
                  _G.WakaTimeStatus = " ⏱️ ..." 
                  _G.WakaTimeLastFetch = 0
                end
                
                local now = vim.uv.now()
                -- 2분 단위 갱신 (120000ms)
                if now - _G.WakaTimeLastFetch > 120000 then 
                  _G.WakaTimeLastFetch = now
                  local wakatime_cli = vim.fn.expand("~/.wakatime/wakatime-cli")
                  if vim.fn.executable(wakatime_cli) == 1 then
                    vim.system({wakatime_cli, "--today"}, {text=true}, function(obj)
                      if obj.code == 0 then
                        local time = (obj.stdout or ""):gsub("\n", "")
                        if time == "" then
                          _G.WakaTimeStatus = " ⏱️ 0m"
                        elseif not time:find("WakaTime Error") then
                          _G.WakaTimeStatus = " ⏱️ " .. time
                        end
                      end
                    end)
                  else
                    -- 만약 기본 wakatime-cli가 시스템 PATH에 있다면
                    if vim.fn.executable("wakatime-cli") == 1 then
                      vim.system({"wakatime-cli", "--today"}, {text=true}, function(obj)
                        if obj.code == 0 then
                          local time = (obj.stdout or ""):gsub("\n", "")
                          if time == "" then
                            _G.WakaTimeStatus = " ⏱️ 0m"
                          elseif not time:find("WakaTime Error") then
                            _G.WakaTimeStatus = " ⏱️ " .. time
                          end
                        end
                      end)
                    end
                  end
                end
                
                return _G.WakaTimeStatus
              end, 
            }
          },
          lualine_z = { 'progress', 'location' }
        },
      })
    end
  }
}
