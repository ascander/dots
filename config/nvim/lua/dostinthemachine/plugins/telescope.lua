return {
  -- telescope.nvim
  -- https://github.com/nvim-telescope/telescope.nvim
  -- Fuzzy finder (files, LSP, etc.)
  {
    'nvim-telescope/telescope.nvim',
    cmd = "Telescope",
    version = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
    },
    keys = {
      -- convenience keymaps for frequently used commands
      { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer", },
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      -- find
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      -- git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
      -- search
      { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
      { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
      -- { "<leader>sw", LazyVim.telescope("grep_string", { word_match = "-w" }), desc = "Word (Root Dir)" },
      -- { "<leader>sW", LazyVim.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
      { "<leader>uC", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "Colorscheme with Preview" },
    },
    opts = function()
      local actions = require("telescope.actions")
      local themes = require("telescope.themes")

      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          mappings = {
            i = {
              ["<C-j>"] = actions.cycle_history_next,
              ["<C-k>"] = actions.cycle_history_prev,
              ["<esc>"] = actions.close,
            },
          }
        },
        extensions = {
          ["ui-select"] = { themes.get_dropdown() },
        }
      }
    end,
    config = function(_, opts)
      require('telescope').setup(opts)

      -- Enable Telescope extensions
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
    end,
  },
}
