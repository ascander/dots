<!-- markdownlint-disable MD013 -->

# Neovim

This document contains notes/tasks/etc. as relevant to migrating from my current [LazyVim](https://github.com/ascander/nvim) distribution to one managed by Nix. A few goals:

- Allow plugins as flake inputs
- Manage all plugins/executables via Nix
- Local Lua-based configuration for Neovim

Waiting for Neovim plugins to land in `nixpkgs` is annoying, so I want to be able to define plugins as flake inputs and build them in an overlay. I've seen this approach in other Neovim flake-based setups, and I think it's a nice addition for plugins not in nixpkgs, and/or plugins that are more volatile. I want my Lua config to be updatable without regenerating the system, and my existing approach of using `mkOutOfStoreSymlink` is working just fine for me.

## Distribution

Home manager `programs.neovim` using [neovim-nightly-overlay](https://github.com/nix-community/neovim-nightly-overlay) for Neovim, plugins, and executables. Local Lua-based config symlinked using `mkOutOfStoreSymlink` for configuration.

## Plugins (check if migrated)

- [x] Comment.nvim (managing comment strings)
- [x] LuaSnip (snippet engine)
- [x] aerial.nvim (LSP symbol outline)
- [x] cmp-buffer (buffer completion)
- [x] cmp-nvim-lsp (LSP completion)
- [x] cmp-path (filepath completion)
- [x] cmp_luasnip (snippet completion)
- [x] conform.nvim (formatter plugin)
- [x] dashboard-nvim (splash page)
- [x] dressing.nvim (fancy `vim.ui` interfaces)
- [x] flash.nvim (treesitter-aware navigation w/ labels, character motions)
- [x] friendly-snippets (snippet collection)
- [x] git-conflict.nvim (manage git merge conflicts)
- [x] gitlinker.nvim (generate links to github from source files)
- [x] gitsigns.nvim (Git integration for buffers)
- [x] indent-blankline.nvim (indentation guides)
- [x] kanagawa.nvim (color theme)
- [x] lualine.nvim (statusline)
- [x] markdown-preview.nvim (preview markdown files)
- [x] mini.ai (extend and create `a`/`i` textobjects)
- [x] mini.align (align text interactively)
- [x] mini.indentscope (visualize and work with indent scope)
- [x] mini.pairs (auto pairs)
- [x] mini.surround (surround actions)
- [x] neoconf.nvim (plugin to manage global and project-local settings)
- [x] neodev.nvim (plugin for configuring lua-language-server for Neovim config)
- [x] neovim (Rosé Pine colorschemes)
- [x] nightfox.nvim (Nightfox colorschemes)
- [x] noice.nvim (replacement UI for `messages`, `cmdline`, `popupmenu`)
- [x] nui.nvim (UI component library for Neovim)
- [x] nvim-cmp (completion engine)
- [x] nvim-colorizer.lua (colorizer plugin in Lua)
- [x] nvim-dap (Debug Adapter Protocol client for Neovim)
- [x] nvim-dap-ui (UI for nvim-dap)
- [x] nvim-lint (async linter plugin for Neovim)
- [x] nvim-lspconfig (configurations for Neovim LSP)
- [x] nvim-metals (a Metals plugin for Neovim (for Scala))
- [x] nvim-nio (plugin for asynchronous IO in Neovim (eg. nvim-dap-ui))
- [x] nvim-notify (fancy UI for notifications in Neovim)
- [x] nvim-spectre (search plugin for Neovim)
- [x] nvim-tmux-navigation (navigate between Neovim buffers and tmux panes)\*\*
- [x] nvim-tree.nvim (file system browser)
- [x] nvim-treesitter (Neovim tree-sitter configurations and abstraction layer)
- [x] nvim-treesitter-context (UI to show code context (eg. method start))
- [x] nvim-treesitter-textobjects (tree-sitter aware textobjects)
- [x] nvim-ts-autotag (use tree-sitter to auto-close and auto-rename HTML tags)
- [x] nvim-ts-context-commentstring (set `commentstring` based on cursor location)
- [x] nvim-web-devicons (use fancy icons in the UI (requires appropriate Nerd font))
- [x] persistence.nvim (session management plugin)
- [x] plenary.nvim (lua function library)
- [x] semshi (semantic highlighting for Python)
- [x] telescope-fzf-native.nvim (FZF sorter for telescope.nvim)
- [x] telescope.nvim (fuzzy finder engine)
- [x] todo-comments.nvim (highlight/search for TODO comments)
- [x] tokyonight.nvim (color theme)
- [x] trouble.nvim (plugin for diagnostics, LSP references, etc.)
- [x] twilight.nvim (UI plugin to dim inactive portions of code)
- [x] vim-illuminate (automatically highlight other uses of word under cursor)
- [x] vim-startuptime (plugin to profile Neovim startup time)
- [x] which-key.nvim (show key bindings for command prefix)
- [x] zen-mode.nvim (distraction-free coding UI)

### Notes
