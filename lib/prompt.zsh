#!/bin/zsh
autoload colors && colors;
autoload -Uz vcs_info;

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true

# Maximum number of `vcs_info_msg_*_` variables.
zstyle ':vcs_info:*' max-exports 2

zstyle ':vcs_info:*' formats '%s' '%b'

_prompt_user() {
	local user="%F{red}%n%f";
	if [[ "$(whoami)" == "root" ]]; then
		user="%B%F{red}%n%f%b";
	fi;
	echo "$user";
}

_prompt_host() {
	local host="%F{yellow}%m%f";
	if [[ "${SSH_TTY}" ]]; then
		host="%B%F{yellow}%m%f%b";
	fi;
	echo "$host";
}

_prompt_directory() {
	echo "%F{green}%~%f";
}

_prompt_vcs() {
	vcs_info

	local name="$vcs_info_msg_0_";
	if [ -z "$name" ]; then
		return;
	fi;

	local output;
	if [ "$name" = "git" ]; then
		output="$(_prompt_git_status ${vcs_info_msg_1_})";
	fi;

	echo "$output";
}

_prompt_git_status() {
	local branch="$1";
	local output="";
	local clean=0;
	
	local staged=0;
	local unstaged=0;
	local untracked=0;

	local staged_files;
	local unstaged_files;
	local untracked_files;

	if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
		staged_files="$(git diff --staged --name-status)";
		unstaged_files="$(git diff --name-status)";
		untracked_files="$(git ls-files --others --exclude-standard)";
	fi;

	if [ -n "$staged_files" ]; then
		staged=$(echo "$staged_files" | wc -l);
		output+="+";
	fi;

	if [ -n "$unstaged_files" ]; then
		unstaged=$(echo "$unstaged_files" | wc -l);
		output+="!";
	fi;

	if [ -n "$untracked_files" ]; then
		untracked=$(echo "$untracked_files" | wc -l);
		output+="?";
	fi;
	
	if (( $staged + $unstaged + $untracked == 0 )); then
		clean=1;
	else
		output="%{%B%F{cyan}%}[$output]%{%f%b%}";
	fi;

	output=" on %{%F{blue}%}$branch%{%f%}$output";
	echo "$output";
}

precmd() {
	# Fake new line to place the $ and cursor on the second line.
	local newline=$'\n';

	# Build the prompt with the following format:
	# $user at $host in $directory
	#
	# Depending on if the current directory is an git or svn repository
	# additional repository information will be placed after directory.
	#
	# The prompt construction have to be placed within the precmd-function
	# otherwise the repository information will not update.
	PROMPT="$(_prompt_user)"
	PROMPT+=" at $(_prompt_host)"
	PROMPT+=" in $(_prompt_directory)";
	PROMPT+="$(_prompt_vcs)";
	PROMPT+="${newline}%B$%b ";

	# $PS2 is used when a single command includes newlines.
	PS2="%B%F{yellow}→%f%b ";
}
