{ pkgs, ... }: {
  # Fonts
  # NOTE: this removes any manually added fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraMono" "IBMPlexMono" ]; })
    source-sans-pro
  ];
}
