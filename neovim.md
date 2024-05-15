<!-- markdownlint-disable MD013 -->

# Neovim

This document contains notes/tasks/etc. as relevant to migrating from my current [LazyVim](https://github.com/ascander/nvim) distribution to one managed by Nix. A few goals:

- Support for vim plugins as flake inputs, for updating outside of waiting for things to land in `nixpkgs`
- Managing all plugins, tree-sitter grammars, language servers, linters, etc. via Nix
- Configuring Neovim and plugins in Lua
- Lazy loading of plugins as possible in Nix

## Distribution

The current plan is to use [kickstart-nix.nvim](https://github.com/nix-community/kickstart-nix.nvim)

## Plugins

The plugins I currently have in my LazyVim configuration are listed below, with a brief description:

### Editor

| plugin                                                                                   | description                                                |
| ---------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| [auto-save.nvim](https://github.com/pocco81/auto-save.nvim)                              | automatically save buffers                                 |
| [flash.nvim](https://github.com/folke/flash.nvim?tab=readme-ov-file)                     | navigate using search labels                               |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                             | statusline                                                 |
| [mini.ai](https://github.com/echasnovski/mini.ai)                                        | extend and create `a/i` textobjects                        |
| [mini.align](https://github.com/echasnovski/mini.align)                                  | align text interactively                                   |
| [mini.bufremove](https://github.com/echasnovski/mini.bufremove)                          | remove (unshow/delete/wipeout) buffers                     |
| [mini.pairs](https://github.com/echasnovski/mini.pairs)                                  | autopairs                                                  |
| [mini.surround](https://github.com/echasnovski/mini.surround)                            | add/delete/replace surrounding characters                  |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)                          | file explorer                                              |
| [nvim-spectre](https://github.com/nvim-pack/nvim-spectre)                                | search/replace in multiple files                           |
| [persistence.nvim](https://github.com/folke/persistence.nvim)                            | session management                                         |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)                                 | library used by other plugins                              |
| [pomo.nvim](https://github.com/epwalsh/pomo.nvim)                                        | pomodoro style timers in neovim                            |
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | FZF sorter for telescope                                   |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)                       | fuzzy finder engine                                        |
| [vim-startuptime](https://github.com/dstein64/vim-startuptime)                           | profile neovim startup time                                |
| [which-key.nvim](https://github.com/folke/which-key.nvim)                                | shows active keybindings of the command you started typing |

### Git

| plugin | description |
| ------ | ----------- |
|

### Coding

|plugin |description|
|-------|-----------|
|[Comment.nvim](https://github.com/numToStr/Comment.nvim)
|[LuaSnip](https://github.com/L3MON4D3/LuaSnip)
|[friendly-snippets](https://github.com/rafamadriz/friendly-snippets)

### UI

| plugin                                                                          | description                                          |
| ------------------------------------------------------------------------------- | ---------------------------------------------------- |
| [dashboard-nvim](https://github.com/nvimdev/dashboard-nvim)                     | configurable start page                              |
| [dressing.nvim](https://github.com/stevearc/dressing.nvim)                      | fancy `vim.ui` interfaces                            |
| [headlines.nvim](https://github.com/lukas-reineke/headlines.nvim)               | fancy highlighting for markdown headers              |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | shows indentation guides                             |
| [mini.indentscope](https://github.com/echasnovski/mini.indentscope)             | active indent guide and indent textobjects           |
| [noice.nvim](https://github.com/folke/noice.nvim)                               | replaces the UI for messages, cmdline, and popupmenu |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim)                             | UI component library                                 |
| [nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua)            | highlights color specifications                      |
| [nvim-notify](https://github.com/rcarriga/nvim-notify)                          | fancy UI for notifications via `vim.notify()`        |
| [nvim-tmux-navigation](https://github.com/alexghergh/nvim-tmux-navigation)      | navigate between Neovim/Tmux windows                 |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)             | fancy icons for UI elements                          |

#### Colorschemes

| plugin                                                                         | description        |
| ------------------------------------------------------------------------------ | ------------------ |
| [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)                      | Kanagawa themes    |
| [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim)                     | Nightfox themes    |
| [rose-pine/neovim](https://github.com/rose-pine/neovim)                        | Rosé Pine themes   |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim?tab=readme-ov-file) | Tokyo Night themes |

```sh
X Comment.nvim                  # managing comment strings
X LuaSnip                       # snippet engine
aerial.nvim                   # LSP symbol outline
X auto-save.nvim                # auto-save buffers
cmp-buffer                    # buffer completion
cmp-nvim-lsp                  # LSP completion
cmp-path                      # filepath completion
cmp_luasnip                   # snippet completion
conform.nvim                  # formatter plugin
X dashboard-nvim                # splash page
X dressing.nvim                 # fancy `vim.ui` interfaces
X flash.nvim                    # treesitter-aware navigation w/ labels, character motions
X friendly-snippets             # snippet collection
X git-conflict.nvim             # manage git merge conflicts
X gitlinker.nvim                # generate links to github from source files
X gitsigns.nvim                 # Git integration for buffers
X headlines.nvim                # horizontal highlights for markdown headers
X indent-blankline.nvim         # indentation guides
X kanagawa.nvim                 # color theme
X lualine.nvim                  # statusline
markdown-preview.nvim         # preview markdown files
mason-lspconfig.nvim          # integration between mason.nvim and lspconfig
mason-nvim-dap.nvim           # integration between mason.nvim and nvim-dap
mason.nvim                    # package manager for LSP servers, DAP servers, linters, etc.
X mini.ai                       # extend and create `a`/`i` textobjects
X mini.align                    # align text interactively
X mini.bufremove                # remove buffers
mini.diff                     # work with diff hunks
X mini.indentscope              # visualize and work with indent scope
X mini.pairs                    # auto pairs
X mini.surround                 # surround actions
X neo-tree.nvim                 # file system browser
neoconf.nvim                  # plugin to manage global and project-local settings
neodev.nvim                   # plugin for configuring lua-language-server for Neovim config
X neovim                        # Rosé Pine colorschemes
X nightfox.nvim                 # Nightfox colorschemes
X noice.nvim                    # replacement UI for `messages`, `cmdline`, `popupmenu`
none-ls.nvim                  # use Neovim as a language server
X nui.nvim                      # UI component library for Neovim
nvim-cmp                      # completion engine
X nvim-colorizer.lua            # colorizer plugin in Lua
nvim-dap                      # Debug Adapter Protocol client for Neovim
nvim-dap-python               # nvim-dap extension for Python debugging
nvim-dap-ui                   # UI for nvim-dap
nvim-dap-virtual-text         # virtual text support for nvim-dap
nvim-lint                     # async linter plugin for Neovim
nvim-lspconfig                # configurations for Neovim LSP
nvim-metals                   # a Metals plugin for Neovim (for Scala)
nvim-nio                      # plugin for asynchronous IO in Neovim (eg. nvim-dap-ui)
X nvim-notify                   # fancy UI for notifications in Neovim
X nvim-spectre                  # search plugin for Neovim
X nvim-tmux-navigation          # navigate between Neovim buffers and tmux panes
nvim-treesitter               # Neovim tree-sitter configurations and abstraction layer
nvim-treesitter-context       # UI to show code context (eg. method start)
nvim-treesitter-textobjects   # tree-sitter aware textobjects
nvim-ts-autotag               # use tree-sitter to auto-close and auto-rename HTML tags
nvim-ts-context-commentstring # set `commentstring` based on cursor location
X nvim-web-devicons             # use fancy icons in the UI (requires appropriate Nerd font)
X persistence.nvim              # session management plugin
X plenary.nvim                  # lua function library
X pomo.nvim                     # pomodoro style timers
rainbow_csv                   # CSV support
semshi                        # semantic highlighting for Python
X telescope-fzf-native.nvim     # FZF sorter for telescope.nvim
X telescope.nvim                # fuzzy finder engine
todo-comments.nvim            # highlight/search for TODO comments
X tokyonight.nvim               # color theme
trouble.nvim                  # plugin for diagnostics, LSP references, etc.
twilight.nvim                 # UI plugin to dim inactive portions of code
venv-selector.nvim            # virtualenv selector for Python projects
vim-illuminate                # automatically highlight other uses of word under cursor
X vim-startuptime               # plugin to profile Neovim startup time
X which-key.nvim                # show key bindings for command prefix
zen-mode.nvim                 # distraction-free coding UI
```
