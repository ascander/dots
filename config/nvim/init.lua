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
require("user.nvim-tree")
-- require("user.comment")
