# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT=true

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# git clone https://github.com/zdharma/history-search-multi-word ~/.oh-my-zsh/custom/plugins/history-search-multi-word
# git clone https://github.com/tymm/zsh-directory-history ~/.oh-my-zsh/custom/plugins/zsh-directory-history
# git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
# git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
#plugins=(lighthouse history-search-multi-word zsh-directory-history history-substring-search zsh-completions zsh-autosuggestions)
plugins=(history-substring-search zsh-completions)

source $ZSH/oh-my-zsh.sh

# speed git dir prompt
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_CLEAN}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

# Customize to your needs...
# wilson
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
# By default 0.4 second delay after hit the <ESC>
export KEYTIMEOUT=0


SAVEHIST=10000 # Number of entries
HISTSIZE=10000
HISTFILE=~/.zsh_history     # File
HISTCONTROL=erasedups
# HISTCONTROL=ignoredups
HISTIGNORE="?:??:???:&:ls:[bf]g:exit:pwd:df*:free*:cd*:ls*:man*:vi*:clear:[ \t]*:hisotry*"
setopt APPEND_HISTORY       # Don't erase history
setopt EXTENDED_HISTORY     # Add additional data to history like timestamp
setopt INC_APPEND_HISTORY   # Add immediately
unsetopt HIST_FIND_NO_DUPS    # Don't show duplicates in search
setopt HIST_IGNORE_SPACE    # Don't into history if have space pre-command.
setopt histignorespace
setopt NO_HIST_BEEP         # Don't beep
setopt SHARE_HISTORY        # Share history between session/terminals

# Our local dir: data, tools, home
#if [ ! -f "/tmp/zsh_init_flag" ]; then
#  # remap caps to ESC
#  xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
#  echo "have init" > "/tmp/zsh_init_flag"
#fi

#alias emacs='emacs -nw'
alias cd=' cd'
alias pwd=' pwd'
alias man=' man'
alias dict="$HOME/tools/dict"
alias eclipse="env SWT_GTK3=0 $HOME/tools/eclipse/eclipse &> /dev/null &"
#alias meld="nohup $HOME/tools/meld/bin/meld"
alias xnview="nohup $HOME/tools/XnView/XnView &> /dev/null &"
alias tmuxkill="tmux ls | grep -v attached | cut -d: -f1 | xargs -I{} tmux kill-session -t {}"

# Use these lines to enable search by globs, e.g. gcc*foo.c
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward

# This will make C-z on the command line resume vi again, so you can toggle between them easily
foreground-vi() {
  fg %vi
}
zle -N foreground-vi
bindkey '^Z' foreground-vi

# Try zman fc or zman HIST_IGNORE_SPACE! (Use n if the first match is not what you were looking for.)
zman() {
  PAGER="less -g -s '+/^       "$1"'" man zshall
}

# cd -<TAB>                 use dirs to display the dirstack,
# zmv '(*).lis' '$1.txt'    dry-run mode -n

unsetopt correct_all
unsetopt nomatch

function _mytail()
{
  if [ -t 0 ]; then
    tail "$@" 2> >(grep -v truncated >&2)
  else
    tail "$@" 2> >(grep -v truncated >&2)
  fi
};
alias tail='_mytail'

function _myftpls()
{
    lftp -u test,test 172.18.2.169 -e "cd upload/hyu; ls; quit;"
};
alias ftpls='_myftpls'

function _myftpget()
{
  if [ -z ${1} ]; then
    echo "parameter dir must be set"
    return 1
  fi

  for var in "$@"
  do
    lftp -u test,test 172.18.2.169 -e "cd upload/hyu; get $var; quit;"
  done
};
alias ftpget='_myftpget'

function _myftprm()
{
  if [ -z ${1} ]; then
    echo "parameter dir must be set"
    return 1
  fi

  for var in "$@"
  do
    lftp -u test,test 172.18.2.169 -e "cd upload/hyu; rm -fr $var; quit;"
  done
  lftp -u test,test 172.18.2.169 -e "cd upload/hyu; ls; quit;"
};
alias ftprm='_myftprm'

function _myftp()
{
  if [ -z ${1} ]; then
    echo "parameter dir must be set"
    return 1
  fi

  if [ -f image.out ]; then
    file=image.out
    lftp -u test,test 172.18.2.169 -e "cd upload/hyu; ls; mkdir $1; cd $1; put $file; put patch.diff; put patch.eco.diff; put fgtcoveragebuild.tar.xz; put fgtcoveragebuild.tar.bz2; put checklist.txt; put fortios.qcow2; put fortiproxy.qcow2; put image.out.vmware.zip; put image.out.ovf.zip; put image.out.hyperv.zip; put image.out.gcp.tar.gz;put image.out.kvm.zip; put image.out.gcp.tar.gz;lpwd; pwd; ls; quit;"
  else
    if [ -z "$1" ]; then
      echo "File not found!"
      return 1
    else
      file=$1
      lftp -u test,test 172.18.2.169 -e "cd upload/hyu; mkdir $1; cd $1; put $file; ls; quit;"
    fi
  fi
};
alias ftpme='_myftp'

# Customize to your needs...
export TERM=screen-256color
export EDITOR='vi'

export PATH=/usr/lib64/qt-3.3/bin:/usr/lib64/ccache:/usr/local/bin:/usr/bin:/bin:$HOME/bin:/usr/local/sbin:/usr/sbin
export PATH="$HOME/perl5/bin:$HOME/script:$HOME/script/git-scripts:$PATH";

export PERL_LOCAL_LIB_ROOT="$PERL_LOCAL_LIB_ROOT:$HOME/perl5";
export PERL_MB_OPT="--install_base $HOME/perl5";
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5";
export PERL5LIB="$HOME/perl5/lib/perl5:$PERL5LIB";
export AWKPATH="$HOME/script/awk:$HOME/script/awk/awk-libs";

export PYTHONPATH="$HOME/dotwiki/lib/python"
export PYENV_ROOT="${HOME}/.pyenv"

if [ -d "${PYENV_ROOT}" ]; then
  export PATH="${PYENV_ROOT}/bin:${PATH}"
  eval "$(pyenv init -)"
fi


# export JAVA_HOME="/usr/java/latest"
export JAVA_HOME="/usr/lib/jvm/java-8-oracle"

export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export PATH="/opt/ActiveTcl-8.6/bin:$PATH"
export PATH="/home/hyu/Komodo-Edit-11/bin:$PATH"

export USESUDO=$(which sudo)
export FORTIPKG=$HOME/fortipkg
#export JEMALLOC_PATH=$HOME/project/jemalloc
#export MALLOC_CONF="prof:true,prof_prefix:jeprof.out"

# minicom line wrap: sudo -E minicom
export MINICOM="-w"

# Disable warning messsage:
#   WARNING: gnome-keyring:: couldn't connect to: /run/user/1000/keyring-s99rSr/pkcs11: Connection refused
unset GNOME_KEYRING_CONTROL
