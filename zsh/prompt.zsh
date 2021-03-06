#!/bin/zsh
autoload colors && colors;
autoload -Uz vcs_info;

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true

# Maximum number of `vcs_info_msg_*_` variables.
zstyle ':vcs_info:*' max-exports 3

zstyle ':vcs_info:*' formats '%s' '%b' '%i'
zstyle ':vcs_info:*' branchformat '%b'

_prompt_user() {
	local user="%F{red}%n%f";
	if [[ "$(whoami)" == "root" ]]; then
		user="%B$user%b";
	fi;
	echo "$user";
}

_prompt_host() {
	local host="%F{yellow}%m%f";
	if [ "${SSH_TTY}" ]; then
		host="%B$host%b";
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
	elif [ "$name" = "git-svn" ]; then
		output=" on %{%F{blue}%}${vcs_info_msg_1_}%{%f%}";
	elif [ "$name" = "svn" ]; then
		output=" on %{%F{blue}%}${vcs_info_msg_1_}%{%f%}:%F{cyan}r${vcs_info_msg_2_}%f";
	fi;

	echo "$output";
}

_prompt_git_status() {
	local output="";
	if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
		local branch="$1";
		local clean=0;

		local staged_files="$(git diff --staged --name-status)";
		local unstaged_files="$(git diff --name-status)";
		local untracked_files="$(git ls-files --others --exclude-standard)";

		local staged=0;
		local unstaged=0;
		local untracked=0;

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

		local behind=0;
		local ahead=0;

		local tracking=$(git for-each-ref --format='%(upstream:short)' "$(git symbolic-ref -q HEAD)" 2>/dev/null);
		if [ -n "$tracking" ]; then
			local -a behind_ahead;
			behind_ahead=($(git rev-list --left-right --count "$tracking"...HEAD));
			if [ -n "$behind_ahead" ]; then
				behind=${behind_ahead[1]};
				if (( $behind != 0 )); then
					output="↓$output";
				fi;

				ahead=${behind_ahead[2]};
				if (( $ahead != 0 )); then
					output="↑$output";
				fi;
			fi;
		fi;

		if (( $staged + $unstaged + $untracked + $behind + $ahead == 0 )); then
			clean=1;
		else
			output="%{%B%F{cyan}%}[$output]%{%f%b%}";
		fi;

		output=" on %{%F{blue}%}$branch%{%f%}$output";
	fi;
	echo "$output";
}

precmd() {
	# Fake new line to place the $ and cursor on the second line.
	local newline=$'\n';
	PROMPT="";

	# If the DISPLAY_EXIT_CODE variable exists and is set to true the exit code
	# for the last command should be prefixed to the prompt.
	if [[ ! -z "${DISPLAY_EXIT_CODE}" ]] && [ "${DISPLAY_EXIT_CODE}" -eq "1" ]; then
		PROMPT+="[%?] ";
	fi;

	# Build the prompt with the following format:
	# $user at $host in $directory
	#
	# Depending on if the current directory is an git or svn repository
	# additional repository information will be placed after directory.
	#
	# The prompt construction have to be placed within the precmd-function
	# otherwise the repository information will not update.
	PROMPT+="$(_prompt_user)"

	# Only display the host if a SSH session is active.
	if [ "${SSH_TTY}" ]; then
		PROMPT+=" at $(_prompt_host)"
	fi;

	PROMPT+=" in $(_prompt_directory)";
	PROMPT+="$(_prompt_vcs)";
	PROMPT+="${newline}%B$%b ";

	# $PS2 is used when a single command includes newlines.
	PS2="%B%F{yellow}→%f%b ";
}
