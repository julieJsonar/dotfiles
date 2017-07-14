#!/usr/bin/env python

from neovim import attach
from collections import Counter
import stat, sys, os, string, commands, time

class NormalReturn(Exception):
   """Base class for other exceptions"""
   pass

def query_yes_no(question, default="yes"):
    """Ask a yes/no question via raw_input() and return their answer.

    "question" is a string that is presented to the user.
    "default" is the presumed answer if the user just hits <Enter>.
        It must be "yes" (the default), "no" or None (meaning
        an answer is required of the user).

    The "answer" return value is True for "yes" or False for "no".
    """
    valid = {"yes": True, "y": True, "ye": True,
             "no": False, "n": False}
    if default is None:
        prompt = " [y/n] "
    elif default == "yes":
        prompt = " [Y/n] "
    elif default == "no":
        prompt = " [y/N] "
    else:
        raise ValueError("invalid default answer: '%s'" % default)

    while True:
        sys.stdout.write(question + prompt)
        choice = raw_input().lower()
        if default is not None and choice == '':
            return valid[default]
        elif choice in valid:
            return valid[choice]
        else:
            sys.stdout.write("Please respond with 'yes' or 'no' "
                             "(or 'y' or 'n').\n")


try:
    question = "Are you sure the tag is lasted by 'tagme'?"
    choice = query_yes_no(question, default="yes")
    if not choice:
        raise NormalReturn

    try:
        # Embed neovim into your python application instead of binding to a running neovim instance.
        #nvim = attach('child', argv=["/bin/env", "nvim", "--embed"])

        # Create a python API session attached to unix domain socket created above:
        nvim = attach('socket', path='/tmp/nvim.trace')
    except Exception, e:
        raise type(e)(e.message + ' Should existed neovim instance by' \
                      '\n    NVIM_PYTHON_LOG_FILE=logfile NVIM_PYTHON_LOG_LEVEL=DEBUG nvim'\
                      '\n    NVIM_LISTEN_ADDRESS=/tmp/nvim.trace nvim')

    # only function name
    #os.system("awk '($2 == \"function\" && $4~/daemon\/wad.*\.c){print $1}' .tagx > /tmp/vim.taglist")
    # only file:line
    os.system("awk '($2 == \"function\" && $4~/daemon\/wad.*\.c/){print $4\":\"$3}' .tagx > /tmp/vim.taglist")

    if not os.path.isfile('/tmp/vim.taglist'):
        raise("No taglist /tmp/vim.taglist")
    tagcount = {}
    with open('/tmp/vim.taglist') as f:
        tagcount = Counter(f.read().split())

    sum = len(tagcount)
    toolbar_width = 80
    # setup toolbar
    sys.stdout.write("[%s]" % (" " * toolbar_width))
    sys.stdout.flush()
    sys.stdout.write("\b" * (toolbar_width+1)) # return to start of line, after '['

    i = 0
    ibar = 0
    for k,v in tagcount.items():
        #print("{}.{}\t{}:{}".format(i, ibar, toolbar_width * i / sum, k))

        #nvim.command('tag ' + k)
        nvim.command('e ' + k)
        #nvim.command("call search('{', 'cW', (line('.')+100))")
        nvim.command("call search('{', 'cW')")
        nvim.command("s/{/{_WAD_TRACE_;/")
        nvim.command("w")

        # update the bar
        i += 1
        #print("{}.{}\t{}".format(i, ibar, toolbar_width * i / sum))
        if toolbar_width * i / sum > ibar:
            sys.stdout.write("-")
            sys.stdout.flush()
            ibar = toolbar_width * i / sum

    sys.stdout.write("\n")

except NormalReturn:
    print "Done!"

except Exception, e:
    print "There was a problem - " + str(e)
