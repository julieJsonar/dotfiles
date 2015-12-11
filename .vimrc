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
" :g/regex/t$      copy match lines append to tail
" s<char><char>    sneak quick motion: <num>s - next count, `` <OR> <Ctrl-O> - backword original, s<enter> repeat search
" :Savesession     save to current dir, use vi -S default.vim to open it.
"
" Howtos:
" =======
"       :R !ls -l           # grab shell cmd output into new tab/buffer
"       :new|0read !ls -l  # grab cmd output into new window
"       :cfile log.marks   # view as quickfix
"       :mks!              # Save to Session.vim
"   Vimgrep:               # Also lvimgrep, short as: vim, lvim
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
"       samples
"       :grep -Iinr 'string' --include='*.[ch]' dirs
"       :grep -w 'word1\|word2' files
"       :grep '[a-z]\{5\}' files
"       :grep '^POST /\(idle\|send\)/CzHmd' log
"       ‘\w’ matches a character within a word
"       ‘\W’ matches a character which is not within a word
"       ‘\<’ matches the beginning of a word
"       ‘\>’ matches the end of a word
"       ‘\b’ matches a word boundary
"       ‘\B’ matches characters which are not a word boundary
"       ‘\`’ matches the beginning of the whole input
"       ‘\'’ matches the end of the whole input
"
" Tools:
" ======
"   DrawIt:                # use \di to start (\ds to stop)
"   W3m:
"       :W3m :W3mTab :W3mReload (local) [url or keyword], keyword include: google, wikipedia, man
"       <backspace>        # Back page
"       <enter>            # Open link under the cursor
"
" Self:
" =====
"   Function:
"       :<C-\>e YourFunc() <CR>       # put YourFunc()'s result here
"   Batchfiles:
"       :TraceAdd,TraceAdjust,TraceClear()     # _WAD_TRACE_
"   CrashLog:              # mark 'a, 'b, then :call Tracecrash()    resolve fgt's crashlog
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

Plugin 'huawenyu/vim-mark'
Plugin 'AnsiEsc.vim'
Plugin 'tpope/vim-markdown'
Plugin 'huawenyu/vim-log-syntax'
Plugin 'pangloss/vim-javascript'
Plugin 'huawenyu/vim-bookmarks'
Plugin 'jceb/vim-orgmode'
Plugin 'tpope/vim-speeddating'

Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-session'
Plugin 'xolox/vim-reload'
"Plugin 'mhinz/vim-startify'

Plugin 'tpope/vim-dispatch'
Plugin 'dyng/ctrlsf.vim'
Plugin 'rking/ag.vim'
"Plugin 'stefandtw/quickfix-reflector.vim'
"Plugin 'huawenyu/vim-easygrep'

Plugin 'Shougo/vimshell.vim'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/neomru.vim'
Plugin 'Shougo/neoyank.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'h1mesuke/unite-outline'

Plugin 'yuratomo/w3m.vim'
Plugin 'DrawIt'
Plugin 'bruno-/vim-man'

Plugin 'huawenyu/c-utils.vim'

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

" The characters after tab is U+2002. in vim with Ctrl-v u 2 0 0 2 (in insert mode).
set listchars=tab:»\ ,trail:~,extends:<,nbsp:.
"set listchars=nbsp:.,tab:>-,trail:~,extends:>,precedes:<
"set listchars=tab:>.,trail:~,extends:<,nbsp:.
"set listchars=tab:> ,trail:~,extends:<,nbsp:.


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
"}

let g:miniBufExplSplitToEdge = 1
let g:miniBufExplorerAutoStart = 1

let g:vim_json_syntax_conceal = 0

" sneek motion: conflict with leader ';'
let g:sneak#s_next = 1

" tracelog
let g:tracelog_default_dir = $HOME . "/script/trace-wad/"

set grepprg=grep

command! -nargs=1 Silent
  \ | execute ':silent !'.<q-args>
  \ | execute ':redraw!'

" vimdiff output to html ignore the same line
let g:html_ignore_folding = 1
let g:html_use_css = 0
let g:enable_numbers = 0

let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1

" Key maps {
  nmap <silent> <space> :call utils#ColumnlineOrDeclaration()<CR>
  "nmap <silent> <space> :ptjump <c-r><c-w><cr><c-w>Pzt<c-w><c-p>
  "map <leader> <space> :<C-\>e OpenFileInPreviewWindow() <CR><CR>

  " when wrap, move by virtual row
  nmap j gj
  nmap k gk
  nmap <leader>i <C-I>
  nmap <leader>o <C-O>

  nmap <leader>x  :tabclose<CR>
  nmap <leader>e  :!~/tools/dict <C-R>=expand("<cword>")<CR><CR>
  "nmap <Leader>j :call GotoJump()<CR>

  " map same key under different mode
  nmap <leader>rr  <ESC>0y$0:<c-u>R !sh -c '<c-r>0'<CR><CR>
  vmap <leader>rr  :<c-u>R !sh -c '<c-r>*'

  nmap          <leader>;q :call utilquickfix#FilterQuickFixList() <CR>
  nmap <silent> <leader>;w :NumbersToggle<CR>
  nmap <silent> <leader>;m :call mark#MarkCurrentWord(expand('cword'))<CR>
  nmap <silent> <leader>;n :TagbarToggle<CR>
  nmap <silent> <leader>;l :call layout#DefaultLayout() <CR><CR>

  let g:ctrlsf_mapping = {
      \ "next": "n",
      \ "prev": "N",
      \ }
  vmap          <leader>;f <Plug>CtrlSFVwordPath
  nmap          <leader>;v :<C-\>e utilgrep#LocalEasyGrep(1,0) <CR>
  vmap          <leader>;v :<C-\>e utilgrep#LocalEasyGrep(1,1) <CR>

  nmap <silent> <leader>;s :call utilcscope#CscopeSymbol() <CR>
  "nmap <silent> <leader>;r :call CurrentReplace() <CR>
  "nmap <silent> <leader>;w :call AppendNoteOnSource() <CR>
  nmap <silent> <leader>;r :!/bin/bash gencs.sh -a all <CR>
      \:cs reset <CR><CR>

  nmap <silent> <leader>;. :call verticalmove#VerticalMoveDown(1)<CR>
  nmap <silent> <leader>;, :call verticalmove#VerticalMoveDown(0)<CR>

  nmap <silent> <leader>1 :norm! 1gt <CR>
  nmap <silent> <leader>2 :norm! 2gt <CR>
  nmap <silent> <leader>3 :norm! 3gt <CR>
  nmap <silent> <leader>4 :norm! 4gt <CR>
  nmap <silent> <leader>5 :norm! 5gt <CR>
  nmap <silent> <leader>6 :norm! 6gt <CR>


  map gf :call utils#GotoFileWithLineNum()<CR>
  map gsf :sp<CR>:call utils#GotoFileWithLineNum()<CR>

  "map <leader>ds :call Asm() <CR>
  map <leader>bs :call blame#SvnBlameCurrent() <CR>
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

  " vim local list
  nmap <silent> gn :silent! lnext <CR>
  nmap <silent> gp :silent! lpre  <CR>

  " TAB conflict with ctrl-i
  nmap <silent> <leader>j <leader>mmxviw:<c-u>%s/<c-r>*/&/gn<cr>:noh<cr>`x
  nmap <silent> <leader>a :FSHere<cr> |" Switch file *.c/h

  nmap <c-h> <c-w>h
  nmap <c-j> <c-w>j
  nmap <c-k> <c-w>k
  nmap <c-l> <c-w>l

  " :R !ls -l   grab command output int new buffer
  command! -nargs=* -complete=shellcmd R tabnew
  			\| setlocal buftype=nofile bufhidden=hide syn=diff noswapfile
  			\| r <args>

  " Cause command 'w' delay
  "cmap w!! w !sudo tee % >/dev/null

  map <leader>va :<C-\>e utilgrep#LocalEasyGrep(0,1) <CR>
  map <leader>vv :<C-\>e utilgrep#LocalEasyGrep(1,1) <CR>
  map <leader>vV :<C-\>e utilgrep#LocalEasyGrep(2,1) <CR>
  map <leader>vr :<C-\>e utilgrep#LocalEasyReplace() <CR>

  "map <leader>s  :<c-u>R !grep-malloc.sh <c-r>*
  nmap <silent> <F3> :redir @a<CR>:g//<CR>:redir END<CR>:tabnew<CR>:put! a<CR>
  nnoremap <leader>;a :<C-u>execute autoreadfiles#WatchForChanges("*",{'autoread':1}) <CR>
  xnoremap * :<C-u>call utils#VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call utils#VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

  " Unite
  let g:unite_source_history_yank_enable = 1
  "call unite#filters#matcher_default#use(['matcher_fuzzy'])
  nnoremap <leader>jt :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
  nnoremap <leader>jf :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec<cr>
  nnoremap <leader>jr :<C-u>Unite -no-split -buffer-name=mru     -start-insert file_mru<cr>
  "nnoremap <leader>jo :<C-u>Unite -no-split -buffer-name=outline -start-insert outline<cr>
  nnoremap <leader>jy :<C-u>Unite -no-split -buffer-name=yank    history/yank<cr>
  nnoremap <leader>jb :<C-u>Unite -no-split -buffer-name=buffer bookmark -start-insert buffer<cr>

  " Custom mappings for the unite buffer
  autocmd FileType unite call s:unite_settings() | imap <buffer> <ESC> <Plug>(unite_exit)
  function! s:unite_settings()
    " Play nice with supertab
    let b:SuperTabDisabled=1
    " Enable navigation with control-j and control-k in insert mode
    imap <buffer> <C-j>   <Plug>(unite_select_next_line)
    imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  endfunction

"}




