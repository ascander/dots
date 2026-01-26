{
  config,
  lib,
  pkgs,
  ...
}:
{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You can update Home Manager without changing this value. See the Home
  # Manager release notes for a list of state version changes in each release.
  #
  # See https://nix-community.github.io/home-manager/release-notes.xhtml
  home.stateVersion = "22.11";

  # Dotfiles
  xdg.configFile.ghostty = {
    source = ../config/ghostty;
    recursive = true;
  };

  xdg.configFile."amethyst/amethyst.yml".source = ../config/amethyst/amethyst.yml;
  xdg.configFile."fd/ignore".source = ../config/fd/ignore;
  xdg.configFile."gh/config.yml".source = ../config/gh/config.yml;
  xdg.configFile."karabiner/karabiner.json".source = ../config/karabiner/karabiner.json;

  # ZSH
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enable
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
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
      MANROFFOPT = "-c";
      GPG_TTY = "$(tty)";
      LESS = "-g -i -M -R -S -W -x4 -z-4";

      XDG_CONFIG_HOME = "$HOME/.config";
    };
    shellAliases = with pkgs; {
      # Tmux
      tm = "${tmux}/bin/tmux";
      tl = "tm list-sessions";
      ts = "tm new-session -s";
      ta = "tm attach -t";
      tk = "tm kill-session -t";

      # Git
      gg = "${lazygit}/bin/lazygit";
      ga = "${git}/bin/git add";
      gc = "${git}/bin/git commit";
      gca = "${git}/bin/git commit -a";
      gco = "${git}/bin/git checkout";
      gcb = "${git}/bin/git checkout -b";
      gb = "${git}/bin/git branch";
      gs = "${git}/bin/git status -sb";
      gl = "${git}/bin/git log";
      gll = "${git}/bin/git ll";
      gd = "${git}/bin/git diff";
      gp = "${git}/bin/git push";
      gpd = "${git}/bin/git push --dry-run";
      gpsup = "${git}/bin/git push --set-upstream";
      gup = "${git}/bin/git pull --rebase";
      grv = "${git}/bin/git remote -v";

      # Nix
      nb = "nix build";
      nd = "nix develop";
      nf = "nix flake";
      ns = "nix shell";
      nr = "nix run";

      # ls
      ls = "${eza}/bin/eza --color=auto --group-directories-first";
      ll = "ls --long --header --git";
      la = "ll -a";
      lm = "ll --sort=modified";
      lt = "ll --tree";
      l = "ll";

      # cat
      bat = "${bat}/bin/bat --theme=TwoDark";
      cat = "bat";
      f = "cat";

      # cd
      ".." = "cd ../.";
      "..." = "cd ../../.";
      "...." = "cd ../../../.";

      # Other
      da = "${direnv}/bin/direnv allow";
      du = "${du-dust}/bin/dust";
      rm = "rm -i";
      mv = "mv -i";
      cp = "cp -i";
      c = "clear";
      mkdir = "mkdir -p";
    };
    initContent = lib.mkOrder 1500 ''
      # History expansion
      bindkey " " magic-space

      # Calculator
      calc () {
        local in="$(echo " $*" | sed -e 's/\[/(/g' -e 's/\]/)/g')";
        gawk -v PREC=201 'BEGIN {printf("%.60g\n", '"$in-0"')}' < /dev/null
      }

      # Initialize homebrew
      if [[ -d "/opt/homebrew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi

      # Initialize zoxide
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"

      # Initialize zsh-vi-mode
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

      # Fixes FZF shell integration and sets custom keybindings after zsh-vi-mode loads
      # see https://github.com/jeffreytse/zsh-vi-mode/issues/24#issuecomment-783981662
      zvm_after_init() {
        source <(${pkgs.fzf}/bin/fzf --zsh)

        # Disable software flow control (free up Ctrl-S / Ctrl-Q)
        stty -ixon

        # Vim-style history navigation
        bindkey '^J' down-line-or-history
        bindkey '^K' up-line-or-history

        # Custom tmux sessionizer shortcuts; see 'scripts/session.sh'
        bindkey -s '^s' 'session\r'             # Fuzzy picker
        bindkey -s '^d' 'session dotfiles\r'    # Dotfiles session
        bindkey -s '^n' 'session neovim\r'      # Neovim config
        bindkey -s '^p' 'session active\r'      # Active (main) project
      }

      # Source secret zshrc if present
      if [[ -s "$HOME/.zshrc.secrets" ]]; then
        source "$HOME/.zshrc.secrets"
      fi
    '';
  };

  # Starship prompt
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ../config/starship/starship.toml);
  };

  # Tmux
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.tmux.enable
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    shortcut = "a";
    terminal = "tmux-256color";
    escapeTime = 10;
    plugins =
      with pkgs;
      with tmuxPlugins;
      [
        {
          plugin = fingers;
          extraConfig = "set -g @fingers-main-action 'pbcopy'";
        }
        {
          plugin = power-theme;
          extraConfig = "set -g @tmux_power_theme 'default'";
        }
        {
          plugin = resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
      ];
    extraConfig = builtins.readFile ../config/tmux/tmux.conf;
  };

  # Git
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Ascander Dost";
    signing = {
      key = "3A7929CA0DEE2AD3";
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
      pull.rebase = true;
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
    # Personal GitHub identity (remote-URL-based, works regardless of clone location)
    # Work identities are added by dashes when available
    userEmail = "1245407+ascander@users.noreply.github.com";
    includes = [
      {
        # Match repos with github.com:ascander/* remotes
        condition = "hasconfig:remote.*.url:git@github.com:ascander/**";
        contents.user.email = "1245407+ascander@users.noreply.github.com";
      }
    ];
  };

  # SSH
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enable
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "yes";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
        extraOptions = {
          IgnoreUnknown = "AddKeysToAgent,UseKeychain";
          UseKeychain = "yes";
        };
      };
    };
  };

  # Neovim
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.enable
  #
  # NOTE: plugin management is handled by `lazy.nvim` outside of Nix. Why be coy? 🤷
  programs.neovim = {
    enable = true;
    # package = pkgs.neovim;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = false;
    extraPackages = with pkgs; [
      coursier
      luajitPackages.luarocks
      nixd
      nixfmt-rfc-style
      python311Packages.pynvim
      python312Packages.jupytext
      tree-sitter
      wget
    ];
  };

  # Direnv
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enable
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.nix-direnv.enable
  #
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      # See https://github.com/direnv/direnv/wiki/Python/#poetry
      layout_poetry() {
          PYPROJECT_TOML="''${PYPROJECT_TOML:-pyproject.toml}"
          if [[ ! -f "$PYPROJECT_TOML" ]]; then
              log_status "No pyproject.toml found. Executing \`poetry init\` to create a \`$PYPROJECT_TOML\` first."
              poetry init --python "^$(python --version 2>/dev/null | cut -d' ' -f2 | cut -d. -f1-2)"
          fi

          if [[ -d ".venv" ]]; then
              VIRTUAL_ENV="$(pwd)/.venv"
          else
              VIRTUAL_ENV=$(poetry env info --path 2>/dev/null ; true)
          fi

          if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
              log_status "No virtual environment exists. Executing \`poetry install\` to create one."
              poetry install
              VIRTUAL_ENV=$(poetry env info --path)
          fi

          PATH_add "$VIRTUAL_ENV/bin"
          export POETRY_ACTIVE=1
          export VIRTUAL_ENV
      }

      # See https://github.com/direnv/direnv/wiki/Python#uv
      layout_uv() {
          if [[ -d ".venv" ]]; then
              VIRTUAL_ENV="$(pwd)/.venv"
          fi

          if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
              log_status "No virtual environment exists. Executing \`uv venv\` to create one."
              uv venv
              VIRTUAL_ENV="$(pwd)/.venv"
          fi

          PATH_add "$VIRTUAL_ENV/bin"
          export UV_ACTIVE=1  # or VENV_ACTIVE=1
          export VIRTUAL_ENV
      }

      # See https://github.com/direnv/direnv/issues/73#issuecomment-1192448475
      export_alias() {
        local name=$1
        shift
        local alias_dir=$PWD/.direnv/aliases
        local target="$alias_dir/$name"
        local oldpath="$PATH"
        mkdir -p "$alias_dir"
        if ! [[ ":$PATH:" == *":$alias_dir:"* ]]; then
          PATH_add "$alias_dir"
        fi

        echo "#!/usr/bin/env bash" > "$target"
        echo "PATH=$oldpath" >> "$target"
        echo "$@" >> "$target"
        chmod +x "$target"
      }
    '';
  };

  # Packages
  home.packages = with pkgs; [
    # Custom scripts
    (writeShellScriptBin "session" (builtins.readFile ../scripts/session.sh))

    # Nix stuff
    nix-zsh-completions
    nixpkgs-fmt

    # ZSH plugins
    zsh-autocomplete
    zsh-autosuggestions
    zsh-completions
    zsh-history-substring-search
    zsh-syntax-highlighting
    zsh-vi-mode

    # Command line utilities
    _1password-cli
    bat
    bottom
    chafa
    delta
    du-dust
    eza
    fastfetch
    fd
    fzf
    gawk
    gh
    gh-dash
    gnugrep
    gnupg
    httpie
    imagemagick
    jq
    lazygit
    nix-tree
    pstree
    reattach-to-user-namespace
    ripgrep
    tree
    yq
    zoxide

    # Misc
    nodejs
    # openjdk11
    pam-reattach # allows use of 'pam_tid' module in tmux
    pinentry_mac
  ];
}
