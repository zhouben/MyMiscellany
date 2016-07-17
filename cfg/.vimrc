set nocompatible

"Set to auto read when a file is changed from the outside
set autoread

if has('mouse')
  set mouse=a
endif

"Enable syntax hl
syntax enable

" For *.c, use space instead of TAB automantically once openning the file.
"autocmd BufEnter * if &filetype == "c" | set expandtab | endif

set shiftwidth=4
set tabstop=4

"Auto indent on pressing RETURN.
set autoindent
set smartindent
set smarttab
"Set C-style indent
set cindent


"Wrap lines
set wrap

"Set backspace
set backspace=eol,start,indent
set hlsearch
"Set colo scheme to koehler
colorscheme koehler
filetype on
filetype indent on
filetype plugin on

"Set system clipboard as default register.
"It doesn't affect on terminal mode.
set clipboard=unnamed
set cino=:0g0t0(sus

set whichwrap=b,s,<,>,[,]

"打开断行模块对亚洲语言支持。
" m 表示允许在两个汉字之间断行， 即使汉字之间没有出现空格。
" B 表示将两行合并为一行的时候， 汉字与汉字之间不要补空格。 该命令支持的更多的选项请参看用户手册。
" r 使得C语言中的注释自动格式化
set fo+=tcqmBr

"Default file encoding: utf-8
set encoding=utf-8
"For those not encoding by utf-8, attemp to detect the file by the order below
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,latin1

" For windows(non-UTF-8 OS)
" set langmenu=zh_CN.UTF-8
set langmenu=none

"If you prefer Simpleifed Chinese, set below
" language message zh_CN.UTF-8
"For english-US
language message en_US.UTF-8

"Turn backup off
set nobackup

" turn off write backup
set nowb


" only display e and g in GUI mode.
set guioptions=eg
"Set font, size.
set guifont=Courier:h12:cANSI

set timeout ttimeoutlen=10

if has("win32")
	" For Windows driver development, set default compile program
	set makeprg=build\ ceZg
	set errorformat=1>%f(%l)\ :\ error\ %t%n:\ %m
else
	"For *nix, set default make program as 'make'
	set makeprg=make
	"set errorformat=\|\|\ %f:%l:\ error:\ %m
	set errorformat=%f:%l:\ error:\ %m,%f\|%l\|\ %m
	"set errorformat=%f(%l)\ :\ %t%*\D%n:\ %m\ ,%*[^"]"%f"%*\D%l:\ %m,%f(%l)\ :\ %m,%*[^ ]\ %f\ %l:\ %m,%f:%l:%c:%m,%f(%l):%m,%f:%l:%m,%f|%l\ %m
endif

" Auto command
" automatically change current path to the current buffer
"autocmd BufEnter *  cd %:p:h
"set autochdir


"Set fold following your preference.
set foldmethod=indent
set nofoldenable
" set foldlevel=50
highlight Folded guibg=black guifg=darkred



"Set height of status line on th window bottom
set laststatus=2
" No.1 在状态栏显示当前文件完整路径，修改标志，行，列，百分比
"set statusline=%<%f%h%m%r%=%l,%c\ \ \ \ %P
" Use CTRL-S for saving, also in Insert mode（保存文件的快捷键）
" No.2 在状态栏显示Taglist
if has("win32")
	let Tlist_Ctags_Cmd='ctags.exe'
endif
highlight MyTagListFileName ctermfg=15 ctermbg=8 guifg=cyan
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_File_Fold_Auto_Close=1
let Tlist_Compact_Format=1
let Tlist_Process_File_Always=1
let Tlist_Show_One_File=1
let Tlist_Enable_Fold_Column=0

set statusline=%<%F%h%m%r\ [\ %{Tlist_Get_Tagname_By_Line()}\ ]%=%l,%c\ \ %P
" the following statusline expression comes form gdb_mapping.vim
"set statusline+=%F%m%r%h%w\ [POS=%04l,%04v]\ [%p%%]\ [LEN=%L]\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]
hi StatusLineNC term=bold  cterm=underline ctermfg=green ctermbg=black gui=bold guifg=blue guibg=white
hi StatusLine term=bold  cterm=underline ctermfg=green ctermbg=black gui=bold guifg=blue guibg=white
so $VIMRUNTIME/ftplugin/man.vim

nnoremap <c-m> :Man <cword><cr>



if has("gui")
	"If in GUI mode, ctrl-s is mapped to save file.
	noremap		<C-S>		:update<CR>
	vnoremap	<C-S>		<C-C>:update<CR>
	inoremap	<C-S>		<C-[>:update<CR>
endif
nnoremap    <leader>c	:qa<cr>

"If in terminal mode, as ctrl-s has been mapped some function
"map ctrl-h to save file
noremap		<C-h>		:update<CR>
vnoremap	<C-h>		<C-C>:update<CR>
inoremap	<C-h>		<C-[>:update<CR>

" Move lines（Ctrl+上下箭头键，实现快速移动行）
nmap		<C-Down>	:<C-u>move .+1<CR>
nmap		<C-Up>		:<C-u>move .-2<CR>
imap		<C-Down>	<C-o>:<C-u>move .+1<CR>
imap		<C-Up>		<C-o>:<C-u>move .-2<CR>
vmap		<C-Down>	:move '>+1<CR>gv
vmap		<C-Up>		:move '<-2<CR>gv

nmap		<C-[>[B	    :<C-u>move .+1<CR>
nmap		<C-[>[A		:<C-u>move .-2<CR>
vmap		<C-[>[B     :move '>+1<CR>gv
vmap		<C-[>[A		:move '<-2<CR>gv

" 设置多文件搜索快捷键，搜索完毕后不自动跳转
" -- obsolete, use cscope/ctags instead.
" if has("win32")
" 	nmap		<M-f>		*:vimgrep /\<<c-r><c-w>\>/j **/*.[ch] **/*.txt **/*.cpp **/*.cc **/*.vhd<cr>
" 	nmap		<leader>f	*:vimgrep /\<<c-r><c-w>\>/j **/*.[ch] **/*.txt **/*.cpp **/*.cc<cr>
" 	"nmap		<leader>F       *:vimgrep /\<<c-r><c-w>\>/j **/*<cr>
" else
" 	nmap		<c-[>f		*:vimgrep /\<<c-r><c-w>\>/j **/*.[ch] **/*.txt **/*.cpp **/*.cc **/*.vhd<cr>
" 	nmap		<c-[>f      *:vimgrep /\<<c-r><c-w>\>/j **/*.[ch] **/*.txt **/*.cpp **/*.cc<cr>
" endif

"change current dir to the directory of the current file.
nnoremap	<c-_>		:cd %:p:h<cr>
inoremap	<c-_>		<c-o>:cd %:p:h<cr>

"Display current buffer, needing BufExplorer plugin
noremap		<c-[>e		:BufExplorer<cr>
nnoremap	<M-e>		:BufExplorer<cr>

"Insert current time
nnoremap	<F5>		a<c-r>=strftime("%c")<cr><esc>
inoremap	<F5>		<c-r>=strftime("%c")<cr>


noremap   <C-n>     :ts /
" if has("gui")
" 	nnoremap	<M-z>		<c-t>
" 	nnoremap	<M-c>		<c-]>
" 	nnoremap	<M-q>		:tp<cr>
" 	nnoremap	<M-w>		:tn<cr>
" 	nnoremap	<M-x>		*
" else
	nnoremap  <c-[>z    <c-t>
	nnoremap  <c-[>c    <c-]>
	nnoremap  <c-[>q    :tp<cr>
	nnoremap  <c-[>w    :tn<cr>
	nnoremap  <c-[>x    *
"endif


"set the path of the tags file.
set tags=./tags,tags;
"
"cs find c|d|e|g|f|i|s|t name
"
"    s：查找C代码符号
"    g：查找本定义
"    d：查找本函数调用的函数
"    c：查找调用本函数的函数
"    t：查找本字符串
"    e：查找本egrep模式
"    f：查找本文件
"    i：查找包含本文件的文件
if has("cscope")
	"first use ctags, then use cscope.out
	set csto=1
	set cspc=3
	set nocst
	set cscopequickfix=g-,c-,t-,e-
	if has("win32")
		nnoremap    <M-s>    :call Csl()<cr>
		nnoremap    <M-r>    :cs find c <cword><cr>
		nnoremap    <M-t>    :cs find t <cword><cr>
		nnoremap    <M-g>    :cs find g <cword><cr>
		nnoremap    <M-i>    :cs find i <cword><cr>
		nnoremap    <M-f>    :cs find f 
	else
		nnoremap   <c-[>s    :call Csl()<cr>
		nnoremap   <c-[>r    :cs find c <cword><cr>
		nnoremap   <c-[>t    :cs find t <cword><cr>
		nnoremap   <c-[>g    :cs find g <cword><cr>
		nnoremap   <c-[>i    :cs find i <cword><cr>
		nnoremap   <c-[>f    :cs find f 
	endif
endif



noremap   <c-[>`    :call QuickfixToggle()<cr>
inoremap  <c-[>`    <esc>:call QuickfixToggle()<cr>i
noremap   <c-[>1    :cp<cr>
noremap   <c-[>2    :cn<cr>
" Open quickfix windows
let g:quickfix_open=0
function! QuickfixToggle()
	if g:quickfix_open == 0
		let g:quickfix_open = 1
		:copen
	else
		let g:quickfix_open = 0
		:cclose
	endif
endfunction



function! Csl()
	if filereadable("cscope.out")
		let w:curd = getcwd()
		if has("win32")
			exe "cs add" w:curd."\\cscope.out" w:curd
		else
			exe "cs add" w:curd."/cscope.out" w:curd
		endif
	else
		let w:cscope_file = findfile("cscope.out", ".;")
		if has("win32")
			let w:cscope_pre = strpart( w:cscope_file, 0, strridx(w:cscope_file, "\\") )
		else
			let w:cscope_pre  = matchstr(w:cscope_file, ".*/")
		endif
		if (!empty (w:cscope_file) && filereadable (w:cscope_file) )
			exe "cs add" w:cscope_file w:cscope_pre
		endif
	endif
endfunction


let g:pydiction_location = '/home/charleszhou/complete-dict'
let g:pydiction_menu_height = 10

" A good example but doean't work well
" -- commented by zcz
"
" find files and populate the quickfix list
" fun! FindFiles(filename)
"   let error_file = tempname()
"   silent exe '!find . -name "'.a:filename.'" | xargs file | sed "s/:/:1:/" > '.error_file
"   set errorformat=%f:%l:%m
"   exe "cfile ". error_file
"   copen
"   call delete(error_file)
" endfun
" command! -nargs=1 FindFile call FindFiles(<q-args>)
