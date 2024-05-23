local opt = vim.opt

-- General
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.completeopt = { "menuone", "noinsert", "noselect" }

-- Neovim UI
opt.number = true
opt.relativenumber = true
opt.showmatch = true
opt.foldmethod = "manual"
opt.scrolloff = 10
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.linebreak = true
opt.breakindent = true
opt.termguicolors = true
opt.showmode = false
opt.cursorline = true
opt.signcolumn = "yes"
opt.report = 0
opt.shortmess = "ltToOcCI"

-- Tabs, spaces, indentation
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.shiftround = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Memory, CPU
opt.lazyredraw = true
opt.synmaxcol = 360
opt.updatetime = 250
opt.timeoutlen = 300
opt.undofile = true
