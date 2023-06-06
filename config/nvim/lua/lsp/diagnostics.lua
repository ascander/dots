--[[

LSP diagnostics configuration

See:

  - https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/

Help tags:

  - vim.diagnostic
  - vim.diagnostic.config

--]]

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Helper function to define a diagnostic sign
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = "",
  })
end

-- Settings.
sign({ name = "DiagnosticSignError", text = "●" })
sign({ name = "DiagnosticSignWarn", text = "▲" })
sign({ name = "DiagnosticSignInfo", text = "»" })
sign({ name = "DiagnosticSignHint", text = "⚑" })

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Autocommands.
local diagnostic_group = augroup("diagnostic", { clear = true })

autocmd("ModeChanged", {
  group = diagnostic_group,
  pattern = { "n:i", "v:s" },
  desc = "Disable diagnostics while typing",
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

autocmd("ModeChanged", {
  group = diagnostic_group,
  pattern = "i:n",
  desc = "Enable diagnostics when leaving insert mode",
  callback = function()
    vim.diagnostic.enable(0)
  end,
})

-- Mappings.
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
