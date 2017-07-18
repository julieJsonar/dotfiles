#!/usr/bin/env python

import neovim
from collections import Counter
import stat, sys, os, string, commands, time
import ConfigParser
import argparse
import re

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
    parser = argparse.ArgumentParser(description='Usage of ' + __file__)
    parser.add_argument('-a','--action', help='Action: add|clear', required=False)
    parser.add_argument('-f','--file',   help='File name match regex', required=False)
    parser.add_argument('-s','--symbol', help='Symbol function name match regex', required=False)
    parser.add_argument('-c','--client', help='Neovim client listen address', required=False)
    parser.add_argument('-t','--target', help='Target config dir name', required=False)
    args = vars(parser.parse_args())

    arg_action = 'add'
    if 'action' in args and args['action'] is not None:
        arg_action = args['action']

    arg_file_regex = 'daemon\/wad.*\.c'
    if 'file' in args and args['file'] is not None:
        arg_file_regex = args['file']

    arg_func_regex = ''
    if 'symbol' in args and args['symbol'] is not None:
        arg_func_regex = args['symbol'];

    arg_client_addr = 'trace'
    if 'client' in args and args['client'] is not None:
        arg_client_addr = args['client'];

    arg_target_conf = 'trace-wad'
    if 'target' in args and args['target'] is not None:
        arg_target_conf = args['target'];

    question = "Are you sure the tag is lasted by 'tagme'?"
    choice = query_yes_no(question, default="yes")
    if not choice:
        raise NormalReturn

    start_time = time.time()
    try:
        # Embed neovim into your python application instead of binding to a running neovim instance.
        #nvim = neovim.attach('child', argv=["/bin/env", "nvim", "--embed"])

        # Create a python API session attached to unix domain socket created above:
        nvim = neovim.attach('socket', path='/tmp/nvim.' + arg_client_addr)
    except Exception, e:
        raise type(e)(e.message + ' Should existed neovim instance by' \
                      '\n    NVIM_PYTHON_LOG_FILE=/tmp/nvim.log NVIM_PYTHON_LOG_LEVEL=DEBUG nvim'\
                      '\n    NVIM_LISTEN_ADDRESS=/tmp/nvim.' + arg_client_addr + ' nvim')

    matcher = '$2 == "function"'
    if arg_func_regex:
        matcher += ' && $2~/' + arg_func_regex + '/'
    if arg_file_regex:
        matcher += ' && $4~/' + arg_file_regex + '/'

    # Generate config type function file
    os.system("echo '[function]' > /tmp/vim.taglist")
    # function = file:line
    awk_cmdstr = "awk '(" + matcher + "){print $4\"+\"$3\" = \"$1}' .tagx >> /tmp/vim.taglist"
    print awk_cmdstr
    os.system(awk_cmdstr)
    if not os.path.isfile('/tmp/vim.taglist'):
        raise("No taglist /tmp/vim.taglist")

    dir_path = os.path.dirname(os.path.realpath(__file__))

    # skip files
    ign_files = {}
    fn = dir_path + '/' + arg_target_conf + '/file'
    print("Load {} and filter-out the ignore files ...".format(fn))
    if os.path.isfile(fn):
        with open(fn) as f:
            ign_files = Counter(f.read().split())

    # skip functions
    ign_functions = {}
    fn = dir_path + '/' + arg_target_conf + '/function'
    print("Load {} and filter-out the ignore functions ...".format(fn))
    if os.path.isfile(fn):
        with open(fn) as f:
            ign_functions = Counter(f.read().split())

    # skip functions
    ign_funcregs = {}
    fn = dir_path + '/' + arg_target_conf + '/funcregex'
    print("Load {} and filter-out the ignore function regex ...".format(fn))
    if os.path.isfile(fn):
        with open(fn) as f:
            ign_funcregs = Counter(f.read().split())

    # {file:{line:function, }, }
    dict_result = {}
    filterout_files = {}
    item_cnt = 0
    file_cnt = 0
    with open('/tmp/vim.taglist') as fp:
        config = ConfigParser.RawConfigParser(allow_no_value=True)
        config.readfp(fp)
        for sec in config.sections():
            for (k, func_name) in config.items(sec):
                if arg_action == 'add' and func_name in ign_functions:
                     continue

                is_ign_func = False
                if arg_action == 'add':
                    for (ign_func, ign_v) in ign_funcregs.iteritems():
                        if ign_func.startswith('#'):
                            continue
                        if re.search(ign_func, func_name):
                            is_ign_func = True
                            continue
                if is_ign_func:
                    continue

                file_line = k.split("+")
                if len(file_line) < 2:
                    print("len not enough: str={} len={}".format(str(file_line), len(file_line)))
                    continue

                is_ign_file = False
                if arg_action == 'add':
                    for (ign_file, ign_v) in ign_files.iteritems():
                        if ign_file.startswith('#'):
                            continue
                        if re.search(ign_file, file_line[0]):
                            if file_line[0] not in filterout_files:
                                filterout_files[file_line[0]] = 1
                                print("ign_files: pattern={} file={}".format(ign_file, file_line[0]))
                            is_ign_file = True
                            continue
                if is_ign_file:
                    continue

                if file_line[0] not in dict_result:
                    dict_result[file_line[0]] = {}
                    file_cnt += 1
                line_func = dict_result[file_line[0]]
                line_func[file_line[1]] = func_name
                item_cnt += 1

    print("Add trace functions number {} ...".format(item_cnt))

    toolbar_width = 40
    # setup toolbar
    sys.stdout.write("[%s]" % (" " * toolbar_width))
    sys.stdout.flush()
    sys.stdout.write("\b" * (toolbar_width+1)) # return to start of line, after '['

    i = 0
    ibar = 0
    have_repstr = False
    for (k_file, v_line_func) in dict_result.iteritems():
        nvim.command('e ' + k_file)
        nvim.command("w")
        if arg_action == 'add':
            for (k_line, v_func) in v_line_func.iteritems():
                nvim.command(k_line)
                nvim.command("call search('{', 'cW')")
                if not have_repstr:
                    nvim.command("s/{/{__TRACEME__;/e")
                else:
                    nvim.command("&")
                    #nvim.command("s/{/{__TRACEME__;/")

                # update the bar
                i += 1
                #print("{}.{}\t{}".format(i, ibar, toolbar_width * i / sum))
                if toolbar_width * i / item_cnt > ibar:
                    sys.stdout.write("-")
                    sys.stdout.flush()
                    ibar = toolbar_width * i / item_cnt
        elif arg_action == 'clear':
            nvim.command("%s/{__TRACEME__;/{/ge")

            # update the bar
            i += 1
            #print("{}.{}\t{}".format(i, ibar, toolbar_width * i / sum))
            if toolbar_width * i / file_cnt > ibar:
                sys.stdout.write("-")
                sys.stdout.flush()
                ibar = toolbar_width * i / file_cnt

        nvim.command("w")

    sys.stdout.write("\n")
    end_time = time.time()

    f_patch = dir_path + '/' + arg_target_conf + '/patch.diff'
    cmdstr = 'if ! patch -R -p0 --dry-run < ' + f_patch + '; then ' \
            'patch -p0 < ' + f_patch + '; fi'
    print cmdstr
    os.system(cmdstr)

    print("seconds: {}".format(end_time - start_time))

except NormalReturn:
    print "Done!"

except Exception as e:
    exc_type, exc_obj, exc_tb = sys.exc_info()
    fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
    print(exc_type, fname, exc_tb.tb_lineno)
    print "  : " + str(e)

