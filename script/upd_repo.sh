#!/bin/bash
#set -o nounset     # Treat unset variables as an error

declare -r DIR=$(cd "$(dirname "$0")" && pwd)
source $DIR/lib_common.sh
source $DIR/lib_bsfl.sh
source $DIR/lib_log4sh.sh

# default message level: ERROR, INFO
#logger_setLevel INFO
logger_info "Starting ..."

# header {{{1
#   sample.sh -- script template
NOTE="Sync all list git-repos"
_DEBUG="off"
verbose=0
dryrun="off"

action="none"
commitmsg="commit message"

declare -r old_dir=$(pwd)
cd -P $DIR && cd .. && phy_dotfiles_dir=$(pwd)

git_repos=( \
  "$HOME/workref/fos-git" \
  "$HOME/workref/fos-5.4" \
  "$HOME/workref/fos-5.6" \
  "$HOME/workref/fos-6.0" \
  "$HOME/workref/fos-trunk" \
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
  -*a [push|pull|status|diff]
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
    if [ -z "${commitmsg}" ] \
        || [ -z "${action}" ] \
        || [ "${action}" != "push" \
            -a  "${action}" != "pull" \
            -a  "${action}" != "status" \
            -a  "${action}" != "diff" ]
    then
    Help
fi
}

DEBUG() { [ "$_DEBUG" == "on" ] && $@; }
Echo () { echo "# $(basename $0): $*"; }
Die()   { echo $1 "$RED"; exit 1; }

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
    DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
    printf "$NOTE: dry=$dryrun action=$action msg=$commitmsg\n\n"

    for git_dir in "${git_repos[@]}"
    do
        if [ ! -d $git_dir ]; then
            continue
        else
            Run "cd $git_dir"
        fi

        # git repo
        if [ -d .git ]; then
            echo .git > /dev/null;
        else
            git rev-parse --git-dir 2> /dev/null;
        fi;

        if [ $? -eq 0 ]; then
            if [[ "$git_dir" == *git ]]; then
                git add -A .; git stash
                git checkout master;
                diff_num=$(git pull --all | wc -l)

                git checkout 5-6; git pull --all;
                git checkout 5-4; git pull --all;
                git checkout 5-2; git pull --all;
                git checkout 5-0; git pull --all;
                git checkout 6.0; git pull --all;
                git checkout master
                git prune
            else
                git add -A .; git stash
                diff_num=$(git pull --all | wc -l)
                git prune
            fi

            if [ $diff_num -gt 2 ]; then
                tagme > /dev/null &
            fi
        fi;

        # svn repo
        if [ -d .svn ]; then
            echo .svn > /dev/null;
        else
            svn info 2> /dev/null;
        fi;

        if [ $? -eq 0 ]; then
            diff_num=$(svn update | wc -l)
            if [ $diff_num -gt 2 ]; then
                tagme > /dev/null &
            fi
        fi;

        msg_ok "update $git_dir changed $diff_num"
    done

    cd "$HOME/workref/fpx-1.0"
    git svn rebase

    cd "$HOME/workref/fpx-trunk"
    git svn rebase

    DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
}

# footer {{{1
#old_dir=$(pwd) > /dev/null 2>&1
DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
#GetOpts "$@"
DEBUG set -vx
Main "$@"
DEBUG set +vx
DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]}{{{${#FUNCNAME[@]}\n"
cd $old_dir
# End of file
