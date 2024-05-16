-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opts = { noremap = true, silent = true }

-- Clear highlight on pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', opts)

-- Toggle
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', opts)

-- Telescope
-- Favorites; set easy maps for common actions
vim.keymap.set('n', '<leader>,', '<cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>', opts)
vim.keymap.set('n', '<leader>/', '<cmd>Telescope live_grep<CR>', opts)
vim.keymap.set('n', '<leader>:', '<cmd>Telescope command_history<CR>', opts)
vim.keymap.set('n', '<leader>;', '<cmd>Telescope resume<CR>', opts)
vim.keymap.set('n', '<leader><space>', '<cmd>Telescope find_files<CR>', opts)
-- Find
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>', opts)
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope git_files<CR>', opts)
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<CR>', opts)
-- Git
vim.keymap.set('n', '<leader>gb', '<cmd>Telescope git_branches<CR>', opts)
vim.keymap.set('n', '<leader>gc', '<cmd>Telescope git_commits<CR>', opts)
vim.keymap.set('n', '<leader>gs', '<cmd>Telescope git_status<CR>', opts)
-- Search
vim.keymap.set('n', '<leader>s"', '<cmd>Telescope registers<CR>', opts)
vim.keymap.set('n', '<leader>sa', '<cmd>Telescope autocommands<CR>', opts)
vim.keymap.set('n', '<leader>sb', '<cmd>Telescope current_buffer_fuzzy_find<CR>', opts)
vim.keymap.set('n', '<leader>sc', '<cmd>Telescope command_history<CR>', opts)
vim.keymap.set('n', '<leader>sC', '<cmd>Telescope commands<CR>', opts)
vim.keymap.set('n', '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<CR>', opts)
vim.keymap.set('n', '<leader>sD', '<cmd>Telescope diagnostics<CR>', opts)
vim.keymap.set('n', '<leader>sg', '<cmd>Telescope live_grep<CR>', opts)
vim.keymap.set('n', '<leader>sh', '<cmd>Telescope help_tags<CR>', opts)
vim.keymap.set('n', '<leader>sH', '<cmd>Telescope highlights<CR>', opts)
vim.keymap.set('n', '<leader>sk', '<cmd>Telescope keymaps<CR>', opts)
vim.keymap.set('n', '<leader>sm', '<cmd>Telescope marks<CR>', opts)
vim.keymap.set('n', '<leader>sM', '<cmd>Telescope man_pages<CR>', opts)
vim.keymap.set('n', '<leader>so', '<cmd>Telescope vim_options<CR>', opts)
vim.keymap.set('n', '<leader>sR', '<cmd>Telescope resume<CR>', opts)
vim.keymap.set('n', '<leader>sw', '<cmd>Telescope grep_string<CR>', opts)
vim.keymap.set('v', '<leader>sw', '<cmd>Telescope grep_string<CR>', opts)
vim.keymap.set('n', '<leader>uC', '<cmd>Telescope colorscheme enable_preview=true<CR>', opts)
vim.keymap.set('n', '<leader>ss', function() require("telescope.builtin").lsp_document_symbols() end, opts)
vim.keymap.set('n', '<leader>sS', function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end, opts)
