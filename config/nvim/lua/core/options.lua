--[[

General Neovim configuration

Default options are not icluded in this configuration file.

See:

  - https://neovim.io/doc/user/vim_diff.html

Help tags:

  - nvim-defaults

--]]

local opt = vim.opt
local g = vim.g

------------------------------------------------------------------------------------------------------------------------
-- General
------------------------------------------------------------------------------------------------------------------------

-- stylua: ignore start
opt.mouse = "a"                                         -- Enable mouse support
opt.clipboard = "unnamedplus"                           -- Use the system clipboard
opt.swapfile = false                                    -- Don't use a swapfile
opt.completeopt = { "menuone", "noinsert", "noselect" } -- Completion options

------------------------------------------------------------------------------------------------------------------------
-- Neovim UI
------------------------------------------------------------------------------------------------------------------------

opt.number = true                                       -- Show line numbers
opt.relativenumber = true                               -- Use relative line numbers
opt.showmatch = true                                    -- Show matching pair
opt.foldmethod = "manual"                               -- Create folds manually
opt.splitright = true                                   -- Vertical splits to the right
opt.splitbelow = true                                   -- Horizontal splits below
opt.ignorecase = true                                   -- Ignore case when searching
opt.smartcase = true                                    -- Don't ignore case on upper case characters
opt.linebreak = true                                    -- Wrap on word boundary
opt.termguicolors = true                                -- Enable 24-bit color
opt.showmode = false                                    -- Don't show the mode via message
opt.cursorline = true                                   -- Highlight the current line
opt.signcolumn = "yes"                                  -- Always display the sign column (for diagnostics)
opt.hlsearch = false                                    -- Don't highlight search results
opt.report = 0                                          -- Always report when lines have changed
opt.shortmess:remove({ "F" })                           -- Give file info when editing a file
opt.shortmess:append({ c = true })                      -- Don't give ins-completion-menu messages

------------------------------------------------------------------------------------------------------------------------
-- Tabs, indentation, spaces
------------------------------------------------------------------------------------------------------------------------

opt.smartindent = true                                  -- Autoindent on new lines
opt.expandtab = true                                    -- Use spaces instead of tabs
opt.shiftwidth = 2                                      -- Default to 2 spaces per indent level
opt.tabstop = 2                                         -- A tab is 2 spaces
opt.shiftround = true                                   -- Round indentation to multiples of 'shiftwidth'
opt.list = true                                         -- Show whitespace

-- How each type of whitespace is displayed
opt.listchars = {
	tab = "| ",
	extends = "⟩",
	precedes = "⟨",
	nbsp = "·",
	trail = "·",
}

------------------------------------------------------------------------------------------------------------------------
-- Memory, CPU
------------------------------------------------------------------------------------------------------------------------

opt.hidden = true                                       -- Enable background buffers
opt.history = 100                                       -- Remember N lines of history
opt.lazyredraw = true                                   -- Avoid redrawing when it might cause issues
opt.synmaxcol = 240                                     -- Max column for syntax highlighting
opt.updatetime = 500                                    -- Wait N ms for a 'CursorHold' autocommand event

------------------------------------------------------------------------------------------------------------------------
-- Startup
------------------------------------------------------------------------------------------------------------------------

opt.shortmess:append({ I = true })                      -- Disable Neovim intro

------------------------------------------------------------------------------------------------------------------------
-- Global variables
------------------------------------------------------------------------------------------------------------------------

g["markdown_composer_autostart"] = 0                    -- Don't render Markdown in a browser tab automatically
g["goyo_width"] = 120                                   -- Default width for distraction-free editing
-- stylua: ignore end
