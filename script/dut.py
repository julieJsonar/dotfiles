#!/usr/bin/env python

import getopt
import os
import sys
import logger
import cmd
from dut_control import *
from act_parser import *

try:
    raw_input
except NameError:
    raw_input = input

#
# https://pythonhosted.org/pynput/keyboard.html
#
#import thread
#from pynput.keyboard import Key, Listener
#def on_release(key):
#    'Key check the release wilson'
#    if key == Key.tab:
#        print('{0} release from {0}'.format(key, help(on_release)))
#    # Stop listener
#    if key == Key.esc:
#        return False
#
#def monitor_key(name, delay):
#    # Collect events until released
#    with Listener(on_release=on_release) as listener:
#        listener.join()
#
## Create two threads as follows
#try:
#   thread.start_new_thread( monitor_key, ("Thread-1", 2, ) )
#except:
#   print "Error: Unable to start thread"
#

log = logger.GetLogger(__name__)

CMD_HELP='''
?, command:?
    Get commands help

Ctrl + ]
    Exit dut's interact.

exit
    This will exit the shell.

example:
    show:log
    show:network

'''


def usage():
    """
    @log=wad:urlfilter
    @debug=wad.user:ovrd
    """
    sname = os.path.basename(sys.argv[0])
    print("Usage:")
    print("  %s -h 10.1.1.2 -u 'admin' -p '' " % sname)
    print("  %s -h 10.1.1.2 -u 'admin' -p '' -l 'log.exp'" % sname)
    print("  %s -v -h 10.1.1.2 -u 'admin' -p ''" % sname)
    print("  %s -h 10.1.1.2 -u 'admin' -p '' -t log:wad,ips,urlfilter;show:wad" % sname)
    print("  %s -h 10.1.1.2 -u 'admin' -p '' -t gdb:wad" % sname)

def main():
    # [getopt](https://pymotw.com/2/getopt/)
    try:
        options, remainder = getopt.getopt(sys.argv[1:],
                                           'c:nh:u:p:l:t:vf',
                                           ['cmd=', 'dryrun', 'host=', 'user=', 'pass=',
                                            'log=', "tag=",
                                            "verbose", "version=", "file="])
    except getopt.GetoptError as err:
        # print help information and exit:
        print(str(err))  # will print something like "option -a not recognized"
        usage()
        sys.exit(2)

    name = "tmpDut"
    dryrun = False
    cmdconnect = "ssh"
    host = None
    username = "admin"
    password = ""
    tag = None
    verbose = False
    logfile = "log.exp"
    version = '1.0'

    for opt, arg in options:
        if opt in ('-n', '--dryrun'):
            dryrun = True
        elif opt in ('-c', '--cmd'):
            cmdconnect = arg
        elif opt in ('-h', '--host'):
            host = arg
        elif opt in ('-u', '--user'):
            username = arg
        elif opt in ('-p', '--pass'):
            password = arg
        elif opt in ('-l', '--log'):
            logfile = arg
        elif opt in ('-t', '--tag'):
            tag = arg
        elif opt in ('-v', '--verbose'):
            verbose = True
        elif opt == '--version':
            version = arg
        else:
            assert False, "unhandled option"

    if not host and not dryrun:
        usage()

    if dryrun:
        dut = DutControl.getInstance("log.dummy", True)
    else:
        dut = DutControl(name, logfile)
        if not dut.login(cmdconnect, host, username, password):
            print("Exit: login fail.")
            return

    me = ActParser.getInstance()
    print(CMD_HELP)
    while True:
        if tag:
            cmd = tag
            tag = ''
        else:
            cmd = raw_input('\nCMD (?, ctrl+]) $ ')
        cmd = cmd.strip()
        if not cmd:
            print(CMD_HELP)
            continue
        elif cmd == 'exit' or cmd == 'quit':
            break
        else:
            ret = me.action_execute(dut, [cmd])
            log.info("dut execute %s return %s.", cmd, ret)
            if ret:
                dut.sendline("")
                dut.interact()
            if not dut.child or not dut.child.isalive():
                print("Login again for disconnect.")
                if dryrun:
                    dut = DutControl.getInstance("log.dummy", True)
                else:
                    dut = DutControl(name, logfile)
                    if not dut.login(cmdconnect, host, username, password):
                        print("Exit: login fail.")
                        return


if __name__ == '__main__':
    main()

