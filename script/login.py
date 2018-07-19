#!/usr/bin/env python

import getopt
import os
import sys
import logger
from dut_control import *

# [getopt](https://pymotw.com/2/getopt/)
g_dut = None
dut = None
log = logger.GetLogger(__name__)

observShow = None       # show daemon&runtime info & detail
observLog = None        # trace log
observDebug = None      # troubleshooting


def usage():
    print "Usage:"
    print "  %s -h 10.1.1.2 -u 'admin' -p '' " % os.path.basename(sys.argv[0])
    print "  %s -h 10.1.1.2 -u 'admin' -p '' -l 'log.exp' " % os.path.basename(sys.argv[0])
    print "  %s -v -h 10.1.1.2 -u 'admin' -p '' " % os.path.basename(sys.argv[0])
    print "  %s -h 10.1.1.2 -u 'admin' -p '' -m log -a wad.ips.urlfilter" % os.path.basename(sys.argv[0])
    print "  %s -h 10.1.1.2 -u 'admin' -p '' -m gdb " % os.path.basename(sys.argv[0])

class Event(object):
    pass



# Your Job class can subclass `Observable`.
# When something of interest happens, call `self.fire(type="progress", percent=50)` or the like.
class Observable(object):
    def __init__(self):
        self.callbacks = []
    def subscribe(self, callback):
        self.callbacks.append(callback)
    def fire(self, **attrs):
        e = Event()
        e.source = self
        for k, v in attrs.iteritems():
            setattr(e, k, v)
        for fn in self.callbacks:
            fn(e)


def act_common():
    strSend = """
        diag debug dis
        diag debug console no enable
        diag debug console timestamp disable
        diag ips debug disable all
        diag wad debug clear
        """
    g_dut.sendline(strSend)


def act_log_wad():
    strSend = """
        diag wad debug enable level verbose
        diag wad debug enable cat all
        diag wad debug display pid enable
        diag debug crash read
        diag debug en
        """
    # "diag test app wad 2300\r"
    # "diag test app wad 110\r"
    # "diag debug console timestamp enable\r"
    g_dut.sendline(strSend)

def act_log_ips():
    strSend = """
        diag ips debug enable all
        diag ips debug disable timeout
        diag debug en
        """
    g_dut.sendline(strSend)

def act_log_urlfilter():
    strSend = """
        diag debug app urlfilter -1
        diag debug en
        diagnose test application urlfilter 21
        """
    g_dut.sendline(strSend)

def act_gdb_wad():
    if not g_dut.is_debug():
        print("Cannot debug release version!")
        return

    strSend = """
        diag debug en
        diag test app wad 1000
        """
    g_dut.sendline(strSend)
    processInfo = r'Process.*?: type=(wanopt|worker).*? index=.*? pid=(.*?) state=.*?\r'
    #ret = g_dut.child.expect([pexpect.EOF, pexpect.TIMEOUT, processInfo, g_dut.prompt], timeout=2)
    ret = g_dut.child.expect([pexpect.EOF, pexpect.TIMEOUT, processInfo], timeout=2)
    if ret > 1:
        log.debug("  worker-pid ret=%d: {%s}", ret, g_dut.child.match.group())
    if ret == 2:  # matched
        wad_worker_pid = g_dut.child.match.group(2)
        ret = g_dut.child.expect([pexpect.EOF, pexpect.TIMEOUT, g_dut.prompt], timeout=2)
        g_dut.sendline("sys sh")
        g_dut.sendline("gdbserver :444 --attach %s" % (wad_worker_pid))

def act_debug_wad():
    strSend = """
        diag debug app urlfilter -1
        diag debug en
        diagnose test application urlfilter 21
        """
    g_dut.sendline(strSend)

def act_show_log():
    strSend = """
        exec log filter cate 3
        exec log filter device memory
        exec log display
        """
    g_dut.sendline(strSend)

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
    cmdconnect = "ssh"
    host = None
    username = "admin"
    password = ""
    mode = None
    mode_arg = "wad"
    mode_sec_arg = ""
    verbose = False
    logfile = "log.exp"
    version = '1.0'

    options, remainder = getopt.getopt(sys.argv[1:],
                                       'c:n:h:u:p:l:m:a:s:v:f',
                                       ['cmd=', 'name=', 'host=', 'user=', 'pass=',
                                        'log=', "mode=", "arg=", "sec=","verbose=",
                                        "version=", "file="])
    for opt, arg in options:
        if opt in ('-n', '--name'):
            name = arg
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
        elif opt in ('-m', '--mode'):
            mode = arg
        elif opt in ('-a', '--arg'):
            mode_arg = arg
        elif opt in ('-s', '--sec'):
            mode_sec_arg = arg
        elif opt in ('-v', '--verbose'):
            verbose = True
        elif opt == '--version':
            version = arg

    if not host:
        usage()

    g_dut = DutControl(name, logfile)
    if not g_dut.login(cmdconnect, host, username, password):
        print("Exit: login fail.")
        return

    # import pexpect
    # g_dut = pexpect.spawn('ssh -qo "StrictHostKeyChecking=no" admin@10.1.1.123')
    # g_dut.setwinsize(0, 0)
    # g_dut.logfile_read = open("log.global", "w")
    # g_dut.setecho(False)
    # g_dut.delaybeforesend = None

    # dut = pexpect.spawn('ssh -qo "StrictHostKeyChecking=no" admin@10.1.1.125')
    # dut.setwinsize(0, 0)
    # dut.logfile_read = open("log.local", "w")
    # dut.setecho(False)
    # dut.delaybeforesend = None


    # dut.sendline("get system status")
    # dut.expect(r".*")
    # g_dut.sendline("get system status")
    # g_dut.expect(r".*")

    # g_dut.sendline("sysctl echo fromglobal2")
    # g_dut.expect(r".*")
    # dut.sendline("sysctl echo fromlobalwilson2")
    # dut.expect(r".*")

    # dut.interact()
    # return;

    print("Running mode=%s" % (mode))
    if mode == "clear":
        if g_dut.has_vdom():
            g_dut.sendline("config global")
        act_common()
    elif mode == "gdb":
        if g_dut.has_vdom():
            g_dut.sendline("config global")
        act_common()
        act_gdb_wad()
    elif mode == "log":
        if g_dut.has_vdom():
            g_dut.sendline("config global")

        act_common()
        if "wad" in mode_arg:
            act_log_wad()
        if "ips" in mode_arg:
            act_log_ips()
        if "url" in mode_arg:
            act_log_urlfilter()

        if g_dut.has_vdom():
            g_dut.sendline("end")
    elif mode == "show":
        if g_dut.has_vdom():
            g_dut.sendline("config global")

        act_common()
        if "log" in mode_arg:
            act_show_log()
    # @todo wilson: add troubleshooting
    elif mode == "debug":
        if g_dut.has_vdom():
            g_dut.sendline("config global")
        act_common()
        if "wad" in mode_arg:
            act_debug_wad()
        if "ips" in mode_arg:
            act_debug_ips()
        if "url" in mode_arg:
            act_debug_urlfilter()
        if g_dut.has_vdom():
            g_dut.sendline("end")

    g_dut.interact()


if __name__ == '__main__':
    main()

