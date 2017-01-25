" <leader>         ";"
" <leader>;*       my shortkey
" :set ts=4 sts=4 noet   indent tab
" :set ts=4 sts=4 et     indent space

" Install vim 8.0: sudo add-apt-repository ppa:jonathonf/vim; sudo apt install vim
" vimscript-OOP: http://bling.github.io/blog/2013/08/16/modularizing-vimscript/
"
"setlocal stl=%t\ (%l\ of\ %L)%{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ %P
"autocmd Filetype qf setlocal statusline=\ %n\ \ %f%=%L\ lines\ 
"
" VimL Debug{{{1
  "set verbose=9
  ""set verbose=15
  "set verbosefile=/tmp/vim.verbose

  let g:decho_enable = 0
  " decho to /tmp/vim.debug file, check with 'tail -f /tmp/vim.debug'
  "let g:dechomode = 6

  function! Decho(...)
    return
  endfunction
" }}}

if has("unix")
    let s:uname = system("uname")
    let g:python_host_prog='/usr/bin/python'
    if s:uname == "Darwin\n"
        let g:python_host_prog='/usr/bin/python'
    endif
endif

" Plugins {{{1}}}
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'VundleVim/Vundle.vim'

Plugin 'holokai'
"Plugin 'darkspectrum'
"Plugin 'sjl/badwolf'
"Plugin 'tomasr/molokai'
"Plugin 'Lokaltog/vim-distinguished'
"Plugin 'nanotech/jellybeans.vim'
"Plugin 'dracula/vim'
Plugin 'morhetz/gruvbox'

Plugin 'derekwyatt/vim-fswitch'
Plugin 'bogado/file-line'
Plugin 'Raimondi/delimitMate'
Plugin 'millermedeiros/vim-statline'
"Plugin 'vivien/vim-linux-coding-style'
Plugin 'MattesGroeger/vim-bookmarks'

Plugin 'majutsushi/tagbar'
"Plugin 'tomtom/ttags_vim'
"Plugin 'tomtom/tlib_vim'

Plugin 'justinmk/vim-sneak'	| " s + prefix-2-char to choose the words
"Plugin 'kien/ctrlp.vim'
"Plugin 'myusuf3/numbers.vim'
"Plugin 'easymotion/vim-easymotion'
"Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-fugitive'
"Plugin 'tpope/vim-dispatch'
Plugin 'radenling/vim-dispatch-neovim'
"Plugin 'vim-scripts/CmdlineComplete'
"Plugin 'vim-utils/vim-vertical-move'
"Plugin 'szw/vim-maximizer'
Plugin 'junegunn/vim-easy-align'	| " selected and ga=

Plugin 'klen/python-mode'
Plugin 'AnsiEsc.vim'
Plugin 'mfukar/robotframework-vim'
"Plugin 'pangloss/vim-javascript'
"Plugin 'jceb/vim-orgmode'
"Plugin 'tpope/vim-speeddating'
"Plugin 'tpope/vim-vinegar'	| " '-' open explore
"Plugin 'vim-scripts/VOoM'
Plugin 'jhidding/VOoM'		| " VOom support +python3
Plugin 'scrooloose/nerdtree'	| " ;;e toggle, <enter> open-file
Plugin 'scrooloose/nerdcommenter'
"Plugin 'Xuyuanp/nerdtree-git-plugin'
"Plugin 'mhinz/vim-signify'
Plugin 'craigemery/vim-autotag' | " First should exist tagfile which tell autotag auto-refresh: ctags -f .tags -R .

"Plugin 'wesleyche/SrcExpl'
Plugin 'vim-scripts/taglist.vim'
Plugin 'yegappan/mru'

Plugin 'cohama/agit.vim'	| " :Agit show git log like gitk
"Plugin 'vimwiki/vimwiki'
Plugin 'vim-scripts/bash-support.vim'
" Markdown
Plugin 'reedes/vim-pencil'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
"Plugin 'tpope/vim-markdown'
"Plugin 'brandonbloom/csearch.vim'
"Plugin 'devjoe/vim-codequery'
Plugin 'huawenyu/vim-grepper'	| " :Grepper text
Plugin 'chrisbra/NrrwRgn'

"Plugin 'lyuts/vim-rtags'
"Plugin 'tpope/vim-obsession'
"Plugin 'xolox/vim-misc'
"Plugin 'xolox/vim-session'
"Plugin 'xolox/vim-reload'
Plugin 'mhinz/vim-startify'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'		| " :'<,'>Gist -e 'list-sample'

"Plugin 'kana/vim-arpeggio'
"Plugin 'dyng/ctrlsf.vim'
"Plugin 'rking/ag.vim'

"Plugin 'JarrodCTaylor/vim-shell-executor'
"Plugin 'Shougo/vimshell.vim'
Plugin 'skywind3000/asyncrun.vim'	| " :asyncrun grep text

"Plugin 'Shougo/unite.vim'
"Plugin 'Shougo/denite.nvim'
"Plugin 'Shougo/neomru.vim'
"Plugin 'Shougo/neoyank.vim'
"Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plugin 'Shougo/neosnippet.vim'		| " c-k apply code, c-n next, c-p previous
Plugin 'Shougo/neosnippet-snippets'
Plugin 'honza/vim-snippets'
"---
"Plugin 'SirVer/ultisnips'
"---
"Plugin 'msanders/snipmate.vim'
"Plugin 'MarcWeber/vim-addon-mw-utils'
"Plugin 'garbas/vim-snipmate'
"Plugin 'tomtom/tlib_vim'

" share copy/paste between vim(""p)/tmux
Plugin 'roxma/vim-tmux-clipboard'
Plugin 'kassio/neoterm'		| " a terminal for neovim; :T ls, # exit terminal mode by <c-\\><c-n>
Plugin 'yuratomo/w3m.vim'
Plugin 'vim-utils/vim-man'	| " :Man printf
"Plugin 'DrawIt'
"Plugin 'vim-scripts/DirDiff.vim'

"Plugin 'AD7six/vim-activity-log'
"Plugin 'vim-scripts/LogViewer'
"Plugin 'stefandtw/quickfix-reflector.vim'

Plugin 'huawenyu/taboo.vim'
Plugin 'huawenyu/vim-mark'
"Plugin 'huawenyu/highlight.vim'
Plugin 'huawenyu/vim-log-syntax'
Plugin 'huawenyu/vimux-script'
Plugin 'huawenyu/vim-dispatch'
Plugin 'huawenyu/c-utils.vim'
Plugin 'huawenyu/neogdb.vim'

" Debug
Plugin 'tpope/vim-scriptease'
Plugin 'huawenyu/Decho'

call vundle#end()
filetype plugin indent on

" Configure {{{1}}}
let mapleader = ";"
" diable Ex mode
map Q <Nop>
nnoremap <C-c> <silent> <C-c>

" Vim status bar prediction/completion
"set wildmode=longest,list,full
set wildmode=longest:full,full
set wildmenu

set clipboard+=unnamed
set clipboard+=unnamedplus

if has("nvim")
  let base16colorspace=256
  let $NVIM_TUI_ENABLE_TRUE_COLOR=0
  set synmaxcol=2048
else
  set term=xterm-256color
endif

set nocompatible
set guifont=Liberation\ Mono\ 13

" Disable any use of bold fonts
set t_md=
set t_vb=
set hidden

" syntax enable
syntax on
set background=dark
set t_Co=256

colorscheme holokai
"colorscheme badwolf
"colorscheme distinguished
"colorscheme darkspectrum
"colorscheme molokai
"colorscheme dracula
"
"let g:gruvbox_italic=1
"let g:gruvbox_termcolors=16
"let g:gruvbox_contrast_dark='hard'
"colorscheme gruvbox

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
set showbreak=↪ |"⇇
set noswapfile
set nostartofline
set noshowmatch
set nonumber
set noexpandtab

" Check which script change the config value
"   :verbose set tabstop sw softtabstop expandtab ?
set tabstop=4
set shiftwidth=4
set softtabstop=4
set textwidth=120
set noexpandtab

" C indent {
set autoindent
set smartindent
set cindent
set cinoptions=:0,l1,t0,g0,(0
"}

set list
"set paste           " conflict with auto-pairs, delimitmate, auto-close plugin
"set showcmd
set splitbelow
set splitright

"set autochdir       " if work with shell or cscope, please not change work-dir
set sessionoptions-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds
set ssop+=curdir     " do not store absolute path
set ssop-=sesdir     " work under current dir as relative path

hi CursorLine guibg=Grey40
"hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
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

" Plugins Configure {{{1}}}

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let g:AutoPairsFlyMode = 1

" wildignore {{{2}}}
set wildignorecase
if exists("g:ctrl_user_command")
  unlet g:ctrlp_user_command
endif
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*,*/\.svn/*,objd/**,obj/**,*.tmp
set wildignore+=*.o,*.obj,.hg,*.pyc,.git,*.rej,*.orig,*.gcno,*.rbc,*.class,.svn,coverage/*,vendor
set wildignore+=*.gif,*.png,*.map
set wildignore+=*.d

" Restore cursor {{{2}}}
"{

 " Tell vim to remember certain things when we exit
 "  !    :  The uppercase global VARIABLE will saved
 "  '30  :  marks will be remembered for up to 10 previously edited files
 "  "300 :  will save up to 100 lines for each register
 "  :30  :  up to 20 lines of command-line history will be remembered
 "  %    :  saves and restores the buffer list
 "  n... :  where to save the viminfo files,
 "            here save to /tmp means we have another viminfo manager 'workspace'
if has("nvim")
  set viminfo=!,'30,\"300,:30,%,n~/.nviminfo
else
  "set viminfo=!,'30,\"300,:30,%,n/tmp/viminfo
  set viminfo='30,\"100,:100,n~/.viminfo
endif

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * silent! call ResCur()
augroup END

"}

" vimfiler {{{2}}}
let g:vimfiler_as_default_explorer = 1
"let g:signify_vcs_list = [ 'git', 'svn' ]

" autotag {{{2}}}
let g:autotagTagsFile = ".tags"

" vim-bookmarks {{{2}}}
let g:bookmark_no_default_key_mappings = 1
let g:bookmark_highlight_lines = 1
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 0
let g:bookmark_show_warning = 0
"let g:bookmark_location_list = 1

" EasyAlign {{{2}}}
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" netrw {{{2}}}
"let g:netrw_banner = 0
"let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"let g:netrw_altv = 1
"let g:netrw_winsize = 16

" NerdTree {{{2}}}
let NERDTreeMouseMode = 3
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeRespectWildIgnore = 1
"let NERDTreeShowBookmarks = 1
let NERDTreeWinSize = 25

" SrcExpl {{{2
"  let g:SrcExpl_winHeight = 8
"  let g:SrcExpl_refreshTime = 100     | " for back from the definition context
"  let g:SrcExpl_searchLocalDef = 0
"
"  let g:SrcExpl_jumpKey = "<F2>"   | " jump into the exact definition context
"  let g:SrcExpl_gobackKey = "<F3>"
"  let g:SrcExpl_prevDefKey = "<F4>"
"  let g:SrcExpl_nextDefKey = "<F5>"
"
"  let g:SrcExpl_isUpdateTags = 0
"  let g:SrcExpl_updateTagsCmd = "gencs.sh -a all"
"  let g:SrcExpl_updateTagsKey = "<F6>"
"}}}

" NerdComment {{{2}}}
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Gist {{{2}}}
let g:gist_show_privates = 1
let g:gist_post_private = 1
let g:gist_get_multiplefile = 1

" startify&Session {{{2}}}
"let g:session_autoload = 'no'
"let g:session_autosave = 'no'
"let g:session_directory = getcwd()
"let g:reload_on_write = 0
let g:startify_list_order = ['sessions', 'bookmarks', 'files', 'dir', 'commands']
let g:startify_change_to_dir = 0
let g:startify_session_autoload = 1
let g:startify_session_dir = './.vim'
let g:startify_session_persistence = 1
let g:startify_session_delete_buffers = 1
let g:startify_session_before_save = [
	  \ 'echo "Cleaning up before saving.."',
	  \ 'silent! cclose',
	  \ 'silent! NERDTreeTabsClose'
	  \ ]

" Deoplete {{{2}}}
let g:deoplete#enable_at_startup = 1
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" w3m {{{2}}}
let g:w3m#command = '/usr/bin/w3m'
let g:w3m#lang = 'en_US'

" plasticboy/vim-markdown {{{2}}}
let g:vim_markdown_conceal = 0
"let g:vim_markdown_toc_autofit = 1
"let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_folding_level = 3
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_emphasis_multiline = 0
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_fenced_languages = ['C=c', 'c=c', 'Shell=sh', 'Java=java', 'Csharp=cs']

let g:AutoComplPop_CompleteoptPreview = 1
let g:AutoComplPop_Behavior = {
\ 'c': [ {'command' : "\<C-x>\<C-o>",
\       'pattern' : ".",
\       'repeat' : 0}
\      ]
\}

" CommandT {{{2}}}
let g:CommandTHighlightColor = 'Ptext'
let g:CommandTNeverShowDotFiles = 1
let g:CommandTScanDotDirectories = 0

" taglist tagbar plugin {{{2
  let g:tagbar_sort = 0
  let g:tagbar_width = 30
  let g:tagbar_compact = 1
  let g:tagbar_indent = 0
  let g:tagbar_iconchars = ['+', '-']

  "let Tlist_GainFocus_On_ToggleOpen = 1
  let Tlist_Show_Menu = 0
  let Tlist_Use_Right_Window = 1
  let Tlist_WinWidth = 40
  let Tlist_File_Fold_Auto_Close = 1
  let Tlist_Show_One_File = 1
  let Tlist_Use_SingleClick = 1
  let Tlist_Enable_Fold_Column = 0
"}}}

let g:miniBufExplSplitToEdge = 1
let g:miniBufExplorerAutoStart = 1
let g:utilquickfix_file = $HOME."/.vim/vim.quickfix"
let g:vim_json_syntax_conceal = 0

" sneek motion {{{2}}}
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1

" tracelog
let g:tracelog_default_dir = $HOME . "/script/trace-wad/"

set grepprg=grep

" vimdiff output to html ignore the same line
let g:html_ignore_folding = 1
let g:html_use_css = 0
let g:enable_numbers = 0

" Python-mode{{{2
  " Activate rope
  " Keys:
  " K             Show python docs
  " <Ctrl-Space>  Rope autocomplete
  " <Ctrl-c>g     Rope goto definition
  " <Ctrl-c>d     Rope show documentation
  " <Ctrl-c>f     Rope find occurrences
  " <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
  " [[            Jump on previous class or function (normal, visual, operator modes)
  " ]]            Jump on next class or function (normal, visual, operator modes)
  " [M            Jump on previous class or method (normal, visual, operator modes)
  " ]M            Jump on next class or method (normal, visual, operator modes)
  let g:pymode_rope = 0

  " Documentation
  let g:pymode_doc = 1
  let g:pymode_doc_key = 'K'

  "Linting
  let g:pymode_lint = 0
  let g:pymode_lint_checker = "pyflakes,pep8"
  " Auto check on save
  let g:pymode_lint_write = 1

  " Support virtualenv
  let g:pymode_virtualenv = 1

  " Enable breakpoints plugin
  let g:pymode_breakpoint = 1
  let g:pymode_breakpoint_bind = '<leader>b'

  " syntax highlighting
  let g:pymode_syntax = 1
  let g:pymode_syntax_all = 1
  let g:pymode_syntax_indent_errors = g:pymode_syntax_all
  let g:pymode_syntax_space_errors = g:pymode_syntax_all

  " Don't autofold code
  let g:pymode_folding = 0
"}}}

"======================================================================
" Tabularize{{{2
    if exists(":Tabularize")
      nmap <leader>a= :Tabularize /=<CR>
      vmap <leader>a= :Tabularize /=<CR>
      nmap <leader>a: :Tabularize /:\zs<CR>
      vmap <leader>a: :Tabularize /:\zs<CR>
    endif
"}}}

" Commands {{{1

command! -nargs=* Wrap set wrap linebreak nolist
"command! -nargs=* Wrap PencilSoft
command! -nargs=* Tree NERDTree | only                |" fix nerdtree and use 'o' to preview file
"command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

command! -nargs=1 Silent
  \ | execute ':silent !'.<q-args>
  \ | execute ':redraw!'

" Autocmd {{{2

   function! AdjustWindowHeight(minheight, maxheight)
       let l = 1
       let n_lines = 0
       let w_width = winwidth(0)
       while l <= line('$')
           " number to float for division
           let l_len = strlen(getline(l)) + 0.0
           let line_width = l_len/w_width
           let n_lines += float2nr(ceil(line_width))
           let l += 1
       endw
       exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
   endfunction

   " Maximizes the current window if it is not the quickfix window.
   function! SetIndentTabForCfiletype()
       " auto into terminal-mode
       if &buftype == 'terminal'
           startinsert
           return
       elseif &buftype == 'quickfix'
           call AdjustWindowHeight(3, 10)
           return
       endif

       let my_ft = &filetype
       if (my_ft == "c" || my_ft == "cpp" || my_ft == "diff" )
           execute ':C8'
       endif
   endfunction

  autocmd BufEnter * call SetIndentTabForCfiletype()
  autocmd FileType qf call AdjustWindowHeight(3, 10)

  "autocmd VimLeavePre * cclose | lclose
  autocmd InsertEnter,InsertLeave * set cul!
  " current position in jumplist
  autocmd CursorHold * normal! m'

  autocmd BufNewFile,BufRead *.json set ft=javascript
  autocmd BufWritePre [\,:;'"\]\)\}]* throw 'Forbidden file name: ' . expand('<afile>')

  command! -nargs=* C0 setlocal autoindent cindent expandtab   tabstop=4 shiftwidth=4 softtabstop=4
  command! -nargs=* C2 setlocal autoindent cindent expandtab   tabstop=2 shiftwidth=2 softtabstop=2
  command! -nargs=* C4 setlocal autoindent cindent noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
  command! -nargs=* C8 setlocal autoindent cindent noexpandtab tabstop=8 shiftwidth=8 softtabstop=8

  autocmd BufNewFile,BufRead *.c.rej,*.c.orig,h.rej,*.h.orig,patch.*,*.diff,*.patch set ft=diff
  autocmd Filetype c,cpp,diff C8

  augroup voom_map
    autocmd!
    autocmd filetype markdown nnoremap <buffer> <leader>;o :VoomToggle markdown<CR>
    autocmd filetype python   nnoremap <buffer> <leader>;o :VoomToggle python<CR>
  augroup END
"}}}
"}}}


" Key maps {{{1}}}
  nmap <silent> <space> :call utils#Declaration()<CR>

  " when wrap, move by virtual row
  nmap j gj
  nmap k gk
  nmap <leader>i <C-I>
  nmap <leader>o <C-O>

  " make vim yank cross vim-sessions
  "vmap <leader>y   "+y
  "vnoremap <leader>p "_dP
  "vmap <leader>y :'<,'>w! <CR>
  "vmap <leader>y :"ay<CR>:redir "/tmp/vim.yank"<CR>:echo @a<CR>:redir END<CR>
  vmap <leader>y :<c-u>call utils#GetSelected("/tmp/vim.yank")<CR>
  nmap <silent> <leader>y  :<c-u>call vimuxscript#Copy() <CR>
  nmap <leader>p :r! cat /tmp/vim.yank<CR>

  " vim local list
  nmap <silent> <a-n> :silent! lnext <CR>
  nmap <silent> <a-p> :silent! lpre <CR>

  " Open tag in new tab
  nmap <silent><Leader><C-]> <C-w><C-]><C-w>T

  nmap <silent> <c-h> <c-w>h
  nmap <silent> <c-j> <c-w>j
  nmap <silent> <c-k> <c-w>k
  nmap <silent> <c-l> <c-w>l
  if has("nvim")
    let b:terminal_scrollback_buffer_size = 10000
    let g:terminal_scrollback_buffer_size = 10000
    tmap <c-h> <C-\><C-n><C-w>h
    tmap <c-j> <C-\><C-n><C-w>j
    tmap <c-k> <C-\><C-n><C-w>k
    tmap <c-l> <C-\><C-n><C-w>l
  endif

  " Window resizing mappings /*{{{*/
  nmap <S-Up> :normal <c-r>=Resize('+')<CR><CR>
  nmap <S-Down> :normal <c-r>=Resize('-')<CR><CR>
  nmap <S-Left> :normal <c-r>=Resize('<')<CR><CR>
  nmap <S-Right> :normal <c-r>=Resize('>')<CR><CR>

  nmap <silent> <C-Right> :tabnext<CR>
  nmap <silent> <C-Left>  :tabprev<CR>
  "nmap <silent> <C-Up>    :cnewer<CR>
  "nmap <silent> <C-Down>  :colder<CR>

  " :on[ly][!]  close all other windows, but keep buffer
  "nmap <silent> <leader>;n :silent! cnewer <CR>
  "nmap <silent> <leader>;p :silent! colder <CR>

  nmap <silent> <c-n> :cn<cr>
  nmap <silent> <c-p> :cp<cr>

  " <leader>;* {{{2}}}
  nmap <silent> <leader>;e :NERDTreeToggle<CR>
  nmap <silent> <leader>;f :NERDTreeFind<CR>
  nmap <silent> <leader>;t :TlistToggle<CR>
  "nmap <silent> <leader>;s :SrcExplToggle<CR>
  "nmap <silent> <leader>;r :MRU<CR>
  nmap <silent> <leader>;r :Dispatch! gencs.sh -a all<CR>
  "nmap <silent> <leader>;, :call verticalmove#VerticalMoveDown(0)<CR>

  " config voom {{{3}}}
  let g:voom_tree_width = 45
  let g:voom_tree_placement = 'right'
  " Voom
  nmap <silent> <leader>;o :VoomToggle<CR>

  let g:tlTokenList = ["FIXME @wilson", "TODO @wilson", "XXX @wilson"]
  let g:ctrlsf_mapping = { "next": "n", "prev": "N", }

  nmap <silent> <leader>;i :call utils#VoomInsert(0) <CR>
  vmap <silent> <leader>;i :call utils#VoomInsert(1) <CR>
  vmap          <leader>;h <Plug>CtrlSFVwordPath
  map  <silent> <leader>;g :redir @a<CR>:g//<CR>:redir END<CR>:tabnew<CR>:put! a<CR>
  "nmap <silent> <leader>;r :call utils#RefreshWindows() <CR>
  "nmap <silent> <leader>rr :call utils#RefreshWindows() <CR>


  " <leader>number {{{2}}}
  map <silent> <leader>1 :norm! 1gt<CR>
  map <silent> <leader>2 :norm! 2gt<CR>
  map <silent> <leader>3 :norm! 3gt<CR>
  map <silent> <leader>4 :norm! 4gt<CR>
  map <silent> <leader>5 :norm! 5gt<CR>
  map <silent> <leader>6 :norm! 6gt<CR>
  map <silent> <leader>7 :norm! 7gt<CR>
  map <silent> <leader>8 :norm! 8gt<CR>
  map <silent> <leader>9 :norm! 9gt<CR>
  map <silent> <leader>0 :norm! 10gt<CR>

  nmap <buffer> <Enter> <C-W><Enter>

  map gf :call utils#GotoFileWithLineNum()<CR>
  map gsf :sp<CR>:call utils#GotoFileWithLineNum()<CR>

  "map <leader>ds :call Asm() <CR>
  map <leader>bs :call blame#SvnBlameCurrent() <CR>
  map <leader>bg :call blame#GitBlameCurrent() <CR>

  "nmap <silent> <leader>;w :NumbersToggle<CR>
  nmap <silent> <leader>;w :MaximizerToggle<CR>
  nmap <silent> <leader>ww :MaximizerToggle<CR>

  nmap          <leader>dd :g/<C-R><C-w>/ norm dd
  nmap          <leader>de  :g/.\{200,\}/d

  nmap          <leader>qs :QSave 
  nmap          <leader>ql :QLoad 
  nmap          <leader>qf :call utilquickfix#QuickFixFilter() <CR>
  nmap          <leader>qq :call utilquickfix#QuickFixFunction() <CR>
  nmap          <leader>;q :call utilquickfix#QuickFixFunction() <CR>

  " Execute selected text as shell
  nmap          <leader>ex  :tabclose<CR>
  nmap          <leader>et  :TabooOpen 
  nmap <silent> <leader>eo  :call VimuxOpenRunner()<CR>
  nmap <silent> <leader>ec  :VimuxCloseRunner<CR>
  nmap <silent> <leader>ev  :<c-u>call vimuxscript#StartCopy() <CR>
  nmap <silent> <leader>ey  :<c-u>call vimuxscript#Copy() <CR>
  vmap <silent> <leader>ee  :<c-u>call vimuxscript#ExecuteSelection(1)<CR>
  nmap <silent> <leader>ee  :<c-u>call vimuxscript#ExecuteSelection(0)<CR>
  nmap <silent> <leader>eg  :<c-u>call vimuxscript#ExecuteGroup()<CR>
  nmap          <leader>ew  :!~/tools/dict <C-R>=expand("<cword>") <CR><CR>
  "nmap <silent> <leader>;e  :<c-u>call vimuxscript#ExecuteSelection(0)<CR>
  "vmap <silent> <leader>;e  :ExecuteSelection <CR>


  " TAB conflict with ctrl-i
  "nmap <silent> <leader>j <leader>mmxviw:<c-u>%s/<c-r>*/&/gn<cr>:noh<cr>`x
  nmap <silent> <leader>a :FSHere<cr> |" Switch file *.c/h

  " :R !ls -l   grab command output int new buffer
  command! -nargs=* -complete=shellcmd R tabnew
              \| setlocal buftype=nofile bufhidden=hide syn=diff noswapfile
              \| r <args>

  " Cause command 'w' delay
  "cmap w!! w !sudo tee % >/dev/null

  map  <leader>va :<C-\>e utilgrep#Grep(0,1) <CR>
  nmap <leader>vv :<C-\>e utilgrep#Grep(1,0) <CR><CR>
  vmap <leader>vv :<C-\>e utilgrep#Grep(1,1) <CR><CR>
  map  <leader>vV :<C-\>e utilgrep#Grep(2,1) <CR>
  "map <leader>vr :<C-\>e utilgrep#LocalEasyReplace() <CR>
  vmap <leader>vr :<C-\>e tmp#CurrentReplace() <CR>
  nmap <leader>vr :Replace <C-R>=expand('<cword>') <CR> <C-R>=expand('<cword>') <CR>
  nmap <leader>;v :<C-\>e utilgrep#Grep(1,0) <CR><CR>
  vmap <leader>;v :<C-\>e utilgrep#Grep(1,1) <CR><CR>

  "bookmark
  nmap <leader>mo :BookmarkLoad Default
  nmap <leader>ma :BookmarkShowAll <CR>
  nmap <leader>mm :call mark#MarkCurrentWord(expand('cword'))<CR>
  nmap <leader>;m :call mark#MarkCurrentWord(expand('cword'))<CR>
  "nmap <silent> <leader>;m :call mark#MarkCurrentWord(expand('cword'))<CR>
  nmap <leader>mg :BookmarkGoto <C-R><c-w>
  nmap <leader>mc :BookmarkDel <C-R><c-w>

  "map <leader>s  :<c-u>R !grep-malloc.sh <c-r>*
  nnoremap <leader>;a :<C-u>execute autoreadfiles#WatchForChanges("*",{'autoread':1}) <CR>
  xnoremap * :<C-u>call utils#VSetSearch('/')<CR>/<C-R>=@/<CR>
  xnoremap # :<C-u>call utils#VSetSearch('?')<CR>?<C-R>=@/<CR>
  vnoremap // y:vim /\<<C-R>"\C/gj %


  " Unite {{{2
  "let g:unite_source_history_yank_enable = 1
  "let g:neoyank#file = $HOME.'/.vim/yankring.txt'
  ""call unite#filters#matcher_default#use(['matcher_fuzzy'])
  "nnoremap <leader>jt :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
  "nnoremap <leader>jf :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec<cr>
  "nnoremap <leader>jr :<C-u>Unite -no-split -buffer-name=mru     -start-insert file_mru<cr>
  ""nnoremap <leader>jo :<C-u>Unite -no-split -buffer-name=outline -start-insert outline<cr>
  "nnoremap <leader>jy :<C-u>Unite -no-split -buffer-name=yank    history/yank<cr>
  "nnoremap <leader>jb :<C-u>Unite -no-split -buffer-name=buffer bookmark -start-insert buffer<cr>
  "nnoremap <leader>jj :<C-u>Unite jump <CR>
  "nnoremap <leader>jc :<C-u>UniteClose <CR>
  "
  "" Custom mappings for the unite buffer
  "autocmd FileType unite call s:unite_settings() | imap <buffer> <ESC> <Plug>(unite_exit)
  "function! s:unite_settings()
  "  " Play nice with supertab
  "  let b:SuperTabDisabled=1
  "  " Enable navigation with control-j and control-k in insert mode
  "  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  "  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  "endfunction
  "}}}

"}

" Documentation {{{1}}}
" ============================
" 1. Vundle.vim
"    $ mv .vim vim-bak; mv .vimrc vimrc-bak;
"    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"    $ vi -c 'PluginInstall'
"
" Usage: {{{2}}}
" ======
"  gd <or> D       goto declare <or> global declare
"  [I              list all occurence
"  g; <or> g,      navigate changelist
" :g/regex/t$      copy match lines append to tail
" s<char><char>    sneak quick motion: <num>s - next count, `` <OR> <Ctrl-O> - backword original, s<enter> repeat search
"
" Howtos: {{{2}}}
" =======
"       :R !ls -l           # grab shell cmd output into new tab/buffer
"       :new|0read !ls -l  # grab cmd output into new window
"       :cfile log.marks   # view as quickfix
"       :mks!              # Save to Session.vim
"       :Tree              # explore dir and use 'o' to open a file into preview windows
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
" Tools: {{{2}}}
" ======
"   DrawIt:                # use \di to start (\ds to stop)
"   W3m:
"       :W3m :W3mTab :W3mReload (local) [url or keyword], keyword include: google, wikipedia, man
"       <backspace>        # Back page
"       <enter>            # Open link under the cursor
"
" My: {{{2}}}
" =====
"   Function:
"       :<C-\>e YourFunc() <CR>       # put YourFunc()'s result here
"   Batchfiles:
"       :TraceAdd,TraceAdjust,TraceClear()     # _WAD_TRACE_
"   CrashLog:              # mark 'a, 'b, then :call Tracecrash()    resolve fgt's crashlog
"======================================================================
