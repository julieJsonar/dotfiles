#!/usr/bin/env python

import getopt
import os
import sys
import logger
import cmd
import thread
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
    config proxy
    config auth
    config network
    config policy.proxy

'''


class Duts(object):
    def __init__(self, name):
        self.dut = None
        self.name = name
        self.dryrun = False
        self.cmdconnect = "ssh"
        self.host = None
        self.username = "admin"
        self.password = ""
        self.tag = None
        self.verbose = False
        self.logfile = "log.exp"
        self.version = '1.0'

    def usage(self):
        """
        @log=wad:urlfilter
        @debug=wad.user:ovrd
        """
        sname = os.path.basename(sys.argv[0])
        print("Usage:")
        print("  %s -n " % sname)
        print("  %s -h 10.1.1.2 -u 'admin' -p '' " % sname)
        print("  %s -h 10.1.1.2 -u 'admin' -p '' -l 'log.exp'" % sname)
        print("  %s -v -h 10.1.1.2 -u 'admin' -p ''" % sname)
        print("  %s -h 10.1.1.2 -u 'admin' -p '' -t log:wad,ips,urlfilter;show:wad" % sname)
        print("  %s -h 10.1.1.2 -u 'admin' -p '' -t gdb:wad" % sname)

    def parseArgs(self):
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
            self.usage()
            sys.exit(2)

        for opt, arg in options:
            if opt in ('-n', '--dryrun'):
                self.dryrun = True
            elif opt in ('-c', '--cmd'):
                self.cmdconnect = arg
            elif opt in ('-h', '--host'):
                self.host = arg
            elif opt in ('-u', '--user'):
                self.username = arg
            elif opt in ('-p', '--pass'):
                self.password = arg
            elif opt in ('-l', '--log'):
                self.logfile = arg
            elif opt in ('-t', '--tag'):
                self.tag = arg
            elif opt in ('-v', '--verbose'):
                self.verbose = True
            elif opt == '--version':
                self.version = arg
            else:
                assert False, "unhandled option"

        if not self.host and not self.dryrun:
            self.usage()

    def is_connect(self):
        if not self.dut or not self.dut.child or not self.dut.child.isalive():
            return False
        return True

    def login(self, reason):
        if not self.is_connect():
            print("Login {0}.".format(reason))
            if self.dryrun:
                self.dut = DutControl.getInstance("log.dummy", True, True)
            else:
                self.dut = DutControl(self.name, self.logfile, True, True)
                if not self.dut.login(self.cmdconnect, self.host, self.username, self.password):
                    print("Exit: login fail.")
                    return False
        return True

    @staticmethod
    def run_interact(name, dut):
        dut.interact()

    def thread_interact(self):
        try:
            thread.start_new_thread(Duts.run_interact, ("ThreadInteract", self.dut))
        except:
            print("Error: Unable to start thread")

    def run(self):
        self.parseArgs()
        self.login("init")

        me = ActParser.getInstance()
        print(CMD_HELP)
        while True:
            if self.tag:
                cmd = self.tag
                self.tag = ''
            else:
                cmd = raw_input('\nCMD (?, ctrl+]) $ ')
            cmd = cmd.strip()
            if not cmd:
                print(CMD_HELP)
                if not self.is_connect():
                    self.login("again for disconnect")
                if self.is_connect():
                    self.dut.sendline("")
                    self.dut.interact()
                    #self.thread_interact()
                continue
            elif cmd == 'exit' or cmd == 'quit':
                break
            elif cmd == 'test':
                self.dut.parse_log(3)
                continue
            else:
                if not self.is_connect():
                    self.login("again for disconnect")
                ret = me.action_execute(self.dut, [cmd])
                log.info("dut execute %s return %s.", cmd, ret)
                if ret and self.is_connect():
                    self.dut.sendline("")
                    self.dut.interact()
                    #self.thread_interact()
                continue


if __name__ == '__main__':
    dut = Duts("tmpDut")
    dut.run()

