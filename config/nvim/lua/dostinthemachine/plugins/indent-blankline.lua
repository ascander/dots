return {
  -- indent-blankline.nvim
  -- https://github.com/lukas-reineke/indent-blankline.nvim
  -- indent-guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help",
          "dashboard",
          "NvimTree",
          "Trouble",
          "trouble",
          "lazy",
          "markdown",
          "mason",
          "notify",
          "toggleterm",
        },
      },
    },
    main = "ibl",
  },
}
