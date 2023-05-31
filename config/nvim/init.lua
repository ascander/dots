--[[

Neovim init file

Not that we needed all that for the trip, but once you get locked into a
serious drug collection, the tendency is to push it as far as you can.

                                                           - Hunter S. Thompson

--]]

-- Import Lua modules
for _, source in ipairs({
  "core.options",
  "core.autocmds",
  "core.colors",
  "core.keymaps",
  "core.statusline",
  "lsp.diagnostics",
  "lsp.lspconfig",
  "lsp.metals",
  "plugins.telescope",
  "plugins.cmp",
  "plugins.treesitter",
  "plugins.comment",
}) do
  local ok, fault = pcall(require, source)
  if not ok then
    vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
  end
end
