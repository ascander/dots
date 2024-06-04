return {
  -- flash.nvim
  -- https://github.com/folke/flash.nvim
  -- enhanced navigation with search labels
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    -- vscode = true,
    ---@type Flash.Config
    opts = { modes = { search = { enabled = true } } },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
}
