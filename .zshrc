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
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

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
if [ ! -f "/tmp/zsh_init_flag" ]; then
  # remap caps to ESC
  xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
  echo "have init" > "/tmp/zsh_init_flag"
fi

alias dict="$HOME/tools/dict"
alias eclipse="env SWT_GTK3=0 $HOME/tools/eclipse/eclipse > /dev/null 2>&1 &"
alias meld="nohup $HOME/tools/meld/bin/meld"
alias xnview="nohup $HOME/tools/XnView/XnView > /dev/null 2>&1 &"
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

# This will run everytime you run a command.
#precmd () {
#  tmux set -qg status-left "#S #P $(pwd)"
#}

# tmux-all-panes
# Runs the specified command (provided by the first argument) in all tmux panes
# in every window.  If an application is currently running in a given pane
# (e.g., vim), it is suspended and then resumed so the command can be run.
all-panes()
{
  all-panes-bg_ "$1" &
}

# The actual implementation of `all-panes` that runs in a background process.
# This prevents the function from being suspended when we press ^z in each pane.
all-panes-bg_()
{
  # Assign the argument to something readable
  local COMMAND=$1

  # Remember which window/pane we were originally at
  local ORIG_WINDOW_INDEX=`tmux display-message -p '#I'`
  local ORIG_PANE_INDEX=`tmux display-message -p '#P'`

  # Loop through the windows
  for WINDOW in `tmux list-windows -F '#I'`; do
    # Select the window
    tmux select-window -t $WINDOW

    # Remember the window's current pane sync setting
    local ORIG_PANE_SYNC=`tmux show-window-options | grep '^synchronize-panes' | awk '{ print $2 }'`

    # Send keystrokes to all panes within the current window simultaneously
    tmux set-window-option synchronize-panes on

    # Send the escape key in case we are in a vim-like program.  This is
    # repeated because the send-key command is not waiting for vim to complete
    # its action...  And sending a `sleep 1` command seems to screw up the loop.
    for i in {1..25}; do tmux send-keys 'C-['; done

    # Temporarily suspend any GUI that's running
    tmux send-keys C-z

    # If no GUI was running, kill any input the user may have typed on the
    # command line to avoid A) concatenating our command with theirs, and
    # B) accidentally running a command the user didn't want to run
    # (e.g., rm -rf ~).
    tmux send-keys C-c

    # Run the command and switch back to the GUI if there was any
    tmux send-keys "$COMMAND; fg 2>/dev/null; echo -n" C-m

    # Restore the window's original pane sync setting
    if [[ -n "$ORIG_PANE_SYNC" ]]; then
      tmux set-window-option synchronize-panes "$ORIG_PANE_SYNC"
    else
      tmux set-window-option -u synchronize-panes
    fi
  done

  # Select the original window and pane
  tmux select-window -t $ORIG_WINDOW_INDEX
  tmux select-pane -t $ORIG_PANE_INDEX
}


# Customize to your needs...
export PATH=/usr/lib64/qt-3.3/bin:/usr/lib64/ccache:/usr/local/bin:/usr/bin:/bin:$HOME/bin:/usr/local/sbin:/usr/sbin
export PATH="$HOME/perl5/bin:$HOME/script:$HOME/script/git-scripts:$PATH";
export PERL_LOCAL_LIB_ROOT="$PERL_LOCAL_LIB_ROOT:$HOME/perl5";
export PERL_MB_OPT="--install_base $HOME/perl5";
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5";
export PERL5LIB="$HOME/perl5/lib/perl5:$PERL5LIB";
export PYTHONPATH="$HOME/work/autotest-robot/library"
export AWKPATH="$HOME/script/awk:$HOME/script/awk/awk-libs";
export TERM=xterm-256color
export EDITOR='vi'
# export JAVA_HOME="/usr/java/latest"
export JAVA_HOME="/usr/lib/jvm/java-8-oracle"

export JEMALLOC_PATH=$HOME/project/jemalloc
export MALLOC_CONF="prof:true,prof_prefix:jeprof.out"
