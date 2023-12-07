--[[

Colors and colorscheme configuration

The following themes are available:

  - kanagawa.nvim (https://github.com/rebelot/kanagawa.nvim)
  - onedark.nvim (https://github.com/navarasu/onedark.nvim)
  - nightfox.nvim (https://github.com/EdenEast/nightfox.nvim)
  - rose-pine (https://github.com/rose-pine/neovim)

This configuration file should load the user's preferred theme, and export the
color palette for use outside this module

Note:

  - Loading/configuration for different color schemes may vary. See the README
    for the color scheme you want for specific instructions.

--]]

-- Load color theme plugin of choice
local ok, nightfox = pcall(require, "nightfox")
if not ok then
  return
end

local ok, rose_pine = pcall(require, "rose-pine")
if not ok then
  return
end

-- Settings.
nightfox.setup({ options = { styles = { comments = "italic" } } })
rose_pine.setup({ dark_variant = "moon" })

-- Enable default theme.
vim.cmd("colorscheme nightfox")
