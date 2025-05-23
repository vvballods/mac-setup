#!/bin/sh

# ___  ___             _____ _____   _____      _
# |  \/  |            |  _  /  ___| /  ___|    | |
# | .  . | __ _  ___  | | | \ `--.  \ `--.  ___| |_ _   _ _ __
# | |\/| |/ _` |/ __| | | | |`--. \  `--. \/ _ \ __| | | | '_ \
# | |  | | (_| | (__  \ \_/ /\__/ / /\__/ /  __/ |_| |_| | |_) |
# \_|  |_/\__,_|\___|  \___/\____/  \____/ \___|\__|\__,_| .__/
#                                                        | |
#                                                        |_|

echo "Mac OS Setup by Valters Ballods"


##############################
#        Oh My Zsh           #
##############################

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
cp ./dotfiles/.zshrc ~/

##############################
#            Configs         #
##############################

sudo cp configs/*.plist /Library/Preferences/

##############################
#            Fonts           #
##############################

cp fonts/*.ttf /Library/Fonts/

##############################
# Prerequisite: Install Brew #
##############################

echo "Installing Homebrew..."

if test ! $(which brew)
then
	## Don't prompt for confirmation when installing homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
fi

brew upgrade
brew update
brew bundle

git config --global alias.lg "log --graph --pretty='format:%C(yellow)%h %C(green)[%C(bold blue)%G? - %aN%C(reset)%C(green)]%C(reset)%C(auto)%d%C(reset) %s %C(green)<%cr>%C(reset)' --abbrev-commit --decorate --all"
git config --global alias.amend "commit --amend --no-edit --date=now"

echo "Configuring Jenv..."

#jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home/

echo "Configuring Mac..."

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "McValters"
sudo scutil --set HostName "mc.valters"
sudo scutil --set LocalHostName "mc.valters.local"

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window (need to logout and click on the clock)
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Remove Siri
defaults write ~/Library/Preferences/com.apple.systemuiserver.plist "NSStatusItem Visible Siri" -bool FALSE

# This makes your Mac run quicker:
# Hide All Desktop Icons from http://osxdaily.com/2009/09/23/hide-all-desktop-icons-in-mac-os-x/
# The files are still in Desktop directory, but they are now not shown.
defaults write com.apple.finder CreateDesktop -bool false;killall Finder

# Show Date
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm"

# Show all files
defaults write com.apple.Finder AppleShowAllFiles true

# Always use list view
defaults write com.apple.finder FXPreferredViewStyle Nlsv

# Use function keys as standard function keys.
defaults write com.apple.keyboard.fnState -int 1

# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"

# Tiled windows should not have margins
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

# Disable the sudden motion sensor as it’s not useful for SSDs
sudo pmset -a sms 0

# Menu bar: show remaining battery time (on pre-10.8); hide percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
#defaults write com.apple.menuextra.battery ShowTime -string "YES"

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Hide animations
defaults write com.apple.dock launchanim -bool false

# Scale effect when minimizing apps
defaults write com.apple.dock mineffect -string scale

# Set dock tile size
defaults write com.apple.dock tilesize -int 35

# Don't show recent apps
defaults write com.apple.dock "show-recents" -bool false

# Only Show Open Applications In The Dock
defaults write com.apple.dock static-only -bool false

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Menu bar: hide the Time Machine, User icons, but show the volume Icon.
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
	defaults write "${domain}" dontAutoLoad -array \
		"/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
		"/System/Library/CoreServices/Menu Extras/User.menu"
done
defaults write com.apple.systemuiserver menuExtras -array \
	"/System/Library/CoreServices/Menu Extras/vpn.menu" \
	"/System/Library/CoreServices/Menu Extras/Volume.menu" \
	"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
	"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
	"/System/Library/CoreServices/Menu Extras/Battery.menu" \
	"/System/Library/CoreServices/Menu Extras/Clock.menu"

# Disable smart quotes and smart dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Use function F1, F, etc keys as standard function keys
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

echo "Mac has been configured."

echo ""
echo "Done!"
echo ""
echo ""
echo "################################################################################"
echo ""
echo ""
echo "Note that some of these changes require a logout/restart to take effect."
echo ""
echo ""
echo -n "Check for and install available OSX updates, install, and automatically restart? (y/n)? "
read response
if [ "$response" != "${response#[Yy]}" ] ;then
    softwareupdate -i -a --restart
fi