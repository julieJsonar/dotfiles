#!/usr/bin/env python
import getopt
import sys
import logger
from dut_control import *

# [getopt](https://pymotw.com/2/getopt/)
g_dut = None
log = logger.GetLogger(__name__)

def usage():
    print "Usage:"
    print "  script -h 10.1.1.2 -u 'admin' -p '' "
    print "  script -h 10.1.1.2 -u 'admin' -p '' -l 'log.exp' "
    print "  script -v -h 10.1.1.2 -u 'admin' -p '' "
    print "  script -h 10.1.1.2 -u 'admin' -p '' -m log -a wad.ips.urlfilter"
    print "  script -h 10.1.1.2 -u 'admin' -p '' -m gdb "

def act_common():
    strSend = """
        diag debug dis
        diag debug console no enable
        diag debug console timestamp disable
        diag ips debug disable all
        diag wad debug clear
        """
    g_dut.sendline(strSend)

def act_debug_wad():
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

def act_debug_ips():
    strSend = """
        diag ips debug enable all
        diag ips debug disable timeout
        diag debug en
        """
    g_dut.sendline(strSend)

def act_debug_urlfilter():
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

    name = "tmpDut"
    cmdconnect = "ssh"
    host = None
    username = "admin"
    password = ""
    mode = None
    mode_arg = "wad"
    verbose = False
    logfile = "log.exp"
    version = '1.0'

    options, remainder = getopt.getopt(sys.argv[1:],
                                       'c:n:h:u:p:l:m:a:v',
                                       ['cmd=', 'name=', 'host=', 'user=', 'pass=',
                                        'log=', "mode=", "arg=", "verbose=",
                                        "version="])
    for opt, arg in options:
        if opt in ('-n', '--name'):
            name = arg
        elif opt in ('-n', '--name'):
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
        elif opt in ('-v', '--verbose'):
            verbose = True
        elif opt == '--version':
            version = arg

    if not host:
        usage()

    g_dut = DutControl(name)
    if not g_dut.login(cmdconnect, host, username, password):
        print("Exit: login fail.")
        return

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
            act_debug_wad()
        if "ips" in mode_arg:
            act_debug_ips()
        if "url" in mode_arg:
            act_debug_urlfilter()

    g_dut.interact()


if __name__ == '__main__':
    main()

