-- Set leader key before plugins are loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set core options
require "dostinthemachine.options"
require "dostinthemachine.keymaps"
require "dostinthemachine.autocmds"
require "dostinthemachine.lazy"
