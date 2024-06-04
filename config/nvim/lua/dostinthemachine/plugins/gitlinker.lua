return {
  -- gitlinker.nvim
  -- https://github.com/ruifm/gitlinker.nvim
  -- Generate Git permalinks
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

      require("gitlinker").setup {
        opts = opts,
        callbacks = callbacks,
      }
    end,
  },
}
