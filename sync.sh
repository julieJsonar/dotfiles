#!/bin/bash
function show_help(){
cat << EOF
Examples:
$ ./sync.sh -a pull
$ ./sync.sh -a push

Do stuff like git pull|push

    -a ACTION   pull action
                push action
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

# START
if [ $verbose -eq '1' ]; then
	set -vx
else
	set +vx
fi

if [ $action_mode == 'push' ]; then
	cd ~/.vim/bundle/vim-dispatch
	git add .
	git commit -am \"$commit_msg\" && git push origin master

	cd ~/.vim/bundle/vimux-script
	git add .
	git commit -am \"$commit_msg\" && git push origin master

	cd ~/.vim/bundle/c-utils.vim
	git add .
	git commit -am \"$commit_msg\" && git push origin master

	cd ~/log
	git add .
	git commit -am \"$commit_msg\" && git push origin master

	cd ~/dotfiles
	./update.sh -a push -m \"$commit_msg\"

elif [ $action_mode == 'pull' ]; then
	cd ~/.vim/bundle/vim-dispatch
	git pull --all
	cd ~/.vim/bundle/vimux-script
	git pull --all
	cd ~/.vim/bundle/c-utils.vim
	git pull --all
	cd ~/log
	git pull --all
	cd ~/dotfiles
	./update.sh -a pull
fi
