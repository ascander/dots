--[[

General autocommand configuration

Help tags:

  - api-autocmd
  - augroup

--]]

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

--------------------------------------------------------------------------------
-- General commands
--------------------------------------------------------------------------------

-- Highlight on yank
local yank_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = yank_group,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = "250" })
  end,
})

-- Delete trailing whitespace on save
autocmd("BufWritePre", {
  pattern = "",
  command = ":%s/\\s\\+$//e",
  desc = "Automatically delete trailing whitespace on save",
})

-- Auto-resize splits
local win_group = augroup("WinResized", { clear = true })
autocmd("VimResized", {
  group = win_group,
  pattern = "*",
  command = "wincmd =",
  desc = "Automatically resize windows when the host window size changes",
})

--------------------------------------------------------------------------------
-- Filetype-specific commands
--------------------------------------------------------------------------------

-- Associate 'poetry.lock' files with the right filetype
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "poetry.lock",
  command = "set filetype=toml",
})

-- Settings for markdown files
autocmd("FileType", {
  pattern = "markdown",
  command = "setlocal spell spelllang=en_us",
})

-- Custom bindings for 'vim-surroud' and Scala files
autocmd("FileType", {
  pattern = { "scala", "sbt" },
  command = 'let b:surround_116 = "\1Type: \1[\r]"',
  desc = "Add type constructor with 't'",
})

autocmd("FileType", {
  pattern = { "scala", "sbt" },
  command = 'let b:surround_114 = \'"""\r"""\'',
  desc = "Add triple quotes with 'r'",
})
