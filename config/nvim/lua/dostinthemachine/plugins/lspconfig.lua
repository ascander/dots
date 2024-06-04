return {
  -- nvim-lspconfig
  -- https://github.com/neovim/nvim-lspconfig
  -- Quickstart configs for Neovim LSP
  --
  -- Dependencies:
  --   neoconf.nvim         (global/project specific settings)
  --   neodev.nvim          (enhanced support for LSP in Neovim config)
  --   mason.nvim           (package manager for LSP)
  --   mason-lspconfig.nvim (mason/lspconfig integration)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
      { "folke/neodev.nvim", opts = {} },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = function()
      local icons = require "dostinthemachine.icons"
      return {
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = false,
          severity_sort = true,
          signs = {
            values = {
              { name = "DiagnosticSignError", text = icons.diagnostics.Error },
              { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
              { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
              { name = "DiagnosticSignInfo", text = icons.diagnostics.Info },
            },
          },
          float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
          },
        },
        servers = {
          basedpyright = {},
          bashls = {},
          jsonls = {},
          nixd = { mason = false }, -- not in the Mason registry
          yamlls = {},

          lua_ls = {
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("neoconf").setup {}

      -- Setup LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("dostinthemachine_lsp_attach", { clear = true }),
        callback = function(event)
          -- Sets a buffer-local keymap
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc, noremap = true, silent = true })
          end

          -- stylua: ignore start
          map("n", "gd", function() require("telescope.builtin").lsp_definitions { reuse_win = true } end, "Goto Definition")
          map("n", "gI", function() require("telescope.builtin").lsp_implementations { reuse_win = true } end, "Goto Implementations")
          map("n", "gy", function() require("telescope.builtin").lsp_type_definitions { reuse_win = true } end, "Goto Type Definition")
          map("n", "gr", "<cmd>Telescope lsp_references<cr>", "References")
          map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
          map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

          map("n", "<leader>cl", "<cmd>LspInfo<cr>", "LSP Info")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, "Run Codelens")
          map("n", "<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display Codelens")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          -- stylua: ignore end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          -- TODO: confirm this works as implemented
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map("n", "<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
            end, "Toggle Inlay Hints")
          end

          -- The following autocommand is used to refresh codelens on certain
          -- events, if the language server supports them.
          -- TODO: troubleshoot and fix if necessary
          -- if client and client.server_capabilities.codeLensProvider and vim.lsp.codelens then
          --   vim.lsp.codelens.refresh()
          --   vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
          --     buffer = event.buf,
          --     group = vim.api.nvim_create_augroup("dostinthemachine_lsp_codelens", { clear = true }),
          --     callback = vim.lsp.codelens.refresh
          --   })
          -- end
        end,
      })

      -- Setup diagnostics
      local diagnostics_config = vim.deepcopy(opts.diagnostics)
      vim.diagnostic.config(diagnostics_config)

      for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config() or {}, "signs", "values") or {}) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
      end

      -- Setup window styling for LSP and diagnostics
      require("lspconfig.ui.windows").default_options.border = "rounded"

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      -- Enable the language servers in `opts.servers` above.
      --
      -- Unless a server has been configured with `mason = false` we add it to
      -- the list of servers for Mason to install.
      local servers = vim.deepcopy(opts.servers)

      -- Configures a language server
      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        require("lspconfig")[server].setup(server_opts)
      end

      -- Install all servers that are available through `mason-lspconfig`.
      --
      -- If a server has been configured with `mason = false` or is not
      -- available through `mason-lspconfig`, assume it will be installed
      -- independently. All other servers are added to the `ensure_installed`
      -- field of the `mason-lspconfig` options.
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mlsp_servers = {}
      if have_mason then
        all_mlsp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      -- Filter servers to populate `ensure_installed` for mason-lspconfig
      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- Run 'setup' manually on servers configured with `mason = false` or
          -- are unavailable through `mason-lspconfig`
          if server_opts.mason == false or not vim.tbl_contains(all_mlsp_servers, server) then
            setup(server)
          elseif server_opts.enabled ~= false then
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      -- Setup mason-lspconfig
      -- TODO: have this load the configured opts (see LazyVim.opts)
      if have_mason then
        mlsp.setup {
          ensure_installed = vim.tbl_deep_extend("force", ensure_installed, {}),
          handlers = { setup },
        }
      end
    end,
  },
}
