--[[

General Neovim mappings

Note:

  - Mappings associated with specific functionality (LSP) or a plugin
    (Telescope) are defined in the relevant module.

Help tags:

  - mapleader
  - maplocalleader
  - vim.keymap.set()

--]]

local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

-- Change split orientation
vim.keymap.set("n", "<leader>tk", "<C-w>t<C-w>K", { desc = "Change vertical split to horizontal" })
vim.keymap.set("n", "<leader>th", "<C-w>t<C-w>H", { desc = "Change horizontal split to vertical" })

-- Reload configuration
vim.keymap.set("n", "<leader>R", ":so %<CR>", { desc = "Reload Neovim configuration" })
