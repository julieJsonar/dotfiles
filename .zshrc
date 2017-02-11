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
plugins=(history-substring-search)

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
export USESUDO=sudo


SAVEHIST=10000 # Number of entries
HISTSIZE=10000
HISTFILE=~/.zsh_history     # File
HISTCONTROL=erasedups
# HISTCONTROL=ignoredups
HISTIGNORE="?:??:???:&:ls:[bf]g:exit:pwd:df*:free*:cd*:ls*:man*:vi*:clear:[ \t]*:hisotry*"
setopt APPEND_HISTORY       # Don't erase history
setopt EXTENDED_HISTORY     # Add additional data to history like timestamp
setopt INC_APPEND_HISTORY   # Add immediately
setopt HIST_FIND_NO_DUPS    # Don't show duplicates in search
setopt HIST_IGNORE_SPACE    # Don't preserve spaces. You may want to turn it off
setopt NO_HIST_BEEP         # Don't beep
setopt SHARE_HISTORY        # Share history between session/terminals

# Our local dir: data, tools, home
#if [ ! -f "/tmp/zsh_init_flag" ]; then
#  # remap caps to ESC
#  xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
#  echo "have init" > "/tmp/zsh_init_flag"
#fi

#alias emacs='emacs -nw'
alias dict="$HOME/tools/dict"
alias eclipse="env SWT_GTK3=0 $HOME/tools/eclipse/eclipse &> /dev/null &"
alias meld="nohup $HOME/tools/meld/bin/meld"
alias xnview="nohup $HOME/tools/XnView/XnView &> /dev/null &"
alias tmuxkill="tmux ls | grep -v attached | cut -d: -f1 | xargs -I{} tmux kill-session -t {}"

# export MYTYPESCRIPT=~/script/`date +%Y%m%d`
# exec /usr/bin/script -q -a -f -t 2>${MYTYPESCRIPT}.time ${MYTYPESCRIPT}.lst

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

function _myftp()
{
  if [ -z ${dir+x} ]; then
    echo "dir is not set"
    return 1
  fi

  if [ -f image.out ]; then
    file=image.out
    genco patch.xml -m "fix huawenyu"
    lftp -u test,test 172.18.2.169 -e "cd upload/hyu; mkdir $dir; cd $dir; put $file; put patch.xml; put fgtcoveragebuild.tar.xz; ls; quit;"
  else
    if [ -z "$1" ]; then
      echo "File not found!"
      return 1
    else
      file=$1
      lftp -u test,test 172.18.2.169 -e "cd upload/hyu; mkdir $dir; cd $dir; put $file; ls; quit;"
    fi
  fi
};
alias ftpme='_myftp'

# Customize to your needs...
export PATH=/usr/lib64/qt-3.3/bin:/usr/lib64/ccache:/usr/local/bin:/usr/bin:/bin:$HOME/bin:/usr/local/sbin:/usr/sbin
export PATH="$HOME/perl5/bin:$HOME/script:$HOME/script/git-scripts:$PATH";
export PERL_LOCAL_LIB_ROOT="$PERL_LOCAL_LIB_ROOT:$HOME/perl5";
export PERL_MB_OPT="--install_base $HOME/perl5";
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5";
export PERL5LIB="$HOME/perl5/lib/perl5:$PERL5LIB";
export PYTHONPATH="$HOME/work/autotest-robot/library"
export AWKPATH="$HOME/script/awk:$HOME/script/awk/awk-libs";
export TERM=screen-256color
export EDITOR='vi'
# export JAVA_HOME="/usr/java/latest"
export JAVA_HOME="/usr/lib/jvm/java-8-oracle"

#export JEMALLOC_PATH=$HOME/project/jemalloc
#export MALLOC_CONF="prof:true,prof_prefix:jeprof.out"

