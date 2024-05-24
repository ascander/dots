return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline until lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      -- https://github.com/LazyVim/LazyVim/blob/0f6ff53ce336082869314db11e9dfa487cf83292/lua/lazyvim/plugins/ui.lua#L123
      local lualine_require = require "lualine_require"
      lualine_require.require = require

      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = "auto",
          always_divide_middle = false,
          globalstatus = true,
          icons_enabled = true,
          ignore_focus = { "NvimTree" },
          disabled_filetypes = { statusline = { "dashboard" }},
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "dianostics" },
          lualine_c = {
            { "filename" },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          },
          lualine_x = {},
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 }},
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return " " .. os.date "%R" 
            end
          },
        },
        extensions = { "lazy", "nvim-tree", "quickfix" }
      }
    end,
  }
}
