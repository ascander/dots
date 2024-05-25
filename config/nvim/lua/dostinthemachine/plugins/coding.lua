return {
  -- Comment.nvim
  --
  -- support for commenting
  -- TODO: research builtin commenting
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
    lazy = false,
  },

  -- gitsigns.nvim
  -- https://github.com/lewis6991/gitsigns.nvim
  -- git indicators in buffers
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    -- TODO: use icons module
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", function() gs.nav_hunk("next") end, "Next Hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- gitlinker.nvim
  -- https://github.com/ruifm/gitlinker.nvim
  {
    "ruifm/gitlinker.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>gy",
        function()
          require("gitlinker").get_buf_range_url("n", {})
        end,
        desc = "Copy Git link",
      },
      {
        "<leader>gy",
        function()
          require("gitlinker").get_buf_range_url("v", {})
        end,
        desc = "Copy Git link",
        mode = "v",
      },
      {
        "<leader>gY",
        function()
          require("gitlinker").get_buf_range_url(
            "n",
            { action_callback = require("gitlinker.actions").open_in_browser }
          )
        end,
        desc = "Open Git link",
      },
      {
        "<leader>gY",
        function()
          require("gitlinker").get_buf_range_url(
            "v",
            { action_callback = require("gitlinker.actions").open_in_browser }
          )
        end,
        desc = "Open Git link",
        mode = "v",
      },
    },
    config = function(_, opts)
      -- append work-specific host to default callbacks
      -- see https://github.com/ruifm/gitlinker.nvim?tab=readme-ov-file#configuration
      local callbacks = {
        ["github.com"] = require("gitlinker.hosts").get_github_type_url,
        ["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
        ["try.gitea.io"] = require("gitlinker.hosts").get_gitea_type_url,
        ["codeberg.org"] = require("gitlinker.hosts").get_gitea_type_url,
        ["bitbucket.org"] = require("gitlinker.hosts").get_bitbucket_type_url,
        ["try.gogs.io"] = require("gitlinker.hosts").get_gogs_type_url,
        ["git.sr.ht"] = require("gitlinker.hosts").get_srht_type_url,
        ["git.launchpad.net"] = require("gitlinker.hosts").get_launchpad_type_url,
        ["repo.or.cz"] = require("gitlinker.hosts").get_repoorcz_type_url,
        ["git.kernel.org"] = require("gitlinker.hosts").get_cgit_type_url,
        ["git.savannah.gnu.org"] = require("gitlinker.hosts").get_cgit_type_url,
        ["git.soma.salesforce.com"] = require("gitlinker.hosts").get_github_type_url,
      }

      require("gitlinker").setup({
        opts = opts,
        callbacks = callbacks,
      })
    end,
  },

  --  git-conflict.nvim
  --  https://github.com/akinsho/git-conflict.nvim
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
      require("git-conflict").setup({
        default_mappings = false,
        disable_diagnostics = true,
      })
    end,
  },
}
