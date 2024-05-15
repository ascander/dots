local plugin = "nvim-tree"
local status_ok, nvimtree = pcall(require, plugin)
if not status_ok then
  vim.notify("plugin " .. plugin .. " not found!")
  return
end

nvimtree.setup({})
