#!/bin/zsh
autoload -U compinit
compinit

for file in ~/.{aliases,extra}; do
	[ -f "$file" ] && [ -r "$file" ] && source "$file";
done;
unset $file;
