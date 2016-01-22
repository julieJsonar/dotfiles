#!/bin/bash
declare -r DIR=$(cd "$(dirname "$0")" && pwd)
source $DIR/lib_common.sh

# header {{{1
#   sample.sh -- script template
NOTE="synce all config change"
_DEBUG="off"
verbose=0
dryrun="off"

action="none"
commitmsg="commit message"

declare -r old_dir=$(pwd)
cd -P $DIR && cd .. && phy_dotfiles_dir=$(pwd)

git_repos=( \
  "$phy_dotfiles_dir" \
  "$HOME/.vim/bundle/vim-dispatch" \
  "$HOME/.vim/bundle/vimux-script" \
  "$HOME/.vim/bundle/c-utils.vim" \
  "$HOME/.vim/bundle/vimux-script" \
  "$HOME/log" \
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
  -*m "some note"

Samples:
  ${0##*/} -na pull
  ${0##*/} -na push -m "<our commit message>"

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

# Main: user script {{{1
Main ()
{
    printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
    printf "$NOTE: $dryrun $action $commitmsg\n"

    for git_dir in "${git_repos[@]}"
    do
        if [ "$action" == "pull" ]; then
            Run "cd $git_dir"
            Run "git pull --all" || Die "Git pull $git_dir failed!"
        elif [ "$action" == "push" ]; then
            Run "cd $git_dir"
            Run "git commit -am \"$commitmsg\"" || Die "Git commit $git_dir failed!"
            Run "git push origin master" || Die "Git push $git_dir failed!"
        fi
    done

    printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
}

# footer {{{1
old_dir=$(pwd) 2> /dev/null
printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
GetOpts "$@"
DEBUG set -vx
Main "$@"
DEBUG set +vx
printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]}{{{${#FUNCNAME[@]}\n"
cd $old_dir
# End of file
