{
  # Dock settings
  system.defaults.dock = {
    autohide = true;
    tilesize = 16;
    mineffect = "scale";
    minimize-to-application = true;
    show-process-indicators = true;
    showhidden = true;
    show-recents = false;
    persistent-apps = [ ];
    persistent-others = [ ];
    static-only = true;
  };

  # Trackpad settings
  system.defaults.trackpad = {
    ActuationStrength = 0;
    Clicking = true;
    Dragging = true;
    TrackpadRightClick = true;
    TrackpadThreeFingerDrag = true;
    TrackpadThreeFingerTapGesture = 0;
  };

  # NSGlobalDomain settings (keyboard, trackpad, etc.)
  system.defaults.NSGlobalDomain = {
    # Set a fast key repeat rate
    KeyRepeat = 1;
    InitialKeyRepeat = 10;

    # Use function keys as standard function keys (F1, F2, etc.)
    "com.apple.keyboard.fnState" = true;

    # Set a fast trackpad speed
    "com.apple.trackpad.scaling" = 3.0;

    # Disable "natural" scrolling
    "com.apple.swipescrolldirection" = false;

    # Miscellaneous
    AppleICUForce24HourTime = true;
    AppleInterfaceStyle = "Dark";
    AppleShowAllExtensions = true;
    AppleShowScrollBars = "Automatic";
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
    NSTableViewDefaultSizeMode = 1;
    _HIHideMenuBar = true;
    "com.apple.springing.delay" = 0.0;
    "com.apple.springing.enabled" = true;
  };

  # Custom system settings
  # TODO: try updating nix-darwin
  # CustomSystemPreferences = {
  #   NSGlobalDomain = {
  #     AppleSpacesSwitchOnActivate = false;
  #   };
  # };
}
