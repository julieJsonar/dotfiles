" Installation:
" =============
" 1. Vim plugin manager:
"	<https://github.com/gmarik/vundle>
"	$ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
"	... copy vimrc from vundle's page ...
"	... open vim to sure everything OK! ...
" 2. update the basic vimrc to this one
"	... then, open vim, command :BundleInstall ...
"	... Done! ...
"
" Usage:
" ======
" <leader> is ";"
"
" R !ls -l		grab command output into new tab/buffer
" gd <or> D		goto declare <or> global declare
" g; <or> g,	navigate changelist
" <space>		open preview window, then <c-w>H adjust layout
" <leader><space>open file in preview window, then <c-w>H adjust layout
" <leader>m		color word, :MarkClear to clear all colors
" <leader>j		color word and count it
" <leader>e		dictionary
" <leader>l		view function name
" <leader>a		switch .c/.h
" <leader>t		command-T: search file
" <leader>g		grep, replace :ptag # if use <leader>s will conflict witch <leader>swp: AnsiEsc:call SaveWinPosn()
" <leader>s		grep struct malloc, conflict witch <leader>swp: AnsiEsc:call SaveWinPosn()
" <leader>y		copy to clipboard, paste use shift+insert
" <leader>n		toggle taglist
" <leader>z		syntax log file: toggle comment
" <leader>w		notes on source, then view by :cfile log.marks as quickfix
" <leader>rr	R run current line or selected, <leader>c to close current tab
" <leader>g ,.	preview definition with ctags: pta, ptn, ptp
"
" call Asm()	disassembly current function
" <leader>bs	svn blame	
" <leader>bg	git blame
"
" <C-n|p>; <leader>,|;> 	jumps quickfix
" <F2>			use plantuml gen uml image and display image: the block between @startuml and @enduml, Pre-install plantuml.jar, java, ImageMagic
" <leader>i 	use plantuml gen uml as acsii
" <F3>			redirect g command output tabn
"
" <leader>f[f|g|s|  c|d]		cs find seriese, :!cscope -[R]kbq; :cs reset
" <leader><leader>w|b <or> fx	easy motion to word
" :g/regex/t$					copy match lines append to tail
"
" Howtos:
" =======
" > Access register from command or script:
" :@+		<<< have @ as prefix, then add register's name
"
" > commandline using vimscript's function:
" :<C-\>eYourFunc() <CR>		<<< use YourFunc() return to replace all current command
"
" > Batch process files:
" :Traceadd|adjust|clear()		_WAD_TRACE_
"
" > Draw topoligy:
" DrawIt:		use \di to start (\ds to stop)
"
" CrashLog		:call Tracecrash()	resolve fgt's crashlog
"
" > Save workplace:
" :mksession! log.vim.session	<<< Save Session
" $ vi -S log.vim.session		<<< Load Session
"======================================================================
set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" My Bundles here: samples
" ****vim-scripts repos
"Bundle 'FuzzyFinder'
" ****non github repos
" ****git repos on your local machine (ie. when working on your own plugin)
"Bundle 'file:///Users/gmarik/path/to/plugin'
Bundle 'darkspectrum'
Bundle 'holokai'
Bundle 'tomasr/molokai'

Bundle 'a.vim'
Bundle 'file-line'
Bundle 'DrawIt'
"Bundle 'netrw.vim'
"Bundle 'Raimondi/delimitMate'
Bundle 'majutsushi/tagbar'
"Bundle 'fholgado/minibufexpl.vim'
Bundle 'millermedeiros/vim-statline'
Bundle 'Lokaltog/vim-easymotion'
"Bundle 'Shougo/vimproc.vim'

Bundle 'Mark'
"Bundle 'AnsiEsc.vim'
"Bundle 'scrooloose/syntastic'
Bundle 'aklt/plantuml-syntax'
Bundle 'elzr/vim-json'
Bundle 'Glench/Vim-Jinja2-Syntax'
Bundle 'plasticboy/vim-markdown'

"Bundle 'Shougo/unite.vim'
"Bundle 'OmniCppComplete'
"Bundle 'L9'
"Bundle 'AutoComplPop'
" yum -y install rake ruby-devel rubygems; cd ~/.vim/bundle/Command-T; rake make
Bundle 'wincent/Command-T'

" ...
" Not very good, slower your vim
" https://github.com/Valloric/YouCompleteMe
" 0. install python-devel, cmake
" 1. install ycm plugin
" 2. download llvm3.3. binary from http://llvm.org/releases/download.html#3.3
" 3. unzip into ~/ycm_temp/llvm_root_dir; ls | grep lib
" 4. mkdir ~/ycm_build; cd ~/ycm_build;
"    cmake -G "Unix Makefiles" -DPATH_TO_LLVM_ROOT=~/ycm_temp/llvm_root_dir . ~/.vim/bundle/YouCompleteMe/cpp
"    make ycm_support_libs
" 5. vimrc:
"    let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'
"    let g:ycm_autoclose_preview_window_after_completion=1
"    nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
"Bundle 'Valloric/YouCompleteMe'

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

"
" Wilson's config from here:
set nocompatible
hi CursorLine guibg=Grey40
set nomodeline
set hidden
set guifont=Liberation\ Mono\ 13
" Disable any use of bold fonts
set t_md=

syntax enable
"colorscheme darkspectrum
"colorscheme molokai
colorscheme holokai
set background=dark

" support mouse click-jump and window-active
set mouse=a	
set mousefocus

set noshowmatch
set nolist
set clipboard+=unnamed
set foldmethod=manual

set backspace=indent,eol,start
set ignorecase
set wildignorecase
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
set nostartofline	" keep cursor position when switch buffers

"set autochdir       " if work with shell or cscope, please not change work-dir
set sessionoptions-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds
set ssop-=curdir     " do not store absolute path
set ssop+=sesdir     " work under current dir as relative path


"set path=~/nbapp/**	" allows me to search in my project directory and subdirectories
"set backupdir=~/nbapp/temp		" makes vim create backup files in a special temporary folder

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

"set listchars=nbsp:.,tab:>-,trail:~,extends:>,precedes:<
"set listchars=tab:>.,trail:~,extends:<,nbsp:.
" The characters after tab is U+2002. in vim with Ctrl-v u 2 0 0 2 (in insert mode).
"set listchars=tab:> ,trail:~,extends:<,nbsp:.
set listchars=tab:»\ ,trail:~,extends:<,nbsp:.
"hi NonText ctermfg=7 guifg=Gray
hi NonText ctermfg=DarkGrey guifg=DarkGrey
hi clear SpecialKey
hi link SpecialKey NonText

filetype plugin indent on
cmap w!! w !sudo tee % >/dev/null
autocmd InsertEnter,InsertLeave * set cul!

" abbrev. of messages (avoids 'hit enter')
set shortmess+=a

" do not display the current mode
set noshowmode

" min num of lines to keep above/below the cursor
set scrolloff=1

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

" nowrap long lines
set nowrap

let mapleader = ";"
map Q <Nop>			" diable Ex mode

vmap <leader>y   "+y
" delete/paste without overwriting the last yank
"" delete without yanking
"nnoremap <leader>d "_d
"vnoremap <leader>d "_d
" replace currently selected text with default register without yanking it
vnoremap <leader>p "_dP

"vmap <leader>y   :<c-u>!echo '<c-r>*' \| tr -d '\n' \| xsel <cr><cr>
" make p in Visual mode replace the selected text with the yank register
"vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" switch between tabs
"let g:lasttab = 1
"nmap <Leader>t :exe "tabn ".g:lasttab<CR>
"au TabLeave * let g:lasttab = tabpagenr()

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

" split normal
set splitbelow
set splitright
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" ctags -R *;  ctags -L cscope.files
nmap <leader>g :ptag <C-R>=expand("<cword>")<CR><CR>
nmap <silent> <leader>, :ptnext<cr>
nmap <silent> <leader>. :ptprevious<cr>
" open function declare in preview windows
" open function declare in the side windows
" copy word to other windows new line
nmap <silent> <space> <c-w>}<c-w>Pzt<c-w><c-p>
"nmap <silent> ;l mxviw<c-w>lmx:<c-u>cs f g <c-r>*<cr>zz<c-w><c-p>`x
"nmap <silent> ;h mxviw<c-w>hmx:<c-u>cs f g <c-r>*<cr>zz<c-w><c-p>`x
"nmap <silent> ;p mxviwy<c-w>lmxo<ESC>p<c-w><c-p>`x

" TAB conflict with ctrl-i
nnoremap <silent> <leader>q :e #<cr>
nmap     <silent> <leader>j <leader>mmxviw:<c-u>%s/<c-r>*/&/gn<cr>:noh<cr>`x
nnoremap <silent> <leader>a :A<cr>

" vimgrep exclude dir
set wildignore+=*/kernel/**
set wildignore+=*/linux-2.4.25/**
set wildignore+=*/linuxatm/**
set wildignore+=*/cooked/**
set wildignore+=*/router/**

set grepprg=grep
function! GrepCurrent()
  return   "R !grep -Enr --include='*.[ch]' -- '" . @* . "' daemon/wad"
endfunction
map <leader>g :<C-\>eGrepCurrent() <CR>
map <leader>s :<c-u>R !grep-malloc.sh <c-r>*
nnoremap <silent> <F3> :redir @a<CR>:g//<CR>:redir END<CR>:tabnew<CR>:put! a<CR>

function! GenUml()
  " remember pos
  exec ":normal mz"
  let startuml = search("@startuml", 'bW')
  let enduml = search("@enduml", 'W')
  " jump back
  exec ":normal `z"
  return   startuml . "," . enduml . ":w !java -jar ~/script/plantuml.jar -pipe > /tmp/uml.png && display -window 1 -remote /tmp/uml.png || display /tmp/uml.png"
endfunction
nnoremap <silent> <F2> ::<C-\>eGenUml() <CR><CR><CR>

function! GenUmlAscii()
  " remember pos
  exec ":normal mz"
  let startuml = search("@startuml", 'bW')
  let enduml = search("@enduml", 'W')
  " jump back
  exec ":normal `z"
  return   startuml . "," . enduml . ":w !java -jar ~/script/plantuml.jar -p -ttxt"
endfunction
nnoremap <silent> <leader>i ::<C-\>eGenUmlAscii() <CR>

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

" precondition: cursor stop at begin brace
" auto insert _WAD_TRACE_; into function's enter
fun! InsertTraceLine()
	let stringtrace = ":normal o\<TAB>_WAD_TRACE_;\<ESC>"
	if search('\<_WAD_TRACE_', 'pnc', (line(".")+2)) == 0
		exec stringtrace
	endif
endfun

" precondition: cursor stop at begin brace
fun! InsertTraceMsg(msg)
	let stringtrace = ":normal o\<TAB>" . a:msg . "\<ESC>"
	if search(a:msg, 'pnc', (line(".")+2)) == 0
		exec stringtrace
	endif
endfun

fun! InsertTraceFile()
	exec ":normal gg"
	exec ":normal ]]"
	while search('{', 'pnc', line(".")) > 0
		" macro define
		if search('\\', 'pnc', line(".")) > 0
		"
		else
			exec ":normal %"
			" struct definition or inline function
			if search('\(}.*,\)\|\(}.*;\)', 'pnc', line(".")) > 0
				exec ":normal %"
				if search('\<inline\>', 'pnbc', (line(".")-1)) > 0
					call InsertTraceLine()
				endif
			else
				exec ":normal %"
				call InsertTraceLine()
			endif
		endif
		exec ":normal ]]"
	endwhile
endfun

fun! InsertTraceAll(action)
	" adjust(clear) specific function
	if a:action == "adjust"
		if filereadable($HOME . "/script/trace.func.del")
			exec ":silent e ~/script/trace.func.del"
			exec ":silent g/^\_s$/normal dd"
			exec ":silent g/(/normal f(d$"
			for line in range(line("1"),line("$"))
				if !empty(getline(line))
					let stringcmd = ":tjump " . getline(line)
					"echom stringcmd
					exec stringcmd
					if search('\s_WAD_TRACE_', 'c', (line(".")+4)) > 0
						exec ":silent .g/_WAD_TRACE_/norm I//"
					endif
					exec ":silent b ~/script/trace.func.del"
				endif
			endfor
		endif

		if filereadable($HOME . "/script/trace.func.add")
			exec ":silent e ~/script/trace.func.add"
			exec ":silent g/^\_s$/normal dd"
			exec ":silent g/(/normal f(d$"
			for line in range(line("1"),line("$"))
				if !empty(getline(line))
					let stringcmd = ":cs f g " . getline(line)
					"echom stringcmd
					exec stringcmd
					if search('\s_WAD_TRACE_', 'c', (line(".")+3)) > 0
						exec ":silent .g/_WAD_TRACE_/norm dd"
					endif

					exec stringcmd
					if search('^{', 'c', (line(".")+2)) > 0
						call InsertTraceLine()
					endif

					exec ":silent b ~/script/trace.func.add"
				endif
			endfor
		endif

		" DEBUG: add memset to free, force crash
		if filereadable("daemon/wad/wad_memtrack.c")
			exec ":silent e daemon/wad/wad_memtrack.c"
			exec ":silent normal gg"
			if search('\swad_memtrack_free') > 0
				exec ":silent normal ]]"
				call InsertTraceMsg("memset(ptr, 0, size);")
			endif
		endif

		exec ":wa"
		exec ":qa"
		echo "All Done!"
		return
	endif

	" check process file list exist
	if !filereadable($HOME . "/script/trace.files")
		echo $HOME . "/script/trace.files not exists"
		return
	endif

	if !filereadable("daemon/wad/ui/fg/wad_ui.c")
				\ || !filereadable("daemon/wad/ui/fg/wad_debug_impl.h")
				\ || !filereadable("daemon/wad/ui/fg/wad_debug_impl.c")
		echo "wad_ui.c wad_debug_impl.[ch] not exists, exit!"
		return
	endif

	" insert trace init
	exec ":silent e daemon/wad/ui/fg/wad_ui.c"
	exec ":normal gg"
	if a:action == "clear"
		exec ":silent g/_WAD_TRACE_/norm dd"
	else
		if search("wad_ui_main") > 0
			exec ":normal ]]"
			let stringtrace = ":normal o\<TAB>_WAD_TRACE_INIT_;\<ESC>"
			if search('\<_WAD_TRACE_', 'pnc', (line(".")+2)) == 0
				exec stringtrace
			endif
		endif
	endif

	" insert trace implement
	exec ":silent e daemon/wad/ui/fg/wad_debug_impl.h"
	exec ":normal gg"
	if a:action == "clear"
		if search("begin-wad-trace") > 0
			exec ":normal ma"
			if search("end-wad-trace") > 0
				exec ":normal mb"
				exec ":'a,'bd"
			endif
		endif
	else
		if search(" WAD_TRACE(") == 0
			if search(" WAD_DEBUG(") == 0
				echo "debug_impl.h have no WAD_TRACE or WAD_DEBUG, exit!"
			endif
		endif
		if search("wad_trace_backtrace_init", 'n') == 0
			exec "/^\s*$"
			exec "r! cat ~/script/trace.macro.def"
		endif
	endif

	exec ":silent e daemon/wad/ui/fg/wad_debug_impl.c"
	exec ":normal gg"
	if a:action == "clear"
		if search("begin-wad-trace") > 0
			exec ":normal ma"
			if search("end-wad-trace") > 0
				exec ":normal mb"
				exec ":'a,'bd"
			endif
		endif
	else
		if search("wad_trace_backtrace_init", 'n') == 0
			exec ":normal G"
			exec "r! cat ~/script/trace.macro.imp"
		endif
	endif

	" insert trace log
	" avoid dead loop
	exec ":silent e ~/script/trace.files"
	exec ":silent g/wad_debug_impl/normal dd"
	exec ":silent g/wad_ui.c/normal dd"
	exec ":silent g/^\_s$/normal dd"
	for line in range(line("1"),line("$"))
		let stringfile = getline(line)
		if filewritable(stringfile)
			exec ":silent e " . stringfile
			if a:action == "clear"
				exec ":silent g/_WAD_TRACE_/norm dd"
			else
				call InsertTraceFile()
			endif
			exec ":silent b ~/script/trace.files"
		endif
	endfor

	if a:action == "clear"
		if filereadable($HOME . "/script/trace.func.add")
			exec ":silent e ~/script/trace.func.add"
			exec ":silent g/^\_s$/normal dd"
			exec ":silent g/(/normal f(d$"
			for line in range(line("1"),line("$"))
				if !empty(getline(line))
					let stringcmd = ":cs f g " . getline(line)
					"echom stringcmd
					exec stringcmd
					if search('\s_WAD_TRACE_', 'c', (line(".")+3)) > 0
						exec ":silent .g/_WAD_TRACE_/norm dd"
					endif
					exec ":silent b ~/script/trace.func.add"
				endif
			endfor
		endif

		"remove: call InsertTraceMsg("memset(ptr, 0, size);")
		if filereadable("daemon/wad/wad_memtrack.c")
			exec ":silent e daemon/wad/wad_memtrack.c"
			exec ":silent normal gg"
			if search('\swad_memtrack_free') > 0
				exec ":silent normal ]]"
				if search('\smemset', 'c', (line(".")+3)) > 0
					exec ":silent .g/memset/norm dd"
				endif
			endif
		endif
	endif

	exec ":wa"
	exec ":qa"
	echo "All Done!"
endfun

fun! Traceadd()
	call InsertTraceAll("add")
endfun
" Have you cscope first?
fun! Traceadjust()
	call InsertTraceAll("adjust")
endfun
fun! Tracedel()
	call InsertTraceAll("clear")
endfun

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

" cscope
" The following maps all invoke one of the following cscope search types:
"   's'   symbol: find all references to the token under cursor
"   'g'   global: find global definition(s) of the token under cursor
"   'c'   calls:  find all calls to the function name under cursor
"   't'   text:   find all instances of the text under cursor
"   'e'   egrep:  egrep search for the word under cursor
"   'f'   file:   open the filename under cursor
"   'i'   includes: find files that include the filename under cursor
"   'd'   called: find functions that function under cursor calls
" +ctags
"         :tags   see where you currently are in the tag stack
"         :tag sys_<TAB>  auto-complete
" http://www.fsl.cs.sunysb.edu/~rick/rick_vimrc
nmap <leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <leader>fg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>fc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <leader>ft :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <leader>fe :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <leader>ff :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <leader>fi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <leader>fd :cs find d <C-R>=expand("<cword>")<CR><CR>
"set cscopeprg=gtags-cscope
" 0 for c, 1 for c++
set csto=0

" move last to make sure valid
set cindent
set autoindent
set smartindent
set list
set paste
"set showcmd
