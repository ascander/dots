return {
  -- nvim-tree.
  -- https://github.com/nvim-tree/nvim-tree.lua
  -- file explorer tree
  {
    "nvim-tree/nvim-tree.lua",
    cmd = "NvimTreeToggle",
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
    },
    opts = function()
      local icons = require "dostinthemachine.icons"

      return {
        hijack_netrw = false,
        sync_root_with_cwd = true,
        view = {
          relativenumber = true,
          width = {
            min = 30,
            max = -1,
            padding = 2,
          },
        },
        renderer = {
          add_trailing = false,
          group_empty = false,
          highlight_git = false,
          full_name = false,
          highlight_opened_files = "none",
          root_folder_label = ":t",
          indent_width = 2,
          indent_markers = {
            enable = false,
            inline_arrows = true,
            icons = {
              corner = "└",
              edge = "│",
              item = "│",
              none = " ",
            },
          },
          icons = {
            git_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ",
            glyphs = {
              default = icons.ui.Text,
              symlink = icons.ui.FileSymlink,
              bookmark = icons.ui.BookMark,
              folder = {
                arrow_closed = icons.ui.ChevronRight,
                arrow_open = icons.ui.ChevronShortDown,
                default = icons.ui.Folder,
                open = icons.ui.FolderOpen,
                empty = icons.ui.EmptyFolder,
                empty_open = icons.ui.EmptyFolderOpen,
                symlink = icons.ui.FolderSymlink,
                symlink_open = icons.ui.FolderOpen,
              },
              git = {
                unstaged = icons.git.FileUnstaged,
                staged = icons.git.FileStaged,
                unmerged = icons.git.FileUnmerged,
                renamed = icons.git.FileRenamed,
                untracked = icons.git.FileUntracked,
                deleted = icons.git.FileDeleted,
                ignored = icons.git.FileIgnored,
              },
            },
          },
          special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
          symlink_destination = true,
        },
        update_focused_file = {
          enable = true,
          debounce_delay = 15,
          update_root = true,
          ignore_list = {},
        },

        diagnostics = {
          enable = true,
          show_on_dirs = false,
          show_on_open_dirs = true,
          debounce_delay = 50,
          severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
          },
          icons = {
            hint = icons.diagnostics.BoldHint,
            info = icons.diagnostics.BoldInformation,
            warning = icons.diagnostics.BoldWarning,
            error = icons.diagnostics.BoldError,
          },
        },
      }
    end,
  },
}
