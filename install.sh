#!/bin/sh

# Usage info
function show_help(){
cat << EOF
Usage: ${0##*/} [-hv] [-a ACTION(pull|push)] [-m MODE(*run|dryrun)]
Do stuff like git pull|push.

    -h          display this help and exit
    -a ACTION   pull action. pull from github, then copy override our local working env
                push action. copy from local pc to here, then push to github
    -m MODE     default run, or we can choose dryrun
    -v          verbose mode. Can be used multiple times for increased
                verbosity.
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
while getopts ":h:v:m:a:" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        v)  verbose=1
            ;;
        a)  action_mode=$OPTARG
            ;;
        m)  dryrun=$OPTARG
            ;;
        '?')
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))" # Shift off the options and optional --.

echo "================"
echo "* Action $action_mode"
echo "* Mode   $dryrun"
echo "================"


function execute(){
	#echo "$@"
	if [ $dryrun == "dryrun" ]; then
		echo "$@"
		return 0
	fi

	eval "$@"
}


# acording action_mode to change copy direction
function copy_file(){
	local flag=$1
	local filename=$2

	if [ $action_mode == 'pull' ]; then
		execute "cp $flag $filename ~/."
	elif [ $action_mode == 'push' ]; then
		execute "cp $flag ~/$filename ."
	else
		echo "Action [$action_mode] is not valid"
		exit 1
	fi
}

# START
if [ $verbose -eq '1' ]; then
	set -vx
else
	set +vx
fi

if [ $action_mode == 'pull' ]; then
	execute "git pull --all"
fi

for f in .* *
do
	if [ $f == $self ] || \
	   [ -z $f ] || \
	   [ $f == '.git' ] || \
	   [ $f == '.' ] || \
	   [ $f == '..' ] ; then
		echo "Skipping $f"
	elif [ -d $f ]; then
		copy_file -r $f
	elif [ -f $f ]; then
		copy_file '' $f
	else
		echo "File [$f] is not valid"
		exit 1
	fi
done

if [ $action_mode == 'push' ]; then
	execute "git commit -am 'script auto push' && git push origin master"
fi

# End of file
