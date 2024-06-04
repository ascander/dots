return {
  -- Comment.nvim
  -- https://github.com/numToStr/Comment.nvim
  -- Smart and powerful comment plugin for Neovim
  --
  -- Dependencies:
  --   nvim-treesitter               (syntax-aware support for coding)
  --   nvim-ts-context-commentstring (set commentstring based on file location)
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
      { "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
    },
    opts = function()
      local tsintegration = require "ts_context_commentstring.integrations.comment_nvim"

      return {
        pre_hook = tsintegration.create_pre_hook(),
      }
    end,
  },
}
