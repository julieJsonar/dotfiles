"======================================================================
" Installation:
" =============
" 1. Vundle.vim
"    $ mv .vim vim-bak; mv .vimrc vimrc-bak;
"    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"    $ vi -c 'PluginInstall'
"
" Usage:
" ======
" <leader>         ";"
" <leader>;*       my shortkey
"
"  gd <or> D       goto declare <or> global declare
"  [I              list all occurence
"  g; <or> g,      navigate changelist
"
" <space>          open preview window, then <c-w>H adjust layout
" <leader><space>  open file in preview window, then <c-w>H adjust layout
" :Layout          open layout
" :on              close all other's windows
"
" <leader>l        show current function name
" <leader>j        show jumplist and choose
" <leader>\        list cscope symbol references in quickfix
" <leader>a        switch .c/.h
" <leader>;r       rebuild & reset cscope database
" <leader>;w       toggle relative line number
" <leader>g        grep, replace :ptag # if use <leader>s will conflict witch <leader>swp: AnsiEsc:call SaveWinPosn()
" <leader>;n       toggle taglist
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
" :Savesession     save to current dir, use vi -S default.vim to open it.
"
" :TT              rename tab
" alt+0,9,8,7      active the 1~4th tab
"
" Howtos:
" =======
"   OpenFile:
"       $ ls | vi -        # shell command output to vi
"       $ vi $(ls)         # open all file which is shell command output
"       $ vi $(!!)         # open all file which come from the last command's output
"   Register:
"       :@+                # have @ as prefix, then add register's name
"       :@/                # the last search word
"       :@"                # the yank word
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
"       <C-n>              # :cnext
"       <C-p>              # :cprevious
"       :colder N          # last result list
"       :cnewer N          # next result list
"       :Qfilter pattern   # filter the result
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
"       :grep -Iinr 'string' --include='*.[ch]' dirs
"       :grep -w 'word1\|word2' files
"       :grep '[a-z]\{5\}' files
"       :grep '^POST /\(idle\|send\)/CzHmd' log
"
"   EasyGrep:
"       <leader>vv         # Search whole current word
"       <leader>va         # Append search whole current word
"       <leader>vr         # Replace whole current word
"   Mark:
"       <leader>mm         # MarkToggle
"       <leader>mr         # MarkRegex
"       <leader>mx         # MarkClearAll
"   CtrlP:
"        <leader>fp        :CtrlP<CR>
"        <leader>fb        :CtrlPBuffer<CR>
"        <leader>fm        :CtrlPMRUFiles<CR>
"        <leader>ft        :CtrlPTag<CR>
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
"       <leader>fS         # List All symbol and add to quickfix, then :Qfilter again
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
"       :<C-\>e YourFunc() <CR>       # put YourFunc()'s result here
"   Batchfiles:
"       :TraceAdd,TraceAdjust,TraceClear()     # _WAD_TRACE_
"   CrashLog:              # mark 'a, 'b, then :call Tracecrash()    resolve fgt's crashlog
"   Shortkeys:             # beginwith <leader>;
"       w                  # relative number line
"       r                  # replace
"======================================================================

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'VundleVim/Vundle.vim'

Plugin 'holokai'
Plugin 'darkspectrum'
Plugin 'tomasr/molokai'
Plugin 'Lokaltog/vim-distinguished'
Plugin 'nanotech/jellybeans.vim'

"Plugin 'christoomey/vim-tmux-navigator'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'ciaranm/detectindent'
Plugin 'file-line'
"Plugin 'netrw.vim'
Plugin 'Raimondi/delimitMate'
"Plugin 'jiangmiao/auto-pairs'
Plugin 'majutsushi/tagbar'
"Plugin 'vim-scripts/taglist.vim'
"Plugin 'fholgado/minibufexpl.vim'
Plugin 'myusuf3/numbers.vim'

Plugin 'huawenyu/taboo.vim'
Plugin 'millermedeiros/vim-statline'
"Plugin 'maciakl/vim-neatstatus'
"Plugin 'bling/vim-airline'

"Plugin 'kien/ctrlp.vim'
Plugin 'justinmk/vim-sneak'
"Plugin 'Lokaltog/vim-easymotion'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-scripts/CmdlineComplete'
Plugin 'vim-utils/vim-vertical-move'

"Plugin 'Shougo/vimproc.vim'
"Plugin 'Shougo/deoplete.nvim'
"Plugin 'benekastah/neomake'

Plugin 'huawenyu/vim-mark'
Plugin 'AnsiEsc.vim'
Plugin 'tpope/vim-markdown'
Plugin 'huawenyu/vim-log-syntax'
Plugin 'pangloss/vim-javascript'

Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-session'
Plugin 'xolox/vim-reload'
"Plugin 'mhinz/vim-startify'

"Plugin 'ervandew/supertab'
"Plugin 'huawenyu/vim-easygrep'
Plugin 'yuratomo/w3m.vim'
Plugin 'DrawIt'
Plugin 'bruno-/vim-man'

Plugin 'huawenyu/tracelog.vim'

call vundle#end()
filetype plugin indent on

let mapleader = ";"
" diable Ex mode
map Q <Nop>
nnoremap <C-c> <silent> <C-c>
set term=xterm-256color

set nocompatible
set guifont=Liberation\ Mono\ 13

" Disable any use of bold fonts
set t_md=
set t_vb=
set hidden

" syntax enable
syntax on
"set background=dark
"set t_Co=256

"colorscheme distinguished
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
set nonumber
set noexpandtab

" indent
set tabstop=4
set shiftwidth=4
set textwidth=160

" C indent {
"set autoindent
"set smartindent
"set cindent
"}

set list
"set paste           " conflict with auto-pairs, delimitmate, auto-close plugin
"set showcmd
set splitbelow
set splitright

"set autochdir       " if work with shell or cscope, please not change work-dir
set sessionoptions-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds
set ssop-=curdir     " do not store absolute path
set ssop+=sesdir     " work under current dir as relative path


" Restore cursor to file {

 " Tell vim to remember certain things when we exit
 "  '30  :  marks will be remembered for up to 10 previously edited files
 "  "300 :  will save up to 100 lines for each register
 "  :30  :  up to 20 lines of command-line history will be remembered
 "  %    :  saves and restores the buffer list
 "  n... :  where to save the viminfo files
 set viminfo='30,\"300,:30,%,n~/.viminfo

 function! ResCur()
   if line("'\"") <= line("$")
     normal! g`"
     return 1
   endif
 endfunction

 augroup resCur
   autocmd!
   autocmd BufWinEnter * call ResCur()
 augroup END

"}

"Status Line
" cf the default statusline: %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" format markers:
"   %< truncation point
"   %= split point for left and right justification
"   %m modified flag [+] (modified), [-] (unmodifiable) or nothing
"
"   %n buffer number
"   %f relative path to file
"   %r readonly flag [RO]
"   %y filetype [ruby]
"   %-35. width specification
"   %l current line number
"   %L number of lines in buffer
"   %c current column number
"   %V current virtual column number (-n), if different from %c
"   %P percentage through buffer
"   %) end of width specification
function! Statusline_set_me()
    set laststatus=2                             " always show statusbar

    set statusline=
    set statusline+=[%{StatlineBufCount()}:%n]\   "space
    "set statusline+=%-18(%02.2c[%02.2B]L%l/%L%)\ "space
    set statusline+=L%l/%L\ %P\ %02.2c[%02.2B]\     "space

    "set statusline+=%h%m%r%w                     " status flags
    "set statusline+=\[%{strlen(&ft)?&ft:'none'}] " file type

    set statusline+=%<
    set statusline+=%=
    set statusline+=%m

    set statusline+=%f:
    set statusline+=%{GetFuncName()}
endfunction

filetype plugin indent on
" DetectIndent using :DetectIndent command
let g:detectindent_preferred_expandtab = 0
let g:detectindent_preferred_indent = 4
let g:detectindent_preferred_when_mixed = 4
let g:detectindent_max_lines_to_analyse = 1024

" Save Session
let g:session_autoload = 'no'
let g:session_autosave = 'no'
let g:session_directory = getcwd()
let g:reload_on_write = 0

" Autocmd {

  autocmd InsertEnter,InsertLeave * set cul!
  " current position in jumplist
  autocmd CursorHold * normal! m'

  autocmd BufNewFile,BufRead * DetectIndent
  autocmd BufNewFile,BufRead *.json set ft=javascript
  autocmd FileType c,cpp,c++,java,c+,javascript
          \ set cindent |
          \ set autoindent |
          \ set smartindent |
          \ call Statusline_set_me() |

"}

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let g:AutoPairsFlyMode = 1

" Use deoplete.
"let g:deoplete#enable_at_startup = 1

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

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

hi CursorLine guibg=Grey40
hi Visual term=reverse cterm=reverse guibg=Grey

"hi MatchParen cterm=bold ctermfg=cyan
"hi MatchParen cterm=none ctermbg=green ctermfg=none
"hi MatchParen cterm=none ctermbg=green ctermfg=blue
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

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


set clipboard+=unnamed
set clipboard+=unnamedplus
"vmap <leader>y   "+y
"vnoremap <leader>p "_dP

let g:AutoComplPop_CompleteoptPreview = 1
let g:AutoComplPop_Behavior = {
\ 'c': [ {'command' : "\<C-x>\<C-o>",
\       'pattern' : ".",
\       'repeat' : 0}
\      ]
\}

"" Vim-session
"let g:session_directory = "."
"let g:session_autoload = "no"
"let g:session_autosave = "yes"
"let g:session_command_aliases = 1

" CommandT
let g:CommandTHighlightColor = 'Ptext'
let g:CommandTNeverShowDotFiles = 1
let g:CommandTScanDotDirectories = 0

"{ taglist tagbar plugin
	let g:tagbar_width = 30
	let g:tagbar_compact = 1
	let g:tagbar_indent = 0
	let g:tagbar_iconchars = ['+', '-']
	
	function! IsLeftMostWindow()
	    let curNr = winnr()
	    wincmd h
	    if winnr() == curNr
	        return 1
	    endif
	    wincmd p " Move back.
	    return 0
	endfunction
	
	autocmd WinEnter * if !IsLeftMostWindow() | let g:tagbar_left = 0 | else | let g:tagbar_left = 1 | endif
"}

let g:miniBufExplSplitToEdge = 1
let g:miniBufExplorerAutoStart = 1

let g:vim_json_syntax_conceal = 0

" sneek motion: conflict with leader ';'
let g:sneak#s_next = 1

" tracelog
let g:tracelog_default_dir = $HOME . "/script/trace-wad/"


" Space: show columnline or open-declaration
function! SingleKey_Space()
  let l:col = virtcol('.')

  " Show colorcolumn
  if getline(".")[col(".")-1] == ' '
    if l:col == 1 || &colorcolumn == l:col
      let &colorcolumn = ''
    else
      let &colorcolumn = l:col
    endif
  else
    execute ":ptjump " . expand("<cword>")
    execute "norm! \<c-w>pzt\<c-w>p"
    "norm! ^wpzt^wp
  endif
endfunction


command! -nargs=0 -bar Qargs execute 'args ' . QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(values(buffer_numbers))
endfunction

" easygrep {

  set grepprg=grep

  function! LocalGrepYankToNewTab()
    execute "R !grep -Inr --include='*.[ch]' -- '" . @" . "' ."
  endfunction

  function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
  endfunction

  " autocmd QuickfixCmdPost make,grep,vimgrep copen
  function! LocalEasyGrep(add,sel)
    if a:add == 0
      let l:cmd = "grepadd"
      let l:param = "! -Inr --include='*.[ch]' -- '"
    elseif a:add == 1
      let l:cmd = "grep"
      let l:param = "! -Inr --include='*.[ch]' -- '"
    elseif a:add == 2
      let l:cmd = "grep"
      let l:param = "! -Inr
                    \ --exclude='patch.*'
                    \ --exclude='cscope.*'
                    \ --exclude='tags'
                    \ --exclude='TAGS'
                    \ --exclude='\*.svn\*'
                    \ --exclude='.svn'
                    \ --exclude='.git'
                    \ -w '"
    endif

    if a:sel == 1
      " when the selection is limited to within one line
      let l:sel_len = virtcol("'>") - virtcol("'<") + 1
      if l:sel_len >= 2
        return l:cmd . l:param . s:get_visual_selection() . "' ."
      endif
    endif

    return l:cmd . l:param . expand('<cword>') . "' ."
  endfunction

  function! LocalEasyReplace()
    return "Qargs | argdo %s/\\<" . expand('<cword>') . "\\>/" . expand('<cword>') . "/gc | update"
  endfunction

"}


function! PreviewWindowOpened()
    for nr in range(1, winnr('$'))
        if getwinvar(nr, "&pvw") == 1
            " found a preview
            return 1
        endif
    endfor

    return 0
endfunction


function! OpenFileInPreviewWindow()
  return "pedit " . matchstr(getline("."), '\h\S*')
endfunction

" note on source {

  function! AppendNoteOnSource()
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
  endfunction

"}

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


function! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfunction

function! GetFuncName()
  let lnum = line(".")
  let col = col(".")
  let l:cmd = getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
  return substitute(l:cmd, "(.*", "()", "")
endfunction


" preconditon: mark a, mark b
" then in <gdb> source log.crash
function! Tracecrash()
	exec ":silent %normal \<ESC>0i#"
	exec ":'a,'b normal df["
	exec ":'a,'b normal f]d$"
	exec ":'a,'b normal Il *"
endfunction


" disassembly current function
function! Asm()
  execute("new|r !gdb -batch sysinit/init -ex 'disas /m " . expand("<cword>") . "'")
endfunction


" Svn|Git blame {

  function! GitBlameCurrent()
    return "!git --no-pager blame -L" . (line(".") - 5) . ",+10 HEAD -- " . expand("%p")
  endfunction

  function! SvnBlameCurrent()
    execute("!svn blame " . expand("%p") . "|sed -n '" . (line(".") - 5) . "," . (line(".") + 5)  . "p'")
  endfunction

  function! SvnBlame()
     let line = line(".")
     setlocal nowrap
     " create a new window at the left-hand side
     aboveleft 18vnew
     " blame, ignoring white space changes
     %!svn blame -x-w "#"
     setlocal nomodified readonly buftype=nofile nowrap winwidth=1
     setlocal nonumber
     if has('&relativenumber') | setlocal norelativenumber | endif
     " return to original line
     exec "normal " . line . "G"
     " synchronize scrolling, and return to original window
     setlocal scrollbind
     wincmd p
     setlocal scrollbind
     syncbind
  endfunction

"}


" QuickFix {

  " autofit
  autocmd FileType qf call AdjustWindowHeight(3, 8)
  function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
  endfunction

  " auto command
  augroup quickfix
    autocmd!
    " forbit focus on quickfix, but confuse my layout
    "autocmd Syntax qf wincmd p

    autocmd QuickFixCmdPost grep,make,grepadd,vimgrep,vimgrepadd,cscope,cfile,cgetfile,caddfile,helpgrep cwindow
    autocmd QuickFixCmdPost lgrep,lmake,lgrepadd,lvimgrep,lvimgrepadd,lfile,lgetfile,laddfile lwindow
  augroup END

  " filter  :Qfilter pattern  <OR>  :Qfilter! pattern
  function! s:FilterQuickfixList(bang, pattern)
    let cmp = a:bang ? '!~#' : '=~#'
    call setqflist(filter(getqflist(), "bufname(v:val['bufnr']) " . cmp . " a:pattern"))
  endfunction
  command! -bang -nargs=1 -complete=file Qfilter call s:FilterQuickfixList(<bang>0, <q-args>)

"}


" Layout {

  function! DefaultLayout()
    exec "normal mP"

	exec ':grep -n -w ' . expand('<cword>') . ' *.' . expand('%:e')
    "exec ":silent vimgrep! /\\<" . expand('<cword>') . "\\>/\\Cgj " . expand('%:p')

    exec ":silent pclose"
    exec ":silent cclose"
    exec ":silent psearch " . expand('<cword>')
    exec "normal \<C-W>H"
    exec ":silent copen"
    exec "normal \<C-W>J"
    exec "normal \<C-W>k"

    exec "normal `P"
  endfunction

"}

function! GotoJump()
  jumps
  let j = input("Please select your jump: ")
  if j != ''
    let pattern = '\v\c^\+'
    if j =~ pattern
      let j = substitute(j, pattern, '', 'g')
      execute "normal " . j . "\<c-i>"
    else
      execute "normal " . j . "\<c-o>"
    endif
  endif
endfunction


" vimdiff output to html ignore the same line
let g:html_ignore_folding = 1
let g:html_use_css = 0

" cscope & tags {

  "nvim should load cscope db by script
  "set tags=tags;/
  set tags=tags

  function! LoadCscope()
    "" Searches from the directory of the current file upwards until root '/'
    "let db = findfile("cscope.out", ".;")
    "if (!empty(db))
    "  let path = strpart(db, 0, match(db, "/cscope.out$"))
    "  set nocscopeverbose " suppress 'duplicate connection' error
    "  exe "cs add " . db . " " . path
    "  set cscopeverbose
    "endif

    set nocscopeverbose
    exe "cs add cscope.out"
    set cscopeverbose
  endfunction
  autocmd BufEnter * call LoadCscope()
  "autocmd BufNewFile,BufRead * call LoadCscope()

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
  nmap <leader>i <C-I>
  nmap <leader>o <C-O>

  " Find symbol and add to quickfix
  function! CscopeSymbol()
    let l:old_cscopeflag = &cscopequickfix
    "let save_cursor = getpos(".")
    exec "normal mP"

    set cscopequickfix=s-,c0,d0,i0,t-,e-
    exec ':cs find s ' . expand("<cword>")
    "exec ':silent !copen'
    "exec "normal \<C-W>k"

    "call setpos('.', save_cursor)
    exec "normal `P"
    let &cscopequickfix = l:old_cscopeflag
  endfunction
  nmap <silent> <c-\> :call CscopeSymbol() <CR>

  "nmap <F11> :!find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files<CR>
  "    \:!cscope -b -i cscope.files -f cscope.out<CR>
  "    \:cs reset<CR>

"}

" Numbers {
  let g:enable_numbers = 0
"}

" Replace {
  function! CurrentReplace()
    return "%s/\\<" . expand("<cword>") . "\\>/" . expand("<cword>") . "/gi"
  endfunction
"}


" my key maps {
  nmap <silent> <leader>q :e #<cr>
  map <leader>l :call ShowFuncName() <CR>
  "nmap <leader>c  :tabclose<CR>
  nmap <leader>e  :!~/tools/dict <C-R>=expand("<cword>")<CR><CR>
  nmap <Leader>j :call GotoJump()<CR>

  " map same key under different mode
  nmap <leader>rr  <ESC>0y$0:<c-u>R !sh -c '<c-r>0'<CR><CR>
  vmap <leader>rr  :<c-u>R !sh -c '<c-r>*'

  nmap <silent> <leader>;w :NumbersToggle<CR>
  nmap <silent> <leader>;m :call mark#MarkCurrentWord(expand('cword'))<CR>
  nmap <silent> <leader>;n :TagbarToggle<CR>
  nmap <silent> <leader>;l :call DefaultLayout() <CR><CR>

  map           <leader>;g :<C-\>e LocalEasyGrep(1,0) <CR>
  map           <leader>;v :<C-\>e LocalEasyGrep(1,1) <CR>
  nmap <silent> <leader>;s :call CscopeSymbol() <CR>
  "nmap <silent> <leader>;r :call CurrentReplace() <CR>
  "nmap <silent> <leader>;w :call AppendNoteOnSource() <CR>
  nmap <silent> <leader>;r :!/bin/bash gencs.sh -a all <CR>
      \:cs reset <CR><CR>

  nmap <silent> <space> :call SingleKey_Space()<CR>
  "nmap <silent> <space> :ptjump <c-r><c-w><cr><c-w>Pzt<c-w><c-p>
  "map <leader> <space> :<C-\>e OpenFileInPreviewWindow() <CR><CR>

  map gf :call GotoFileWithLineNum()<CR>
  map gsf :sp<CR>:call GotoFileWithLineNum()<CR>

  "map <leader>ds :call Asm() <CR>
  map <leader>bs :call SvnBlameCurrent() <CR>
  map <leader>bg :Gblame <CR>

  nmap <silent> <c-n> :cn<cr>
  nmap <silent> <c-p> :cp<cr>
  nmap <buffer> <Enter> <C-W><Enter>

  " ctags -R *;  ctags -L cscope.files
  "nmap <leader>g :ptag <C-R>=expand("<cword>")<CR><CR>
  "nmap <silent> <leader>, :ptnext<cr>
  "nmap <silent> <leader>. :ptprevious<cr>

  " :on[ly][!]  close all other windows, but keep buffer
  nmap <leader>n :silent! cnewer <CR><CR>
  nmap <leader>p :silent! colder <CR><CR>

  " TAB conflict with ctrl-i
  nmap     <silent> <leader>j <leader>mmxviw:<c-u>%s/<c-r>*/&/gn<cr>:noh<cr>`x
  nnoremap <silent> <leader>a :FSHere<cr> |" Switch file *.c/h

  nnoremap <c-h> <c-w>h
  nnoremap <c-j> <c-w>j
  nnoremap <c-k> <c-w>k
  nnoremap <c-l> <c-w>l

  " https://github.com/christoomey/vim-tmux-navigator
  "let g:tmux_navigator_no_mappings = 1
  "nnoremap <silent> <c-h>  :TmuxNavigateLeft<cr>
  "nnoremap <silent> <c-j>  :TmuxNavigateDown<cr>
  "nnoremap <silent> <c-k>  :TmuxNavigateUp<cr>
  "nnoremap <silent> <c-l>  :TmuxNavigateRight<cr>
  "nnoremap <silent> <c-\>  :TmuxNavigatePrevious<cr>

  " vim local list
  "nnoremap <silent> gn  :lnext<cr>
  "nnoremap <silent> gp  :lpre<cr>
  "nnoremap <silent> gn  :cnew<cr>
  "nnoremap <silent> gp  :cold<cr>

  " CtrlP
  "let g:crtlp_map='<F11>'
  "nnoremap <leader>fp :CtrlP<CR>
  "nnoremap <leader>fb :CtrlPBuffer<CR>
  "nnoremap <leader>fm :CtrlPMRUFiles<CR>
  "nnoremap <leader>ft :CtrlPTag<CR>

  " :R !ls -l   grab command output int new buffer
  command! -nargs=* -complete=shellcmd R tabnew
  			\| setlocal buftype=nofile bufhidden=hide syn=diff noswapfile
  			\| r <args>

  " Cause command 'w' delay
  "cmap w!! w !sudo tee % >/dev/null

  map <leader>va :<C-\>e LocalEasyGrep(0,1) <CR>
  map <leader>vv :<C-\>e LocalEasyGrep(1,1) <CR>
  map <leader>vV :<C-\>e LocalEasyGrep(2,1) <CR>
  map <leader>vr :<C-\>e LocalEasyReplace() <CR>

  "map <leader>g  :call LocalGrepYankToNewTab() <CR>
  "map <leader>s  :<c-u>R !grep-malloc.sh <c-r>*
  nnoremap <silent> <F3> :redir @a<CR>:g//<CR>:redir END<CR>:tabnew<CR>:put! a<CR>

"}

