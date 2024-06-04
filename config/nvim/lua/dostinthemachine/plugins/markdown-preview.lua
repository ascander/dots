return {
  -- markdown-preview.nvim
  -- https://github.com/iamcco/markdown-preview.nvim
  -- Markdown preview plugin for Neovim
  -- TODO: fix yarn error in build step
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd [[do FileType]]
    end,
  },
}
