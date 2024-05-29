return {

  -- lualine.nvim
  -- https://github.com/nvim-lualine/lualine.nvim
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" }
    },
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = require("dostinthemachine.icons")

      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },

          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          },
          lualine_x = {
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return icons.misc.Watch .. " " .. os.date("%R")
            end,
          },
        },
        extensions = { "nvim-tree", "lazy" },
      }
    end,
  },

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
          "mason",
          "notify",
          "toggleterm",
        },
      },
    },
    main = "ibl",
  },

  -- mini.indentscope
  -- https://github.com/echasnovski/mini.indentscope
  -- animated highlights of indent guides
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = "VeryLazy",
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- nvim-web-devicons
  -- https://github.com/nvim-tree/nvim-web-devicons
  -- Fancy icon support (requires a Nerd font)
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- nvim-colorizer.lua
  -- https://github.com/norcalli/nvim-colorizer.lua
  -- High-performance color highlighter for Neovim
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    keys = {
      { "<leader>to", "<cmd>ColorizerToggle<cr>", desc = "Toggle Colorizer"},
    },
    config = function ()
      require("colorizer").setup()
    end
  },

  -- zen-mode.nvim
  -- https://github.com/folke/zen-mode.nvim
  -- Distraction-free writing mode
  {
    "folke/zen-mode.nvim",
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
