#!/bin/zsh
# Use the `od -c`-command to track keyboard combinations.
#
# http://www.cs.elte.hu/zsh-manual/zsh_14.html
# https://wiki.archlinux.org/index.php/zsh
# http://unixhelp.ed.ac.uk/CGI/man-cgi?terminfo+5
typeset -A key;

# Force the Emacs-mode.
# http://zsh.sourceforge.net/Guide/zshguide04.html
bindkey -e;

# Jump to the beginning of the line.
key[Home]=${terminfo[khome]};

# Jump to the end of the line.
key[End]=${terminfo[kend]};

# Move one character forward/backward.
key[Left]=${terminfo[kcub1]};
key[Right]=${terminfo[kcuf1]};

# Move one word forward/backward.
key[AltLeft]=";3D";
key[AltRight]=";3C";

# Replace/delete characters.
key[Insert]=${terminfo[kich1]};
key[Delete]=${terminfo[kdch1]};

# Go to the beginning/end of the buffer or history.
key[PageUp]=${terminfo[kpp]};
key[PageDown]=${terminfo[knp]};

# Go up/down in the buffer or history.
key[Up]=${terminfo[kcuu1]};
key[Down]=${terminfo[kcud1]};

[[ -n "${key[Home]}" ]] && bindkey "${key[Home]}" beginning-of-line

[[ -n "${key[End]}" ]] && bindkey "${key[End]}" end-of-line

[[ -n "${key[Left]}" ]] && bindkey "${key[Left]}" backward-char
[[ -n "${key[Right]}" ]] && bindkey "${key[Right]}" forward-char

[[ -n "${key[AltLeft]}" ]] && bindkey "${key[AltLeft]}" backward-word
[[ -n "${key[AltRight]}" ]] && bindkey "${key[AltRight]}" forward-word

[[ -n "${key[Insert]}" ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n "${key[Delete]}" ]] && bindkey "${key[Delete]}" delete-char

[[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" up-line-or-history
[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" down-line-or-history

[[ -n "${key[PageUp]}" ]] && bindkey "${key[PageUp]}" beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]] && bindkey "${key[PageDown]}" end-of-buffer-or-history

# Search the history with what is already entered in the prompt.
# http://unix.stackexchange.com/questions/97843/how-can-i-search-history-with-what-is-already-entered-at-the-prompt-in-zsh/#97844
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward