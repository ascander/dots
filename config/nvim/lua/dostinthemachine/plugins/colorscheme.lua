return {
  -- tokyonight.nvim
  -- https://github.com/folke/tokyonight.nvim
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd "colorscheme tokyonight-moon"
    end,
  },

  -- rose-pine/neovim
  -- https://github.com/rose-pine/neovim
  { "rose-pine/neovim", name = "rose-pine", lazy = true },

  -- kanagawa.nvim
  -- https://github.com/rebelot/kanagawa.nvim
  { "rebelot/kanagawa.nvim", lazy = true },

  -- nightfox.nvim
  -- https://github.com/EdenEast/nightfox.nvim
  --
  -- See https://github.com/folke/lazy.nvim?tab=readme-ov-file#examples
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
  },
}
