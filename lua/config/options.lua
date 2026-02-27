-- ~/.config/nvim/lua/config/options.lua

pcall(function()
  vim.loader.enable()
end)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 기본 옵션
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.termguicolors = true
vim.opt.mouse = "a" -- 모든 모드에서 마우스 활성화
vim.opt.mousescroll = "ver:2,hor:6" -- 터미널 스크롤 부드럽게 (세로 2줄, 가로 6칸)
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- UX
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 8
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.updatetime = 200
vim.opt.timeoutlen = 400
vim.opt.undofile = true
vim.opt.inccommand = "split"
vim.opt.wrap = false

vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", trail = "•", extends = ">", precedes = "<" }
vim.opt.fillchars = { 
  eob = " ", fold = " ", foldopen = "▾", foldclose = "▸",
  horiz = '━', horizup = '┻', horizdown = '┳',
  vert = '┃', vertleft  = '┫', vertright = '┣', verthoriz = '╋',
}
vim.opt.shortmess:append("I")

-- Git/cURL trace 차단
vim.env.GIT_TRACE = nil
vim.env.GIT_TRACE_CURL = nil
vim.env.GIT_CURL_VERBOSE = nil

-- PATH 보강 (~/.local/bin)
local local_bin = vim.fs.normalize("~/.local/bin")
if vim.fn.isdirectory(local_bin) == 1 then
  local path = vim.env.PATH or ""
  if not path:find(local_bin, 1, true) then
    vim.env.PATH = local_bin .. ":" .. path
  end
end

-- provider 최소화
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_node_provider = 0
