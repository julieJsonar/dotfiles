"======================================================================
" Installation:
" =============
" 1. [Vim plugin manager](https://github.com/gmarik/vundle)
"    $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
"    ... copy vimrc from vundle's page ...
"    ... open vim to sure everything OK! ...
" 2. update the basic vimrc to this one
"    ... then, open vim, command :BundleInstall ...
"    ... Done! ...
"
" Usage:
" ======
" <leader>         ";"
"
"  gd <or> D       goto declare <or> global declare
"  [I              list all occurence
"  g; <or> g,      navigate changelist
" <space>          open preview window, then <c-w>H adjust layout
" <leader><space>  open file in preview window, then <c-w>H adjust layout
" <leader>l        show current function name
" <leader>a        switch .c/.h
" <leader>g        grep, replace :ptag # if use <leader>s will conflict witch <leader>swp: AnsiEsc:call SaveWinPosn()
" <leader>s        grep struct malloc, conflict witch <leader>swp: AnsiEsc:call SaveWinPosn()
" <leader>n        toggle taglist
" <leader>z        syntax log file
" <leader>g ,.     preview definition with ctags: pta, ptn, ptp
" <leader>e        dictionary
"  :<C-r><C-w>     get current word under cursor
"
" call Asm()       disassembly current function
"
" <C-n|p>; <leader>,|;>         jumps quickfix
" <F3>             redirect g command output tabn
"
" :g/regex/t$      copy match lines append to tail
" s<char><char>    sneak quick motion: <num>s - next count, `` <OR> <Ctrl-O> - backword original, s<enter> repeat search
"
" Howtos:
" =======
"   Register:
"       :@+                # have @ as prefix, then add register's name
"   RunShellCmd:
"       R !ls -l           # grab shell cmd output into new tab/buffer
"       <leader>rr         # R run current line or selected,
"       <leader>c          # close current tab
"       :new|0read !ls -l  # grab cmd output into new window
"   Notes:
"       <leader>w          # notes on source
"       :cfile log.marks   # view as quickfix
"   Quckfix:
"       :cw                # open
"       <C-n>              # next
"       <C-p>              # previous
"       :colder N          # last result list
"       :cnewer N          # next result list
"   AutoComplete:
"       <C-n>              # popup selector or navigate next
"       <C-p>              # popup selector or navigate previous
"       hit any            # select current and enter your hit also
"   Vimgrep:               # Also lvimgrep, short as: vim, lvim
"        vimregex          # rules:
"                           . any-char \s whitespace \d digit \x hex \o octal
"                           \h head-char-of-word \p printable-char
"                           \w word \a alpha \l lowercase \u uppercase
"                          # reverse rules:
"                           \S non-whitespace \D non-digit \X non-hex \O non-octal
"                           \H non-head-char-of-word \P like \p, but-excluding-digits
"                           \W non-word \A non-alpha \L non-lowercase \U non-uppercase
"                          # times:
"                           * 0-more \+  1-more \=  0or1-more \{n,m} \{n} \{,m} \{n,}
"       samples
"       :vim /some/gj **/*.c **/*.h
"       :vim /^POST \/\(idle\|send\)\/CzHmd/gj %
"
"       /^joe.*fred.*bill/ # AND
"       /fred\|joe/        # OR
"       /.*fred\&.*joe/    # AND no-order
"       /\<fred\>/         # whole word
"       /begin\_.*end/     # search over possible multiple lines
"       /fred\_s*joe/      # any whitespace including newline [C]
"       /^\n\{3}/          # find 3 empty lines
"
"   Grep:                  # grepprg=grep, using outer grep tool
"       regex              # rules:
"                           ^ begin-with $ end-with
"                           . any-one-char * any-char .* any-char-list
"                           \<~ \>~ words-end
"                           \w~ words \W~ no-words
"                           []~char-set [^]~no-match-char-set
"                           \(xxx\)~match-group
"                           x/{m/}~ x/{m,n/}~
"       samples
"       :grep -inr 'string' --include='*.[ch]' dirs
"       :grep -w 'word1\|word2' files
"       :grep '[a-z]\{5\}' files
"       :grep '^POST /\(idle\|send\)/CzHmd' log
"
"   EasyGrep:
"       <leader>vv         # Search whole current word
"       <leader>va         # Append search whole current word
"       <leader>vr         # Replace whole current word
"       <leader>vo         # Set grep option
"   Mark:
"       <leader>mm         # MarkToggle
"       <leader>mr         # MarkRegex
"       <leader>mx         # MarkClearAll
"   Cscope:
"        :!cscope -[R]kbq;
"        :cs reset
"       <leader>;          # Jump definition
"       <leader>i          # <C-I>
"       <leader>o          # <C-O>
"       <leader>fg         # Jump definition
"       <leader>fc         # List All call current function
"       <leader>fd         # List current function called
"       <leader>ff         # find file, use . represent any char
"                            :cs f f my_conn.<Enter> will show my_conn.c my_conn_impl.h
"       <leader>fs         # List All symbol
"   SvnGitBlame:
"       <leader>bs         # svn blame
"       <leader>bg         # git blame
"   SaveSession:
"       :mks!              # Save to Session.vim
"       :mks! log.vim      # Save Session to log.vim
"       $ vi -S log.vim    # Load Session
"
" Tools:
" ======
"   DrawIt:                # use \di to start (\ds to stop)
"   W3m:
"       :W3m :W3mTab :W3mReload (local) [url or keyword], keyword include: google, wikipedia, man
"       <backspace>        # Back page
"       <enter>            # Open link under the cursor
"       f                  # Hit-A-Hint.
"       s                  # Toggle Syntax On/Off
"       c                  # Toggle Cookie On/Off.
"
" Self:
" =====
"   Function:
"       :<C-\>eYourFunc() <CR>       # use YourFunc() return to replace all current command
"   Batchfiles:
"       :Traceadd|adjust|clear()     # _WAD_TRACE_
"   CrashLog:                        # mark 'a, 'b, then :call Tracecrash()    resolve fgt's crashlog
"======================================================================

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Bundle 'darkspectrum'
Bundle 'holokai'
Bundle 'tomasr/molokai'

Bundle 'christoomey/vim-tmux-navigator'
Bundle 'derekwyatt/vim-fswitch'
Bundle 'ciaranm/detectindent'
Bundle 'file-line'
"Bundle 'netrw.vim'
"Bundle 'Raimondi/delimitMate'
Bundle 'majutsushi/tagbar'
"Bundle 'fholgado/minibufexpl.vim'

Bundle 'millermedeiros/vim-statline'
"Bundle 'maciakl/vim-neatstatus'
"Bundle 'bling/vim-airline'

Bundle 'justinmk/vim-sneak'
"Bundle 'Lokaltog/vim-easymotion'
"Bundle 'Shougo/vimproc.vim'

Bundle 'huawenyu/vim-mark'
"Bundle 'AnsiEsc.vim'
Bundle 'tpope/vim-markdown'

"Bundle 'ervandew/supertab'
Bundle 'huawenyu/vim-easygrep'
Bundle 'yuratomo/w3m.vim'
Bundle 'DrawIt'

Bundle 'huawenyu/tracelog.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" My local plugins
"source /home/wilson/.vim/plugin/log.vim

let mapleader = ";"
" diable Ex mode
map Q <Nop>
nnoremap <C-c> <silent> <C-c>

set nocompatible
set guifont=Liberation\ Mono\ 13
" Disable any use of bold fonts
set t_md=
set t_vb=
set hidden

syntax enable
"set background=dark
"colorscheme darkspectrum
"colorscheme molokai
colorscheme holokai

if has('mouse')
	set mouse=a
	set mousefocus
endif
set foldmethod=manual

set backspace=indent,eol,start
set ignorecase
set smartcase
set hlsearch
set incsearch
set history=1000
set undolevels=1000
set shortmess+=a
set scrolloff=1

set visualbell
set noerrorbells
set nobackup
set noshowmode
set nomodeline
set nowrap
set nowrapscan
set noswapfile
set nostartofline
set noshowmatch

" indent
set tabstop=4
set shiftwidth=4
set textwidth=78

" C indent
set nonumber
set autoindent
set smartindent
set cindent
set expandtab

" DetectIndent using :DetectIndent command
let g:detectindent_preferred_expandtab = 0
let g:detectindent_preferred_indent = 4
let g:detectindent_preferred_when_mixed = 4
let g:detectindent_max_lines_to_analyse = 1024
autocmd VimEnter * DetectIndent

set list
set paste
"set showcmd
set splitbelow
set splitright

"set autochdir       " if work with shell or cscope, please not change work-dir
set sessionoptions-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds
set ssop-=curdir     " do not store absolute path
set ssop+=sesdir     " work under current dir as relative path

"Status Line {
    set laststatus=2                             " always show statusbar
    set statusline=
    set statusline+=%-10.3n\                     " buffer number
    set statusline+=%f\                          " filename
    set statusline+=%h%m%r%w                     " status flags
    set statusline+=\[%{strlen(&ft)?&ft:'none'}] " file type
    set statusline+=%=                           " right align remainder
    set statusline+=0x%-8B                       " character value
    set statusline+=%-14(%l,%c%V%)               " line, character
    set statusline+=%<%P                         " file position

" vim-airline
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'

"}

" w3m
let g:w3m#command = '/usr/bin/w3m'
let g:w3m#lang = 'en_US'

" vimgrep, ctrlp exclude dir
set wildignorecase
if exists("g:ctrl_user_command")
  unlet g:ctrlp_user_command
endif
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*,*/\.svn/*
set wildignore+=*.o,*.obj,.hg,*.pyc,.git,*.rbc,*.class,.svn,coverage/*,vendor
set wildignore+=*.gif,*.png,*.map

set wildignore+=*/kernel/**
set wildignore+=*/linux-2.4.25/**
set wildignore+=*/linuxatm/**
set wildignore+=*/cooked/**
set wildignore+=*/router/**

"set path=~/nbapp/**	" allows me to search in my project directory and subdirectories
"set backupdir=~/nbapp/temp		" makes vim create backup files in a special temporary folder

"hi MatchParen cterm=bold ctermfg=cyan
"hi MatchParen cterm=none ctermbg=green ctermfg=none
"hi MatchParen cterm=none ctermbg=green ctermfg=blue
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta
hi CursorLine guibg=Grey40

" change highlight color for search hits
"hi Search guibg=peru guifg=wheat
"hi Search ctermfg=grey ctermbg=darkblue cterm=NONE
hi Search ctermfg=Red ctermbg=NONE cterm=NONE

"hi TabLineFill ctermfg=Black ctermbg=Green cterm=NONE
hi TabLine ctermfg=DarkBlue ctermbg=NONE cterm=NONE
hi TabLineSel ctermfg=Red ctermbg=NONE cterm=NONE
hi TabLineFill ctermfg=NONE ctermbg=NONE cterm=NONE
"hi NonText ctermfg=7 guifg=Gray
hi NonText ctermfg=DarkGrey guifg=DarkGrey
hi clear SpecialKey
hi link SpecialKey NonText

"set listchars=nbsp:.,tab:>-,trail:~,extends:>,precedes:<
"set listchars=tab:>.,trail:~,extends:<,nbsp:.
" The characters after tab is U+2002. in vim with Ctrl-v u 2 0 0 2 (in insert mode).
"set listchars=tab:> ,trail:~,extends:<,nbsp:.
set listchars=tab:»\ ,trail:~,extends:<,nbsp:.

filetype plugin indent on
cmap w!! w !sudo tee % >/dev/null
autocmd InsertEnter,InsertLeave * set cul!
autocmd BufNewFile,BufRead *.json set ft=javascript

set clipboard+=unnamed
set clipboard+=unnamedplus
vmap <leader>y   "+y
vnoremap <leader>p "_dP

" https://github.com/christoomey/vim-tmux-navigator
"nnoremap <c-h> <c-w>h
"nnoremap <c-j> <c-w>j
"nnoremap <c-k> <c-w>k
"nnoremap <c-l> <c-w>l
"nnoremap <silent> <leader>q :e #<cr>
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-h>  :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j>  :TmuxNavigateDown<cr>
nnoremap <silent> <c-k>  :TmuxNavigateUp<cr>
nnoremap <silent> <c-l>  :TmuxNavigateRight<cr>
nnoremap <silent> <c-\>  :TmuxNavigatePrevious<cr>

" vim local list
"nnoremap <silent> gn  :lnext<cr>
"nnoremap <silent> gp  :lpre<cr>
nnoremap <silent> gn  :cnew<cr>
nnoremap <silent> gp  :cold<cr>

" :R !ls -l   grab command output int new buffer
command! -nargs=* -complete=shellcmd R tabnew
			\| setlocal buftype=nofile bufhidden=hide syn=diff noswapfile
			\| r <args>

" map same key under different mode
nmap <leader>rr  <ESC>0y$0:<c-u>R !sh -c '<c-r>0'<CR><CR>
vmap <leader>rr  :<c-u>R !sh -c '<c-r>*'
nmap <leader>c  :tabclose<CR>
nmap <leader>e  :!~/tools/dict <C-R>=expand("<cword>")<CR><CR>

let g:AutoComplPop_CompleteoptPreview = 1
let g:AutoComplPop_Behavior = {
\ 'c': [ {'command' : "\<C-x>\<C-o>",
\       'pattern' : ".",
\       'repeat' : 0}
\      ]
\}

" CommandT
let g:CommandTHighlightColor = 'Ptext'
let g:CommandTNeverShowDotFiles = 1
let g:CommandTScanDotDirectories = 0

" taglist plugin
map <leader>n :TagbarToggle<cr>
let g:miniBufExplSplitToEdge = 1
let g:miniBufExplorerAutoStart = 1

let g:vim_json_syntax_conceal = 0

" sneek motion: conflict with leader ';'
let g:sneak#s_next = 1

" tracelog
let g:tracelog_default_dir = $HOME . "/script/trace-wad/"

" ctags -R *;  ctags -L cscope.files
nmap <leader>g :ptag <C-R>=expand("<cword>")<CR><CR>
nmap <silent> <leader>, :ptnext<cr>
nmap <silent> <leader>. :ptprevious<cr>
"nmap <silent> <space> <c-w>}<c-w>Pzt<c-w><c-p>
nmap <silent> <space> :ptjump <c-r><c-w><cr><c-w>Pzt<c-w><c-p>

" TAB conflict with ctrl-i
nmap     <silent> <leader>j <leader>mmxviw:<c-u>%s/<c-r>*/&/gn<cr>:noh<cr>`x
nnoremap <silent> <leader>a :FSHere<cr>

set grepprg=grep
function! GrepCurrent()
  return   "R !grep -Enr --include='*.[ch]' -- '" . @" . "' daemon/wad"
endfunction
map <leader>g :<C-\>eGrepCurrent() <CR>
map <leader>s :<c-u>R !grep-malloc.sh <c-r>*
nnoremap <silent> <F3> :redir @a<CR>:g//<CR>:redir END<CR>:tabnew<CR>:put! a<CR>

function! OpenFileInPreviewWindow()
  return "pedit " . matchstr(getline("."), '\h\S*')
endfunction
map <leader><space> :<C-\>eOpenFileInPreviewWindow() <CR><CR>

fun! AppendQuickfix()
	call inputsave()
	let msg = input('log.marks msg: ')
	call inputrestore()
	if(empty(msg))
		return
	endif

	redir => msg2 | call ShowFuncName() | redir END

	let msg2 = substitute(msg2, '^\n', '', '')
	let msg2 = substitute(msg2, '^\s*\(.\{-}\)\s*$', '\1', '')
	let msg2 = substitute(msg2, '\n$', '', '')
	let line = line(".")

	redir >> log.marks
	echo strftime("%Y-%m-%d %H:%M") . " '" . msg . "' in " . msg2
	"echo expand('%') . ' ' . (line-1) . '  ' . getline(line-1)
	echo expand('%') . ':' .  line    . ': ' . getline(line)
	"echo expand('%') . ' ' . (line+1) . ': ' . getline(line+1)
	redir END

	"silent cfile log.marks
	"silent clast
endfun
nnoremap <silent> <leader>w :call AppendQuickfix() <CR>

function! GotoFileWithLineNum()
    " filename under the cursor
    let file_name = expand('<cfile>')
    if !strlen(file_name)
        echo 'NO FILE UNDER CURSOR'
        return
    endif

    " look for a line number separated by a :
    if search('\%#\f*:\zs[0-9]\+')
        " change the 'iskeyword' option temporarily to pick up just numbers
        let temp = &iskeyword
        set iskeyword=48-57
        let line_number = expand('<cword>')
        exe 'set iskeyword=' . temp
    endif

    " edit the file
    exe 'e '.file_name

    " if there is a line number, go to it
    if exists('line_number')
        exe line_number
    endif
endfunction

map gf :call GotoFileWithLineNum()<CR>
map gsf :sp<CR>:call GotoFileWithLineNum()<CR>


fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map <leader>l :call ShowFuncName() <CR>

" preconditon: mark a, mark b
" then in <gdb> source log.crash
fun! Tracecrash()
	exec ":silent %normal \<ESC>0i#"
	exec ":'a,'b normal df["
	exec ":'a,'b normal f]d$"
	exec ":'a,'b normal Il *"
endfun

" syntax=log
nnoremap <leader>z :call HideCommentToggle()<cr>
function! HideCommentToggle()
	let logfilename=expand("%")
	if match(logfilename,"log") >= 0
		"if exists("b:hidecomment_is_open")
		"	unlet b:hidecomment_is_open

		"	"set syntax=unknown
		"	syntax reset
		"	hi! clear Comment
		"	hi! link Comment Ignore
		"	hi MatchParen cterm=none ctermbg=green ctermfg=none
		"else
			let b:hidecomment_is_open = 1

		"	syntax on
			set syntax=log
			hi MatchParen cterm=none ctermbg=green ctermfg=none
		"endif
	else
		set syntax=c
	endif
endfunction

" disassembly current function
function! Asm()
  execute("new|r !gdb -batch sysinit/init -ex 'disas /m " . expand("<cword>") . "'")
endfunction
"map <leader>ds :call Asm() <CR>

" svn|git blame
function! GitBlameCurrent()
  "execute("!git --no-pager blame -L" . (line(".") - 5) . ",+10 HEAD -- " . expand("%p"))
  return "!git --no-pager blame -L" . (line(".") - 5) . ",+10 HEAD -- " . expand("%p")

  "let loc_blame_offset = winheight(0)/2 - 2
  "let loc_start = line('.') - loc_blame_offset
  "let loc_end = line('.') + loc_blame_offset
  "if (loc_start < 0)
  "  let loc_start = 0
  "endif
  "if (loc_end > line('$'))
  "  let loc_end = line('$')
  "endif

  "return   "!echo '======================================================' && " .
  "         \ "git --no-pager blame -L" . loc_start . "," . loc_end .
  "         \ " HEAD -- " . expand("%p")
endfunction

function! SvnBlameCurrent()
  execute("!svn blame " . expand("%p")
			  \. "|sed -n '" . (line(".") - 5) . "," . (line(".") + 5)  . "p'")
endfunction
map <leader>bs :call SvnBlameCurrent() <CR>
map <leader>bg :<C-\>eGitBlameCurrent() <CR><CR>
command! GitBlameCurrent call GitBlameCurrent()
command! SvnBlameCurrent call SvnBlameCurrent()

" quickfix
nmap <silent> <c-n> :cn<cr>
nmap <silent> <c-p> :cp<cr>

" quickfix autofit
nnoremap <buffer> <Enter> <C-W><Enter>
au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" vimdiff output to html ignore the same line
let g:html_ignore_folding = 1
let g:html_use_css = 0

" golang
"let g:go_disable_autoinstall = 1

" cscope
" The following maps all invoke one of the following cscope search types:
"   's'   symbol: find all references to the token under cursor
"   'g'   global: find global definition(s) of the token under cursor
"   'c'   calls:  find all calls to the function name under cursor
"   'd'   called: find functions that function under cursor calls
"   't'   text:   find all instances of the text under cursor
"   'e'   egrep:  egrep search for the word under cursor
"   'f'   file:   open the filename under cursor
"   'i'   includes: find files that include the filename under cursor
" +ctags
"         :tags   see where you currently are in the tag stack
"         :tag sys_<TAB>  auto-complete
" http://www.fsl.cs.sunysb.edu/~rick/rick_vimrc

":help cscope-options
set cscopetag
set cscopequickfix=s0,c0,d0,i0,t-,e-

nmap <leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <leader>fg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>fc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <leader>fd :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <leader>ft :cs find t <C-R>=expand("<cword>")<CR>
nmap <leader>fe :cs find e <C-R>=expand("<cword>")<CR>
nmap <leader>ff :cs find f <C-R>=expand("<cfile>")<CR>
nmap <leader>fi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>

nmap <leader>] :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>; :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>i <C-I>
nmap <leader>o <C-O>


" Using gnu-global replace cscope&ctags
""Using gtags.vim
"" $ find . -name '*.[ch]' > tags.files
"" $ gtags -f tags.files
"" $ global -u    <<< incremental update
"" $ vim -c 'cs add GTAGS'
"" have gtags.vim, the name can be partial
""   :Gtags funcname
""   :Gtags -P filename
""   :Gtags -r funcname    <<< called
""   :GtagsCurrent
"set cscopeprg=gtags-cscope
"
"" gtags which come from gnu-global + gtags.vim
"" http://www.gnu.org/software/global/manual/global.html
"nmap <leader>] :GtagsCursor<CR>
"
"" 0 for c, 1 for c++
"set csto=0


""Using gtags-cscope.vim
""<C-space>t  open define in horizon window
""<C-space><C-space>t  open define in vertical window
"let GtagsCscope_Auto_Load = 1
"let GtagsCscope_Auto_Map = 1
"let GtagsCscope_Quiet = 1
"set cscopetag
