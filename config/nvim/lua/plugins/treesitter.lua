--[[

Treesitter configuration

Plugins:

  - nvim-treesitter (https://github.com/nvim-treesitter/nvim-treesitter)

See:

  - https://vonheikemen.github.io/devlog/tools/neovim-plugins-to-get-started/

Help tags:

 - treesitter
 - treesitter-parsers

Note: Treesitter grammars are managed by Nix. See the Treesitter discussion in:

https://nixos.org/manual/nixpkgs/unstable/#managing-plugins-with-vim-packages

for details.

--]]

local ok, ts = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

-- Settings.
ts.setup({
  highlight = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      node_decremental = "grm",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ia"] = "@parameter.inner",
      },
    },
    swap = {
      enable = true,
      swap_previous = { ["{a"] = "@parameter.inner" },
      swap_next = { ["}a"] = "@parameter.inner" },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]a"] = "@parameter.inner",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[a"] = "@parameter.inner",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
      },
    },
  },
})
