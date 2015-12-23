#!/bin/bash

# QuickStart
# ==========
# Help
# ./update.sh -a pull                       # sync from remote github
# ... change ...
# ./update.sh -da push -m "commit message"  # dryrun review
# ./update.sh -a push -m "commit message"   # sync to remote github
#
# Usage info
# ==========
function show_help(){
cat << EOF
Usage: ${0##*/} [-hv] [-a ACTION(pull|push)] [-d DEBUG(just dryrun)] [-m NOTE]
Examples:
$ ./install.sh -a pull                       # sync from remote github
$ ... change ...
$ ./install.sh -da push -m "commit message"  # dryrun review
$ ./install.sh -a push -m "commit message"   # sync to remote github

Do stuff like git pull|push, but also refresh the file between git and our pc's home

    -h          display this help and exit
    -a ACTION   pull action. pull from github, then copy override our local working env
                push action. copy from local pc to here, then push to github
    -d DEBUG    just dry run
    -m NOTE     git commit message
    -v          verbose mode. Can be used multiple times for increased
                verbosity.
EOF
}


# Initialize our own variables:
self=`basename $0`
action_mode=""
verbose=0
dryrun="run"
commit_msg="script auto commit"

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
        m)  commit_msg=$OPTARG
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
echo "* Commit $commit_msg"
echo "================"


function execute(){
	#echo "$@"
	if [ $dryrun == "run" ]; then
		eval "$@"
	else
		echo "DRYRUN> $@"
		return 0
	fi
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
	   [ $f == 'README.md' ] || \
	   [ $f == 'init_ubuntu.sh' ] || \
	   [ $f == 'update.sh' ] || \
	   [ $f == 'patch.smbconf' ] || \
	   [ $f == 'FortiGate-VM64.vmx' ] || \
	   [ $f == 'eclipse-moonrise-theme' ] || \
	   [ $f == 'zsh_hist.awk' ] || \
	   [ $f == '.zsh_history' ] || \
	   [ $f == 'tftp' ] || \
	   [ $f == '.' ] || \
	   [ $f == '..' ]; then
		echo "Skipping $f"
	elif [ -d $f ] && \
	   [ $f != 'eclipse-moonrise-theme' ]; then
		copy_file -r $f
	elif [ -f $f ]; then
		copy_file '' $f
	else
		echo "File [$f] is not valid"
		exit 1
	fi
done

if [ $action_mode == 'push' ]; then
# special commands
	execute "git add ."
	execute "git commit -am \"$commit_msg\" && git push origin master"
elif [ $action_mode == 'pull' ]; then
#	test file exists cannot use '~' to replace $HOME, and should have double-quote
	gvimrc="$HOME/.gvimrc"
	nvimrc="$HOME/.nvimrc"
	nvim="$HOME/.nvim"
	rm -f $gvimrc
	rm -f $nvimrc
	rm -f $nvim

	if [ ! -f "$gvimrc" ] && [ ! -L "$gvimrc" ]
	then
		execute "ln -s ~/.vimrc $gvimrc"
	fi
	awk -f zsh_hist.awk ~/.zsh_history .zsh_history > ~/.zsh_history

	# neovim
	#ln -s ~/.vim ~/.config/nvim
	#ln -s ~/.vimrc ~/.config/nvim/init.vim
fi

# End of file
