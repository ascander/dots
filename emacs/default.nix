{ pkgs }:

let
  emacsBase = pkgs.emacsUnstable; # Emacs 27.1
  emacsWithPackages = (pkgs.emacsPackagesGen emacsBase).emacsWithPackages;
in
emacsWithPackages (epkgs: (
  with epkgs.melpaPackages; [
    use-package
    general
    evil
    evil-collection
    exec-path-from-shell
    osx-trash
    no-littering
    default-text-scale
    vterm
    solarized-theme
    doom-themes
    moody
    minions
    ignoramus
    ace-window
    shackle
    magit
    evil-magit
    git-timemachine
    flx
    smex
    ivy
    counsel
    swiper
    projectile
    counsel-projectile
    avy
    ivy-avy
    prescient
    ivy-prescient
    ivy-rich
    yasnippet
    yasnippet-snippets
    evil-surround
    rainbow-delimiters
    company
    company-prescient
    company-emoji
    lsp-mode
    lsp-metals
    lsp-ui
    lsp-ivy
    shell-pop
    git-commit
    gitconfig-mode
    gitignore-mode
    gitattributes-mode
    vmd-mode
    markdown-mode
    scala-mode
    sbt-mode
    lsp-python-ms
    conda
    yaml-mode
    nix-mode
    which-key
  ]
) ++ (
  with epkgs.elpaPackages; [
    rainbow-mode
  ]
) ++ (
  with epkgs.orgPackages; [
  ]
))
