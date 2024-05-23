local icons = require "user.icons"
local lspconfig = require "lspconfig"

-- TODO: switch to basedpyright once it lands in nixpkgs
-- See https://github.com/NixOS/nixpkgs/pull/308503
local servers = {
  "pyright",
  "bashls",
  "jsonls",
  "lua_ls",
  "nixd",
  "yamlls",
}

local function on_attach(_, bufnr)
  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

  local opts = { buffer = bufnr, noremap = true, silent = true }

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
  vim.keymap.set("n", "gd", function()
    require("telescope.builtin").lsp_definitions { reuse_win = true }
  end, opts)
  vim.keymap.set("n", "gI", function()
    require("telescope.builtin").lsp_implementations { reuse_win = true }
  end, opts)
  vim.keymap.set("n", "gy", function()
    require("telescope.builtin").lsp_type_definitions { reuse_win = true }
  end, opts)

  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, opts)

  vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", opts)
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, opts)
  vim.keymap.set("n", "<leader>cC", vim.lsp.codelens.refresh, opts)
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename)
end

local function common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  return capabilities
end

local default_diagnostic_config = {
  signs = {
    active = true,
    values = {
      { name = "DiagnosticSignError", text = icons.diagnostics.Error },
      { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
      { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
      { name = "DiagnosticSignInfo", text = icons.diagnostics.Info },
    },
  },
  virtual_text = false,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

vim.diagnostic.config(default_diagnostic_config)

for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config() or {}, "signs", "values") or {}) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
require("lspconfig.ui.windows").default_options.border = "rounded"

for _, server in pairs(servers) do
  local opts = {
    on_attach = on_attach,
    capabilities = common_capabilities(),
  }
  if server == "lua_ls" then
    require("neodev").setup {}
  end

  lspconfig[server].setup(opts)
end
