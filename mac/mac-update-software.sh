#!/bin/bash
echo "(1/5) Updating by System Software Update tool"
sudo softwareupdate --install --recommended --verbose

echo "(2/5) Updating Homebrew packages"
brew update
brew upgrade --cleanup --verbose

echo "(3/5) Updating Homebrew-Cask packages"
brew cask upgrade --verbose
brew cask upgrade --greedy --verbose
brew cask cleanup --verbose

echo "(4/5) Checking system for potential problems with Homebrew packages"
brew doctor
brew missing
brew prune

echo "(5/5) Checking system for potential problems with Homebrew-Cask packages"
brew cask doctor
