--[[

Neovim autocompletion configuration

Plugins:

  - nvim-cmp
  - cmp-buffer
  - cmp-path
  - cmp_luasnip
  - cmp-nvim-lsp
  - cmp-nvim-lsp-signature-help
  - luasnip
  - friendly-snippets

See:

  - https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/
  - https://github.com/hrsh7th/nvim-cmp#recommended-configuration
  - https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion

--]]

local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then
  return
end

local luasnip_ok, luasnip = pcall(require, "luasnip")
if not luasnip_ok then
  return
end

-- Load snippets from friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- For mappings where we want to select a completion candidate
local select_opts = { behavior = cmp.SelectBehavior.Select }

-- Settings.
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp", priority = 10 },
    { name = "nvim_lsp_signature_help" },
    { name = "luasnip", keyword_length = 2, priority = 7 },
    { name = "buffer", keyword_length = 3 },
    { name = "path" },
  },
  window = {
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    fields = { "menu", "abbr", "kind" },
    format = function(entry, item)
      local menu_icon = {
        buffer = "Ω",
        path = "/",
        nvim_lsp = "λ",
        luasnip = "⋗",
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = {
    ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
    ["<Down>"] = cmp.mapping.select_next_item(select_opts),

    ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
    ["<C-n>"] = cmp.mapping.select_next_item(select_opts),

    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),

    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      local col = vim.fn.col(".") - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      elseif luasnip.jumpable(-1) then
        luasnip.jump()
      else
        fallback()
      end
    end, { "i", "s" }),
  },
})
