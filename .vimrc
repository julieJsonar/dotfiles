" <leader> is <space>
" Doc {{{1
"   http://stevelosh.com/blog/2011/09/writing-vim-plugins/
" }}}
"
" VimL Debug{{{1

  set verbose=0
  "set verbose=8
  "set verbosefile=/tmp/vim.log

  let g:decho_enable = 0
  let g:bg_color = 233 | " current background's color value, use by log to invisible
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
" ColorTheme {{{2
    Plug 'holokai'
    "Plug 'tomasr/molokai'
    "Plug 'darkspectrum'
    "Plug 'dracula/vim'
    "Plug 'morhetz/gruvbox'
    "Plug 'sjl/badwolf'
    "Plug 'jnurmine/Zenburn'
    "Plug 'joshdick/onedark.vim'
    "Plug 'ryu-blacknd/vim-nucolors'
    "Plug 'chriskempson/base16-vim'
    "Plug 'Lokaltog/vim-distinguished'
    "Plug 'flazz/vim-colorschemes'
    "Plug 'nanotech/jellybeans.vim'
    "Plug 'huawenyu/color-scheme-holokai-for-vim'
"}}}

" Mode {{{2
    " Python {{{3
        " auto-complete
        " https://github.com/neovim/python-client
        " Install https://github.com/davidhalter/jedi
        " https://github.com/zchee/deoplete-jedi
        Plug 'klen/python-mode'
    "}}}

    Plug 'huawenyu/neogdb.vim', Cond(has('nvim'))
    "Plug 'vimwiki/vimwiki'
    Plug 'jceb/vim-orgmode'
    Plug 'tpope/vim-speeddating'
"}}}



" Facade {{{2
    Plug 'Raimondi/delimitMate'
    Plug 'millermedeiros/vim-statline'
    "Plug 'vivien/vim-linux-coding-style'
    "Plug 'MattesGroeger/vim-bookmarks'
    "Plug 'hecal3/vim-leader-guide'
    "Plug 'megaannum/self'
    "Plug 'megaannum/forms'
    Plug 'mhinz/vim-startify'
"}}}

" Syntax/Language {{{2
    Plug 'octol/vim-cpp-enhanced-highlight'
    Plug 'justinmk/vim-syntax-extra'
    "Plug 'justinmk/vim-dirvish'
    "Plug 'kovisoft/slimv'
    "Plug 'AnsiEsc.vim'
    Plug 'powerman/vim-plugin-AnsiEsc'
    Plug 'mfukar/robotframework-vim'
    Plug 'plasticboy/vim-markdown'
    "Plug 'pangloss/vim-javascript'
    " http://www.thegeekstuff.com/2009/02/make-vim-as-your-bash-ide-using-bash-support-plugin/
    "Plug 'vim-scripts/bash-support.vim'
    Plug 'WolfgangMehner/bash-support'
    "Plug 'vim-scripts/DirDiff.vim'
    Plug 'huawenyu/vim-log-syntax'
    Plug 'Shougo/vinarise.vim' | " Hex viewer
"}}}

" Improve {{{2
    "Plug 'derekwyatt/vim-fswitch'
    Plug 'kopischke/vim-fetch'
    Plug 'terryma/vim-expand-region'
    Plug 'szw/vim-maximizer'
    Plug 'huawenyu/vim-mark'
    "Plug 'huawenyu/highlight.vim'


    " Motion {{{3
        "Plug 'justinmk/vim-sneak'    | " s + prefix-2-char to choose the words
        Plug 'easymotion/vim-easymotion'
        "Plug 'tpope/vim-repeat'
        "Plug 'vim-utils/vim-vertical-move'
    "}}}

    " Search {{{3
        Plug 'huawenyu/neovim-fuzzy', Cond(has('nvim'))
        "Plug 'Dkendal/fzy-vim'
        Plug 'huawenyu/vim-grepper'    | " :Grepper text
    "}}}

    " Async {{{3
        "Plug 'tpope/vim-dispatch'
        "Plug 'huawenyu/vim-dispatch'        | " Run every thing. :Dispatch :Make :Start man 3 printf
        "Plug 'radenling/vim-dispatch-neovim', Cond(has('nvim'))
        Plug 'huawenyu/neomake', Cond(has('nvim'))
    "}}}

    " View/Outline {{{3
        Plug 'scrooloose/nerdtree'    | " ;;e toggle, <enter> open-file
        Plug 'scrooloose/nerdcommenter'
        Plug 'jeetsukumaran/vim-buffergator'
        Plug 'huawenyu/vim-rooter'  | " Get or change current dir

        "Plug 'tpope/vim-vinegar'    | " '-' open explore
        Plug 'jhidding/VOoM'        | " VOom support +python3
        Plug 'vim-voom/VOoM_extras'
        "Plug 'mhinz/vim-signify'
        Plug 'craigemery/vim-autotag' | " First should exist tagfile which tell autotag auto-refresh: ctags -f .tags -R .
        Plug 'vim-scripts/taglist.vim'
        Plug 'majutsushi/tagbar'
        "Plug 'tomtom/ttags_vim'
        "Plug 'tomtom/tlib_vim'
    "}}}

    " Tools {{{3
        Plug 'DrawIt'
        Plug 'reedes/vim-pencil'
        "Plug 'godlygeek/tabular'
        "Plug 'dhruvasagar/vim-table-mode'
        "Plug 'chrisbra/NrrwRgn'
        "Plug 'stefandtw/quickfix-reflector.vim'
        Plug 'kassio/neoterm', Cond(has('nvim'))    | " a terminal for neovim; :T ls, # exit terminal mode by <c-\\><c-n>
        Plug 'junegunn/vim-easy-align'    | " selected and ga=
        Plug 'huawenyu/c-utils.vim'
        Plug 'huawenyu/taboo.vim'
        Plug 'thinca/vim-quickrun'
        Plug 'wsdjeg/SourceCounter.vim'
        "Plug 'junegunn/goyo.vim'
    "}}}
"}}}

" Integration {{{2
    Plug 'cohama/agit.vim'    | " :Agit show git log like gitk
    Plug 'tpope/vim-fugitive' | " Awesome git wrapper
    "Plug 'juneedahamed/svnj.vim'
    Plug 'juneedahamed/vc.vim'| " Support git, svn, ...
    Plug 'sjl/gundo.vim'
    Plug 'mattn/webapi-vim'
    Plug 'mattn/gist-vim'        | " :'<,'>Gist -e 'list-sample'

    " share copy/paste between vim(""p)/tmux
    Plug 'roxma/vim-tmux-clipboard'
    Plug 'huawenyu/vimux-script'
    Plug 'yuratomo/w3m.vim'
    Plug 'nhooyr/neoman.vim', Cond(has('nvim'))    | " :Nman printf, :Nman printf(3)
    Plug 'szw/vim-dict'
"}}}

" AutoComplete {{{2
    "Plug 'ervandew/supertab'
    Plug 'Shougo/deoplete.nvim', Cond(has('nvim'))         | "{ 'do': ':UpdateRemotePlugins' }
    Plug 'Shougo/neosnippet.vim', Cond(has('nvim'))        | " c-k apply code, c-n next, c-p previous
    Plug 'Shougo/neosnippet-snippets', Cond(has('nvim'))
    Plug 'honza/vim-snippets'
    "Plug 'vim-scripts/CmdlineComplete'
    Plug 'reedes/vim-wordy'
"}}}


" Debug {{{2
    Plug 'tpope/vim-scriptease'
    Plug 'huawenyu/vimlogger'
    "Plug 'huawenyu/Decho'
"}}}
call plug#end()


" Configure {{{1}}}
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
set ttyfast
"set autoread

" syntax enable
syntax on
set background=dark
set t_Co=256

colorscheme holokai
"colorscheme badwolf
"colorscheme distinguished
"colorscheme darkspectrum
"colorscheme molokai
"colorscheme jellybeans
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
set esckeys         " Allow cursor keys in insert mode
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
set nowrap
set nobackup
set noswapfile
set nowritebackup
set noshowmode
set nomodeline
set nowrapscan
set showbreak=↪ |"⇇
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

" which will cause vimgrep ignore
set wildignore+=*.so,*.swp,*.zip,*/vendor/*,*/\.git/*,*/\.svn/*,objd/**,obj/**,*.tmp
set wildignore+=*.o,*.obj,.hg,*.pyc,.git,*.rej,*.orig,*.gcno,*.rbc,*.class,.svn,coverage/*,vendor
set wildignore+=*.gif,*.png,*.map
set wildignore+=*.d

" viminfo {{{2}}}
 " Tell vim to remember certain things when we exit
 "  !    :  The uppercase global VARIABLE will saved
 "  '30  :  marks will be remembered for up to 10 previously edited files
 "  "300 :  will save up to 100 lines for each register
 "  :30  :  up to 20 lines of command-line history will be remembered
 "  %    :  saves and restores the buffer list
 "  n... :  where to save the viminfo files,
 "            here save to /tmp means we have another viminfo manager 'workspace'
if has("nvim")
  set viminfo=!,'30,\"30,:30,%,n~/.nviminfo
else
  "set viminfo=!,'30,\"300,:30,%,n/tmp/viminfo
  set viminfo='30,\"30,:30,n~/.viminfo
endif

" Restore cursor {{{2}}}
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
  " Enter to go to end of file, Backspace to go to beginning of file.
  "nnoremap <CR> G
  "nnoremap <BS> gg

"set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words

" vimfiler {{{2}}}
let g:vimfiler_as_default_explorer = 1
"let g:signify_vcs_list = [ 'git', 'svn' ]

" tabular {{{2}}}

" neocomplcache {{{2}}}
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" vim-rooter
let g:rooter_manual_only = 1
let g:rooter_patterns = ['Rakefile', '.git', '.git/', '.svn', '.svn/']

" neomake: make & asynrun
let g:neomake_open_list = 1
let g:neomake_place_signs = 1
"let g:neomake_verbose = 3
"let g:neomake_logfile = './log.make'
let g:neomake_warning_sign = {
  \ 'text': 'W',
  \ 'texthl': 'WarningMsg',
  \ }
let g:neomake_error_sign = {
  \ 'text': 'E',
  \ 'texthl': 'ErrorMsg',
  \ }

" fuzzy
"let g:fuzzy_file_list = ["cscope.files"]
"let g:fuzzy_file_tag = ['tags.x', '.tags.x']

" supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" easymotion {{{2
  let g:EasyMotion_do_mapping = 0 " Disable default mappings

  " Jump to anywhere you want with minimal keystrokes, with just one key binding.
  " `s{char}{label}`
  nmap s <Plug>(easymotion-overwin-f)

  " or
  " `s{char}{char}{label}`
  " Need one more keystroke, but on average, it may be more comfortable.
  "nmap s <Plug>(easymotion-overwin-f2)
"}}}

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
nnoremap ga <Plug>(EasyAlign)

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

" Buffergator
let g:buffergator_suppress_keymaps = 1
let g:buffergator_suppress_mru_switch_into_splits_keymaps = 1
let g:buffergator_autoupdate = 1
let g:buffergator_autodismiss_on_select = 0
let g:buffergator_autoexpand_on_split = 0
let g:buffergator_vsplit_size = 25
"let g:buffergator_viewport_split_policy = 'L'   |" L, R, T, B, n/N
let g:buffergator_show_full_directory_path = 0
let g:buffergator_mru_cycle_loop = 0
let g:buffergator_mru_cycle_local_to_window = 1
let g:buffergator_sort_regime = 'filepath'
"let g:buffergator_display_regime = 'basename'

" voom {{{3}}}
let g:voom_tree_width = 45
let g:voom_tree_placement = 'right'

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

let g:tlTokenList = ["FIXME @wilson", "TODO @wilson", "XXX @wilson"]
let g:ctrlsf_mapping = { "next": "n", "prev": "N", }

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

" plasticboy/vim-markdown {{{2
  "set conceallevel=0
  "let g:vim_markdown_conceal = 1
  "let g:vim_markdown_toc_autofit = 1
  "
  let g:vim_markdown_folding_disabled = 1
  let g:vim_markdown_override_foldtext = 0
  let g:vim_markdown_folding_level = 6
  let g:vim_markdown_folding_style_pythonic = 1
  "
  let g:vim_markdown_emphasis_multiline = 0
  let g:vim_markdown_new_list_item_indent = 2
  let g:vim_markdown_no_default_key_mappings = 1
  let g:vim_markdown_json_frontmatter = 1
  let g:vim_markdown_fenced_languages = ['C=c', 'c=c', 'Shell=sh', 'Java=java'
        \ , 'Csharp=cs', 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']
"}}}

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
      nnoremap <leader>a= :Tabularize /=<CR>
      vmap <leader>a= :Tabularize /=<CR>
      nnoremap <leader>a: :Tabularize /:\zs<CR>
      vmap <leader>a: :Tabularize /:\zs<CR>
    endif
"}}}

" Commands {{{1

command! -nargs=* Wrap set wrap linebreak nolist
"command! -nargs=* Wrap PencilSoft
"command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
command! -nargs=+ -bang -complete=shellcmd
      \ Make execute ':NeomakeCmd make '. <q-args>

command! -nargs=1 Silent
  \ | execute ':silent !'.<q-args>
  \ | execute ':redraw!'

command! -nargs=* C0  setlocal autoindent cindent expandtab   tabstop=4 shiftwidth=4 softtabstop=4
command! -nargs=* C08 setlocal autoindent cindent expandtab   tabstop=8 shiftwidth=2 softtabstop=8
command! -nargs=* C2  setlocal autoindent cindent expandtab   tabstop=2 shiftwidth=2 softtabstop=2
command! -nargs=* C4  setlocal autoindent cindent noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
command! -nargs=* C8  setlocal autoindent cindent noexpandtab tabstop=8 shiftwidth=8 softtabstop=8

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
       let exp_height = max([min([n_lines, a:maxheight]), a:minheight])
       if (abs(winheight(0) - exp_height)) > 2
           exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
       endif
   endfunction

   " Maximizes the current window if it is not the quickfix window.
   function! SetIndentTabForCfiletype()
       " auto into terminal-mode
       if &buftype == 'terminal'
           startinsert
           return
       elseif &buftype == 'quickfix'
           call AdjustWindowHeight(2, 10)
           return
       endif

       let my_ft = &filetype
       if (my_ft == "c" || my_ft == "cpp" || my_ft == "diff" )
           execute ':C8'

           " The 'NonText' highlighting will be used for 'eol', 'extends' and 'precedes'  
           " The 'SpecialKey' for 'nbsp', 'tab' and 'trail'.
           hi NonText          ctermfg=238
           hi SpecialKey       ctermfg=238
       endif
   endfunction

   augroup fieltype_automap
       " Voom:
       " <Enter>             selects node the cursor is on and then cycles between Tree and Body.
       " <Tab>               cycles between Tree and Body windows without selecting node.
       " <C-Up>, <C-Down>    move node or a range of sibling nodes Up/Down.
       " <C-Left>, <C-Right> move nodes Left/Right (promote/demote).
       "
       autocmd!
       "autocmd VimLeavePre * cclose | lclose
       autocmd InsertEnter,InsertLeave * set cul!
       " current position in jumplist
       autocmd CursorHold * normal! m'

       autocmd BufEnter * call SetIndentTabForCfiletype()
       autocmd BufNewFile,BufRead *.json set ft=javascript
       autocmd BufNewFile,BufRead *.c.rej,*.c.orig,h.rej,*.h.orig,patch.*,*.diff,*.patch set ft=diff
       autocmd BufWritePre [\,:;'"\]\)\}]* throw 'Forbidden file name: ' . expand('<afile>')

       autocmd filetype markdown nnoremap <buffer> <a-o> :VoomToggle markdown<CR>
       autocmd filetype python   nnoremap <buffer> <a-o> :VoomToggle python<CR>
       autocmd FileType qf call AdjustWindowHeight(2, 10)
       autocmd Filetype c,cpp,diff C8
       autocmd Filetype zsh,bash C2
       autocmd Filetype vim,markdown C08

       autocmd filetype log nnoremap <buffer> <leader>la :call log#filter(expand('%'), 'all')<CR>
       autocmd filetype log nnoremap <buffer> <leader>le :call log#filter(expand('%'), 'error')<CR>
       autocmd filetype log nnoremap <buffer> <leader>lf :call log#filter(expand('%'), 'flow')<CR>
       autocmd filetype log nnoremap <buffer> <leader>lt :call log#filter(expand('%'), 'tcp')<CR>
   augroup END

"}}}
"}}}


" Key maps {{{1}}}
  let mapleader = "\<Space>"
  " diable Ex mode
  map Q <Nop>
  " Stop that stupid window from popping up
  map q: :q
  nnoremap <C-c> <silent> <C-c>
  nnoremap <buffer> <Enter> <C-W><Enter>
  nnoremap <C-q> :<c-u>qa!<cr>
  inoremap <S-Tab> <C-V><Tab>

  " when wrap, move by virtual row
  nnoremap j gj
  nnoremap k gk

  " Substitue for MaboXterm diable <c-h>
  nnoremap <leader>h <c-w>h

  nnoremap <c-h> <c-w>h
  nnoremap <c-j> <c-w>j
  nnoremap <c-k> <c-w>k
  nnoremap <c-l> <c-w>l

  if has("nvim")
    let b:terminal_scrollback_buffer_size = 2000
    let g:terminal_scrollback_buffer_size = 2000

    tnoremap <c-h> <C-\><C-n><C-w>h
    tnoremap <c-j> <C-\><C-n><C-w>j
    tnoremap <c-k> <C-\><C-n><C-w>k
    tnoremap <c-l> <C-\><C-n><C-w>l
  endif

  " Automatically jump to end of text you pasted
  "vnoremap <silent> y y`]
  vnoremap <silent> p p`]
  nnoremap <silent> p p`]
  " Paste in insert mode
  inoremap <silent> <a-p> <c-r>"

  " vp doesn't replace paste buffer
  function! RestoreRegister()
      let @" = s:restore_reg
      let @+ = s:restore_reg | " sometime other plug use this register as paste-buffer
      return ''
  endfunction
  function! s:Repl()
      let s:restore_reg = @"
      return "p@=RestoreRegister()\<cr>"
  endfunction
  vnoremap <silent> <expr> p <sid>Repl()

  nnoremap <silent> <a-o> :VoomToggle<cr>
  nnoremap <silent> <a-w> :MaximizerToggle<CR>
  nnoremap <silent> <a-e> :NERDTreeToggle<cr>
  nnoremap <silent> <a-f> :NERDTreeFind<cr>
  nnoremap <silent> <a-t> :TlistToggle<CR>
  nnoremap <silent> <a-i> :BuffergatorToggle<cr>
  nnoremap <silent> <a-u> :GundoToggle<CR>

  nnoremap <silent> <a-n> :lnext<cr>
  nnoremap <silent> <a-p> :lpre<cr>
  nnoremap <silent> <c-n> :cn<cr>
  nnoremap <silent> <c-p> :cp<cr>

  nnoremap <silent> <leader>n :cn<cr>
  nnoremap <silent> <leader>p :cp<cr>

  function! s:JumpI(mode)
      if v:count == 0
          if a:mode
              let ans = input("FuzzySymbol ", utils#GetSelected(''))
              exec 'FuzzySymb '. ans
          else
              FuzzySymb
          endif
      else
      endif
  endfunction
  function! s:JumpO(mode)
      if v:count == 0
          if a:mode
              let ans = input("FuzzyOpen ", utils#GetSelected(''))
              exec 'FuzzyOpen '. ans
          else
              FuzzyOpen
          endif
      else
          exec ':silent! b'. v:count
      endif
  endfunction
  function! s:JumpH(mode)
  endfunction
  function! s:JumpJ(mode)
      if v:count == 0
          if a:mode
              let ans = input("FuzzyFunction ", utils#GetSelected(''))
              exec 'FuzzyFunc '. ans
          else
              FuzzyFunc
          endif
      else
          exec 'silent! '. v:count. 'wincmd w'
      endif
  endfunction
  function! s:JumpK(mode)
      if v:count == 0
      else
          exec 'normal! '. v:count. 'gt'
      endif
  endfunction
  function! s:JumpComma(mode)
      if v:count == 0
          silent call utils#Declaration()
      else
      endif
  endfunction

  " Must install fzy tool(https://github.com/jhawthorn/fzy)
  nnoremap <silent> <leader>i  :<c-u>call <SID>JumpI(0)<cr>
  vnoremap          <leader>i  :<c-u>call <SID>JumpI(1)<cr>
  nnoremap <silent> <leader>o  :<c-u>call <SID>JumpO(0)<cr>
  vnoremap          <leader>o  :<c-u>call <SID>JumpO(1)<cr>
  "nnoremap <silent> <leader>h  :<c-u>call <SID>JumpH(0)<cr>
  "vnoremap          <leader>h  :<c-u>call <SID>JumpH(1)<cr>
  nnoremap <silent> <leader>j  :<c-u>call <SID>JumpJ(0)<cr>
  vnoremap          <leader>j  :<c-u>call <SID>JumpJ(1)<cr>
  nnoremap          <leader>k  :ls<cr>:b<Space>
  nnoremap <silent> <leader>;  :<c-u>call <SID>JumpComma(0)<cr>
  vnoremap          <leader>;  :<c-u>call <SID>JumpComma(1)<cr>

  nnoremap <silent> <leader>a  :<c-u>FuzzyOpen <C-R>=printf("%s\\.", expand('%:t:r'))<cr><cr>

  nnoremap <silent> <leader>ll :<c-u>call log#log(expand('%'))<CR>
  vnoremap <silent> <leader>ll :<c-u>call log#log(expand('%'))<CR>

  nnoremap          <leader>bb :VCBlame<cr>

  nnoremap <silent> <leader>v] :NeomakeSh! tagme<CR>
  nnoremap <silent> <leader>vi :call utils#VoomInsert(0) <CR>
  vnoremap <silent> <leader>vi :call utils#VoomInsert(1) <CR>

  nnoremap <silent> <leader>vv :<C-\>e utilgrep#Grep(1,0)<cr><cr>
  vnoremap <silent> <leader>vv :<C-\>e utilgrep#Grep(1,1)<cr><cr>
  nnoremap <leader>vr :Replace <C-R>=expand('<cword>') <CR> <C-R>=expand('<cword>') <cr>
  vnoremap <leader>vr :<C-\>e tmp#CurrentReplace() <CR>


  vnoremap <silent> <leader>ee :<c-u>call vimuxscript#ExecuteSelection(1)<CR>
  nnoremap <silent> <leader>ee :<c-u>call vimuxscript#ExecuteSelection(0)<CR>
  nnoremap <silent> <leader>eg :<c-u>call vimuxscript#ExecuteGroup()<CR>

  vnoremap <silent> <leader>yy :<c-u>call utils#GetSelected("/tmp/vim.yank")<CR>
  nnoremap <silent> <leader>yy  :<c-u>call vimuxscript#Copy() <CR>
  nnoremap <silent> <leader>yp :r! cat /tmp/vim.yank<CR>

  xnoremap * :<C-u>call utils#VSetSearch('/')<CR>/<C-R>=@/<CR>
  xnoremap # :<C-u>call utils#VSetSearch('?')<CR>?<C-R>=@/<CR>
  vnoremap // y:vim /\<<C-R>"\C/gj %

  " execute file that I'm editing in Vi(m) and get output in split window
  nnoremap <silent> <leader>x :w<CR>:silent !chmod 755 %<CR>:silent !./% > /tmp/vim.tmpx<CR>
              \ :tabnew<CR>:r /tmp/vim.tmpx<CR>:silent !rm /tmp/vim.tmpx<CR>:redraw!<CR>

  vnoremap v <Plug>(expand_region_expand)
  vnoremap <a-v> <Plug>(expand_region_shrink)

  " Search-mode: hit cs, replace first match, and hit <Esc>
  "   then hit n to review and replace
  vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
        \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
  onoremap s :normal vs<CR>

  nnoremap gf :call utils#GotoFileWithLineNum()<CR>
  nnoremap gsf :sp<CR>:call utils#GotoFileWithLineNum()<CR>

  "map <leader>ds :call Asm() <CR>
  nnoremap <leader>dd :g/<C-R><C-w>/ norm dd
  nnoremap <leader>de  :g/.\{200,\}/d

  nnoremap <leader>qw :R! ~/tools/dict <C-R>=expand('<cword>') <cr>
  nnoremap <leader>qs :QSave
  nnoremap <leader>ql :QLoad
  nnoremap <leader>qf :call utilquickfix#QuickFixFilter() <CR>
  nnoremap <leader>qq :call utilquickfix#QuickFixFunction() <CR>

  function! s:R(cap, ...)
      if a:cap
          tabnew
          setlocal buftype=nofile bufhidden=hide syn=diff noswapfile
          exec ":r !". join(a:000)
      else
          tabnew | enew | exec ":term ". join(a:000)
      endif
  endfunction
  " :R ls -l   grab command output int new buffer
  " :R! ls -l   only show output in another tab
  command! -nargs=+ -bang -complete=shellcmd R call s:R(<bang>1, <q-args>)

  "bookmark
  nnoremap <leader>mm :call mark#MarkCurrentWord(expand('cword'))<CR>
  "nnoremap <leader>mo :BookmarkLoad Default
  "nnoremap <leader>ma :BookmarkShowAll <CR>
  "nnoremap <leader>mg :BookmarkGoto <C-R><c-w>
  "nnoremap <leader>mc :BookmarkDel <C-R><c-w>

"}

" VimL Debug{{{1
  silent! call logger#init('ALL', ['/tmp/vim.log'])
  "silent! call logger#init('ERROR', ['/tmp/vim.log'])

  "   " in .vimrc
  "   call logger#init('ALL', ['/dev/stdout', '~/.vim/log.txt'])
  "
  "   " in script
  "   silent! let s:log = logger#getLogger(expand('<sfile>:t'))
  "
  "   " start logger
  "   silent! call s:log.info('hello world')
"}}}

