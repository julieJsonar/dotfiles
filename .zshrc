# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
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
alias vi='gvim -v'
alias vim='gvim -v'
alias gitme='git --no-pager'
alias eclipse='nohup ~/tools/eclipse/eclipse > /dev/null 2>&1 &'
alias xnview='nohup ~/tools/XnView/XnView > /dev/null 2>&1 &'
alias tmuxkill='tmux ls | grep -v attached | cut -d: -f1 | xargs -I{} tmux kill-session -t {}'
alias traceadd='vi . -c "call Traceadd()" ; cswad ; vi . -c "call Traceadjust()"'
alias tracedel='vi . -c "call Tracedel()"'

# export MYTYPESCRIPT=~/script/`date +%Y%m%d`
# exec /usr/bin/script -q -a -f -t 2>${MYTYPESCRIPT}.time ${MYTYPESCRIPT}.lst

unsetopt correct_all
unsetopt nomatch

# Customize to your needs...
export PATH=/usr/lib64/qt-3.3/bin:/usr/lib64/ccache:/usr/local/bin:/usr/bin:/bin:/home/wilson/bin:/usr/local/sbin:/usr/sbin
export PATH="/home/wilson/perl5/bin:/home/wilson/script:/home/wilson/script/git-scripts:$PATH";

export PERL_LOCAL_LIB_ROOT="$PERL_LOCAL_LIB_ROOT:/home/wilson/perl5";
export PERL_MB_OPT="--install_base /home/wilson/perl5";
export PERL_MM_OPT="INSTALL_BASE=/home/wilson/perl5";
export PERL5LIB="/home/wilson/perl5/lib/perl5:$PERL5LIB";
export PYTHONPATH="/home/wilson/work/autotest-robot/library"
export AWKPATH="/home/wilson/script/awk:/home/wilson/script/awk/awk-libs";
