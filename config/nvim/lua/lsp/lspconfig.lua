--[[

LSP configuration

Installed servers:

  Bash    → bashls
  Lua     → lua-language-server
  Nix     → nil
  Python  → pyright
  Scala   → nvim-metals (Note: not part of lspconfig)
  YAML    → yamlls

Plugins:

  nvim-lspconfig (https://github.com/neovim/nvim-lspconfig)
  cmp-nvim-lsp (https://github.com/hrsh7th/cmp-nvim-lsp)

Note: diagnostics configuration is in `lsp/diagnostics` and completion
      configuration is in `plugins/cmp`.

--]]

local api = vim.api
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local lsp_ok, lspconfig = pcall(require, "lspconfig")
if not lsp_ok then
  return
end

local builtin_ok, builtin = pcall(require, "telescope.builtin")
if not builtin_ok then
  return
end

-- Add additional capabilities supported by nvim-cmp
-- See: https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion#nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Style hover and signature help floating windows
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

local lsp_group = augroup("lsp", { clear = true })
autocmd("LspAttach", {
  desc = "LSP keymaps & autocommands",
  group = lsp_group,
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufmap = function(mode, lhs, rhs)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Enable completion triggered by <c-x><c-o>
    if client.server_capabilities.completionProvider then
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end

    -- Enable symbol highlighting for the current buffer
    if client.server_capabilities.documentHighlightProvider then
      autocmd("CursorHold", {
        desc = "Highlight matching symbols in buffer",
        group = lsp_group,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      })
      autocmd("CursorMoved", {
        desc = "Clear highlighted symbols in buffer",
        group = lsp_group,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end

    if client.server_capabilities.codeLensProvider then
      autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        desc = "Refresh the codelens for the current buffer",
        group = lsp_group,
        buffer = bufnr,
        callback = function()
          vim.lsp.codelens.refresh()
        end,
      })
    end

    -- Mappings
    bufmap("n", "gD", vim.lsp.buf.declaration)
    bufmap("n", "gd", vim.lsp.buf.definition)
    bufmap("n", "gi", vim.lsp.buf.implementation)

    bufmap("n", "gr", builtin.lsp_references)
    bufmap("n", "gds", builtin.lsp_document_symbols)
    bufmap("n", "gws", builtin.lsp_dynamic_workspace_symbols)

    bufmap("n", "K", vim.lsp.buf.hover)
    bufmap("n", "<leader>k", vim.lsp.buf.signature_help)

    bufmap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder)
    bufmap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder)
    bufmap("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end)
    bufmap("n", "<leader>D", vim.lsp.buf.type_definition)
    bufmap("n", "<leader>rn", vim.lsp.buf.rename)
    bufmap("n", "<leader>ca", vim.lsp.buf.code_action)
    bufmap("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end)
  end,
})

-- Configure language servers
local servers = { "bashls", "pyright", "yamlls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({ capabilities = capabilities })
end

-- Configure nil language server
-- See https://github.com/oxalica/nil/blob/dcd38b96c91a2d07552f824a6480e00dc7b4948a/dev/nvim-lsp.nix#L83-L95
lspconfig.nil_ls.setup({
  autostart = true,
  capabilities = capabilities,
  cmd = { "nil" },
  settings = {
    ['nil'] = {
      formatting = {
        command = { "nixpkgs-fmt" },
      },
    },
  },
})

-- Configure lua language server
-- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})
