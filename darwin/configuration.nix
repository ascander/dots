{pkgs, ...}: {
  # Fonts
  # https://nix-darwin.github.io/nix-darwin/manual/#opt-fonts.packages
  fonts.packages = with pkgs; [
    cooper-hewitt
    nerd-fonts.blex-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    source-sans
    source-serif
  ];

  # Manage '/etc/pam.d/sudo_local' with nix-darwin
  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
  };
}
