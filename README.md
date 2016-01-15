# dotfiles

linux programmer's config files: zsh, tmux, vim, ...

# Setup

If ubuntu type OS: ubuntu, linux mint, ...
```Shell
  ./init_ubuntu.sh  
```
Commit & Update  
```Shell
  ./update.sh  
```
Rollback  
```Shell
  git reset --hard <old-commit-id>  
  git push -f origin branch  
```
# Tools
## vim server
```Shell
<terminal-1> $ vim --servername foo                           <<< start vim-server named 'foo'
<terminal-2> $ vim --servername foo --remote-silent bar.hs    <<< open current dir's file 'bar.hs' but display on the vim-server
<terminal-3> $ vim --servername foo --remote-tab file2.txt file3.txt   <<< open these files into new tabs on the vim-server
<terminal-4> $ vim --servername foo --remote-send '<Esc>:mksession ~/sessionFile.vim<CR>:wqa<CR>'    <<< save session and used by another vim-server
<terminal-5> $ vim --servername bar -S ~/sessionFile.vim
```
## gdb-dashboard
https://github.com/cyrus-and/gdb-dashboard

using gdb's python interface, if use ubuntu 14.04, the gdb using python3 interface, so if some python module need, please `sudo pip3 install <module>`

  - start GDB in one terminal: enter python mode by `(gdb) source ~/.gdb-dashboard`, or if want do it automatic, please `ln -s ~/.gdb-dashboard ~/.gdbinit`
    * config show model: `dashboard -layout !registers source !assembly !stack !threads`
    * debug as usual, the only different is python prompt `>>> `, not `(gdb) `, but we can change by `dashboard -style prompt '(gdb)'`
  - Use vim as source viewer:
    * In another terminal (e.g. tmux pane), start vim (+clientserver): `vim --servername "GDB.SOURCE"`
  - Output to another terminal by tty:
    * In another terminal (e.g. tmux pane) and get its TTY with the tty command (e.g. /dev/ttys001, the name may be different for a variety of reasons);
    * Issue the command gdb-python mode '>>> dashboard -output /dev/ttys001` to redirect the dashboard output to the newly created terminal;
  - Or output to another terminal by tail:
    * In another terminal (e.g. tmux pane): `tail -f /tmp/gdb.output`, if you hate the tail's `file truncated` message:

```Shell
function _mytail()
{
  if [ -t 0 ]; then
    tail "$@" 2> >(grep -v truncated >&2)
  else
    tail "$@" 2> >(grep -v truncated >&2)
  fi
};
alias tail='_mytail'
```

## eclipse dark theme

eclipse-moonrise-theme  
from https://github.com/guari/eclipse-ui-theme  

Modify the active view should click two times: 1st focus, 2nd click item.  
If plugin invalid, we can install by update:  
  https://raw.github.com/guari/eclipse-ui-theme/master/com.github.eclipseuitheme.themes.updatesite  
Then replaced by our modified version.

Please choose the moonrise, not moonrise(standalone)
```Shell
$ cd eclipse-moonrise-theme
$ jar cf com.github.eclipseuitheme.themes.moonrise-ui_0.8.9.201404052318.jar *
$ mv com.github.eclipseuitheme.themes.moonrise-ui_0.8.9.201404052318.jar  <your-install-dir>/eclipse/plugins/.
```
