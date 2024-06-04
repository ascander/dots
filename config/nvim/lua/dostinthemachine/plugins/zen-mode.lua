return {
  -- zen-mode.nvim
  -- https://github.com/folke/zen-mode.nvim
  -- Distraction-free writing mode
  --
  -- Dependencies:
  --   twilight.nvim (dim inactive portions of code)
  {
    "folke/zen-mode.nvim",
    -- Dims inactive portions of code using Treesitter
    dependencies = {
      "folke/twilight.nvim",
      keys = {
        { "<leader>uZ", "<cmd>Twilight<cr>", desc = "Toggle Twilight" },
      },
    },
    keys = {
      { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    },
    opts = {
      plugins = {
        options = { laststatus = 0 },
        tmux = { enabled = true },
        twilight = { enabled = true },
        alacritty = {
          enabled = true,
          font = "16",
        },
      },
    },
  },
}
