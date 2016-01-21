#!/bin/bash
# header {{{1
#   sample.sh -- script template
NOTE="synce all config change"
_DEBUG="off"
verbose=0
dryrun="off"
usermsg="auto update"

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
  -*m "some note"

Samples:
  ${0##*/} -na pull -m "auto update"

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
    m)  usermsg=$OPTARG
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
    if [ -z "${usermsg}" ] || [ -z "${action}" ] \
        || [ "${action}" != "push" -a  "${action}" != "pull" ] ; then
        Help
    fi
}

DEBUG() { [ "$_DEBUG" == "on" ] && $@; }
Echo () { echo "# $(basename $0): $*"; }
Die()   { echo $1; exit 1; }

Run ()
{
    if [ "$dryrun" == "on" ]; then
        echo "$*"
        return 0
    fi

    eval "$@"
}

# Main: user script {{{1
Main ()
{
    printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
    printf "$NOTE: $dryrun $action $usermsg\n"

	if [ "$action" == "push" ]; then
		Run "cd ~/.vim/bundle/vim-dispatch"
		Run "git commit -am \"$usermsg\""
		Run "git push origin master"

		Run cd ~/.vim/bundle/vimux-script
		Run "git commit -am \"$usermsg\""
		Run "git push origin master"

		Run cd ~/.vim/bundle/c-utils.vim
		Run "git commit -am \"$usermsg\""
		Run "git push origin master"

		Run cd ~/log
		Run "git commit -am \"$usermsg\""
		Run "git push origin master"

		Run cd ~/dotfiles
		Run "./update.sh -a push -m \"$usermsg\""

	elif [ "$action" == "pull" ]; then
		Run "cd ~/.vim/bundle/vim-dispatch"
		Run "git pull --all"
		Run "cd ~/.vim/bundle/vimux-script"
		Run "git pull --all"
		Run "cd ~/.vim/bundle/c-utils.vim"
		Run "git pull --all"
		Run "cd ~/log"
		Run "git pull --all"
		Run "cd ~/dotfiles"
		Run "./update.sh -a pull"
	fi

    printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
}

# footer {{{1
printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
GetOpts "$@"
DEBUG set -vx
Main "$@"
DEBUG set +vx
printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]}{{{${#FUNCNAME[@]}\n"
# End of file
