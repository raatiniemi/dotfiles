#!/bin/zsh
# Jump back `n` directories at a time
# # http://alias.sh/jump-back-n-directories-time
alias ..='cd ..';
alias ...='cd ../../';
alias ....='cd ../../../';
alias .....='cd ../../../../';
alias ......='cd ../../../../../';

# Gzip-enabled `curl`
alias gurl='curl --compressed';

# # Get week number
alias week='date +%V';

# Shortcuts for common git commands.
alias gs="git status";
alias gd="git diff";
alias gc="git commit";
alias ga="git add";
alias gm="git mv";
alias gr="git rm";
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";

# Shortcuts for SSH operations
alias sshx="ssh -XC -c blowfish-cbc,arcfour";
