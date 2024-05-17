-- Enable the experimental Lua module loader
-- See `:help loader`
vim.loader.enable()

-- Disable netrw
-- See `:help netrw-noload`
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Load modules
require("user.options")
require("user.keymaps")
require("user.colorscheme")
require("user.autocmds")
require("user.lualine")
require("user.telescope")
require("user.treesitter")
require("user.nvim-tree")
require("user.gitsigns")
require("user.gitlinker")
require("user.gitconflict")
require("user.mini")
require("user.comment")
require("user.autotag")
require("user.indent-blankline")
require("user.dashboard")
