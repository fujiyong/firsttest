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
" 多级撤销
set nocompatible

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

"vim是否在覆盖一文件之前进行备份
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

" //////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
" //////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
"vim官网     http://www.vim.org/scripts/index.php
"vim插件官网 http://vim-scripts.org/vim/scripts.html
"  Vundle == vim bundle
"1下载 git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"2

set nocompatible              " be iMproved, required 
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim 
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins 
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required 
Plugin 'VundleVim/Vundle.vim'
"Plugin 'c.vim'
"Plugin 'vim-scripts/rstatusline'
Plugin 'kien/ctrlp.vim'
"Plugin 'Valloric/YouCompleteMe'

" 使用非插件官网的其他网上地址 
"Plugin 'git@gitlab.alibaba-inc.com:ziying.liuziying/studyvim.git'
" 使用非插件官网的本地插件
"Plugin 'file:///home/gmarik/path/to/plugin'

" All of your Plugins must be added before the following line 
call vundle#end()               " required 
filetype plugin indent on       " required 
" To ignore plugin indent changes, instead use: 
"filetype plugin on

"3 重启vim 安装:PluginInstall 删除:PluginClean 更新:PluginUpdate 列举:PluginList
"  帮助 :h $(plugin_name}
"  //////<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
"  //////<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


"alias 查看所有的alias :!alias | grep vi
"!vimtutor
":help user-manual    :!locate vimrc_example.vim  :help 'wrap'//最好加上'
"查看配置文件 :scriptnames
":version 查看vim有哪些功能插件
":options 
"   打开选项，回车可跳到主题，对选项进行更改后  然后Ctrl-O返回到菜单
"   :set ${item}? 用于查看已经设置的值
"   :set 选项名&  用于恢复默认值
"   :set list nolist list!(toggle) 用于toggle 
":set //查看用户所有不同于默认值的选项
":help option-list 可以查看所有选项的缩写
"命令补全  :{x}-Ctrl-d 输入任意字母x，然后按Ctrl-d，就会出现以该字母为首的命令
"          :e Ctrl-d 按tab选择edit，然后输入文件名的前几个字母，再按tab补全
"set fileformat=unix //将wndows的^M去掉
"set fileencodings=  文件支持类型
"set fileencoding=   文件类型
"set termencoding=   终端类型
":e<CR> 刷新窗口 :e .打开当前目录列表，然后可以使用jk选择
"百度 vim 系统缓冲区
"  vim剪切板 与 系统剪切板
"  set clipboard unnamedplus
"gd跳到变量定义处 gf 在include处跳到文件 K调用man命令查看当前C函数或shell脚本的帮助
"
"查看所有终端字符 stty -a
"进退之间
"   挂起 Ctrl-Z(等价与:suspend,windows一般为撤销命令)  恢复 fg
":lcd 只影响当前窗口的工作目录 :cd 影响全局 :pwd
"
"
"gf 首先在当前工作目录:pwd中查找,然后在path下查找光标下关键字的定义
":set path += /a/b/c,/d/e 添加path :set path? 查看path
"gf     == :fin[d] stdio.h 在path中查找 
"[f  ]f == :sf[ind]       则会新建立窗口
"^Wf    == :tabf[ind]
"
"
"
"光标移动
"   向左{n}  字符    h backspace 
"            单词    首b 尾ge   "B gE" 对于有non-word的特殊字符时(.-)/等时，使用大写
"   向右{n}  字符    l spacebar
"            单词    首w 尾e    "W E" //this is-a line, with special/separated/words (and som more);
"   下行{n}          +  j enter
"   上行{n}          -  k
"   行      0第一个字符 ^第一个非空白字符   {n}$ 
"   句    首(   尾)
"   段    首{   尾}
"   屏幕    Home Middle Last
"   文件    {n}% 50%  文件行数的50%处 
"           :goto {n} 文件字节偏移处 :goto 3 去第3个字节
"
"屏幕移动定位C-Up向上半屏 C-Down向下半屏 C-Forward向前一屏 C-Back向后一屏
"
"插入
"   字符 前i  后a
"   行   前I  尾A
"        下一行o   上一行O
"删除 d operation + w/e w包括空白，e不包括空白
"   字符 {n}x == {n}dl X == dh
"   词   "{n}dW {n}dw {n}dE {n}de"
"   行   {n}dd
"        行首 d0 
"        行尾 d$ d$等价于D
"   文件 dgg dG
"删除并进入插入模式 change operation + w/e w包括空白，e不包括空白
"   字符  {n}s == {n}cl              至少是词，不能是单个字母
"   词    "{n}cW {n}cw {n}cE {n}ce"    
"   行    {n}cc 等价与S
"         行首 c0 
"         行尾 c$等价于C
"   文件 cgg cG
"替换
"   R 进入Replace模式，替换当前光标位置及其后面的字符，直至按ESC
"   ～ 改变当前光标下的大小写 gu将下一行都改成小写 gU将下一行都改成大写
"   g～大小写反写
"简单的重复执行修改命令 复杂的使用Recording
"   .除了u C-R 和以冒号开始的命令
"   .需要在normal模式下执行，先定好位，然后.  重复的是上一次修改命令而不是被修改的内容
"   例如上一次执行cwxyz<Esc>(删除当前单词，然后插入xyz),那么定好位后，执行.也就是执行cwxyz<Esc>
"句子
"   is inner sentence
"   as a sentence      == is + 句子后的空白
"   eg: v模式 + as/is   das dis cas cis
"
"复制 yank operation + w/e w包括空白，e不包括空白 非Copy，因为c被change占用
"   词 "{n}yW {n}yw  {n}yE {n}ye" //特殊历史情况，cw==ce
"   行 {n}yy {n}Y
"   y 复制选中内容 
"粘贴putting 非paste
"   {n}p/P 粘贴 若是一个字母，则粘贴到当前光标后的第一个位置;
"          若是一行,则粘贴到下一行
"          n 表示重复执行n次
"系统剪切板    "*yy "*p

"撤销与重做 u U(撤销一行中所作的修改) c-R(撤销最后一次的撤销)
"查找
"   同一行
"       {n}f{x} 向右查找, {n}F{x}向左查找, 
"       {n}t{x} 向右停止till于x的前一个字符 {n}T{x}
"       ";"与原方向相同地重复执行上述命令  ","与原方向相反重复执行
"   当前单词 {n}*  {n}#反向
"   当前几个单词 visual select, yank, :let @/=@", n
"   /\<{string}\>\c <>单词起止c表示忽略大小写 {2}n同向搜索第2处 {2}N逆向搜索第2处; 
"   ?{stringi}\c向后搜索;  .*[]^%/?~$转义 .匹配换行符以外的任意字符
"   :set ic hls is ws //ignore case highlight-search increment-search wrapscan
"Visual模式
"   v 进入Visual模式       o(other end)切换到选中区域的另一头 
"   Shift-V进入行选择模式  o(other end)切换到选中区域的另一头 
"   C-v进入矩形框选择模式  o矩形对角位置切换 O同行左右角切换
"
"   行尾非规则矩形
"       $会选择至该行的末尾，不管这些行是否参差不齐。这种情况会持续到下一个改变水平命令如h.
"   矩形(前插入|尾追加|修改)文本
"       Ctrl-V选择矩形或行尾不规则矩形
"       0/O切换到矩形左上角或右上角 
"       I{str}<Esc>  //I在矩形前插入(若其中某行短该短行无效) A矩形尾追加 c修改 ~交换大小写 r替换
"                    //str表示插入的字符串 
"                    //在输入str的同时，只会在第一行显示 按下2下Esc后其他行也插入了str
"
"标签
"   m{a} 只对当前文件有效 将当前光标的位置标记为{a}， `{a}跳转到a处 '{a}跳转到a处行首
"   mA 为全局标记，对全部文件有效
"   :marks查看所有标签 
"       '为此处跳转前的起跳点 
"       "上次编辑该文件时的光标的最后位置
"       [最后一次修改的起始位置, 
"       ]最后一次修改的结束位置
"   :marks aB //list marks a and B
"   :delm a b 1 //del marks a b 1
"   :delm!  //del all marks
"
"多个窗口
"   vi -o/O a.txt b.txt c.txt
"   C-w-w 切换窗口 C-w-h,j,k,l C-w-H,J,K,L H当前窗口内容左移
"   C-w--/+ 减少/增加高度 
"   :on[ly] 除当前窗口外，其他窗口都关闭
"   :wa[ll]! :qa[ll]!
"
"读写文件
"   :[n1,n2]w[rite][!] [>>]a.txt //将n1,n2行之间的内容[追加]到文件a.txt
"   :[0,,$]r[ead] a.txt          //将a.txt读入到文件头 当前行 文件尾
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
"   :all 所有文件都置于一个水平窗口 :vertical all
"
"vimdiff a.txt b.txt
"   dp[ut] do[btain]  
"   {n}[c {n}]c 上一个差异change 
"   :diffu[pdate] 重新比较2个文件
"   :set scrollbind 同步滚动
"   
"wf 创建折叠行 zo打开 zc关闭 zR/mr打开所有折行 zM/zm关闭所有折行
"zd删除当前行折行 zD删除所有折叠
"J命令
"   换行符 行前的空白 行尾的空白都替换为单个的空格，最后的行尾放2个空格
"   若要保持行前空白和行尾空白，使用gJ
"
"使用了grepprg选项指定外部的应用程序
":grep java *.c 在所有的c程序中找到java行，并跳到第一个符合的行
"   :cn[ext] cp[rev] :cl[ist]
"
" subsitute
"   分隔符可以是除src/dst外的任意一个字符
"   范围
"       行号
"           .    当前行
"           $    最后一行
"           75   75行
"           2,75 第2行到第75行
"           %    所有
"       搜索模式
"           :?^Chapter?,/^Chapter/s=grey=gray=g //?^Chapter?向后查找 /^Chapter/向前查找 =分隔符
"       增与减
"           :?^Chapter?-1,/^Chapter/+2s=grey=gray=g //?^Chapter?向后查找 /^Chapter/向前查找 
"           :.+3,$-5s=grey=gray=g  //当前行+3 最后一行减5
"       标签
"           :'s,'es=grey=gray=g //先ms,'s表示s标签位置
"       visual模式
"           在visual模式下选定了文本后按下":",将会看到如下命令 
"           :'<,'>  '< 表示起始位置 '>表示结束位置 即使退出visual模式后仍保留，除非重复覆盖掉
"           :'<,$    //'<表示上一次visual模式的起始处
"       以当前行为始,以下{n}行，则可以按下n,然后在按下:,则在命令行看到:.,,+{n}-1 //一共n行
"   提示 Yes/No/All/Quit/leave 该完这个就退出
"        /^E由于在底部无法看其上下文内容所以需要滚屏上一行
"        /^Y                                        下
"全局命令
"   :[range]global/{pattern}/{command} //gloal可以缩写为g 分隔符/可以为其他
"
"命令行
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
"   位移键  <Left>或<Right> 左右 Ctrl-B 或Home  Ctrl-E 或End
"           <S-Left>或<C-Left> 左一单词 <S-Right>或<C-Right>右一单词
"   删除光标之前    字符backspace    单词Ctrl-W    整个Ctrl-U
"   撤销    CTRL-C 或 ESC
"   执行外部程序
"       :!{prog}
"       :r !{prog} //执行prog并读取其输入到当前行
"       :w !{prog} //用当前缓冲区的内容作为prog的输入并执行prog
"       :[range]!{prog} //以prog过滤指定的行
"   快速查找 :{最近命令的前半部分}+向上箭头<Up>
"   历史  :history
"命令窗口
"   打开 q:现在处于Normal模式，既然是窗口，
"           可以类似vi操作 hjkl移动 change x insert操作 /或?搜索 
"           回车执行该行被修改后的命令,同时关闭窗口
"   关闭 :q    或Ctrl-C跳到命令行再Ctrl-C关闭窗口
"
"QuickFix窗口
"   打开 :botright copen 10
"   :cw 打开编译错误窗口
"   :cn next
"   :cp pre
"   :cl list
"
"
"
"
"宏Recording录制
"   录制
"       开始准备寄存器  q{x}  x可以是[a-z]寄存器
"                       执行操作
"       结束            q
"   回放
"       {n}@{x}
"
"   eg: 
"       vim *.cpp
"       qq  //保存到q
"       :%s=\<GetResp\>=GetAnswer=ge // "e"就算没有找到也不要报错，因为报错会终止宏的进行
"       :wnext
"       q
"       @q   //执行q
"
"恢复
"   updatetime  vim在4秒不输入内容时sync一次
"   updatecount vim在输入200个字符时sync一次
"
"
":reg 查看剪贴板的内容
"   ""为当前剪切板（用y复制之后的内容）
"   "0-9是历史剪切板
"   "+是系统剪切板
"   "*为当前选择区 选择的内容
"
"
"map
"   查看所有映射 :map

" 
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
" """ 上下切割
" "%" 左右切割
" "x" 关闭当前pane
" "z" 最大化或恢复当前pane
"q 显示pane索引, 然后按索引号
"！从windows移除当前pane
"{ 跟前一个pane交换位置
"} 跟后一个pane交换位置
"o 切换到下一个pane或使用方向键切换pane
"


" Don't use Ex mode, use Q for formatting
"等价于
"if &t_Co > 2 || has("gui_running")
"  syntax on
"  set hlsearch
"endif
map Q gq
" 设置backspace何时可以删除光标之前的文: 行首的空格、换行、进入insert模式之前
set backspace=indent,eol,start

set nu rnu             "relativenumber V7.4支持hybrid mode 当前行绝对行号 其他相对行号
augroup numbertoggle   "插入模式下的显示相对，命令模式下的显示绝对行号
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

source $VIMRUNTIME/ftplugin/man.vim " K是在同一个窗口中打开帮助，添加上该句后，
                                    " 就可以上下窗口运行:Man [n]{str}打开彩色帮助
                                    " 比如 :Man 2 open 注意是 "Man" 而不是man
                                    " 之后就可以在其中Ctrl-]和Ctrl-o
                                    " 为什么 "\K"无效
syn on
set sw=4            "shiftwidth 指定一个shift单位等于多少空格 向右>  向左<
set ts=4            "tabstop 设置一个tab等于多少空格
set ai              "autoindent 在insert模式下回车或normal模式下按o时,新行与上一行有同样的缩进方式
set si              "smartindent
set expandtab       "将tab转化为空格
"set nowrap         "一行显示不下时，不折叠到下一行显示
"set iskeyword+=-   "iskeyword=@,48-57,_,192-255 @表示所有字母 48-57即是0-9 192-255可打印拉丁字母
"set iskeyword-=-   "+=表示添加 -=表示减少排除
set scrolloff=0     "光标离窗口上下边界的最小行距离
set history=50		"keep 50 lines of command line history

set is              "incsearch increment search
set ic              "help ic ignoreCase when search
set showmatch       "sm 当在输入([{时显示匹配的括号
set hlsearch        "hls

set fileencodings=utf-8,gb18030,utf-16,big5
"自动识别文件类型 不同文件类型使用plugin脚本和缩进定义文件
filetype plugin indent on
"当文件类型是c cpp时，就自动执行后面的命令
autocmd Filetype c,cpp set sw=4 

"colorscheme evening
"cd /usr/share/vim/vim80/colors
"查看颜色:edit $VIMRUNTIME/syntax/colortest.vim     :source %
"保存当前文件为彩色文件 
"   转化为临时html  :source $VIMRUNTIME/syntax/2html.vim 
"   保存为有名html  :w a.html
"color desert

"set mouse=a
"set cc=80         "80列高亮
"set textwidth=78 "设置行宽 默认78
"autocmd InsertLeave * se nocul  " 用浅色高亮当前行
"autocmd InsertEnter * se cul    " 用浅色高亮当前行
set cursorline
"set cursorcolumn
"hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
"hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
"在normal模式下状态栏的坐标前显示不完整命令 比如d是完整命令dw的前缀
"$show-mode                  $show-cmd  $ruler
set showcmd	
set ruler		" show the cursor position all the time 右下角显示光标位置
set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]

let mapleader = ";"    " 查看:options可知默认是\
"let mapleader = ","

"当前行位于屏幕
map T zt
"map Z zz 影响了ZZ保存退出
"map B zb 影响了移动B

map <C-h> <C-W>h
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-l> <C-W>l

nmap <leader>w :w!<cr>
nmap <leader>q :q<cr>
nmap <leader>f :find<cr>
nmap <leader>fn :nohls<cr>
nmap <leader>hl <Plug>MarkSet
nmap <leader>hh <Plug>MarkClear
nmap <leader>hr <Plug>MarkRegex
nmap <leader>t :set tags=tags<cr>

"查看所有标签
nmap <leader>sm :marks<cr>       
"buffers操作 一个缓冲区就是一个被编辑文件的副本
" :ls 查看所有缓冲区  *a表示actiive
" :on[ly] 只保留当前窗口,其他都关闭 :q关闭当前窗口
"
" :bad[d] {fname} 添加文件
" :bd[elete] [n] 从bufferlist中删除[n]
" :b[uf] {n} 切换到n编号缓冲区    :sb  {n}  以split方式打开
" :bf[irst] :bl[ast]              :sbf sbl
" :bp[re]   :bn[nex]              :sbp sbn
" :b#        之前所在的buffer
"
" :bufdo {cmd} 在所有的缓冲区中执行cmd  :bufdo /e
" :windo {cmd} 在所有的窗口中执行cmd    :windo /e
" :h timeout map组合键有时间限制1000ms
nmap <leader>sb :buffers<cr>
nmap <leader>a  :b#<cr>
nmap <leader>bn :bn<cr>
nmap <leader>bp :bp<cr>

"tab操作
" :tabs 列出所有tab  >当前窗口  +已修改buffer
" :tabnew    
" :tabc[lose]  :q
" :tabo[nly]
"
" :tabfir[st] tabl[ast]
" 
" :tabp[re]   {n}     == :tabN[ext]{n}   == {n}gT 
" :tabn[ext] {seq_n}                     == {seq_n}gt
"
"tags操作
" 产生
" :tags 列举所有tag >表示current 
" :ta[g] ${re_tag}    //支持re正则表达式
" :tj[ump] ${re_ag} :stj[ump] ${re_tag} //支持re正则表达式

"Find/replace issue
nmap <F6> :cn<cr>
nmap <F7> :cp<cr>

set tag=./tags,../tags,../../tags,../../../tags "优先在当前目录中寻找
set tags=./tags;,tags  " 第一个tags 在当前打开的文件下寻找tags ；表示如果没找到，往上一级目录找
                       " 第二个tags
set tags+=~/.vim/systags
map <F10>                  :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
imap <F10> <ESC>:!rm tags && ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR><ESC> :TlistUpdate<CR>

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
map <C-r> <C-W>r  " 顺时针转换窗口
map <C-R> <C-W>R  " 逆时针转换窗口
map <C-x> <C-W>x  " 左右上下对换窗口
"let loaded_nerd_comments=1
let NERDMenuMode=0
let NERDShutUp=1
let NERDSpaceDelims=1           " 让注释符与语句之间留一个空格
let NERDCompactSexyComs=1       " 多行注释时样子更好看
let g:NERDDefaultAlign = 'left'  "将行注释符左对齐
