#!/bin/zsh
export DOTFILES="$HOME/.dotfiles";

autoload -U compinit
compinit

for config_file ($DOTFILES/lib/*.zsh); do
	source $config_file;
done;
unset config_file;

# Source the .extra file if it exists and is readable.
[ -f ~/.extra ] && [ -r ~/.extra ] && source ~/.extra;
