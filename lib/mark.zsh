#!/bin/zsh
# Filesystem Markers & Jump
# # http://alias.sh/filesystem-markers-jump
# # http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
#
# Export the path for the marks.
export MARKPATH="${HOME}/.marks";

# Jump to a marked directory.
# Ex: `jump home`
function jump { 
	cd -P "${MARKPATH}/${1}" 2>/dev/null || echo "No such mark: ${1}";
}

# Mark the current directory.
# Ex: `mark home`
function mark { 
	mkdir -p "${MARKPATH}"; ln -s "$(pwd)" "${MARKPATH}/${1}";
}

# Remove marked directory, with confirmation question.
# Ex: `unmark home`
function unmark { 
	rm -i "${MARKPATH}/${1}";
}

# List all of the marked directories, with their paths.
# Ex: `marks`
# doc -> /home/user/documents
function marks {
	# Only attempt to list the marked directories if the .marks
	# directory actually exists within the user directory.
	#
	# TODO: Clean up output, remove unnecessary blank lines.
	# TODO: Add support for OS X.
	if [ -d "${MARKPATH}" ]; then
		marks=$(ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g');
		echo $marks;
	else
		echo "No directories have been marked";
	fi;
}

# Handles autocompletion for marked directories.
function _completemarks {
	# Only attempt to autocomplete if .marks directory exists.
	if [ -d "${MARKPATH}" ]; then
		reply=($(ls "${MARKPATH}"));
	fi;
}

# Add autocompletion to the `jump` and `unmark` commands.
compctl -K _completemarks jump
compctl -K _completemarks unmark