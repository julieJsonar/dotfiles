#!/usr/bin/env python

import getopt
import os
import sys
import logger
from dut_control import *
from act_parser import *

# [getopt](https://pymotw.com/2/getopt/)
g_dut = None
dut = None
log = logger.GetLogger(__name__)

observShow = None       # show daemon&runtime info & detail
observLog = None        # trace log
observDebug = None      # troubleshooting


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
    """
    #dut = DutControl("Linux122")
    #print dut.name
    #
    #me = DutControl("DutFOS-123", DutType.DutFOS, True, ' # ')
    #me.login("ssh", "10.1.1.123", "admin", "")
    #
    >>> print 'hello'
    hello0
    """
    global g_dut
    global dut
    global observShow
    global observLog
    global observDebug

    observShow = None       # show daemon&runtime info & detail
    observLog = None        # trace log
    observDebug = None      # troubleshooting

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
        g_dut = DutControl.getInstance("log.dummy", True)
    else:
        g_dut = DutControl(name, logfile)
        if not g_dut.login(cmdconnect, host, username, password):
            print("Exit: login fail.")
            return

    me = ActParser.getInstance()
    if tag:
        me.action_execute(g_dut, [tag])
    g_dut.sendline("")
    g_dut.interact()

if __name__ == '__main__':
    main()

