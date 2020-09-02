# Don't make annoying sounds when emptying trash or taking a screenshot
defaults write -g com.apple.sound.uiaudio.enabled -int 0

# Don't litter the desktop with screenshots
SCREENSHOTS_DIR="${HOME}/Pictures/Screenshots"

if [ ! -d "$SCREENSHOTS_DIR" ]; then
    echo "Creating directory: $SCREENSHOTS_DIR for screenshots"
    mkdir -p "$SCREENSHOTS_DIR"
fi

defaults write com.apple.screencapture location "$SCREENSHOTS_DIR"

# Install iTerm2 preferences
if [ -d "${HOME}/Library/Preferences/"]; then
    echo "Copying iTerm2 preferences to: $HOME/Library/Preferences/"
    cp ./../resources/com.googlecode.iterm2.plist ${HOME}/Library/Preferences/.
fi
