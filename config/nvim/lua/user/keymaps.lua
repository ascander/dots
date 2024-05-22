-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opts = { noremap = true, silent = true }

-- Clear highlight on pressing <Esc> in normal mode
vim.keymap.set({ "i", "n" }, '<Esc>', '<cmd>nohlsearch<CR><Esc>', opts)

-- Better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase Window Width" })

-- Move Lines
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<CR>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<CR>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move Up" })

-- Buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<CR>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bd", UI.bufremove, { desc = "Delete Buffer" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
vim.keymap.set(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- Save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save File" })

-- keywordprg
vim.keymap.set("n", "<leader>K", "<cmd>norm! K<CR>", { desc = "Keywordprg" })

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- New file
vim.keymap.set("n", "<leader>fn", "<cmd>enew<CR>", { desc = "New File" })

-- Quickfix lists
vim.keymap.set("n", "<leader>xl", "<cmd>lopen<CR>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<CR>", { desc = "Quickfix List" })
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Diagnostics
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit All" })

-- Highlights under cursor
vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

-- Windows
vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })

-- Tabs
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<CR>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<CR>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<CR>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<CR>", { desc = "Previous Tab" })

-- NvimTree
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', opts)

-- Flash
vim.keymap.set({ "n", "x", "o"}, "s", function() require("flash").jump() end, opts)
vim.keymap.set({ "n", "x", "o"}, "S", function() require("flash").treesitter() end, opts)
vim.keymap.set("o", "r", function() require("flash").remote() end, opts)
vim.keymap.set({ "x", "o" }, "R", function() require("flash").treesitter_search() end, opts)
vim.keymap.set("c", "<C-s>", function() require("flash").toggle() end, opts)

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
vim.keymap.set('n', '<leader>uc', '<cmd>Telescope colorscheme enable_preview=true<CR>', opts)
vim.keymap.set('n', '<leader>ss', function() require("telescope.builtin").lsp_document_symbols() end, opts)
vim.keymap.set('n', '<leader>sS', function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end, opts)

-- Gitlinker
vim.keymap.set('n', '<leader>gy', function() require("gitlinker").get_buf_range_url("n", {}) end, opts)
vim.keymap.set('v', '<leader>gy', function() require("gitlinker").get_buf_range_url("v", {}) end, opts)
vim.keymap.set('n', '<leader>gY', function() require("gitlinker").get_buf_range_url("n", { action_callback = require("gitlinker.actions").open_in_browser }) end, opts)
vim.keymap.set('v', '<leader>gY', function() require("gitlinker").get_buf_range_url("v", { action_callback = require("gitlinker.actions").open_in_browser }) end, opts)

-- Git-conflict
vim.keymap.set("n", "]x", "<cmd>GitConflictNextConflict<CR>", opts)
vim.keymap.set("n", "[x", "<cmd>GitConflictPrevConflict<CR>", opts)
vim.keymap.set("n", "co", "<cmd>GitConflictChooseOurs<CR>", opts)
vim.keymap.set("n", "ct", "<cmd>GitConflictChooseTheirs<CR>", opts)
vim.keymap.set("n", "cn", "<cmd>GitConflictChooseNone<CR>", opts)
vim.keymap.set("n", "cb", "<cmd>GitConflictChooseBoth<CR>", opts)

-- Mini.pairs
vim.keymap.set("n", "<leader>up", function()
	vim.g.minipairs_disable = not vim.g.minipairs_disable
	if vim.g.minipairs_disable then
		vim.notify("Disabled auto pairs")
	else
		vim.notify("Enabled auto pairs")
	end
end, opts)

-- Persistence
vim.keymap.set("n", "<leader>qr", function() require("persistence").load() end, opts)
vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, opts)
vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, opts)

-- Todo-comments.nvim
vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, opts)
vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, opts)
vim.keymap.set("n", "<leader>xt", "<cmd>TodoTrouble<CR>", opts)
vim.keymap.set("n", "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<CR>", opts)
vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<CR>", opts)
vim.keymap.set("n", "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<CR>", opts)
