-- Enable the experimental Lua module loader
-- See `:help loader`
vim.loader.enable()

-- Disable netrw
-- See `:help netrw-noload`
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Load UI utils
_G.UI = require "util.ui"

-- Load modules
require "user.options"
require "user.keymaps"
require "user.colorscheme"
require "user.autocmds"
require "user.lualine"
require "user.telescope"
require "user.treesitter"
require "user.nvimtree"
require "user.gitsigns"
require "user.gitlinker"
require "user.gitconflict"
require "user.mini"
require "user.comment"
require "user.autotag"
require "user.indent-blankline"
require "user.dashboard"
require "user.persistence"
require "user.flash"
require "user.todocomments"
require "user.whichkey"
require "user.illuminate"
require "user.lspconfig"
require "user.cmp"
