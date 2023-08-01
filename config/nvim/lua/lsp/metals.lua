--[[

Nvim-Metals configuration

Plugins:

  - nvim-metals (https://github.com/scalameta/nvim-metals)
  - cmp-nvim-lsp (https://github.com/hrsh7th/cmp-nvim-lsp)
  - telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)

See:

  - https://github.com/scalameta/nvim-metals/discussions/279

Help tags:

  - nvim-metals

Note: nvim-metals provides additional functionality over the Metals language
server. Metals CANNOT be configured via `nvim-lspconfig` as other language
servers are.

--]]

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local ok, metals = pcall(require, "metals")
if not ok then
  return
end

-- Settings
local metals_config = metals.bare_config()
metals_config.settings = {
  serverVersion = "1.0.0",
  fallbackScalaVersion = "2.12.15",
  showImplicitArguments = true,
  showImplicitConversionsAndClasses = true,
  showInferredType = true,
  excludedPackages = {
    "akka.actor.typed.javadsl",
    "com.github.swagger.akka.javadsl",
    "akka.stream.javadsl",
    "akka.http.javadsl",
  },
}

-- Show Metals status in the statusline
metals_config.init_options.statusBarProvider = "on"

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
metals_config.capabilities = capabilities

-- Metals-specific mappings
metals_config.on_attach = function(client, bufnr)
  local bufmap = function(mode, lhs, rhs)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  bufmap("v", "K", metals.type_of_range)
  bufmap("n", "<leader>mc", require("telescope").extensions.metals.commands)
  bufmap("n", "<leader>ws", function()
    metals.hover_worksheet({ border = "rounded" })
  end)
  bufmap("n", "<leader>st", function()
    metals.toggle_setting("showImplicitArguments")
  end)
  bufmap("n", "<leader>tt", require("metals.tvp").toggle_tree_view)
  bufmap("n", "<leader>tr", require("metals.tvp").reveal_in_tree)
end

-- Start Metals when a file of the right type is opened
local metals_group = augroup("metals", { clear = true })
autocmd("FileType", {
  group = metals_group,
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
})
