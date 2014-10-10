#!/bin/zsh
export DOTFILES="$HOME/.dotfiles";

# Source the profile, only if the file exists and is readable.
[ -f ~/.zprofile ] && [ -r ~/.zprofile ] && source ~/.zprofile;
