#!/bin/zsh
export DOTFILES="$HOME/.dotfiles";

autoload -U compinit
compinit

# Only attempt to source the library files if the
# directory actually exists.
if [ -d "$DOTFILES/lib" ]; then
	for config_file ($DOTFILES/lib/*.zsh); do
		source $config_file;
	done;
	unset config_file;
fi;

# Source the .extra file if it exists and is readable.
[ -f ~/.extra ] && [ -r ~/.extra ] && source ~/.extra;
