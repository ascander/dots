return {
  -- nvim-colorizer.lua
  -- https://github.com/norcalli/nvim-colorizer.lua
  -- High-performance color highlighter for Neovim
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    keys = {
      { "<leader>uo", "<cmd>ColorizerToggle<cr>", desc = "Toggle Colorizer" },
    },
    config = function()
      require("colorizer").setup()
    end,
  },
}
