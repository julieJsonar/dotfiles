#!/bin/bash
function show_help(){
cat << EOF
Usage: ${0##*/} [-hv] [-a ACTION(wad|daemon|all)] [-d DEBUG(just dryrun)]
    -h          display this help and exit
    -a ACTION   wad|daemon|all
    -d DEBUG    just dry run
    -v          verbose mode.
Examples:
$ ./gencs.sh -a all
EOF
}


# Initialize our own variables:
self=`basename $0`
action_mode=""
verbose=0
dryrun="run"

if [ $# -eq 0 ]; then
	show_help >&2
	exit 1
fi

OPTIND=1 # Reset is necessary if getopts was used previously in the script. It is a good idea to make this local in a function.
while getopts "hvda:m:" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        v)  verbose=1
            ;;
        a)  action_mode=$OPTARG
            ;;
        d)  dryrun="dryrun"
            ;;
        '?')
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))" # Shift off the options and optional --.


function execute(){
	#echo "$@"
	if [ $dryrun == "run" ]; then
		eval "$@"
	else
		echo "DRYRUN> $@"
		return 0
	fi
}


# START
if [ $verbose -eq '1' ]; then
	set -vx
else
	set +vx
fi

#if [ $action_mode == 'all' ]; then
	#echo "Generating tags and cscope database..."
	execute "find . -name '*.c' -o -name '*.cc' -o -name '*.h' -o -name '*.cpp' -o -name '*.hpp' | \
		grep -v 'wad/ui/stdin/'        | \
		grep -v 'wad/ui/stdin/'        | \
		grep -v 'wad/test/'            | \
		grep -v 'wad/redirect/socket/' | \
		grep -v 'kernel/'              | \
		grep -v 'linux/'               | \
		grep -v 'linux-.*/'            | \
		grep -v 'compress/'            | \
		grep -v 'cooked/'              | \
		grep -v 'fortitest/'           | \
		grep -v 'linuxatm/'            | \
		grep -v 'sysctl/'              | \
		grep -v 'router/'              | \
		grep -v 'router/'              | \
		grep -v 'fortiweb/'            | \
		grep -v 'fortitest/'            | \
		grep -v 'tests/gtest/'         | \
		grep -v 'tools/'               | \
		grep -v '/_' \
		> cscope.files"

#		grep -v 'router/'              | \
#

	execute "sort cscope.files > cscope.files.sorted"
	execute "mv cscope.files.sorted cscope.files"
#	execute "/usr/bin/time gtags -f cscope.files"
#	execute "/usr/bin/time global -u -L cscope.files"

	execute "cscope -kbq > /dev/null 2>&1"
	execute "LC_COLLATE=C ctags --extra=+f -L cscope.files > /dev/null 2>&1 &"
	execute "LC_COLLATE=C ctags -xL cscope.files > tags.x"
	#echo "Done."
	notify-send "Done!"
#	execute "ctags -e --c-kinds=+defgstum -L cscope.files > /dev/null 2>&1 &"
#fi

# End of file
