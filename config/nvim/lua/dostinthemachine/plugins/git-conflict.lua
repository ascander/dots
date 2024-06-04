return {
  --  git-conflict.nvim
  --  https://github.com/akinsho/git-conflict.nvim
  --  Visualize and resolve Git merge conflicts
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    version = "*", -- update plugin on new versions only
    keys = {
      { "]x", "<cmd>GitConflictNextConflict<cr>", desc = "Next conflict" },
      { "[x", "<cmd>GitConflictPrevConflict<cr>", desc = "Prev conflict" },
      { "co", "<cmd>GitConflictChooseOurs<cr>", desc = "Choose ours" },
      { "ct", "<cmd>GitConflictChooseTheirs<cr>", desc = "Choose theirs" },
      { "cn", "<cmd>GitConflictChooseNone<cr>", desc = "Choose none" },
      { "cb", "<cmd>GitConflictChooseBoth<cr>", desc = "Choose bolth" },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("git-conflict").setup {
        default_mappings = false,
        disable_diagnostics = true,
      }
    end,
  },
}
