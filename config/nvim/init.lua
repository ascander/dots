-- Enable the experimental Lua module loader
-- See `:help loader`
vim.loader.enable()

-- Disable netrw
-- See `:help netrw-noload`
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Load UI utils
_G.UI = require "util.ui"

-- Core modules
require "user.options"
require "user.keymaps"
require "user.autocmds"

-- Editor
require "user.telescope"
require "user.treesitter"
require "user.flash"
require "user.nvimtree"
require "user.gitsigns"
require "user.gitlinker"
require "user.gitconflict"
require "user.comment"
require "user.mini"
require "user.autotag"
require "user.persistence"

-- UI
require "user.colorscheme"
require "user.lualine"
require "user.dashboard"
require "user.indent-blankline"
require "user.whichkey"
require "user.todocomments"
require "user.illuminate"

-- LSP
require "user.lspconfig"
require "user.cmp"
