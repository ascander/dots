local opt = vim.opt

-- General
opt.clipboard = "unnamedplus"
opt.completeopt = { "menuone", "noinsert", "noselect" }
opt.mouse = "a"
opt.swapfile = false

-- Neovim UI
opt.breakindent = true
opt.conceallevel = 2
opt.cursorline = true
opt.foldmethod = "manual"
opt.ignorecase = true
opt.linebreak = true
opt.number = true
opt.relativenumber = true
opt.report = 0
opt.scrolloff = 10
opt.shortmess:append { W = true, I = true, c = true, C = true }
opt.showmatch = true
opt.showmode = false
opt.signcolumn = "yes"
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true

-- Tabs, spaces, indentation
opt.expandtab = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.shiftround = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2

-- Memory, CPU
opt.timeoutlen = 300
opt.undofile = true
opt.updatetime = 200
