return {
  -- nvim-tmux-navigation
  -- https://github.com/alexghergh/nvim-tmux-navigation
  {
    "alexghergh/nvim-tmux-navigation",
    keys = {
      { "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", desc = "Navigate Left" },
      { "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", desc = "Navigate Down" },
      { "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", desc = "Navigate Up" },
      { "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", desc = "Navigate Right" },
      { "<C-\\>", "<cmd>NvimTmuxNavigateLastActive<cr>", desc = "Navigate Last Active" },
      { "<C-Space>", "<cmd>NvimTmuxNavigateNavigateNext<cr>", desc = "Navigate Next" },
    },
    config = true,
  }
}
