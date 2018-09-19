" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Jul 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc
"
"http://vimdoc.sourceforge.net/htmldoc/
"for help, plx :help $cmd

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
  set nobackup 
endif

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"set t_Co=256
if has("autocmd")
	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
	  \| exe "normal g'\"" | endif
endif

augroup filetype
    autocmd! BufRead,BufNewFile BUILD set filetype=blade
augroup end


":options 打开选项，回车可跳到主题，对选项进行更改后 :set 选项名&
":set 用于查看已经设置的值
"低行模式就是命令行的特殊模式,命令行模式下输入:
"用于恢复默认值 set list set nolist set list!(toggle)
"set fileformat=unix //将wndows的^M去掉
"set fileencodings=  文件支持类型
"set fileencoding=   文件类型
"set termencoding=   终端类型
"查看配置文件 :scriptnames
"查看配置项的值 :set ${item}?
":e<CR> 刷新窗口
"还原被撤销的编辑操作 Ctr+R
"百度 vim 系统缓冲区
"  set clipboard unnamedplus
"
"
"vim剪切板 与 系统剪切板
"
"
"光标移动
"   向左{n}  字符    h backspace 
"            单词    b
"   向右{n}  字符    l spacebar
"            单词    w e
"   下行{n}          +  j enter
"   上行{n}          -  k
"   行      0    $ 
"   句    首(   尾)
"   段    首{   尾}
"   屏幕    Home Middle Last
"
"屏幕移动定位C-Up向上半屏 C-Down向下半屏 C-Forward向前一屏 C-Back向后一屏
"
"插入
"   字符 前i  后a
"   行   前I  尾A
"        下一行o   上一行O
"删除
"   字符 {n}x
"   词   {n}dw 删除当前单词及其后空白 d{2}w删除第二个单词； de但不包括空白
"        cw 删除当前单词进入插入模式,等价于s
"   行   {n}dd
"        cc 删除当前行进入插入模式，等价与S
"        d0 d$ d$ 等价于D
"   文件 dgg dG
"查找
"   {n}f{x} 向右查找, {n}F{x}向左查找, ";"重复上述命令
"   /{string} {2}n向前搜索第2处 {2}N向后搜索第2处; ?{stringi}向后搜索;
"R 进入Replace模式，替换当前光标位置及其后面的字符，直至按ESC
"～ 改变当前光标下的大小写 gu将下一行都改成小写 gU将下一行都改成大写
"g～大小写反写
"V 进入Visual模式，C-v进入矩形框选择模式, Shift-V进入行选择模式
"
"复制
"   y 复制选中内容 Y复制整行 yw复制整个单词及其后的空白
"   ye复制整个单词但不包括空白
"粘贴
"   p 粘贴 若是一个字母，则粘贴到当前光标后的第一个位置;若是一行,则粘贴到下一行
"
"wf 创建折叠行 zo打开 zc关闭 zR/mr打开所有折行 zM/zm关闭所有折行
"zd删除当前行折行 zD删除所有折叠
"set nowrap 长行不折叠到下一行
"
"m{a} 只对当前文件有效 将当前光标的位置标记为{a}， `{a}跳转到a处 '{a}跳转到a处行首
"mA 为全局标记，对全部文件有效
"   :marks查看所有标签 '为此处跳转前的起跳点 "上次编辑该文件时的光标的最后位置
"   [最后一次修改的起始位置, ]最后一次修改的结束位置
"
"
"编辑多个文件
"   vi a.txt b.txt c.txt 只会打开第一个
"   :fir[st] :[]wp[revious] :next :[3]wn[ext] :la[st]  w表示write
"   :args 列举，正在编辑的文件用[]括起
"   :args b.txt a.txt c.txt重新编排
"   C-^ 在当前和下一个文件中切换
"   :saveas e.txt 另存为
"   当回到某个文件时， '.回到最后修改处 '"回到最后光标处
"   :e[dit] foo.txt 关闭当前文件，打开foo.txt
"
"多个窗口
"   vi -o/O a.txt b.txt c.txt
"   C-w-w 切换窗口 C-w-h,j,k,l
"   C-w--/+ 减少/增加高度 
"   :on[ly] 除当前窗口外，其他窗口都关闭
"   :wa[ll] :qa[ll]
"
"vimdiff a.txt b.txt
"   dp[ut] do[btain]  
"   {n}[c {n}]c 上一个差异change 
"   :diffu[pdate] 重新比较2个文件
"   
"
":grep java *.c 在所有的c程序中找到java行，并跳到第一个符合的行
"   :cnext cprev :clist
"
" 范围
"   . 当前行
"   $ 最后一行
"   75 75行
"   2,75 第2行到第75行
"   % 所有
"
"
"在命令行上即命令行模式下输入:
"   定位行 :行号+回车
"   拷贝多行到粘贴版 :{n1},{n2}y
"   定位到某个文件某行再粘贴 :{n3}p
"   纯行号操作
"       复制多行 :{n1},{n2} co {n3}   //copy                                   
"       删除多行 :{n1},{n2} de        //delete
"       剪切多行 :{n1},{n2} m         //move
"   标签操作
"       光标移动到起始行 输入ma
"       光标移动到结束行 输入mb
"       光标移动好粘贴行 输入mc
"       然后输入 :'a,'b co 'c  //co换成m就是剪切了  copy move
"
"
":set path += /a/b/c 添加path :set path? 查看path
"gf 在path下查找光标下关键字的定义
":find stdio.h 在path中查找 sfind则会新建立窗口
"
"
":reg 查看剪贴板的内容
"   ""为当前剪切板（用y复制之后的内容）
"   "0-9是历史剪切板
"   "+是系统剪切板
"   "*为当前选择区 选择的内容

"
"
"
"session
"C-z 关闭tmux
":   进入命令模式
"?   列出所有快捷键
"t   显示时间
"d   退出当前tmux，在后台运行
"$   重命名当前session
"s   显示所有session并切换到某一session
"(   切换到上一session
")   切换到下一session
"L   切换到前一个活跃的session
"
"window
"c   新增一个
"&   退出当前window
",   重命名当前window
"l   调转到上一个所在的window
"w   显示所有的window并切换window
"0~9 切换到相应的window编号
"p   切换到上一个window
"n   切换到下一个window
"'   切换到输入编号的window
"f   切换到搜索到的window
"space 改变当前windows的布局
"
"pane
"" 上下切割
"% 左右切割
"x 关闭当前pane
"z 最大化或恢复当前pane
"q 显示pane索引
"！从windows移除当前pane
"{ 跟前一个pane交换位置
"} 跟后一个pane交换位置
"o 切换到下一个pane
"  使用方向键切换pane
"
"alias 查看所有的alias


" Don't use Ex mode, use Q for formatting
map Q gq
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set showcmd		" display incomplete commands


set nu rnu             "relativenumber V7.4支持hybrid mode 当前行绝对行号 其他相对行号
augroup numbertoggle   "插入模式下的显示相对，命令模式下的显示绝对行号
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

syn on
set sw=4
set ts=4
set expandtab
set ai              "autoindent
set si              "smartindent
set is              "incsearch increment search
set ic              "help ic ignoreCase when search
set showmatch       "sm
set hlsearch        "hls
set scrolloff=0
set history=50		"keep 50 lines of command line history

set fileencodings=utf-8,gb18030,utf-16,big5
autocmd Filetype c,cpp set sw=4 
set backspace=indent,eol,start
filetype plugin indent on

"colorscheme
"cd /usr/share/vim/vim80/colors
"color desert

"set mouse=a
set cc=80         "80列高亮
set cursorline
"set cursorcolumn
"hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
"hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
set ruler		" show the cursor position all the time
set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]

"let mapleader = ";"
"let mapleader = ","

map T zt
map Z zz
map B zb

map <C-h> <C-W>h
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-l> <C-W>l

nmap <leader>w :w!<cr>
nmap <leader>f :find<cr>
nmap <leader>q :q<cr>
nmap <leader>hl <Plug>MarkSet
nmap <leader>hh <Plug>MarkClear
nmap <leader>hr <Plug>MarkRegex
nmap <leader>fn :nohls<cr>
nmap <leader>t :set tags=tags<cr>

nmap <leader>sm :marks<cr>
nmap <leader>sb :buffers<cr>
nmap <leader>a :b#<cr>
nmap <leader>bn :bn<cr>
nmap <leader>bp :bp<cr>

"Find/replace issue
nmap <F6> :cn<cr>
nmap <F7> :cp<cr>

map <F10> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
imap <F10> <ESC>:!rm tags && ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"imap <F10> <ESC>:!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
"set tags = tags
"set tags+=./tags
set tag=./tags,../tags,../../tags,../../../tags
set tags+=~/.vim/systags
"set tags+=~/.vim/systags,~/.vim/systags2
"set tags=tags;  "优先在当前目录中寻找

"自动注释
"map zs : Dox<cr>
"let g:DoxygenToolkit_authorName="puppetry"
"let g:DoxygenToolkit_licenseTag="My own license\<enter>"
"let g:DoxygenToolkit_undocTag="DOXIGEN_SKIP_BLOCK"
"let g:DoxygenToolkit_briefTag_pre = "\\brief\t"
"let g:DoxygenToolkit_paramTag_pre = "\\param\t"
"let g:DoxygenToolkit_returnTag = "\\return\t"
"let g:DoxygenToolkit_briefTag_funcName = "no"
"let g:DoxygenToolkit_maxFunctionProtoLines = 30
"let g:DoxygenToolkit_startCommentTag="/*! "
"let g:DoxygenToolkit_startCommentBlock="/*! "
"let g:DoxygenToolkit_keepEmptyLineAfterComment="no"
"
"nmap <F8> :Dox<cr>
"nmap <F9> :Doxs<cr>
nmap <F9> :Tlist<CR>
let Tlist_Show_One_File=1    
let Tlist_WinWidth=40      
let Tlist_Exit_OnlyWindow=1  
let Tlist_Use_Right_Window=1 
"nmap <silent><F10> :Gtags -rx<CR>
nmap <silent><F11> :Gtags -rx<CR>
nmap <silent><F12> :Gtags<CR>

"nerdcomment插件
nmap <leader>tree :NERDTree<cr>
map <C-r> <C-W>r  "顺时针转换窗口
map <C-R> <C-W>R  "逆时针转换窗口
map <C-x> <C-W>x  "左右上下对换窗口
"let loaded_nerd_comments=1
let NERDMenuMode=0
let NERDShutUp=1
let NERDSpaceDelims=1           " 让注释符与语句之间留一个空格
let NERDCompactSexyComs=1       " 多行注释时样子更好看
let g:NERDDefaultAlign = 'left'  "将行注释符左对齐
