--[[

Statusline configuration

Plugins:

  - lualine.nvim (https://github.com/nvim-lualine/lualine.nvim)

See:

  - https://github.com/nvim-lualine/lualine.nvim#usage-and-customization

--]]

local ok, lualine = pcall(require, "lualine")
if not ok then
  return
end

-- Settings.
lualine.setup({
  options = {
    icons_enabled = true,
    always_divide_middle = false,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename", "g:metals_status" },
    lualine_x = { "fileformat", "encoding", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { "fugitive", "quickfix" },
})
