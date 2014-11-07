#!/bin/zsh
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
