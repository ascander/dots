return {
  { "folke/tokyonight.nvim" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "rebelot/kanagawa.nvim" },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme terafox")
    end
  }
}
