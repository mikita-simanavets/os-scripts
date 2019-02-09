#!/bin/bash
echo "(1/8) Updating Mac App Store applications"
mas outdated
read -p "Do you want to run mas upgrade? (Y/n) " choice
case "$choice" in
  y|Y|* ) mas upgrade;;
  n|N ) echo "mas update skipped";;
esac

echo "(2/8) Updating Homebrew packages"
brew update
brew upgrade

echo "(3/8) Updating Homebrew-Cask packages"
brew cask outdated | cut -f 1 | xargs brew cask reinstall

echo "(4/8) Updating Atom text editor plugins"
apm update --no-confirm

echo "(5/8) Updating all the npm global installed binaries"
npm update --global

echo "(6/8) Removing all Homebrew cache files older than 30 days"
brew cleanup --prune 30

echo "(7/8) Checking system for potential problems with Homebrew packages"
brew doctor
brew missing

echo "(8/8) Checking system for potential problems with Homebrew-Cask packages"
brew cask doctor
