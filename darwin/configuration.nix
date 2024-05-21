{pkgs, ...}: {
  # Fonts
  # NOTE: this removes any manually added fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    cooper-hewitt
    (nerdfonts.override {fonts = ["FiraMono" "FiraCode" "IBMPlexMono"];})
    source-sans
    source-serif
  ];

  # Enable sudo authentication with Touch ID
  security.pam.enableSudoTouchIdAuth = true;
}
