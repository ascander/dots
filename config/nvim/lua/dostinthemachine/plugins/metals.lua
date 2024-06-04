return {
  -- nvim-metals
  -- https://github.com/scalameta/nvim-metals
  -- A Metals plugin for Neovim
  --
  -- Dependencies:
  --   plenary.nvim (Lua function library)
  --   nvim-dap     (DAP client for Neovim)
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    ft = { "scala", "sbt", "java" },
    keys = {
      {
        "<leader>cM",
        function()
          require("telescope").extensions.metals.commands()
        end,
        desc = "Metals commands",
      },
    },
    opts = function()
      local metals_config = require("metals").bare_config()

      metals_config.settings = {
        fallbackScalaVersion = "2.12.15",
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        excludedPackages = {
          "akka.actor.typed.javadsl",
          "com.github.swagger.akka.javadsl",
          "akka.stream.javadsl",
          "akka.http.javadsl",
        },
      }

      metals_config.init_options.statusBarProvider = "on"
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      metals_config.on_attach = function()
        require("metals").setup_dap()
      end

      return metals_config
    end,
    config = function(self, opts)
      local nvim_metals_group = vim.api.nvim_create_augroup("dostinthemachine_nvim_metals", { clear = true })

      -- Start Metals when opening a Scala/SBT/Java file
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(opts)
        end,
        group = nvim_metals_group,
      })
    end,
  },
}
