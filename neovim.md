<!-- markdownlint-disable MD013 -->

# Neovim

This document contains notes/tasks/etc. as relevant to migrating from my current [LazyVim](https://github.com/ascander/nvim) distribution to one managed by Nix. A few goals:

- Support for vim plugins as flake inputs, for updating outside of waiting for things to land in `nixpkgs`
- Managing all plugins, tree-sitter grammars, language servers, linters, etc. via Nix
- Configuring Neovim and plugins in Lua
- Lazy loading of plugins as possible in Nix

## Distribution

Home manager programs.neovim using the neovim nightly overlay to use Neovim 0.10 as the package

## Plugins (check if migrated)

- [ ] LuaSnip (snippet engine)
- [ ] aerial.nvim (LSP symbol outline)
- [ ] auto-save.nvim (auto-save buffers)
- [ ] cmp-buffer (buffer completion)
- [ ] cmp-nvim-lsp (LSP completion)
- [ ] cmp-path (filepath completion)
- [ ] cmp_luasnip (snippet completion)
- [ ] conform.nvim (formatter plugin)
- [ ] dressing.nvim (fancy `vim.ui` interfaces)
- [ ] friendly-snippets (snippet collection)
- [ ] markdown-preview.nvim (preview markdown files)
- [ ] neoconf.nvim (plugin to manage global and project-local settings)
- [ ] neodev.nvim (plugin for configuring lua-language-server for Neovim config)
- [ ] noice.nvim (replacement UI for `messages`, `cmdline`, `popupmenu`)
- [ ] none-ls.nvim (use Neovim as a language server)
- [ ] nui.nvim (UI component library for Neovim)
- [ ] nvim-cmp (completion engine)
- [ ] nvim-colorizer.lua (colorizer plugin in Lua)
- [ ] nvim-dap (Debug Adapter Protocol client for Neovim)
- [ ] nvim-dap-python (nvim-dap extension for Python debugging)
- [ ] nvim-dap-ui (UI for nvim-dap)
- [ ] nvim-dap-virtual-text (virtual text support for nvim-dap)
- [ ] nvim-lint (async linter plugin for Neovim)
- [ ] nvim-lspconfig (configurations for Neovim LSP)
- [ ] nvim-metals (a Metals plugin for Neovim (for Scala))
- [ ] nvim-nio (plugin for asynchronous IO in Neovim (eg. nvim-dap-ui))
- [ ] nvim-notify (fancy UI for notifications in Neovim)
- [ ] nvim-spectre (search plugin for Neovim)
- [ ] rainbow_csv (CSV support)
- [ ] semshi (semantic highlighting for Python)
- [ ] trouble.nvim (plugin for diagnostics, LSP references, etc.)
- [ ] twilight.nvim (UI plugin to dim inactive portions of code)
- [ ] venv-selector.nvim (virtualenv selector for Python projects)
- [ ] vim-illuminate (automatically highlight other uses of word under cursor)
- [ ] zen-mode.nvim (distraction-free coding UI)
- [x] Comment.nvim (managing comment strings)
- [x] dashboard-nvim (splash page)
- [x] flash.nvim (treesitter-aware navigation w/ labels, character motions)
- [x] git-conflict.nvim (manage git merge conflicts)
- [x] gitlinker.nvim (generate links to github from source files)
- [x] gitsigns.nvim (Git integration for buffers)
- [x] indent-blankline.nvim (indentation guides)
- [x] kanagawa.nvim (color theme)
- [x] lualine.nvim (statusline)
- [x] mini.ai (extend and create `a`/`i` textobjects)
- [x] mini.align (align text interactively)
- [x] mini.indentscope (visualize and work with indent scope)
- [x] mini.pairs (auto pairs)
- [x] mini.surround (surround actions)
- [x] neo-tree.nvim (file system browser)\*
- [x] neovim (Rosé Pine colorschemes)
- [x] nightfox.nvim (Nightfox colorschemes)
- [x] nvim-tmux-navigation (navigate between Neovim buffers and tmux panes)\*\*
- [x] nvim-treesitter (Neovim tree-sitter configurations and abstraction layer)
- [x] nvim-treesitter-context (UI to show code context (eg. method start))
- [x] nvim-treesitter-textobjects (tree-sitter aware textobjects)
- [x] nvim-ts-autotag (use tree-sitter to auto-close and auto-rename HTML tags)
- [x] nvim-ts-context-commentstring (set `commentstring` based on cursor location)
- [x] nvim-web-devicons (use fancy icons in the UI (requires appropriate Nerd font))
- [x] persistence.nvim (session management plugin)
- [x] plenary.nvim (lua function library)
- [x] telescope-fzf-native.nvim (FZF sorter for telescope.nvim)
- [x] telescope.nvim (fuzzy finder engine)
- [x] todo-comments.nvim (highlight/search for TODO comments)
- [x] tokyonight.nvim (color theme)
- [x] vim-startuptime (plugin to profile Neovim startup time)
- [x] which-key.nvim (show key bindings for command prefix)

### Notes

- replaced `neo-tree` with `nvim-tree`
- replaced `nvim-tmux-navigation` with `vim-tmux-navigator`
- `vim-startuptime` does not seem to work; progress is stuck on 0%; need to troubleshoot further

### LSP plugin set

- [ ] aerial.nvim
- [ ] neodev.nvim
- [ ] nvim-lspconfig
- [ ] nvim-metals
- [ ] semshi
- [ ] language servers: bashls, lua-language-server, pyright, ruff-lsp, vscode-json-language-server, yaml-language-server
