#!/bin/zsh
for file in ~/.{aliases,extra}; do
	[ -f "$file" ] && [ -r "$file" ] && source "$file";
done;
unset $file;
