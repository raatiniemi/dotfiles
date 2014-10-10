#!/bin/zsh
autoload -U compinit
compinit

for config_file ($DOTFILES/lib/*.zsh); do
	source $config_file;
done;
unset config_file;

for file in ~/.{aliases,extra}; do
	[ -f "$file" ] && [ -r "$file" ] && source "$file";
done;
unset file;
