#!/bin/bash
#
# sdc - svn diff in colour
# Steven Wilkin @stevebiscuit

cleanup_exit() {
    rm -rf "$SVNTMP"
}

# Remove temporary files even if we get interrupted
trap "cleanup_exit" 0 # normal exit
trap "exit 255" 1 2 3 6 15 # HUP INT QUIT ABRT TERM

SVNTMP="${TMPDIR-/tmp}/svneditor.$RANDOM.$RANDOM.$RANDOM.$$"
(umask 077 && mkdir "$SVNTMP") || {
    echo "Could not create temporary directory! Exiting." 1>&2
    exit 1
}

(
	svn diff > "$SVNTMP/diff"
)

if [ -s "$SVNTMP/diff" ]; then
    vim "+e $SVNTMP/diff" '+set buftype=help filetype=diff' || exit $?
fi

exit $?
