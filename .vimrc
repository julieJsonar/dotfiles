set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
" ****original repos on github
Bundle 'majutsushi/tagbar.git'
Bundle 'scrooloose/syntastic.git'
Bundle 'vim-scripts/netrw.vim.git'
Bundle 'tomasr/molokai.git'
Bundle 'Lokaltog/vim-easymotion.git'
Bundle 'millermedeiros/vim-statline.git'
Bundle 'fholgado/minibufexpl.vim.git'

" ****vim-scripts repos
"Bundle 'FuzzyFinder'
" ****non github repos
"Bundle 'git://git.wincent.com/command-t.git'
" ****git repos on your local machine (ie. when working on your own plugin)
"Bundle 'file:///Users/gmarik/path/to/plugin'
" ...

filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..

set nocompatible
hi CursorLine guibg=Grey40
set nomodeline
set hidden
set guifont=Liberation\ Mono\ 13
" Disable any use of bold fonts
set t_md=

syntax enable
"colorscheme darkspectrum
colorscheme molokai
set background=dark

"set autochdir      " if work with shell or cscope, please not change work-dir
set paste
xnoremap p pgvy     " when paste, not replace the yank content, so you can paste serval times with the same content

set cindent
set autoindent
set noshowmatch
set nolist
set clipboard+=unnamed
set foldmethod=manual
"set listchars=nbsp:.,tab:>-,trail:~,extends:>,precedes:<
set listchars=tab:>.,trail:~,extends:<,nbsp:.
set backspace=indent,eol,start
set ignorecase
set smartcase
set hlsearch
set incsearch
set nowrapscan
set history=1000
set undolevels=1000
set visualbell
set noerrorbells
set nobackup
set noswapfile
set t_vb=
filetype plugin indent on
cmap w!! w !sudo tee % >/dev/null
autocmd InsertEnter,InsertLeave * set cul!

" abbrev. of messages (avoids 'hit enter')
set shortmess+=a

" display the current mode
set noshowmode

" min num of lines to keep above/below the cursor
set scrolloff=2

" disable the line numbering column
"set nonumber

" also ignore these while opening and filtering
set wildignore+=.hg,*.pyc

" a tab is 4 spaces
set tabstop=4

" autoindent is 4 spaces
set shiftwidth=4

" the text width
set textwidth=79

" wrap long lines
set nowrap

vmap <leader>y "+y 
nnoremap <leader>p "+p

map <leader>n :TagbarToggle<cr>
let g:miniBufExplSplitToEdge = 1
let g:miniBufExplorerAutoStart = 1

nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

"switch between two file
map <TAB>  :e#<CR>

" quickfix autofit
nnoremap <buffer> <Enter> <C-W><Enter>
au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

"cscope
" The following maps all invoke one of the following cscope search types:
"
"   's'   symbol: find all references to the token under cursor
"   'g'   global: find global definition(s) of the token under cursor
"   'c'   calls:  find all calls to the function name under cursor
"   't'   text:   find all instances of the text under cursor
"   'e'   egrep:  egrep search for the word under cursor
"   'f'   file:   open the filename under cursor
"   'i'   includes: find files that include the filename under cursor
"   'd'   called: find functions that function under cursor calls
nmap <leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <leader>fg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>fc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <leader>ft :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <leader>fe :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <leader>ff :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <leader>fi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <leader>fd :cs find d <C-R>=expand("<cword>")<CR><CR>

