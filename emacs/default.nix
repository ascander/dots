{ pkgs }:

let
  emacsBase = pkgs.emacsGit; # Emacs 28.0.50
  emacsWithPackages = (pkgs.emacsPackagesGen emacsBase).emacsWithPackages;
in
emacsWithPackages (epkgs: (
  with epkgs.melpaPackages; [
    ace-window
    all-the-icons
    all-the-icons-dired
    all-the-icons-ivy
    avy
    beacon
    company
    company-emoji
    company-prescient
    conda
    counsel
    counsel-projectile
    default-text-scale
    evil
    evil-collection
    evil-magit
    evil-org
    evil-surround
    exec-path-from-shell
    flx
    flycheck
    general
    git-commit
    git-timemachine
    gitattributes-mode
    gitconfig-mode
    gitignore-mode
    ignoramus
    ivy
    ivy-avy
    ivy-prescient
    ivy-rich
    lsp-ivy
    lsp-metals
    lsp-mode
    lsp-python-ms
    lsp-ui
    magit
    markdown-mode
    minions
    moody
    nix-mode
    no-littering
    org-bullets
    org-ql
    osx-trash
    prescient
    projectile
    rainbow-delimiters
    sbt-mode
    scala-mode
    shackle
    shell-pop
    smex
    solarized-theme
    swiper
    use-package
    vmd-mode
    vterm
    which-key
    yaml-mode
    yasnippet
    yasnippet-snippets
  ]
) ++ (
  with epkgs.elpaPackages; [
    rainbow-mode
  ]
) ++ (
  with epkgs.orgPackages; [
    org-plus-contrib
  ]
))
