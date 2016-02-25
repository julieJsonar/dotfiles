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
NOTE="re-genco and check patch.diff"
_DEBUG="off"
verbose=0
dryrun="off"

commitmsg="commit message"

declare old_dir=$(pwd)

git_repos=( \
  "WAD_RUN_TEST_FROM_CLI" \
  "daemon/wad/wad_debug.c" \
  "__FGT_DISK_MGR_DEBUG" \
)

# functions {{{1
# help {{{2
Help ()
{
cat << EOF
Usage: ${0##*/} [-hvdn] [-m <message>]

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
    while getopts "hvdnm:" opt; do
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
    if [ -z "${commitmsg}" ] ; then
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
    printf "$NOTE: dry=$dryrun msg=$commitmsg\n\n"

    Run "genco patch.xml -m \"$commitmsg\"" \
        && Run "genco -i patch.xml -r changeorder.xml" \
        && Run "mv changeorder-new.xml changeorder.xml" \
        && Run "genco -i changeorder.xml -d > patch.eco.diff" \
        && msg_ok "re-genco: patch.eco.diff" \
        || Die "re-genco fail."

    if [ ! -f "patch.eco.diff" ] ; then
        msg_failed "re-genco fail"
        Die "Fail: no patch.eco.diff"
    fi

    have_failed=0
    for git_dir in "${git_repos[@]}"
    do
        #Run "grep '$git_dir' patch.eco.diff"
        grep -C3 "$git_dir" patch.eco.diff
        if [ $? == 0 ]; then
            have_failed=1
            msg_not_ok "Fail: patch contain bad words '$git_dir'!"
        fi
    done

    if [ $have_failed -gt 0 ] ; then
        msg_failed "Fail: patch contain bad words!"
    else
        msg_success "Patch check passed!"
    fi

    DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
}

# footer {{{1
old_dir=$(pwd) > /dev/null 2>&1
DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
GetOpts "$@"
DEBUG set -vx
Main "$@"
DEBUG set +vx
DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]}{{{${#FUNCNAME[@]}\n"
cd $old_dir
# End of file
