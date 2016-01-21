#!/bin/bash
declare -r DIR=$(cd "$(dirname "$0")" && pwd)
source $DIR/lib_common.sh

# header {{{1
NOTE="update dotfile config"
_DEBUG="off"
verbose=0
dryrun="off"

action="none"
commitmsg="auto update"

ignore_files=( "$(basename $0)" '.' '..' \
    '.git' 'README.md' \
    'plugin' \
    '.zsh_history' \
)

# functions {{{1
# help {{{2
Help ()
{
cat << EOF
Usage: ${0##*/} [-hvdn] [-a <action>] [-m <message>]

Options:
  -h  help
  -v  verbose
  -d  debug
  -n  dry-run
  -*a [push|pull]
  -*m "commit message"

Samples:
  ${0##*/} -na pull
  ${0##*/} -na push -m "auto update"

EOF
exit ${1:-0}
}

# basic function {{{2
GetOpts ()
{
    if [ $# -eq 0 ]; then
        Help >&2
    fi

    # Reset is necessary if getopts was used previously in the script.
    OPTIND=1
    local opt
    while getopts "hvdna:m:" opt; do
    case "$opt" in
    h)
        Help
        ;;
    v)  verbose=$OPTARG
        ;;
    d)  _DEBUG="on"
        ;;
    n)  dryrun="on"
        ;;
    a)  action=$OPTARG
        ;;
    m)  commitmsg=$OPTARG
        ;;
    \?)
        Help >&2
        ;;
    *)
        Help >&2
        ;;
    esac
    done
    # Shift off the options and optional
    shift "$((OPTIND-1))"

    # Check options
    if [ -z "${commitmsg}" ] || [ -z "${action}" ] \
        || [ "${action}" != "push" -a  "${action}" != "pull" ] ; then
        Help
    fi
}

DEBUG() { [ "$_DEBUG" == "on" ] && $@; }
Echo () { echo "# $(basename $0): $*"; }
Die()   { echo $1; exit 1; }

Run ()
{
    if [ "$dryrun" == "off" ]; then
        eval "$@"
    else
        echo "Will $*"
        return 0
    fi
}

# user function {{{2

# acording action to change copy direction
copy_file()
{
	local flag=$1
	local filename=$2

	if [ $action == 'pull' ]; then
		execute "cp $flag $filename ~/."
	elif [ $action == 'push' ]; then
		execute "cp $flag ~/$filename ."
	else
		echo "Action [$action] is not valid"
		exit 1
	fi
}

# Main: user script {{{1
Main ()
{
    printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
    printf "$NOTE: dry=$dryrun v=$verbose action=$action dir=$DIR\n"

    old_dir=$(pwd)
    cd -P $DIR && cd .. && phy_dotfiles_dir=$(pwd)
    echo "Current dir: $old_dir, change to $(pwd)"

    if [ $action == 'pull' ]; then
        Run "git pull --all" || Die "Git pull failed!"

        for file in .* *
        do
            array_contains ignore_files "$file"  && echo "Skipping $file" && continue

            home_f=$HOME/$file
            if [[ -f "$home_f" || -d "$home_f" ]]; then
                if [[ -L "$home_f" ]]; then
                    true
                else
                    Run "rm -fr $home_f"
                fi
            fi

            Run "ln -s $phy_dotfiles_dir/$file $home_f" || Die "Create softlink $home_f failed!"
        done

        Run "awk -f $phy_dotfiles_dir/zsh_hist.awk $HOME/.zsh_history $phy_dotfiles_dir/.zsh_history > $HOME/.zsh_history"
        ##	test file exists cannot use '~' to replace $HOME, and should have double-quote
        #gvimrc="$HOME/.gvimrc"
        #nvimrc="$HOME/.nvimrc"
        #nvim="$HOME/.nvim"
        #Run "rm -f $gvimrc"
        #Run "rm -f $nvimrc"
        #Run "rm -f $nvim"

        #if [ ! -f "$gvimrc" ] && [ ! -L "$gvimrc" ]
        #    ;
        #then
        #    Run "ln -s ~/.vimrc $gvimrc"
        #fi
        #Run "awk -f zsh_hist.awk ~/.zsh_history .zsh_history > ~/.zsh_history"

        ## neovim
        ##Run "ln -s ~/.vim ~/.config/nvim"
        ##Run "ln -s ~/.vimrc ~/.config/nvim/init.vim"
    elif [ $action == 'push' ]; then
        Run "git commit -am \"$commitmsg\"" || Die "Git commit failed!"
        Run "git push origin master" || Die "Git push failed!"
    fi

    echo "Backto current dir: $old_dir"
    printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
}

# footer {{{1
old_dir=$(pwd)
printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
GetOpts "$@"
DEBUG set -vx
Main "$@"
DEBUG set +vx
printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]}{{{${#FUNCNAME[@]}\n"
cd $old_dir
# End of file
