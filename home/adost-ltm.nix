{ config, lib, pkgs, ... }:
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

  # Dotfiles
  # TODO: re-evaluate
  xdg.configFile."karabiner/karabiner.json".source = ../config/karabiner/karabiner.json;
  xdg.configFile."fd/ignore".source = ../config/fd/ignore;
  xdg.configFile."direnv/direnvrc".source = ../config/direnv/direnvrc;
  xdg.configFile."alacritty/alacritty.yml".source = ../config/alacritty/alacritty.yml;
  xdg.configFile."iTerm2/com.googlecode.iterm2.plist".source = ../config/iTerm2/com.googlecode.iterm2.plist;
  xdg.configFile.nvim = {
    source = ../config/nvim;
    recursive = true;
  };

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
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      GPG_TTY = "$(tty)";

      JAVA_HOME = "${pkgs.openjdk8}";
      TERMINFO_DIRS = "${pkgs.unstable.alacritty.terminfo.outPath}/share/terminfo";
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
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  withNodeJs = true;
  plugins =
    with pkgs;
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
    exa
    fasd
    fd
    fzf
    gawk
    gitAndTools.gh
    glow
    gnupg
    gnugrep
    gtop
    jq
    openjdk8
    ncspot
    nix-zsh-completions
    nodePackages.bash-language-server
    nodePackages.yaml-language-server
    nodePackages.mermaid-cli
    pinentry_mac
    pyright
    reattach-to-user-namespace
    ripgrep
    rnix-lsp
    stylua
    sumneko-lua-language-server
    tree
    tree-sitter
    zsh-completions
    zsh-syntax-highlighting
  ];
}
