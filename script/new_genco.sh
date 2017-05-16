#!/bin/bash
#set -o nounset     # Treat unset variables as an error

declare -r DIR=$(cd "$(dirname "$0")" && pwd)
me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
source $DIR/lib_common.sh
source $DIR/lib_bsfl.sh
source $DIR/lib_log4sh.sh

# default message level: ERROR, INFO
#logger_setLevel INFO
logger_info "Starting ..."

# header {{{1
#   sample.sh -- script template
NOTE="rb_genco.py and check patch.diff"
_DEBUG="off"
verbose=0
dryrun="off"

commitmsg="none"

declare old_dir=$(pwd)

ban_words=( \
  "WAD_RUN_TEST_FROM_CLI" \
  "daemon/wad/wad_debug.c" \
  "__FGT_DISK_MGR_DEBUG" \
  "wilson" \
  "message" \
  "cooked" \
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
        return 0
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

    Run "rm -f patch.eco.diff 2> /dev/null"
    Run "rm -f $HOME/.rb_genco/.rb_genco 2> /dev/null"


    # patch.eco.diff
    Run "rb_genco.py diff -o patch.eco.diff"
    if [ ! -f "patch.eco.diff" ] ; then
        msg_fail "Fail: local ./patch.eco.diff file not exists"
        Die
    else
        lines=$(wc -l < patch.eco.diff)
        if [ $lines -eq 0 ]; then
            msg_fail "Fail: local ./patch.eco.diff file is empty"
            Die
        else
            msg_ok "($me) ./patch.eco.diff $lines lines"
        fi
    fi


    if [ ! -f "rb_genco" ] ; then
        # new post
        Run "rm -f rb_genco 2> /dev/null"
        Run "rb_genco.py post"
        Run "cp $HOME/.rb_genco/.rb_genco rb_genco"
        RB_ID="$(awk -F'=' '{print $2}' rb_genco)"
        msg_ok "===================================================="
        msg_ok "($me) rb_genco.py post: create new ./rb_genco $RB_ID"
        msg_ok "===================================================="
    else
        # update existed id
        RB_ID="$(awk -F'=' '{print $2}' rb_genco)"
        Run "rb_genco.py update $RB_ID"
        msg_ok "===================================================="
        msg_ok "($me) rb_genco.py update ./rb_genco $RB_ID"
        msg_ok "===================================================="
    fi

    if [ ! -f "rb_genco" ] ; then
        msg_fail "Fail: local ./rb_genco file not exists"
        Die
    fi

    # Sanity code check
    have_failed=0
    for ban_word in "${ban_words[@]}"
    do
        #Run "grep '$ban_word' patch.eco.diff"
        grep "$ban_word" patch.eco.diff
        if [ $? == 0 ]; then
            have_failed=1
            msg_not_ok "Fail: patch contain bad words '$ban_word'!"
        fi
    done

    if [ $have_failed -gt 0 ] ; then
        :
    else
        msg_success "Patch check passed!"

        grep "CONFIG_DEBUG" .config
        if [ $? == 0 ]; then
            msg_alert "Maybe we need build a release version!"
        fi
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
