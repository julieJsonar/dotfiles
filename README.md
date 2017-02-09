## dotfiles

linux config files: zsh, tmux, vim, script, ...

## Install

### If first time
You can git download dotfiles to any where
```Shell
$ cd ~
$ apt-get install git
$ git clone https://github.com/huawenyu/dotfiles.git
$ cd dotfiles/script
$ ./update_dot.sh -a pull
```

### Apply dotfiles
- All your old dotfiles will backup to `$HOME/dotfiles_bak` if it's not softlink
- The script will create softlink of all dotfile into your `$HOME`, includes: `config for vim, tmux, zshrc, xterm, git, ag, ...`
  * script, include the update_dot.sh, update_all.sh, init_ubuntu.sh, ...
  * the config files

```Shell
$ cd ~/dotfiles/script
$ ./update_dot.sh -a pull
```

#### [optional] ubuntu setup develop env
If want setup develop env for ubuntu type OS: ubuntu, linux mint, ...
- install gcc build env, cscope, ctags, ...
- install tools: git, svn, vim-gnome, tftp, samba, ...
- config tftp-service, samba service

```Shell
$ cd ~/dotfiles/script
$ ./init_ubuntu.sh
```

## Usage

There have two script under dotfiles/script:
- update_dot.sh: use to sync the dotfile under dotfiles
- update_all.sh: use to sync all git dirs which list at `array git_repos`

For your convenience, please add the `<your-download-dir>/dotfiles/script` to `$PATH` by
`export PATH=$HOME/dotfiles/script:$PATH` to our `.bashrc` or `.zshrc`

For example, use update_dot.sh:
```Shell
$ update_dot.sh
Usage: update_dot.sh [-hvdn] [-a <action>] [-m <message>]

Options:
  -h  help
  -v  verbose
  -d  debug
  -n  dry-run
  -*a [push|pull]
  -*m "commit message"

Samples:
  update_dot.sh -na pull
  update_dot.sh -na push -m "auto update"

$ update_dot.sh -a pull

<do some modify>

$ update_dot.sh -a push -m "do some modify"
```

Rollback  
```Shell
  git reset --hard <old-commit-id>  
  git push -f origin branch  
```
## Tools

### sample: script template

Can output like this in vim-plugin `VOom`:
```Code
= |###./sample.sh:0: main
  . |###./sample.sh:168: Main
  . . |###./sample.sh:163: Demo
  . . . |###./sample.sh:125: LogicAndOr
  . . . |###./sample.sh:125: LogicAndOr
  . . |###./sample.sh:163: Demo
  . |###./sample.sh:168: Main
  |###./sample.sh:0: main
```

### bashdb: shell script debugger

To use this script you simply prepend the call to the script you want to test with `bashdb`.
```Shell
$ ./bashdb header.sh . .
 $1 - The name of the original script we are debugging
 $2 - The directory where temporary files are stored
 $3 - The directory where bashdb.pre and bashdb.fns are stored
```
bashdb will read off the first parameter as the script you want to debug and forward any other parameters to that script when it calls it. The script will then return a prompt for you to enter commands and step through debugging.

You can enter h or ? at the prompt for a full listing of available commands.
