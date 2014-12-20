#!/bin/zsh
# Make vi the default editor
export EDITOR="vi";

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X";

# Larger history (allow 32³ entries; default is 500)
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE;
export HISTCONTROL=ignoredups;