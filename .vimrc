" <leader>         ";"
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

  function! Cond(cond, ...)
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
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
call plug#begin('~/.vim/bundle')
Plug 'holokai'
"Plug 'darkspectrum'
"Plug 'sjl/badwolf'
"Plug 'tomasr/molokai'
"Plug 'Lokaltog/vim-distinguished'
"Plug 'nanotech/jellybeans.vim'
"Plug 'dracula/vim'
Plug 'morhetz/gruvbox'

Plug 'derekwyatt/vim-fswitch'
Plug 'bogado/file-line'
Plug 'Raimondi/delimitMate'
Plug 'millermedeiros/vim-statline'
"Plug 'vivien/vim-linux-coding-style'
Plug 'MattesGroeger/vim-bookmarks'

Plug 'majutsushi/tagbar'
"Plug 'tomtom/ttags_vim'
"Plug 'tomtom/tlib_vim'

Plug 'justinmk/vim-sneak'	| " s + prefix-2-char to choose the words
"Plug 'kien/ctrlp.vim'
"Plug 'myusuf3/numbers.vim'
"Plug 'easymotion/vim-easymotion'
"Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"Plug 'cloudhead/neovim-fuzzy', Cond(has('nvim'))
Plug 'Dkendal/fzy-vim'
"Plug 'tpope/vim-dispatch'
Plug 'radenling/vim-dispatch-neovim', Cond(has('nvim'))
"Plug 'vim-scripts/CmdlineComplete'
"Plug 'vim-utils/vim-vertical-move'
"Plug 'szw/vim-maximizer'
Plug 'junegunn/vim-easy-align'	| " selected and ga=

Plug 'klen/python-mode'
"Plug 'AnsiEsc.vim'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'mfukar/robotframework-vim'
"Plug 'pangloss/vim-javascript'
"Plug 'jceb/vim-orgmode'
"Plug 'tpope/vim-speeddating'
"Plug 'tpope/vim-vinegar'	| " '-' open explore
"Plug 'vim-scripts/VOoM'
Plug 'jhidding/VOoM'		| " VOom support +python3
Plug 'scrooloose/nerdtree'	| " ;;e toggle, <enter> open-file
Plug 'scrooloose/nerdcommenter'
"Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'mhinz/vim-signify'
Plug 'craigemery/vim-autotag' | " First should exist tagfile which tell autotag auto-refresh: ctags -f .tags -R .

"Plug 'wesleyche/SrcExpl'
Plug 'vim-scripts/taglist.vim'
"Plug 'yegappan/mru'

Plug 'cohama/agit.vim'	| " :Agit show git log like gitk
Plug 'juneedahamed/svnj.vim'
"Plug 'vimwiki/vimwiki'
Plug 'vim-scripts/bash-support.vim'
" Markdown
Plug 'reedes/vim-pencil'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
"Plug 'tpope/vim-markdown'
"Plug 'brandonbloom/csearch.vim'
"Plug 'devjoe/vim-codequery'
Plug 'huawenyu/vim-grepper'	| " :Grepper text
Plug 'chrisbra/NrrwRgn'

"Plug 'lyuts/vim-rtags'
"Plug 'tpope/vim-obsession'
"Plug 'xolox/vim-misc'
"Plug 'xolox/vim-session'
"Plug 'xolox/vim-reload'
Plug 'mhinz/vim-startify'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'		| " :'<,'>Gist -e 'list-sample'

"Plug 'kana/vim-arpeggio'
"Plug 'dyng/ctrlsf.vim'
"Plug 'rking/ag.vim'

"Plug 'JarrodCTaylor/vim-shell-executor'
"Plug 'Shougo/vimshell.vim'
"Plug 'skywind3000/asyncrun.vim'	| " :asyncrun grep text

"Plug 'Shougo/unite.vim'
"Plug 'Shougo/denite.nvim'
"Plug 'Shougo/neomru.vim', Cond(has('nvim'))
"Plug 'Shougo/neoyank.vim', Cond(has('nvim'))
"Plug 'Shougo/vimproc.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet.vim', Cond(has('nvim'))        | " c-k apply code, c-n next, c-p previous
Plug 'Shougo/neosnippet-snippets', Cond(has('nvim'))
Plug 'honza/vim-snippets'
"---
"Plug 'SirVer/ultisnips'
"---
"Plug 'msanders/snipmate.vim'
"Plug 'MarcWeber/vim-addon-mw-utils'
"Plug 'garbas/vim-snipmate'
"Plug 'tomtom/tlib_vim'

" share copy/paste between vim(""p)/tmux
Plug 'roxma/vim-tmux-clipboard'
Plug 'kassio/neoterm', Cond(has('nvim'))	| " a terminal for neovim; :T ls, # exit terminal mode by <c-\\><c-n>
Plug 'yuratomo/w3m.vim'
Plug 'nhooyr/neoman.vim', Cond(has('nvim'))	| " :Nman printf, :Nman printf(3)
"Plug 'DrawIt'
"Plug 'vim-scripts/DirDiff.vim'

"Plug 'AD7six/vim-activity-log'
"Plug 'vim-scripts/LogViewer'
"Plug 'stefandtw/quickfix-reflector.vim'

Plug 'huawenyu/taboo.vim'
Plug 'huawenyu/vim-mark'
"Plug 'huawenyu/highlight.vim'
Plug 'huawenyu/vim-log-syntax'
Plug 'huawenyu/vimux-script'
Plug 'huawenyu/vim-dispatch'		| " Run every thing. :Dispatch :Make :Start man 3 printf
Plug 'huawenyu/c-utils.vim'
Plug 'huawenyu/neogdb.vim', Cond(has('nvim'))

" Debug
Plug 'tpope/vim-scriptease'
Plug 'huawenyu/Decho'
call plug#end()


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

filetype plugin indent on
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

" svnj {{{2}}}
let g:svnj_browse_cache_all = 1

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

  " tabpage {{{3}}}
  nmap <silent><tab>j :tabnew<cr>
  nmap <silent><tab>k :tabclose<cr>
  nmap <silent><tab>n :tabn<cr>
  nmap <silent><tab>p :tabp<cr>

  "nmap <silent> <C-Right> :tabnext<CR>
  "nmap <silent> <C-Left>  :tabprev<CR>
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
  "
  " execute file that I'm editing in Vi(m) and get output in split window
  nmap <silent> <leader>;x :w<CR>:silent !chmod 755 %<CR>:silent !./% > /tmp/vim.tmpx<CR>
              \ :tabnew<CR>:r /tmp/vim.tmpx<CR>:silent !rm /tmp/vim.tmpx<CR>:redraw!<CR>

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

"}

" Documentation {{{1}}}
" ============================
" Usage: {{{2}}}
" ======
"  gd <or> D       goto declare <or> global declare
"  [I              list all occurence
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
" Tools: {{{2}}}
" ======
"   DrawIt:                # use \di to start (\ds to stop)
