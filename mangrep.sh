#!/bin/bash
##
## mangrep (mg)
##
## look for a keyword in a man page
##

# bookkeeping
base=$(basename "$0")
let argCount=$#

# UI
ERROR_MISSING_ARGUMENTS=1
ERROR_IGNORED_ARGUMENTS=2
help() {
	cat <<-EOS
		$base: look for a keyword in a man page.
		Usage: \$ $base [OPTIONS] [--] COMMAND KEYWORD
EOS
}

# default switches for grep.
# user provided switches will be added here,
# and overwrite the default ones if there are duplicates.
grepArgs='-C2 --color=always '

# shift through command line switches
while [[ $1 =~ -.+ ]]
do
	if [[ $1 = -- ]]; then
		shift
		break
	elif [[ $1 = --help || $1 = -h ]]; then
		help
		case $argCount in
			1) exit 0;;
			*) exit 2;;
		esac
	else
		grepArgs+="$1 "
		shift
	fi
done

# remaining args
if [[ $# -lt 2 ]]; then
	echo "Missing arguments. Try \`$base --help\` for usage info."
	exit $ERROR_MISSING_ARGUMENTS
else
	page="$1"
	keyword="$2"
fi

# main
man "$page" | grep $grepArgs -- "$keyword"
