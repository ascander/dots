{ pkgs, ... }:
{
  # Fonts
  fonts.packages = with pkgs; [
    cooper-hewitt
    nerd-fonts.blex-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    source-sans
    source-serif
  ];

  # Enable (tmux-aware) sudo authentication with Touch ID
  # see 'modules/darwin/pam.nix'
  security.pam.touchIdAuth = {
    enable = true;
    reattach.enable = true;
    reattach.ignoreSSH = true;
  };
}
