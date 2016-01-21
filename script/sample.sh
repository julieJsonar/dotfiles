#!/bin/bash
#   sample.sh -- Demonstrate how testing feature can be implemented in program
#
#       Copyright (C) 2009 Jari Aalto <jari.aalto@cante.net>
#
#   License
#
#       This program is free software; you can redistribute it and/or
#       modify it under the terms of the GNU General Public License as
#       published by the Free Software Foundation; either version 2 of
#       the License, or (at your option) any later version.
#
#       This program is distributed in the hope that it will be useful, but
#       WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#       General Public License for more details.
#
#       You should have received a copy of the GNU General Public License
#       along with program. If not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
#       02110-1301, USA.
#
#       Visit <http://www.gnu.org/copyleft/gpl.html>
#
#   Description
#
#       To enable debugging and testing capabilities in shell
#       scripts, add function Run() and use it to proxy all commands.
#
#   Notes
#
#       The functions in the program are "defined before used". It is only
#       possible to call a function (= command) if it exists (= is defined).
#
#       There is explicit Main() where program starts. This follows
#       the convention of good programming style. By putting the code
#       inside functions, it also makes one think about modularity and
#       reusable components.
#
#   Run Sample:
#         -d      Debug. Before command is run, show it.
#         -t      Dry-run test mode. Show commands, do not really execute.
#      $ bash sample.sh -t
#
#      test-demo.sh -- Demonstrate how testing feature can be implemented in program
#      # DEMO: a command
#      ls -l
#
#      # DEMO: a command with pipe
#      ls -l | sort
#
#      # DEMO: a command with pipe and redirection
#      ls -l | sort > /tmp/jaalto.1396-ls.lst
#
#      # DEMO: a command with pipe and redirection using quotes
#      ls -l | sort > "/tmp/jaalto.1396-ls.lst"
#
#      # DEMO: a command and subshell call.
#      echo ls -l
####################################################################################

DESC="$0 -- Demonstrate how testing feature can be implemented in program"
TEMPDIR=${TEMPDIR:-/tmp}
TEMPPATH=$TEMPDIR/${LOGNAME:-foo}.$$

#   This variable is best to be undefined, not TEST="" or anything.
unset TEST

Help ()
{
    echo "\
$DESC

Available options:

-d      Debug. Before command is run, show it.
-t      Test mode. Show commands, do not really execute.

The -t option takes precedence over -d option."

    exit ${1:-0}
}

Run ()
{
    if [ "$TEST" ]; then
        echo "$*"
        return 0
    fi

    eval "$@"
}

Echo ()
{
    echo "# DEMO: $*"
}

Demo ()
{
    Echo "a command"
    Run ls -l

    Echo "a command with pipe"
    Run "ls -l | sort"

    Echo "a command with pipe and redirection"
    Run "ls -l | sort > $TEMPPATH-ls.lst"

    Echo "a command with pipe and redirection using quotes"
    Run "ls -l | sort > \"$TEMPPATH-ls.lst\""

    #   You need to put Run() call also into subshell, otherwise
    #   it would be run "for real" and defeat the test mode.

    Echo "a command and subshell call."
    Run "echo $( Run ls -l )"
}

LogicAndOr ()
{
}

Main ()
{
    echo "$DESC"

    OPTIND=1
    local arg

    while getopts "hdt" arg "$@"
    do
        case "$arg" in
            h)  Help
                ;;
            t)  TEST="test"
                ;;
        esac
    done

    #   Remove found options from command line arguments.
    shift $(($OPTIND - 1))

    #   Run the demonstration
    Demo
}

Main "$@"

# End of file
