#!/bin/bash
echo "(1/7) Updating Mac App Store applications"
mas outdated
read -p "Do you want to run mas upgrade? (y/N) " choice
case "$choice" in
  y|Y ) mas upgrade;;
  n|N|* ) echo "mas update skipped";;
esac

echo "(2/7) Updating Homebrew packages"
brew update
brew upgrade --cleanup

echo "(3/7) Updating Homebrew-Cask packages"
brew cask outdated | cut -f 1 | xargs brew cask reinstall
brew cask cleanup

echo "(4/7) Updating Atom text editor plugins"
apm update --no-confirm

echo "(5/7) Updating all the npm global installed binaries"
npm update --global

echo "(6/7) Checking system for potential problems with Homebrew packages"
brew doctor
brew missing
brew prune

echo "(7/7) Checking system for potential problems with Homebrew-Cask packages"
brew cask doctor
