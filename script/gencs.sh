#!/bin/sh
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

if [ $action_mode == 'wad' ]; then
	execute "find daemon/wad -name '*.c' -o -name '*.h' | \
		grep -v 'wad/ui/stdin/' | \
		grep -v 'wad/test/' | \
		grep -v 'wad/redirect/socket/' \
		> cscope.files"
	execute "sort cscope.files > cscope.files.sorted"
	execute "mv cscope.files.sorted cscope.files"
	execute "cscope -kbq"
	execute "ctags -e --c-kinds=+defgpstuxm -L ~/script/trace.files"
elif [ $action_mode == 'daemon' ]; then
	execute "find daemon cmf migadmin migbase proxy include -name '*.c' -o -name '*.h' | \
		grep -v '^_' | \
		grep -v 'wad/test/' | \
		grep -v 'wad/redirect/socket/' \
		> cscope.files"
	execute "sort cscope.files > cscope.files.sorted"
	execute "mv cscope.files.sorted cscope.files"
	execute "cscope -kbq"
	execute "ctags -e --c-kinds=+defgpstuxm -L cscope.files"
elif [ $action_mode == 'all' ]; then
	execute "find . -name '*.c' -o -name '*.h' | \
		grep -v '/_' | \
		grep -v 'wad/ui/stdin/' | \
		grep -v 'wad/ui/stdin/' | \
		grep -v 'wad/test/' | \
		grep -v 'wad/redirect/socket/' \
		> cscope.files"
	execute "sort cscope.files > cscope.files.sorted"
	execute "mv cscope.files.sorted cscope.files"
	execute "cscope -kbq"
	execute "ctags -e --c-kinds=+defgpstuxm -L cscope.files"
fi

# End of file