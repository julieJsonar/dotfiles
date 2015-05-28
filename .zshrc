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
export USESUDO=sudo

# export HISTCONTROL=erasedups
export HISTCONTROL=ignoredups
export HISTIGNORE="hisotry:cd ..:cd ~:cd work:cd fos:cd fos_git:cd work_me:cd ~/work:cd ~/work_me:pwd:ls:ls -l:ls –ltr:"

alias dict='~/tools/dict'
alias makeimage='rm -f image-10vd.out; make image -s; cp image-10vd.out /var/lib/tftpboot/image.out && ls -l /var/lib/tftpboot && ~/script/image.exp'
alias mywad='make -C daemon/wad >/dev/null && make -C sysinit && cp sysinit/init /var/lib/tftpboot/ && ls -l /var/lib/tftpboot && strip -s /var/lib/tftpboot/init'
alias mywadfull='make -C daemon/wad >/dev/null && make -C sysinit && cp sysinit/init /var/lib/tftpboot/ && ls -l /var/lib/tftpboot && chmod 777 /var/lib/tftpboot/init'
alias mycrash='~/script/addrmapsearch.rb -f crash -m init.map > crashlog && vi crashlog'
alias vi='nvim'
alias vim='nvim'
alias eclipse='nohup ~/tools/eclipse/eclipse -showlocation > /dev/null 2>&1 &'
# https://github.com/GNOME/meld
alias meld='nohup ~/tools/meld/bin/meld > /dev/null 2>&1 &'
alias xnview='nohup ~/tools/XnView/XnView > /dev/null 2>&1 &'
alias tmuxkill='tmux ls | grep -v attached | cut -d: -f1 | xargs -I{} tmux kill-session -t {}'

# export MYTYPESCRIPT=~/script/`date +%Y%m%d`
# exec /usr/bin/script -q -a -f -t 2>${MYTYPESCRIPT}.time ${MYTYPESCRIPT}.lst

unsetopt correct_all
unsetopt nomatch
unset GREP_OPTIONS

# Customize to your needs...
export PATH=/usr/lib64/qt-3.3/bin:/usr/lib64/ccache:/usr/local/bin:/usr/bin:/bin:/home/wilson/bin:/usr/local/sbin:/usr/sbin
export PATH="/home/wilson/perl5/bin:/home/wilson/script:/home/wilson/script/git-scripts:$PATH";
export PERL_LOCAL_LIB_ROOT="$PERL_LOCAL_LIB_ROOT:/home/wilson/perl5";
export PERL_MB_OPT="--install_base /home/wilson/perl5";
export PERL_MM_OPT="INSTALL_BASE=/home/wilson/perl5";
export PERL5LIB="/home/wilson/perl5/lib/perl5:$PERL5LIB";
export PYTHONPATH="/home/wilson/work/autotest-robot/library"
export AWKPATH="/home/wilson/script/awk:/home/wilson/script/awk/awk-libs";
export TERM=xterm-256color
export EDITOR='nvim'
export JAVA_HOME="/usr/java/latest"

