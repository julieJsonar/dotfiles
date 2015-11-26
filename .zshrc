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

export HISTCONTROL=erasedups
#export HISTCONTROL=ignoredups
export HISTIGNORE="?:??:???:&:ls:[bf]g:exit:pwd:clear:mount:umount:[ \t]*:hisotry:cd ..:cd ~:cd /data:cd work:cd fos:cd fos_git:cd work_me:cd ~/work:cd ~/work_me:ls -l:ls –ltr:"

mydata='/data'
myhome='/home/wilson'

alias dict='$mydata/tools/dict'
alias makeimage='rm -f image-10vd.out; make image -s; cp image-10vd.out /var/lib/tftpboot/image.out && ls -l /var/lib/tftpboot && $mydata/script/image.exp'
alias mywad='make -C daemon/wad >/dev/null && make -C sysinit && cp sysinit/init /var/lib/tftpboot/ && ls -l /var/lib/tftpboot && strip -s /var/lib/tftpboot/init'
alias mywadfull='make -C daemon/wad >/dev/null && make -C sysinit && cp sysinit/init /var/lib/tftpboot/ && ls -l /var/lib/tftpboot && chmod 777 /var/lib/tftpboot/init'
alias mycrash='$mydata/script/addrmapsearch.rb -f crash -m init.map > crashlog && vi crashlog'
alias eclipse='nohup $mydata/tools/eclipse/eclipse > /dev/null 2>&1 &'
alias meld='nohup $mydata/tools/meld/bin/meld > /dev/null 2>&1 &'
alias xnview='nohup $mydata/tools/XnView/XnView > /dev/null 2>&1 &'
alias tmuxkill='tmux ls | grep -v attached | cut -d: -f1 | xargs -I{} tmux kill-session -t {}'

# export MYTYPESCRIPT=~/script/`date +%Y%m%d`
# exec /usr/bin/script -q -a -f -t 2>${MYTYPESCRIPT}.time ${MYTYPESCRIPT}.lst

unsetopt correct_all
unsetopt nomatch

#
# GREP
#
GREP_OPTIONS="--exclude-dir=.svn --exclude-dir=.git --exclude=TAGS --exclude=tags --exclude=cscope.\* "
function _mygrep()
{
  if [ -t 0 ]; then
    /bin/grep "$@" $GREP_OPTIONS
  else
    /bin/grep $@
  fi
};
alias grep='_mygrep'
unset GREP_OPTIONS



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
export PATH=/usr/lib64/qt-3.3/bin:/usr/lib64/ccache:/usr/local/bin:/usr/bin:/bin:$myhome/bin:/usr/local/sbin:/usr/sbin
export PATH="$myhome/perl5/bin:$myhome/script:$myhome/script/git-scripts:$PATH";
export PERL_LOCAL_LIB_ROOT="$PERL_LOCAL_LIB_ROOT:$myhome/perl5";
export PERL_MB_OPT="--install_base $myhome/perl5";
export PERL_MM_OPT="INSTALL_BASE=$myhome/perl5";
export PERL5LIB="$myhome/perl5/lib/perl5:$PERL5LIB";
export PYTHONPATH="$myhome/work/autotest-robot/library"
export AWKPATH="$myhome/script/awk:$myhome/script/awk/awk-libs";
export TERM=screen-256color
export EDITOR='vi'
# export JAVA_HOME="/usr/java/latest"
export JAVA_HOME="/usr/lib/jvm/java-8-oracle"

