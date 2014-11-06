#!/bin/zsh
autoload -U compinit
compinit

# Only attempt to source the configuration files
# if the dotfiles directory actually exists.
export DOTFILES="$HOME/.dotfiles";
if [ -d $DOTFILES ]; then
	for config_file ($DOTFILES/*/*.zsh); do
		source $config_file;
	done;
	unset config_file;
fi;

# Source the .extra file if it exists and is readable.
[ -f ~/.extra ] && [ -r ~/.extra ] && source ~/.extra;
