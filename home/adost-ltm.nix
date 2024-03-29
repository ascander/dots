{ config, lib, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  nixConfigDir = "/Users/adost/code/dots";
in
{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You can update Home Manager without changing this value. See the Home
  # Manager release notes for a list of state version changes in each release.
  #
  # See https://nix-community.github.io/home-manager/release-notes.html
  home.stateVersion = "22.11";

  # Dotfiles (stable)
  xdg.configFile."karabiner/karabiner.json".source = ../config/karabiner/karabiner.json;
  xdg.configFile."fd/ignore".source = ../config/fd/ignore;
  xdg.configFile."direnv/direnvrc".source = ../config/direnv/direnvrc;

  # Dotfiles (unstable)
  # This allows direct editing for testing, troubleshooting, etc.
  xdg.configFile."alacritty/alacritty.yml".source = mkOutOfStoreSymlink "${nixConfigDir}/config/alacritty/alacritty.yml";
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "${nixConfigDir}/config/nvim";

  # ZSH
  # https://nix-community.github.io/home-manager/options.html#opt-programs.zsh.enable
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
      size = 10000;
      save = 10000;
    };
    plugins = [
      {
        name = "zsh-vi-mode";
        src = pkgs.fetchFromGitHub {
          owner = "jeffreytse";
          repo = "zsh-vi-mode";
          rev = "v0.10.0";
          sha256 = "13ifm0667my9izsl2zwidf33vg6byjw5dnyrm27lcprn0g1rjkj0";
        };
      }
    ];
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      GPG_TTY = "$(tty)";

      JAVA_HOME = "${pkgs.openjdk8}";
      TERMINFO_DIRS = "$HOME/.local/share/terminfo:${pkgs.unstable.alacritty.terminfo.outPath}/share/terminfo";
    };
    initExtra = builtins.readFile ../config/zsh/.zshrc;
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    package = pkgs.unstable.starship;
    settings = builtins.fromTOML (builtins.readFile ../config/starship/starship.toml);
  };

  # Tmux
  # https://nix-community.github.io/home-manager/options.html#opt-programs.tmux.enable
  #
  # NOTE:
  # The 'tmux-256color' terminal is not available on macOS systems by default.
  # To manually install it, run:
  #
  #   /usr/bin/tic -x -o $HOME/.local/share/terminfo tmux-256color.src
  #
  # with the patched terminfo entry included in the 'resources' folder. Set
  # `TERMINFO_DIRS` to pick up the location:
  #
  #   export TERMINFO_DIRS=$HOME/.local/share/terminfo:$TERMINFO_DIRS
  #
  # See: https://gpanders.com/blog/the-definitive-guide-to-using-tmux-256color-on-macos/
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    shortcut = "a";
    terminal = "tmux-256color";
    escapeTime = 10;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.fingers;
        extraConfig = "set -g @fingers-copy-command 'pbcopy'";
      }
      {
        plugin = tmuxPlugins.power-theme;
        extraConfig = "set -g @tmux_power_theme 'default'";
      }
    ];
    extraConfig = builtins.readFile ../config/tmux/tmux.conf;
  };

  # Git
  # https://nix-community.github.io/home-manager/options.html#opt-programs.git.enable
  programs.git = {
    enable = true;
    userName = "Ascander Dost";
    userEmail = "1815984+ascander@users.noreply.github.com";
    signing = {
      key = "7406157BCA775D6B";
      signByDefault = true;
    };
    aliases = {
      a = "add";
      c = "commit";
      ca = "commit -a";
      co = "checkout";
      cb = "checkout -b";
      p = "push";
      psup = "push --set-upstream";
      up = "pull --rebase";
      ll = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      unstage = "reset HEAD --";
      uncommit = "reset HEAD~";
      last = "log -1 HEAD";
      lasttag = "describe --abbrev=0";
    };
    extraConfig = {
      add.interactive.useBuiltin = false;
      commit.verbose = true;
      core.pager = "delta --minus-style=\"normal #43242B\" --minus-emph-style=\"normal #C34043\" --plus-style=\"normal #2B3328\" --plus-emph-style=\"syntax #76946A\" --syntax-theme=\"TwoDark\"";
      credential.helper = "osxkeychain";
      diff.colorMoved = "default";
      init.defaultBranch = "main";
      interactive.diffFilter = "delta --color-only --features=interactive";
      merge.conflictstyle = "diff3";
      push.default = "simple";
      rerere.enabled = true;
      color = {
        status = "auto";
        branch = "auto";
        diff = "auto";
        interactive = "auto";
        ui = true;
        pager = true;
      };
      delta = {
        navigate = true;
        light = false;
      };
    };
    ignores = [
      ".DS_Store"
      "*.bak"
      "*.swp"
      "*.swo"
      "*.temp"
      "*~"
      "*#"
      ".envrc"
      ".direnv/"
      ".bloop/"
      ".bsp/"
      ".metals/"
      "project/project"
      "project/metals.sbt"
      "project/.bloop"
    ];
  };

  # Neovim
  # https://nix-community.github.io/home-manager/options.html#opt-programs.neovim.enable
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    plugins =
      with pkgs.unstable;
      with vimPlugins;
      [
        cmp-buffer
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help
        cmp-path
        cmp_luasnip
        comment-nvim
        friendly-snippets
        kanagawa-nvim
        lspkind-nvim
        lualine-nvim
        luasnip
        markdown-preview-nvim
        nightfox-nvim
        nvim-cmp
        nvim-lspconfig
        nvim-metals
        (nvim-treesitter.withPlugins (plugins: with plugins; [
          tree-sitter-bash
          tree-sitter-dockerfile
          tree-sitter-java
          tree-sitter-kotlin
          tree-sitter-lua
          tree-sitter-markdown
          tree-sitter-nix
          tree-sitter-python
          tree-sitter-scala
          tree-sitter-toml
          tree-sitter-yaml
        ]))
        nvim-treesitter-textobjects
        nvim-web-devicons
        onedark-nvim
        rose-pine
        symbols-outline-nvim
        telescope
        telescope-fzf-native-nvim
        vim-easy-align
        vim-fugitive
        vim-nix
        vim-rhubarb
        vim-surround
        vim-tmux-navigator
      ];
  };

  # Direnv
  # https://nix-community.github.io/home-manager/options.html#opt-programs.direnv.enable
  # https://nix-community.github.io/home-manager/options.html#opt-programs.direnv.nix-direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Packages
  home.packages = with pkgs; [
    bat
    coursier
    delta
    unstable.eza
    fd
    fzf
    gawk
    gitAndTools.gh
    glow
    gnupg
    gnugrep
    gtop
    httpie
    jq
    openjdk8
    ncspot
    nil
    nix-zsh-completions
    nixpkgs-fmt
    nodePackages.bash-language-server
    nodePackages.yaml-language-server
    nodePackages.mermaid-cli
    pinentry_mac
    pyright
    reattach-to-user-namespace
    ripgrep
    stylua
    unstable.lua-language-server
    tree
    tree-sitter
    zoxide
    zsh-completions
    zsh-syntax-highlighting
  ];
}
