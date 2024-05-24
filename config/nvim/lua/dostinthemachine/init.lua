-- disable netrw before loading any plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set leader keys before loading any plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require "dostinthemachine.options"
require "dostinthemachine.keymaps"
require "dostinthemachine.autocmds"
require "dostinthemachine.lazy"
