#!/usr/bin/env python

"""
Usage, need two terminal:
    term1 $ rm -f /tmp/nvim.trace; NVIM_LISTEN_ADDRESS=/tmp/nvim.trace nvim
    term2 $ traceme.py
"""

import neovim
from collections import Counter
import stat, sys, os, string, commands, time
import ConfigParser
import argparse
import re

# args
arg_action = 'add'
arg_file_regex = 'daemon\/wad.*\.c'
arg_func_regex = ''
arg_client_addr = 'trace'
arg_target_conf = 'trace-wad'
arg_new_tag = '  __TRACEME__;'

ign_files = {}
ign_functions = {}
ign_funcregs = {}

class NormalReturn(Exception):
   """Base class for other exceptions"""
   pass

class NeovimNone(Exception):
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

def parse_args():
    global arg_action
    global arg_file_regex
    global arg_func_regex
    global arg_client_addr
    global arg_target_conf

    parser = argparse.ArgumentParser(description='Usage of ' + __file__)
    parser.add_argument('-a','--action', help='Action: add|clear', required=False)
    parser.add_argument('-f','--file',   help='File name match regex', required=False)
    parser.add_argument('-s','--symbol', help='Symbol function name match regex', required=False)
    parser.add_argument('-c','--client', help='Neovim client listen address', required=False)
    parser.add_argument('-t','--target', help='Target config dir name', required=False)
    args = vars(parser.parse_args())

    if 'action' in args and args['action'] is not None:
        arg_action = args['action']
    if 'file' in args and args['file'] is not None:
        arg_file_regex = args['file']
    if 'symbol' in args and args['symbol'] is not None:
        arg_func_regex = args['symbol'];
    if 'client' in args and args['client'] is not None:
        arg_client_addr = args['client'];
    if 'target' in args and args['target'] is not None:
        arg_target_conf = args['target'];

def load_from_file(res, fn, info):
    global arg_target_conf

    dir_path = os.path.dirname(os.path.realpath(__file__))
    f = dir_path + '/' + arg_target_conf + '/' + fn
    print("Load {} and {} ...".format(f, info))
    if os.path.isfile(f):
        res = set(line.strip() for line in open(f))
    return res

def load_ignores():
    global ign_files
    global ign_functions
    global ign_funcregs

    ign_files = load_from_file(ign_files, 'file', 'filter-out the ignore files')
    ign_functions = load_from_file(ign_functions, 'function', 'filter-out the ignore functions')
    ign_funcregs = load_from_file(ign_funcregs, 'funcregex', 'filter-out the ignore function regex')

def parse_taglist():
    global arg_action
    global arg_file_regex
    global arg_func_regex
    global arg_client_addr
    global arg_target_conf

    if not os.path.isfile('.tagx'):
        raise("No tagx file, tagme first.")

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

# @return bool
def filterout_trace_functions(file_line, func_name, filterout_files):
    global ign_files
    global ign_functions
    global ign_funcregs

    if func_name in ign_functions:
        return True;

    is_ign_func = False
    for ign_func in ign_funcregs:
        if not ign_func:
            continue
        if ign_func.startswith('#'):
            continue
        if re.search(ign_func, func_name):
            is_ign_func = True
            continue
    if is_ign_func:
        return True

    is_ign_file = False
    for ign_file in ign_files:
        if not ign_file:
            continue
        if ign_file.startswith('#'):
            continue
        if re.search(ign_file, file_line[0]):
            if file_line[0] not in filterout_files:
                filterout_files.add(file_line[0])
                print("ign_files: pattern={} file={}".format(ign_file, file_line[0]))
            is_ign_file = True
            continue
    if is_ign_file:
        return True
    return False

# @return f_cnt, tag_cnt, {file:{line:function, }, }
def parse_trace_functions():
    if not os.path.isfile('/tmp/vim.taglist'):
        raise("No taglist /tmp/vim.taglist")

    filterout_files = set()
    dict_result = {}
    item_cnt = 0
    file_cnt = 0
    with open('/tmp/vim.taglist') as fp:
        config = ConfigParser.RawConfigParser(allow_no_value=True)
        config.readfp(fp)
        for sec in config.sections():
            for (_file_line, func_name) in config.items(sec):
                file_line = _file_line.split("+")
                if len(file_line) < 2:
                    print("len not enough: str={} len={}".format(str(file_line), len(file_line)))
                    continue

                if arg_action == 'add' and filterout_trace_functions(file_line, func_name, filterout_files):
                    continue

                if file_line[0] not in dict_result:
                    dict_result[file_line[0]] = {}
                    file_cnt += 1
                line_func = dict_result[file_line[0]]
                line_func[file_line[1]] = func_name
                item_cnt += 1
    return file_cnt, item_cnt, dict_result

def get_nvim_instance(client_addr):
    try:
        # Embed neovim into your python application instead of binding to a running neovim instance.
        #nvim = neovim.attach('child', argv=["/bin/env", "nvim", "--embed"])

        # Create a python API session attached to unix domain socket created above:
        path = '/tmp/nvim.' + client_addr
        nvim = neovim.attach('socket', path='/tmp/nvim.' + client_addr)
        return path, nvim
    except Exception, e:
        pass
    return path, None

# f_cnt, tag_cnt, {file:{line:function, }, }
def add_trace_nvim(file_cnt, item_cnt, dict_result):
    global arg_action
    global arg_client_addr
    global arg_new_tag

    path, nvim = get_nvim_instance(arg_client_addr)
    if nvim is None:
        os.system('rm -fr ' + path)
        path, nvim = get_nvim_instance(arg_client_addr)
    if nvim is None:
        raise NeovimNone

    # setup progress-bar
    toolbar_width = 40
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
                    nvim.command("s/{/{" + arg_new_tag + "/e")
                else:
                    nvim.command("&")
                    #nvim.command("s/{/{" + arg_new_tag + "/")

                # update the bar
                i += 1
                #print("{}.{}\t{}".format(i, ibar, toolbar_width * i / sum))
                if toolbar_width * i / item_cnt > ibar:
                    sys.stdout.write("-")
                    sys.stdout.flush()
                    ibar = toolbar_width * i / item_cnt
        elif arg_action == 'clear':
            nvim.command("%s/{" + arg_new_tag + "/{/ge")

            # update the bar
            i += 1
            #print("{}.{}\t{}".format(i, ibar, toolbar_width * i / sum))
            if toolbar_width * i / file_cnt > ibar:
                sys.stdout.write("-")
                sys.stdout.flush()
                ibar = toolbar_width * i / file_cnt

        nvim.command("w")
    sys.stdout.write("\n")

def patch_trace_implement(reverse):
    global arg_target_conf

    dir_path = os.path.dirname(os.path.realpath(__file__))
    f_patch = dir_path + '/' + arg_target_conf + '/patch.diff'
    if reverse:
        os.system('patch -R -p0 < ' + f_patch)
    else:
        cmdstr = 'if ! patch -R -p0 --dry-run < ' + f_patch + '; then ' \
            'patch -p0 < ' + f_patch + '; fi'
        print cmdstr
        os.system(cmdstr)

def main():
    global arg_client_addr
    global arg_action

    try:
        parse_args()
        patch_trace_implement(arg_action == 'clear')

        question = "Are you sure the tag is lasted by 'tagme'?"
        choice = query_yes_no(question, default="yes")
        if not choice:
            return

        start_time = time.time()
        parse_taglist()
        if not os.path.isfile('/tmp/vim.taglist'):
            raise("No taglist /tmp/vim.taglist")

        load_ignores()

        # {file:{line:function, }, }
        file_cnt, item_cnt, dict_result = parse_trace_functions()
        print("Add trace functions number {} ...".format(item_cnt))
        add_trace_nvim(file_cnt, item_cnt, dict_result)

        end_time = time.time()
        print("seconds: {}".format(end_time - start_time))

    except NormalReturn:
        print "Done!"
    except NeovimNone:
        print("Should existed neovim instance by" \
              "\n    NVIM_PYTHON_LOG_FILE=/tmp/nvim.log NVIM_PYTHON_LOG_LEVEL=DEBUG nvim"\
              "\n    NVIM_LISTEN_ADDRESS=/tmp/nvim.{} nvim".format(arg_client_addr))

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
        print(exc_type, fname, exc_tb.tb_lineno)
        print "  : " + str(e)


if  __name__ =='__main__':
    main()
