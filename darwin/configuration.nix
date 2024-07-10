{ pkgs, ... }: {
  # Fonts
  fonts.packages = with pkgs; [
    cooper-hewitt
    (nerdfonts.override { fonts = [ "FiraMono" "FiraCode" "IBMPlexMono" ]; })
    source-sans
    source-serif
  ];

  # Enable sudo authentication with Touch ID
  # TODO: implement a module to add full path to 'pam_reattach'
  security.pam.enableSudoTouchIdAuth = true;
}
