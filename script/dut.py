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


class Duts(cmd.Cmd):
    """Simple command processor example."""

    def __init__(self, dut=None):
        cmd.Cmd.__init__(self)
        self.dut = dut

    def set_dut(self, dut):
        self.dut = dut

    @staticmethod
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

    LOG_HELP = [ 'wad', 'url', 'ips', ]
    def do_log(self, person):
        "Greet the person"
        if person and person in self.LOG_HELP:
            greeting = 'hi, %s!' % person
        elif person:
            greeting = "hello, " + person
        else:
            greeting = 'hello'
        print greeting

    def complete_greet(self, text, line, begidx, endidx):
        if not text:
            completions = self.LOG_HELP[:]
        else:
            completions = [ f
                            for f in self.LOG_HELP
                            if f.startswith(text)
                            ]
        return completions

    def do_show(self, person):
        "Greet the person"
        pass

    def do_EOF(self, line):
        return True


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
        Duts.usage()
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
        Duts.usage()

    if dryrun:
        dut = DutControl.getInstance("log.dummy", True)
    else:
        dut = DutControl(name, logfile)
        if not dut.login(cmdconnect, host, username, password):
            print("Exit: login fail.")
            return

    me = ActParser.getInstance()
    #if tag:
    #    me.action_execute(dut, [tag])
    #    dut.sendline("")
    #    dut.interact()
    #else:
    #    duts = Duts()
    #    duts.set_dut(dut)
    #    duts.cmdloop()

    print(CMD_HELP)
    while True:
        if tag:
            cmd = tag
            tag = ''
        else:
            cmd = raw_input('\nCMD (?,exit,ctrl+]) $ ')
        cmd = cmd.strip()
        if not cmd:
            print(CMD_HELP)
            continue
        elif cmd == 'exit' or cmd == 'quit':
            break
        else:
            if me.action_execute(dut, [cmd]):
                #print("wilson return true")
                dut.sendline("")
                dut.interact()
            else:
                pass
                #print("wilson return false")
            #print('#' * 79)


if __name__ == '__main__':
    main()
    #Duts().cmdloop()

