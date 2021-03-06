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
  "$phy_dotfiles_dir" \
  "$HOME/log" \
  "$HOME/pcap" \
  "$HOME/algorithm" \
  "$HOME/wiki" \
  "$HOME/dotwiki" \
  "$HOME/proj/pcap" \
  "$HOME/proj/apue2e" \
  "$HOME/proj/log" \
  "$HOME/proj/cocti" \
  "$HOME/proj/algorithm" \
  "$HOME/proj/algorithm-doc" \
  "$HOME/proj/c-algorithms" \
  "$HOME/proj/Design-Patterns-in-C" \
  "$HOME/proj/Object-Oriented-in-C" \
  "$HOME/proj/Boost-Cookbook" \
  "$HOME/proj/libevent-book" \
  "$HOME/proj/robot-fortios" \
  "$HOME/proj/linux-0.11" \
  "$HOME/proj/oldlinux" \
  "$HOME/.vim/bundle/neovim-fuzzy" \
  "$HOME/.vim/bundle/vim-grepper" \
  "$HOME/.vim/bundle/taboo.vim" \
  "$HOME/.vim/bundle/vim-mark" \
  "$HOME/.vim/bundle/vim-log-syntax" \
  "$HOME/.vim/bundle/vimux-script" \
  "$HOME/.vim/bundle/c-utils.vim" \
  "$HOME/.vim/bundle/neogdb.vim" \
  "$HOME/.vim/bundle/vim-rooter" \
  "$HOME/.vim/bundle/neomake" \
  "$HOME/.vim/bundle/vimlogger" \
  "$HOME/.vim/bundle/asyncrun.vim" \
  "$HOME/.vim/bundle/VOoM" \
  "$HOME/.vim/bundle/robotframework-vim" \
  "$HOME/.vim/bundle/vim-indentwise" \
)

## removed
#  "$HOME/.vim/bundle/Decho" \
#  "$HOME/.vim/bundle/vim-dispatch" \

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

    if [ "$action" == "pull" ]; then
      Run "cd ~/grive; grive"
    fi

    for git_dir in "${git_repos[@]}"
    do
        if [ ! -d $git_dir ]; then
            msg_warning "Directory $git_dir not existed."
            continue
        else
            Run "cd $git_dir"
        fi

        if [ "$action" == "pull" ]; then
            Run "git pull --all &> /tmp/git.tmp" \
                || Die "$action $git_dir failed!"

            diff_num=$(grep --color=none '^ \S' /tmp/git.tmp | wc -l)
            if [ $diff_num -gt 0 ]; then
                msg_ok "$action :$diff_num $git_dir"
                grep --color=none '^ \S' /tmp/git.tmp
            else
                msg_passed "$action $git_dir"
            fi
        elif [ "$action" == "status" ]; then
            file_num=$(git status --short | wc -l)
            if [ $file_num -gt 0 ]; then
                msg_ok "$action $git_dir"
                Run "git status --short"
            else
                msg_passed "$action $git_dir"
            fi
        elif [ "$action" == "diff" ]; then
            msg_passed "$action $git_dir"
            Run "git --no-pager diff"
        elif [ "$action" == "push" ]; then
            #diff_num=$(git diff | wc -l)
            #file_num=$(git status --short | grep -v '^?' | wc -l)
            #if [ $diff_num -gt 0 ] || [ $file_num -gt 0 ]; then
            #    Run "git commit -am \"$commitmsg\" &> /dev/null" \
            #        && Run "git push origin master &> /dev/null" \
            #        && msg_ok "$git_dir push $diff_num lines patch." \
            #        || Die "Git commit or push failed: $git_dir"
            #else
            #    msg_passed "$git_dir no changed!"
            #fi

            diff_num=$(git diff | wc -l)
            file_num=$(git status --short | grep -v '^?' | wc -l)
            Run "git commit -am \"$commitmsg\" &> /dev/null"
            Run "git push origin master &> /dev/null"
            if [ $diff_num -gt 0 ] || [ $file_num -gt 0 ]; then
                msg_ok "$action $file_num:$diff_num $git_dir"
            else
                msg_passed "$action $file_num:$diff_num $git_dir"
            fi
        fi
    done

    if [ "$action" == "push" ]; then
      Run "cd ~/grive; grive"
    fi

    DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
}

# footer {{{1
#old_dir=$(pwd) > /dev/null 2>&1
DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
GetOpts "$@"
DEBUG set -vx
Main "$@"
DEBUG set +vx
DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]}{{{${#FUNCNAME[@]}\n"
cd $old_dir
# End of file
