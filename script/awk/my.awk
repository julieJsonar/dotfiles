# $AWKPATH: please set this in your environment

#****************color print***************
#Foreground                      Background
#   30 - black    34 - blue      40 - black    44 - blue
#   31 - red      35 - magenta   41 - red      45 - magenta
#   32 - green    36 - cyan      42 - green    46 - cyan
#   33 - yellow   37 - white     43 - yellow   47 - white
# on = "\033[47;1;37m";    off = "\033[0m\n"
#
#   0 - all attributes off
#   1 - bold (bright) on
#   2 - faint on (bold off)
#   5 - blink on
#   7 - reverse video
#   8 - concealed on

function red(s)   { printf("%s%s%s", "\033[1;31m", s, "\033[0m ") }
function green(s) { printf("%s%s%s", "\033[1;32m", s, "\033[0m ") }
function yellow(s){ printf("%s%s%s", "\033[1;33m", s, "\033[0m ") }
function blue(s)  { printf("%s%s%s", "\033[1;34m", s, "\033[0m ") }
function magenta(s){printf("%s%s%s", "\033[1;35m", s, "\033[0m ") }
function cyan(s)  { printf("%s%s%s", "\033[1;36m", s, "\033[0m ") }

#****************shell cmd capture output***************
function exec_cmd(c) {
    while( (c|getline foo) > 0 )
        printf( "%s\n", foo );
    close( c );
}

#****************RS FS sample***************
# substring1||||substring2   
# FS awk -F"[|]{4}" "{ printf $1, $2 }" infile
# older-SHA: awk -c -F"[|]+"
# older-SHA: awk -c -F"[|][|][|][|]"

