

帮助

- Linux Family   Yellow dog Updater, Modified

| Linux Family                     |                       |                       |      |
| -------------------------------- | --------------------- | --------------------- | ---- |
| fedora RHEL CentOS  Oracle Linux | dnf     install jq    | Dandified YUM         |      |
| Debian ubuntulinux Mint          | apt-get install jq    | advanced package tool |      |
| SUSE    SLES	OpenSUSE         | zypper   install jq   |                       |      |
| Arch                             | pacman   -Sy    jq    | packageMan            |      |
| **BSD Family**                   |                       |                       |      |
| freeBSD                          | pkg install jq        |                       |      |
| solaries                         | pkgutil -i jq         |                       |      |
| mac                              | brew install jq       |                       |      |
| **Windows Family**               |                       |                       |      |
| windows                          | chocolatey install jq |                       |      |

```
whereis        #搜索可执行，头文件和帮助信息的位置，使用系统内建数据库
man yum.conf   #查看配置文件的说明

chocolatey install jq

init 3  #从界面进入命令行
startx  #从命令行进入正常界面
xinit && mozila  startkde gnome-sesssion       #从命令行进入不能变化大小移动的界面
xinint && twm && mozila startkde gnome-seesion #从命令行进入可以变化大小移动的界面 
											   #twm terminal window manager
kde     k desktop environment                 类似于winxp桌面
gnome   gnu network object model environment  类似于ubuntu桌面

col  vs column -t

cat > a.txt
aa
bb
Ctrl-d

#如何实现在bash脚本中使文件中插入一段话heredoc
cat > a.txt << -'EOF'
aa
bb
EOF

man bash | col -bx > bash.txt
方法1:转化为md
    :%s/^\([A-Z]\)/#\1/g                     #在行首有字母的行前添加#使之成为一级标题
    :%s/^[ ]\{3\}\([A-Z]\)/##\1/g            #在行首为3个空格的非空白行前添加##使之成为二级标题
    mv bash.txt bash.md
方法2: 直接使用vscode, 根据缩进折叠展开
```

# bash

##  选项

```
shopt            #set/unset shell options

set  -o          #set -o的值
echo $-          #shell默认选项
echo $SHELLOPTS  #set -o为on的选项
```

##  命令

```
chsh -l           #查看系统支持的shell,等价于cat /etc/shells
echo $SHELL       #查看使用哪种shell  env | grep SHELL
chsh -s /bin/bash #更改默认shell
export PS1="[\u@\h \W $(getGitBranchFuncName) ]$\n$" #man bash 搜索PS1,根据提示搜索PROMPTING

主要就是为了设置PS1这个环境变量,也就是shell输入命令的前缀
/etc/profile                           #system-wide .profile file for the Bourne shell
(~/.bash_profile|~/.bash_login|~/.profile)   #executed by Bourne-compatible login shells.
~/.bashrc                                    #executed by bash(1) for non-login shells
/etc/bashrc                   # System-wide .bashrc file for interactive bash(1) shells.
~/.bash_logout

交互式shell:    命令行式
非交互式shell   执行脚本式

登录shell       需要用户名密码登录或--login登录
			   执行logout/exit退出shell
非登录shell     不需要用户名密码登录或--login登录  如在命令行执行bash命令 在KDE或GNODE打开Terminal
               执行exit退出shell
			   
			   
中文man手册
apt install manpages-zh

wget https://github.com/man-pages-zh/manpages-zh/archive/v1.6.3.3.tar.gz
tar -zxvf v1.6.3.3.tar.gz
rm -f v1.6.3.3.tar.gz
cd manpages-zh-1.6.3.3
autoreconf --install --force
./configure
make && make install

wget  https://src.fedoraproject.org/repo/pkgs/man-pages-zh-CN/manpages-zh-1.5.1.tar.gz/13275fd039de8788b15151c896150bc4/manpages-zh-1.5.1.tar.gz
./configure --disable-zhtw  --prefix=/usr/local/zhman
make && make install
echo "alias cman='man -M /usr/local/zhman/share/man/zh_CN' " >> ~/.bash_profile
source ~/.bash_profile
```

###  内置命令

```
help                     #查看bash的语法, 比enable功能更强大
help    ${builtin_cmd}   #查看bash的内置命令的帮助,类似于查看用户命令的帮助man {user_cmd}
					     #help \(\(
help variables           #内置shell变量
					     
enable                   #查看bash的所有内置命令, 或禁止某命令
builtin ${builtin-cmd}   #忽略alias, 直接运行内置命令
command ${buildin_cmd}   #忽略alias, 直接运行内置命令或执行程序
bind -P                  #列出所有 bash 的快捷键
eval $script             #en对script 变量中的字符串求值（执行）
source a.sh   #source 包含函数的脚本, 然后可以在shell中直接使用: $ $func_name $arg1 $arg2
set -o vi     #设置在命令行的操作方式  默认是emacs
type function  user_cmd builtin_cmd 
```

###  用户命令

```
man bash                           # 查看命令行的快捷方式
man hier                           # 查看文件系统的结构和含义
man man                            # 查看帮助各部分的含义
man test                           # 查看 posix sh 的条件判断帮助
getconf LONG_BIT                   # 查看系统是 32 位还是 64 位
kill -l                            # 查看有哪些信号
stty -a                            # 查看发送信号的快捷键
    C^C  intr
    C^D  eof
    C^\  quit
    C^Z  susp    //vi中途退出 fg重新回到vi
    C^S  stop    //查看日志tail -f时停止滚屏
    C^Q  start   //查看日志tail -f时重新滚屏
```

###  命令自动完成

```
bash自动补全/etc/bash_completion.d
complete  $option   $cur 补全命令
    -C $cmder           将执行cmder的结果作为候选的补全结果
    -G $fileNamePattern 将匹配pattern的文件名作为候选结果
    -F $funcName        执行funcName,在funcName中生成COMPREPLY作为候选结果
    -W $wordlist        分割wordlist作为候选结果
    -p [name]           列出所有的补全命令
    -r [name]           删除某个补全命令 
    -A file             表示默认动作是补全文件名,也即是如果bash找不到补全的内容(如执行函数-F中COMPREPLY为空),就会默认以文件名进行补全

compgen  筛选命令
	根据$cur的值从候选列表中选择符合匹配单词的值并打印
	compgen --help
    	-a #查看所有别名
        -c #有哪些可用命令complete    compgen -c | sort > comp.txt
        -b #所有bash内置命令
        -k #所有bash关键字
        -A #所有函数
        #compgen -w "aa ab bb cc" --"a" #从"aa ab bb cc"中找出以"a"开始的单词
        #compgen -W "error error2 key perform run" -- "err" #打印补全当前单词error error2

compopt [-o|+o option] [-DE] [name ...] 修改补全命令设置,只能在补全函数中使用,否则报错
    	-o nospace

内置补全变量
    COMP_WORDS     数组,当前命令行中输入的所有单词
    COMP_CWORD     整数,当前输入的单词在COMP_WORDS中的索引,从1开始
    COMPREPLY      数组,存放候选的补全结果
    COMP_WORDBREAK 字符串,表示单词之间的分隔符
    COMP_LINE      字符串,表示当前命令行输入的字符
    COMP_POINT     整数,表示光标在当前命令行的哪个位置

viewlog -s servicename -t logtype 中servicename为/data/applog目录下的文件名，logtype为debug error key perform run中的一种。
想实现的效果是：输入viewlog时可以自动补全出-t -s, 输入-s时可以自动补全出/data/applog下的文件，-t时则可以自动补全出debug error key perform run中的一种

 _viewlog()
{
    COMPREPLY=()      #说明是个数组

    local cur prev opts
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="-s -t"

    #参数-s需要补全/data/applog目录下的服务
    if [[ ${prev} == "-s" ]];then
        local servicename=$(ls -l /data/applog | grep ^d | awk '{print $9}')
        COMPREPLY=( $(compgen -W "${servicename}" -- ${cur}) )
        return 0
    fi
    #-t的补全对象为"debug error key perform run"
    if [[ ${prev} == "-t" ]];then
    	local logtypes="debug error key perform run"
        COMPREPLY=( $(compgen -W "debug error key perform run" -- ${cur}) )
		return 0
    fi

    #只输入viewlog时，补全该命令可选的参数
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _viewlog viewlog


_pandoc() {
    local pre cur
 
    COMPREPLY=()
    #pre="$3"
    #cur="$2"
    pre=${COMP_WORDS[COMP_CWORD-1]}
    cur=${COMP_WORDS[COMP_CWORD]}
    READ_FORMAT="native mediawiki haddock latex"
    WRITE_FORMAT="native json revealjs s5"
 
    case "$pre" in
    -f|-r )
        COMPREPLY=( $( compgen -W "$READ_FORMAT" -- $cur ) )
        return 0
        ;;
    -t|-w )
        COMPREPLY=( $( compgen -W "$WRITE_FORMAT" -- $cur ) )
        return 0
    esac
 
    complete_options() {
        local opts i
        opts="-f -r -t -w -o --output -v --version -h --help"
        for i in "${COMP_WORDS[@]}"
        do
            if [ "$i" == "-f" -o "$i" == "-r" ]
            then
                opts="$opts"" -R -S --filter -p"
                break
            fi
        done
 
        for i in "${COMP_WORDS[@]}"
        do
            if [ "$i" == "-t" -o "$i" == "-w" ]
            then
                opts="$opts"" -s --template --toc"
                break
            fi
        done
        echo "$opts"
    }
 
    case "$cur" in
    -* )
        COMPREPLY=( $( compgen -W "$(complete_options)" -- $cur) )
        ;;
    * )
        COMPREPLY=( $( compgen -A file ))
    esac
}
complete -F _pandoc pandoc
```

###  空命令

```
:        #冒号
```

## 变量

```
declare/typeset set env/export 

export 向子进程导出的
为什么需要export
>declare -p k1  #显示未定义
>k1=v1
>echo $k1                #打印v1
>/bin/bash -c "echo $k1" #打印v1
>echo "echo $k1" > a.sh && chmod u+x a.sh; /bin/bash a.sh #打印为空

变量种类
	declare|set
		shell-buildina: HISTSIZE  
						#export | grep HIS
						#为空且在各session中存在，说明不是通过export的
		env|export:     export userVarName=userVarValue
		                #在打印与设置变量功能是等价的
		                #但help export /usr/bin/env
		命令行临时:      shellVarName=shellVarValue

	使用unset取消set export env定义的变量
	使用readonly重新设置变量的属性，之后该变量就不能unset
	使用local在function中设置属性
函数
	declare|set

>varName=varValue         #用户在命令行中设定shell变量
                          #从declare | grep varName
                          #等价于declare -- varName=varValue
>export | grep varName    #在这个session中没有显示
>env    | grep varName    #在这个session中没有显示
>set    | grep varName    #在这个session中有显示        ？？？？？？

>export varName
>export | grep varName    #在这个session中有显示
>env    | grep varName    #在这个session中有显示

>exit
>login

>export | grep varName    #在这个session中没有显示
>env    | grep varName    #在这个session中没有显示
>set    | grep varName    #在这个session中没有显示

typeset == declare等价 从字面就可以看出设置set类型type
declare	  #普通的变量定义(varName=)没有附加属性
	作用1 打印, 后不接varName和functionName  
		declare      #显示所有变量和函数 与set效果相同
		declare -p   #显示变量及其属性
		declare -F   #显示所有函数名
		declare -f   #显示所有函数及其定义
		declare -f $funcName
	作用2 声明为某类型变量 附加额外属性， 否则默认都是字符串变量即使v= 也是空字符
		declare [+/-] [rxai] varName=varValue  #可以组合使用
			- 具有某属性，如整型  +取消某属性
			r readonly
			x 指定变量会export为环境变量，可供非shell调用
			i integer
			a array
			A map

			eg
			declare -a arr='([0]="a" [1]="b" [2]="c")' #声明数组变量
			declare -ar                                #可组合使用
```

###  set

```
显示shell变量
设置shell变量为新值, 不能定义新的变量
使用+/-打开或关闭特定的模式
```

###  declare/typeset

```
declare [-aAfFgilnrtux] [-p] [name[=value] ...]
	display/set variable values and attributes.
	Options:
      -f        restrict action or display to function names and definitions
      -F        restrict display to function names only (plus line number and
    				source file when debugging)
      -g        create global variables when used in a shell function; otherwise ignored
      -p        display the attributes and value of each NAME

	属性attr   +设置变量的属性 -取消变量的属性
	  -a        to make NAMEs indexed arrays (if supported)
      -A        to make NAMEs associative arrays (if supported)
      -i        to make NAMEs have the `integer' attribute
      -l        to convert NAMEs to lower case on assignment
      -n        make NAME a reference to the variable named by its value
      -r        to make NAMEs readonly
      -t        to make NAMEs have the `trace' attribute
      -u        to convert NAMEs to upper case on assignment
      -x        to make NAMEs export
	查看
		declare -a                # 查看所有数组
    	declare -f                # 查看所有函数
    	declare -F                # 查看所有函数，仅显示函数名
    	declare -i                # 查看所有整数
    	declare -r                # 查看所有只读变量
    	declare -x                # 查看所有被导出成环境变量的东西
    	declare -p varname        # 输出变量是怎么定义的（类型+值）
	声明
		declare var=value         #等价于1.var=value  2.typeset var=value
		declare -x var1=value1 
```

###  env 唯一非buildin

```
显示环境变量
在一新环境中设置变量
	[OPTION]... [-] [NAME=VALUE]... [COMMAND [ARG]...]
	Set each NAME to VALUE in the environment and run COMMAND.
	-i, --ignore-environment   start with an empty environment
	-u, --unset=NAME           remove variable from the environment
```

###  export

```
默认情况下,用户变量不会传递给子shell.export之后,就可以了
-f：代表[变量名称]中为函数名称
-n：删除指定的变量。变量实际上并未删除，只是不会输出到后续指令的执行环境中
-p：列出所有的shell赋予程序的环境变量
```

###  readonly

```
定义
-a	n=v	定义只读数组
-f 	定义只读函数
-p	查看只读变量或数组或函数
```

###  unset

```
取消变量的定义
unset
    unset
	unset f
```



```
3种变量
shell变量set  
	内部变量  
		系统提供 不用定义  不能修改   如$0 $@ $# $? $$
    环境变量env   
        系统提供 不用定义  可以修改,可以导出为用户变量 如HOME PS1 PWD
        用户变量 用户提供 用户定义  可以修改

set    表示当前这个shell比如说bash而不是dash的环境变量,包括当前用户的环境变量 env | sort
export 将bash变量导出为用户变量    export | sort
env    表示当前用户的环境的变量     env | sort

预定义变量                   
    $#  #参数个数
    $0  #第0个参数 即应用名
    $@  #参数数组组成的字符串
    $*  #参数数组
    $?  # 查看最近一条命令的返回码
    $-  # set选项 or those set by the shell itself (such as the -i option)
        ########### /bin/bash -o更容易看出
        # 可以从help set得知shell的当前选项
        #	echo $-  返回himBH
      # Hexpand history 就是可以使用!!/!n来操作~/.bash_history 但前提命令行字符串中无!符号,否则''
      # m monitor job  就是C-z 和 fg这些 
      # B brace expand 就是mkdir -p ./{a,b}
    $$  # 查看当前 shell 的进程号
    $!  # 查看最近调用的后台任务进程号
    $_  
用户定义变量
	local var=''   #在单引号里不能进行任何变量转义
	local var="x ${var2} yy"   #在等号前不能有空格 左边不需要,右边引用变量需要 在双引号$变量可以转义
	local var=`id -u user`
	local var=$(id -u user)   #运行命令，并将标准输出内容捕获并将返回值赋值
	                          #相对于``,$()能够转义,支持内嵌
	
变量定界符  主要是拼接字符串变量
	local var="visitor"; 
	${var}or        #visitor 拼接字符串,为了明确变量的边界,需要添加
   	${var}${var2}
 查看变量
 	echo $var
```

##  数值let exp [] (( )) awk/bc

```
整数
	计算
        i=((i+1))
        let number_var=$number_var+1 
        number_var=`expr $number + 1`   # 兼容 posix sh 的计算，需要转义
	比较
        [ num1 $opt num2]
        if (( num1 $opt num2 ))      # == != < <= > >=
小数
	计算比较都使用awk或bc
	awk
	bc 
		echo "1+2" | bc
		bc <<< "1+2"
```

##  字符串[[ ]]

```
长度  #获取之后就可以有边界的切割了 sed cut awk
    ${#varname}               # 返回字符串长度
切割
    ${varname:offset:len}     # 取得字符串的子字符串
拼接
    ${var}er
    ${var1}${var2}
替换
    ${variable/pattern/str}   # 将变量中第一个匹配 pattern 的替换成 str，并返回
    ${variable//pattern/str}  # 将变量中所有匹配 pattern 的地方替换成 str 并返回
比较
	不管是在[]还是在[[]]中,=都与==等价
	#注意使用[]时,< 或 > 是字面量，shell会误认为重定向, 要加反斜杆以便转义; 所以最好是使用[[]]
	
	[]
		[ str1 = str2 ]              # 判断字符串相等，如 [ "$x" = "$y" ] && echo yes
    	[ str1 != str2 ]             # 判断字符串不等，如 [ "$x" != "$y" ] && echo yes
    	[ str1 \< str2 ]             # 字符串小于，如 [ "$x" \< "$y" ] && echo yes
    	[ str2 \> str2 ]             # 字符串大于
    	
    	等号==
    	[ $v == "z*" ]              #字面比较 如果$v是字面字符串z*
    	[ $v == z*   ]              #File globbing 和word splitting将会发生
	
	[[]]
        [[ str1 < str2 ]] 
        [[ str1 > str2 ]] 
        
        等号==
        [[ $v == "z*" ]]           #字面比较 如果$v是字面字符串z*
        [[ $v ==  z*  ]]           #如果$v符合正则表达式z*
        
在bash3.2之后,加""就是字面比较.
如若需要通配或正则比较,则不能使用"";如果通配或正则中含有空格,则需定义变量,如t="abc123"
[[ $t ==  abc*         ]] #true 通配符globbing比较
[[ $t =~  [abc]+[123]+ ]] #true 正则比较
[[ $t == "abc*" ]]        #false 字面比较

    # 判断字符串为空（长度等于零）
    if [ -z str1 ]     
    if [[ -z str1 ]]                 
    if [ "$v" ] 
    if [ "$v" = "" ] 
    if [ x$v = "x" ]
    # 判断字符串不为空（长度大于零）
    if [ -n str1 ]
    if [[ -n str1 ]]

    ${varname:-word}          # 如果变量不为空则返回变量，否则返回 word
    ${varname:=word}          # 如果变量不为空则返回变量，否则赋值成 word 并返回
    ${varname:?message}       # 如果变量不为空则返回变量，否则打印错误信息并退出
    ${varname:+word}          # 如果变量不为空则返回 word，否则返回 null
    ${varname:offset:len}     # 取得字符串的子字符串

    ${variable#pattern}       # 如果变量头部匹配 pattern，则删除最小匹配部分返回剩下的
    ${variable##pattern}      # 如果变量头部匹配 pattern，则删除最大匹配部分返回剩下的
    ${variable%pattern}       # 如果变量尾部匹配 pattern，则删除最小匹配部分返回剩下的
    ${variable%%pattern}      # 如果变量尾部匹配 pattern，则删除最大匹配部分返回剩下的
    ${variable/pattern/str}   # 将变量中第一个匹配 pattern 的替换成 str，并返回
    ${variable//pattern/str}  # 将变量中所有匹配 pattern 的地方替换成 str 并返回

    *(patternlist)            # 零次或者多次匹配
    +(patternlist)            # 一次或者多次匹配
    ?(patternlist)            # 零次或者一次匹配
    @(patternlist)            # 单词匹配
    !(patternlist)            # 不匹配
```

##  数值字符串

|                  | [ ]                     | [[]]                    | (())              |
| ---------------- | ----------------------- | ----------------------- | ----------------- |
| string           | \\<                     | <                       |                   |
|                  | \\>                     | >                       |                   |
|                  | =                       | =  ==                   |                   |
|                  | !=                      | !=                      |                   |
|                  | -n                      | -n                      |                   |
|                  | -z                      | -z                      |                   |
| integer          | -gt -lt -ge -le -eq -ne | -gt -lt -ge -le -eq -ne | \> \>= == != < <= |
| condition        | -a                      | &&                      | &&                |
|                  | -o                      | \|\|                    | \|\|              |
|                  | !                       | !                       | !                 |
| expression group | \\(     \ \)            | ()                      | ()                |
| pattern matching |                         | = ==                    |                   |
| reg     matching |                         | =~                      |                   |

###   小括号

- ( )    组命令 group cmder     启动一个子shell执行,括号外不可使用括号内的变量 命令之间用";"分割, 最后一个可以没有";", 各命令与括号之间不必有空格( )  

- (a b c)   初始化数组 init array            

- \$(hostname)  命令替换cmd substitution

  支持变量嵌套"\$(echo \"$x" | grep "aa")"  

  支持表达式的双引号嵌套而不用使用转义符 "\$(echo "$x"|grep aa)"
  
- (())   bash extension 不具移植性  integer arithmetic expansion, 类似于let,但比let强  

  - 整数 完全取代[]中整数操作

    只要括号中的运算符表达式符合C语言运算规则,都可以放在$((exp))中,甚至三目运算符 echo $(( 2 > 1  ? 1 : 2 )) 

    ​		++ --          前后缀

    ​		/  % + -

    ​		**             幂

    ​		<< >>       左右位移  

    ​		& | ~        位与或非

    ​		= > == != < <= 

  -  重定义变量值  如a=5; ((a++))  #$a为6

  - 算术运算比较   

    双括号中的变量可以不使用$前缀. 括号内支持多个用逗号分隔的符合C语言运算规则的表达式 
    	for((i=0;i<10;i++))   for i in `seq 0 10` for in {0..10}

  - 逻辑运算       如if ((\$i))                 if ((\$i<5))  

    ​                      &&   ||   !    支持()改变优先级

  - 不支持文件操作
  
- $(( ))      进制转换      将(2,8,16)转换成10进制, 如echo $((16#5f))   #16进制转为10进制结果为95


###  中括号

- []  posix标准,具有移植性    /usr/bin/[ 由ubuntu16.04提供,但优先级没有bash中内置的高, 用于

  - 数组下标

  - 正则表达式的字符范围  [a-z]

  -  test operator, 等价于test, 既是bash内置关键字也是可执行命令 左右都要有空格

    - 字符串的操作符  

      -n  -z   =(亦可用bash extension符==)  != 

      其他的需要转义以防止表示重定向, 如posix扩展\\< \\> ,不支持\<= \>=?

    - 整数           -gt -ge -eq -ne -lt -le

    - 逻辑运算   -a  -o  !  不支持()改变优先级,因为()在[]表示sub shell,所以如果需要改变优先级需转义\( \)

- [[ ]]  bash extension,不具移植性

  - test operator

    - 字符串  不用使用""以便防止字符串变量切割 如x='a b'; [[ $x = a b ]]
      - 仍然保留一部分  -n -z =(亦可用bash extension符==) !=                      \<= \>=?

      - 新增部分 不区分大小写比较 shopt -s nocaseglob
        <            取代\\<     由于[[ $a < $b ]] 不知是字符还是整数,所以[[ "x$a" < "x$b" ]]

         \>            取代\\>  
         ! \$a >\$b      表示不大于即<=含义
         ! $a < \$b      表示不小于即>=含义

      - 完全新增部分

        ==(偶尔亦可用=) !=  模式匹配pattern matching     globbing 
                                      匹配字符串或通配符,一定不需要引号,否则当成文本字符串  
        
        ​                                  如 [[ hello == hell? ]]
        
    
    ​              =~                             正则匹配regular expression 
  
    - 整数  同[]    不支持>= > == != < <= 建议数值比较使用(())
  
  - 逻辑   && ||  !  支持()改变优先级

###  大括号

- {}
  - 组命令 group cmd, 又称代码块,内部组, 实际上创建了一个匿名函数   
                    不会启动子shell执行, 括号外仍可使用括号内的变量 
                    命令之间用";"分割, 最后一个必须要有";", 第一个命令必须与左括号有一个空格
  -  大括号扩展
                    以,分割的离散文件列表  touch {a,d}.txt 结果为a.txt d.txt
                    以..分割的连续文件列表 touch {a..d}.txt 结果为a.txt b.txt c.txt d.txt
- \${}   refer to variables and avoid confusion over their name  如${var}const


```
${var:-string}     if ( var == null ) { return string} else { return var}                 为空返回默认值,否则返回原值
${var:=string}     if ( var == null ) { var = string; return string;} else { return var;} 为空返回默认值并赋值,否则返回原值
${var:+string}     if ( var != null ) { return string } else { return null }              不为空返回默认值,否则返回null  明显是搞事的
${var:?string}     if ( var != null ) { return var } else { print string; exit 0;} 判断是否已经赋值 打印为空时的错误消息  提前询问

${var#pattern}            去掉左边最小匹配
${var##pattern}           去掉左边最大匹配
${var%pattern}            去掉右边最小匹配  ${filename%.*}   echo $filename | sed 's/\.[^.]*$//'
${var%%pattern}           去掉右边最大匹配

字符串切割
${var:num}                 从var中第$num处提取到末尾的所有的字符. 若num为正数则从左边num处;若num为负数,则从右边开始
                           但必须使用在冒号后面加空格或一个数字或整个num加上括号，如${var: -2} ${var:1-3}或${var:(-2)}
${var:num1:num2}           从var中第$num1处摘取长度为$num2的子串  不能为负数

字符串替换
${var/pattern1/pattern2}   将var中第一个匹配patter1的字符串替换为pattern2
${var//pattern1/pattern2}  将var中所有匹配patter1的字符串替换为pattern2


#字符匹配的条件 中间== 右边有双引号""
[ "$a" == "z*" ]
[[ $a  == "z*" ]]

#模式匹配的条件 中间== 右边没有双引号""
[  $a  == z*   ]   #file globbing word splitting
[[ $a  == z*   ]]  #模式匹配 如果$a以z开始,那么为true

#正则匹配的条件  中间=~ 右边没有双引号""
[[ $a  =~ z*   ]]
```

##  数组/map

```
man bash 查看Arrays

声明
	declare -a indexedArray        
	declare -A associateArray

初始化
	定义index数组
		array=(valA valB valC)
    	array=([0]=valA [3]=valB [8]=valC)   #支持稀疏数组
    	array[0]=val1; array[3]=val3; array[8]=value8;
    	旋转门
    		转入数组
        		array=($text)             # 按空格分隔 text 成数组，并赋值给变量
        		IFS="/" array=($text)     # 按斜杆分隔字符串 text 成数组，并赋值给变量 
    		转出数组
        		text="${array[*]}"        # 用空格链接数组并赋值给变量
        		text=$(IFS=/; echo "${array[*]}")  # 用斜杠链接数组并赋值给变量
    定义associate数组map
    	array=([indexName1]=val1 [indexName2]=val2)
    	array[indexName1]=val1; array[indexName2]=val2;

增
	array[#array[@]]=v
	array[indexName1]=val1; array[indexName2]=val2;
删除第i个元素
	方法一:切片方法构造
	i=2;array=($array[@]:0:$i $array[@]:$i+1);echo ${!array[@]}  #数组下标对应的元素变化
	
	方法二:unset删除下标法
	array=(A B C D E)                       #下标是0 1 2 3 4
	i=2;unset array[$i]; echo ${!array[@]}  #打印  0 1   3 4
	由于下标变换错误做法
		for ((i=0;i<${#array[@]};i++));do 
			echo "MYARR[$i]=${MYARR[$i]}"; #[0]=A [1]=B [2]= [3]=D ##[2]出现 [4]没出现
		done
	由于下标变换正确做法
		for i in ${!MYARR[@]}; do 
			echo "MYARR[${i}]=${MYARR[${i}]}"; #[0]=A [1]=B [3]=D [4]=E
		done
	这时需要使用旋转门重整下标
		array=(${array[@]}); 
		for ((i=0;i<${#array[@]};i++));do 
			echo "array[$i]=${array[$i]}"; 
		done
清空数组
	unset array[@]
	unset array[*]
删除整个数组
	unset array
改
	array[0]=val1; array[3]=val3; array[8]=value8;
	array[indexName1]=val1; array[indexName2]=val2;
遍历
	for ((i=1; i<=j; i++)); do  done
    for i in {1..10}
    for i in 192.168.1.{1..254}
    for i in "${arr[@]}"          #遍历数组
    for i in "a" "b"              #枚举
    for i in /etc/*.conf          
    for i in $(seq 10)     #执行命令`` man seq   $(seq 5 -1 1)  start=5 step=-1 end=1
    for i in $(<file)
    IFS=$'\n'; for line in `cat $file`; do done
    for i in "$@"   #$#变量个数 $@ $*变量内容 $0文件名 $9 ${10} ${11}
                    #当变量个数大约9时,需要{},也就是要明确边界
	
获取所有元素           ${array[@]}    ${array[*]}
获取所有元素下标        ${!array[@]}   ${!array[*]}
获取数组长度           ${#array[@]}  ${#array[*]}
获取数组元素            ${array[i]}
获取数组中某变量长度     ${#array[i]}
数组切片               ${array[@]:offset:number} #当number省略时,表示直至数组结束
    A=( foo bar "a  b c" 42 ) # 数组定义
    B=("${A[@]:1:2}")         # 数组切片：B=( bar "a  b c" )
    C=("${A[@]:1}")           # 数组切片：C=( bar "a  b c" 42 )
    echo "${B[@]}"            # bar a  b c
    echo "${B[1]}"            # a  b c
    echo "${C[@]}"            # bar a  b c 42
    echo "${C[@]: -2:2}"      # a  b c 42  减号前的空格是必须的
```

##  文件属性

```
help test
```

## 逻辑运算

```
buildin关键字 true(0) false(1)
test {expression}         # 判断条件为真的话 test 程序返回0 否则非零
```

##  流程控制if for while util case select

除了if-then case-esac外,其余的都是do-done

```
if   []; then    #help if
elif []; then
else
fi

while []; do     #help while
done

util  []; do     #help util
done

##迭代处理for
for opt in "$@"; do
  case $opt in              #help case 深入理解pattern matching
    --help)  ;;
    [1yY]*)  ;;
    *)       help; ;;
  esac
done

#菜单选择select
select name [in list]; do 
	echo "your input is $REPLY and you choose result is $name"
	case $name in 
        pattern1 | pattern2 )  statements ;;
        *                   )  otherwise  ;;
	esac
done
```

##  函数 

```
function myfunc {    ###或myfunc () {
	# $# 代表参数个数
	# $0 代表被调用者自身的名字
    # $1 代表第一个参数，$N 代表第 N 个参数
    # ${10} 代表第10个参数 当参数序数大于9时,需用{}表示截止
    # $* 空格链接起来的所有参数，类型是字符串 
    #	for i in "$*";do echo $i; done
    # $@ 代表所有参数，类型是个数组，想传递所有参数给其他命令用 cmd "$@" 
    #	for i in "$@";do echo $i; done
    {shell commands ...}
    //readonly local
}

myfunc                    # 调用函数 myfunc 
myfunc arg1 arg2 arg3     # 带参数的函数调用
myfunc "$@"               # 将所有参数传递给函数
myfunc "${array[@]}"      # 将一个数组当作多个参数传递给函数
shift                     # 参数左移

unset -f myfunc           # 删除函数
declare -f                # 列出函数定义

log() {
    local prefix="[$(date +%Y/%m/%d\ %H:%M:%S)]: "
    echo $prefix $@ >&2
}
#log "INFO" "A message"
```

##  命令行参数处理

```
##位置变量
	只能处理简单固定位置的变量

###############################bash内置的getopts
optstrinng的格式
	若第一个字符为":",表示不报任何错误,优先级低于OPTERR
	字母后面的":"表示该选项需要参数, 参数存储在变量OPTARG中
优点
	允许选项叠加如-fs 需要表示选项值中间必须要有空格
弱点
	不支持长选项如--debug
	选项名与选项值中间必须要有空格 格式必须是-d val,
	遇到非"-"开始的选项或选项参数结束标记--就停止处理参数, 选项参数必须在非选项参数前面
报错
	环境变量OPTERR为0时,表示不报任何错误,优先级最高
$sh getopts.sh -b -c "cc" -a "aa" -e -f -g -h -i
$cat getopts.sh
while getopts "a:bc:h" opt; do
	case $opt in
		a) 
			echo "a $OPTARG $OPTIND $6" # 输出a aa 6
			;;
		b)                              #-b后面不要跟参数，否则遇到非选项命令行参数，会结束
			echo "b         $OPTIND $2" # 输出 b  2 -c
			;;                         
		c) 
			echo "c $OPTARG $OPTIND $4" # 输出c cc 4 -a
			;;
		m | n)
			;;
		?)                          #不明选项时  当命令行中出现了optstring中没有的参数时匹配"?"
			echo "error"            #依然会改变OPTIND的值
			;;    
	esac
done
echo $OPTIND            #下一个要处理的参数的位置号 输出11
shift $(( $OPTIND-2 ))  #移除前4个即-b -c "cc" -a 只会改变$# $@ $0 $1 ... $N参数值
						#shift使用场景
				        #1.参数很长,只想使用$0 $1这前几个变量处理,而不想使用${11}因为书写麻烦
					    #2.参数很长,可以分组处理参数,在这个组里只处理一部分参数,其余参数留给其他组处理
echo $OPTIND            #下一个要处理的参数的位置号 输出11
echo $0 $#              #脚本名                 输出getopts.sh aa
echo $*                 #参数列表                输出aa

#####################################getopt功能更强大
老版本有bug，新版本/增强版修正了 若getopt -T && echo $? 返回4则表示增强版
getopt --help
-o      短选项
--long  长选项
-n
#-a没冒号表示一定不能带参数
#-b有冒号表示一定需要带参数
#-c有双冒号表示可带可不带参数
#-n 
#--  用于分割选项与参数 这个符号之前的是选项options，之后的是参数paramter
#    
#./mygetopt.sh -b 123 -a file2 -c456 file1 
#./mygetopt.sh --blong 123 -a --clong=456 file1 file2  
ARGS=`getopt -o ab:c:: --long along,blong:,clong:: -n 'mygetopt.sh' -- "$@"`
if [ $? != 0 ]; then
    echo "Terminating..."
    exit 1
fi

#echo $ARGS  ##./mygetopt.sh -b 123 -a file2 -c456 file1
#将规范化后的命令行参数分配至位置参数（$1,$2,...)
#set --	Assign any remaining arguments to the positional parameters.
#		If there are no remaining arguments, the positional parameters
#		are unset
eval set -- "${ARGS}"
#echo $ARGS  ##./mygetopt.sh -a -b 123 -c456 file1 file2
 
while true
do
    case "$1" in
        -a|--along) 
            echo "Option a";
            shift
            ;;
        -b|--blong)
            echo "Option b, argument $2";
            shift 2
            ;;
        -c|--clong)
            case "$2" in
				# c has an optional argument. As we are in quoted mode,
                # an empty parameter will be generated if its optional
                # argument is not found.
                "")
                    echo "Option c, no argument";
                    shift 2  
                    ;;
                *)
                    echo "Option c, argument $2";
                    shift 2;
                    ;;
            esac
            ;;
        --)
            shift
            break
            ;;
        *)   #不明选项时
            echo "Internal error!"
            exit 1
            ;;
    esac
done
 
#处理剩余的参数
for arg in $@
do
    echo "processing $arg"
done

https://www.cnblogs.com/yxzfscg/p/5338775.html
```

##  输入输出重定向

###   cat 

```
cat > a.file            #表示从键盘获取标准输入给cat,然后cat将输出重定向到a.file
xxx
#这里按下ctl+D离开

cat > a.file << EOF    #here doc
EOF
```

###   read

```
####读取到变量和数组
read [-p "prompt"] $line      #读取一行到变量line
read [-p "prompt"] $v1 $v2 $n #将一行按照IFS分割赋值给各变量 
                              #若变量数小于切片数,则最后一个变量再获取其余值;
                              #若变量数大于切片数,则多余变量值为空
read [-p "prompt"] -a $arr    #读取一行到数组

####应用到结构代码块重定向
这种方式将<提前,更易理解
while read line < $file;do
done

从文件中读取
while IFS= read -r  line; do  #The -r option passed to read command prevents backslash 								  #		escapes from being interpreted
							  #Add IFS= option before read command to prevent                                           #     leading/trailing whitespace from being trimmed 
done < $file
从命令行结果中读取
while IFS= read -r -u13 line; do
done 13 < "$(cmd)"

####应用到函数
answer_yes_or_no() {
  while true; do
  	#help read  -r表示do not allow backslashes to escape any characters
    read -p "prompt_string ([y]/n) " -r
    REPLY=${REPLY:-"y"}
    if   [[ $REPLY =~ ^[Yy]$ ]]; then
      return 0
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
      return 1
    fi
  done
}
```

###  <> exec

```
cmd1 | cmd2                        # 管道，cmd1 的标准输出接到 cmd2 的标准输入
左边的fd与>不能有空格 >与右边的file之间可以有空格
-表示关闭

不使用文件描述符的重定向
    >  file                            # 将命令的标准输出重定向到文件，会覆盖文件
    >> file                            # 将命令的标准输出重定向到文件，追加不覆盖
    >| file                            # 强制输出到文件，即便设置过：set -o noclobber

    <   file                           # 将文件内容重定向为命令的标准输入 mysql < a.sql
    <<  text                           # here doc
    <<< "word"                         # 将word字符串和后面的换行作为输入提供给命令行
                                       # mysql <<< "select version();" 不需再mysql -e ""
    diff <(cmd1) <(cmd2)               # 比较两个命令的输出

使用文件描述符的重定向
    cmd  >&n                           # 将输出送到文件描述符n
    cmd m>&n                           # 将输出到文件描述符m的重定向到文件描述符n
    cmd  >&-                           # 关闭标准输出
    cmd  >&n-                         

    cmd  <&n                           # 输入来自文件描述符
    cmd m<&n                           
    cmd  <&-                           # 关闭标准输入
    cmd  <&n-
    
    n> file                            # 重定向文件描述符 n 的输出到文件
    n>| file                           # 强制将文件描述符 n的输出重定向到文件
    
    n< file                            # 重定向文件描述符 n 的输入为文件内容

    复合文件描述符重定向
    cmd 2>&1 1>file                    #三者等价
    cmd      &>file                    #更简洁
    cmd      >&file

    cmd 2>&1 1>>file                   #二者等价
    cmd      &>>file                   #更简洁

n>&                                # 将标准输出 dup/合并 到文件描述符 n
n<&                                # 将标准输入 dump/合并 定向为描述符 n
n>&-                               # 关闭作为输出的文件描述符 n
n<&-                               # 关闭作为输入的文件描述符 n
     
cmd <> file                        # 同时使用该文件作为标准输入和标准输出
                                   # 以读写模式把文件file重定向到输入，文件file不会被破坏
                                   # 仅当应用程序利用了这一特性时，它才是有意义的
n<> file                           # 同时使用文件作为文件描述符 n 的输出和输入

exec 以上命令都是在当前行输入输出重定向,但exec可使接下来都重定向
exec 3<> File             # 打开"File"并且将fd 3分配给它
```

##  组合命令group cmd

```
()
{}
```

##  expect 语法与bash完全不同

```
#####telnet
#!/usr/bin/expect -f
set ip         [lindex $argv 0]   #获取第一个参数
set userid     [lindex $argv 1]
set mypassword [lindex $argv 2]
set mycommand  [lindex $argv 3]

set timeout 10
spawn telnet $ip
    expect "username:" {send "$userid\r"}
    expect "password:" {send "$mypassword\r"}
    expect "%"         {send "$mycommand\r"}
    expect "%"         {set results $expct_out(buffer); send "exit\r"}
    expect eof

#####ftp
#!/usr/bin/expect -f
set ip         [lindex $argv 0]
set userid     [lindex $argv 1]
set mypassword [lindex $argv 2]

set timeout 10
spawn ftp $ip
    expect "username:" {send "$userid\r"}
    expect "password:" {send "$mypassword\r"}
    expect "ftp>"      {send "bin\r"}
    expect "ftp>"      {send "prompt\r"}        #关闭提示符
    expect "ftp>"      {send "mget *\r"}        #下载所有文件
    expect "ftp>"      {send "bye\r"}
    expect eof

#####ssh
if { $argc != 2 }{
	send_user "usage: ./expect $user $password"
}
for {set i 10} {$i<=12} {incr i}{    #类似于for(i:=10;i<12;i++)
	set timeout 30
	set ssh_user [lindex $argv 0]
    set password [lindex $argv 1]
    spawn  ssh  $username 192.168.0.1
    expect  {
        "*yes/no"     {send "yes\r"; exp_continue;}
        "*password:"  {send "$password\r"}
    } 
}
interact
```

##  调试

```
$help set
Set or unset values of shell options and positional parameters

set +x    #扩展shell中变量并打印
          #Using + rather than - causes these flags to be turned off.  
          
    	  #The flags can also be used upon invocation of the shell. 
    	  #		eg bash -euo pipefail x.sh
    	  
    	  #The current set of flags may be found in $-   eg  echo $-
    	  
    	  #The remaining n ARGs are positional parameters 
    	  #		and are assigned,in order,to $1,.. $n
    	  
    	  #If no ARGs are given, all shell variables are printed

shell文件外在命令行2种设置方式
	$ set  -exuvno pipefail && cmd  #前任uv + yes/no中的no
	$ bash -exuvno pipefail a.sh

shell文件内设置
#!/bin/bash
set  -exuvno pipefail #一次性设置

set -n			#语法检查Read commands but do not execute them
			    #等价于set -o noexec
			    
set -e         #Exit immediately if a command exits with a non-zero status
		       #默认情况下 遇到错误仍然会继续往下执行
		       #等价于set -o errexit

set -x         # Print commands and their arguments as they are executed
			   # 等价于set -o xtrace

set -u         #Treat unset variables as an error when substituting
			   #默认情况下 遇到未定义的变量仍然会继续往下执行
			   #等价于 set -o nounset

set -v		   #Print shell input lines as they are read
               #等价于set -o verbose  跟踪每个命令的执行 
               
set -o pipefail #the return value of a pipeline is the status of
                #the last command to exit with a non-zero status,
                #or zero if no command exited with a non-zero status
                #
                #set -e的对管道的失效
                #	默认情况下, 即使设置了set -e 但管道只要最后一个命令不失败, 
                #   则管道命令总是会执行, 管道命令下面一行的命令也会执行,如
                #       set -e
                #       failCmd | echo "aa"
                #       echo "bbb"
                #为了使管道错误就不执行下面一行命令代码而退出,需要设置该选项
bash -c "echo 'a'; exit 1" | bash -c "echo 'b'; exit 2;" | bash -c "echo 'c'; exit 3"
echo $?
```
##  经验

> ```
> shellcheck $shell_name.sh
> 
> 当在调试模式-x时打印行号
> echo "export PS4='+$LINENO:{$FUNCNAME[0]}'"  >> ~/.bash_profile
> 
> ubuntu6.0默认是dash 比bash精简了很多指令 执行速度更快 也就少了一些功能的支持
> 解决source命令没找到的方法
> 方法1  代码头部添加#!/bin/bash 执行的时候使用source a.sh 或/bin/bash a.sh 或 ./a.sh
> 绝对不能sh a.sh 因为sh使用默认值dash 优先级高于a.sh的提示行,会覆盖掉a.sh的提示行
> 方法2  改变默认的shell为bash, sudo dpkg-reconfig bash
> 
> trap "rm -rf tmpdir" EXIT 无论正常或异常退出都会执行
> trap err_func  ERR  
> UserDefinedErrorVar=0
> function err_func {
> 	if [ $UserDefinedErrorVar -eq 100 ]; then
> 	elif [$UserDefinedErrorVar -eq 100 ]; then
> 	fi
> }
> 
> while read line; do
> 	echo $line
> done < file.txt
> 
> for word in $line; do
> 	echo $word
> done
> 
> for((i=0;i<${#word};i++));do
> 	echo ${word:i:1}
> done
> 
> shell中的函数只能返回整数值 否则 numeric argument required,如果需要获取值可以echo "aa"
> function f(){ echo "aa"; return 0;}
> $(f)
> 
> export OH=  等价于  export OH=""  等价于 javascript中的undefined
> if [ $OH ]; then echo "1"; else echo "2"; fi
> 
> 对于设置set -e的shell来说
> 情景1:
> 	if [ `which ipfs2` ]; then echo "11"; else echo "22"; fi
> 情景2  #崩了, 不能赋值, 更不用说再往下执行了
> 	$badCmd
> 	v=`$badCmd`  
> 	$badCmd | $(some cmd has something to do with preCmd)
> 情景4   #这条组合命令的返回值等于后一个命令的返回值
> 	$badCmd || $(some cmd has nothing to do with preCmd) 
> 	$badCmd || :
> 
> #添加path
> if [[ ! "$PATH" == */root/.fzf/bin* ]]; then
> 	export PATH="${PATH:+${PATH}:}/root/.fzf/bin"
> fi
> 
> help() {
> cat << EOF
> usage: $0 [OPTIONS]
> --help               Show this message
> EOF
> }
> 
> 引号""
> 变量特别是路径变量需要使用双引号围住如"$path",否则如果path中含有空格则有可能前一部分赋值后一部分执行命令
> '"${variable}"'   尽管''中直接变量${v}不转义,但${v}先在""中
> " "${var}" is ok" 里面的双引号""竟然不用转义
> 
> 赋值
> va="$()"
> va=$()
> 
> ``替换为"$($cmd)" 且不用空格
> $(( $n + 1 ))    数值计算$((后需要空格
> 
> 在shell脚本中不能使用~代替用户根目录而应该使用$HOME 例如 mkdir "{HOME}"/ipfs, 而不能是mkdir ~/ipfs
> [ $environment_variable ] && echo "OK"  #判断环境变量是否设置 对于简单判断if-then-fi直接&&
> 若写入到~/.bash_profile的环境变量未生效, 则在shell脚本中先source "${HOME}"/.bash_profile
> ```
>

#  命令

##  man/info 

```
    ________________type________________
	|       |        |         |       |
  alias  declare  builtins   PATH   scriptName
严格执行
type 
	type -t $symbol   #alias function keyword builtin file 
alias
	alias $symbol
declare
	declare -f $symbol
	declare -p $symbol
builtins  # 若type返回$symbol is shell builtsin(pwd)   compgen -b
	help $cmder 
keywords  # 若type返回$symbol is shell keyword(for)    compgen -k
    help $cmder
PATH
	whatis $cmder   #获取描述，得知大致功能
	whereis $cmder  #得知bin/source/man&info位置
		busybox $cmder --help   #bman busy    man tar top
		cman $cmder             #cman chinese man 
		tldr $cmder             #sman simple  man
		
		$cmder --help   #防止man和info会提供太详细而不归类的文档
		man -[1-9] $cmder
		info $cmder     #若whereis返回值中有info位置

#终极大杀器，查看安装的官方文档/usr/share/doc/下的README
locate $keyword | grep share 
#死马当活马医
man -k $keyword  #man short description搜索
man -K $keyword  #man手册全局搜索
info -k $keyword #index搜索
info -a $keyword #info手册全局搜索


help
help help
help echo 
help \(\(   #否则会当做sub shell group cmder

经典命令
enable


man -h        #man的输出其实是less快捷键操作  默认忽略大小写
man -k printf #在cmdname及其short description部分匹配搜索keyword
man -K printf #全局搜索keyword
man -w printf #where 说明printf手册的位置  
cd $(dirname $(man -w man)) && ls -1 #查看man1有哪些命令

#经典命令
manpath -g | tr : \\n
man2html /usr/share/man/man7/ip.7.gz > ip.html


#经典文档
man bash
man test
man 2 syscalls  #查看系统调用system call
man 7 signal    #查看信号安全signal-safe函数functions man 7 pthreads
man 7 tcp udp
man 7 time   #real proces hard/soft/HZ/jiffies/epoch

#进程间通讯
man 7 svipc     #system v(古罗马数字5) interprocess communication mechanisms
                #msg sem shm
man 7 sem_overview semver
man 7 shm_overview
man 7 mq_overview
man 7 pipe
man 7 fifo


#粗略文档，一扫而过
man man
man 1 busybox
man 7 man man-pages       #man文档的格式
man 3 readline  #查看快捷键绑定
man intro       #chkconfig是perl脚本
man 7 asscii armscii-8       #128 256
man 7 bash-builtins builtins #help参考手册
man 7 boot bootparam bootup  #linux启动流程图
man 7 charsets 
man 7 environ   #environ 全局变量
man 7 standards #c有哪些标准
man 7 glibc     #http://www.gnu.org/software/libc/ git clone git://sourceware.org/git/glibc.git && cd glic && git checkout master
man 7 glob regex     #文件名/路径通配符globbing，区别于正则表达式 ?任意单个字符 *任意长度(包括0)的任意字符
man 7 nmcli-examples
man 7 posixoptions #查看posix api
man 7 suffixes units    #查看文件后缀 磁盘容量单位KMGTPEZY
man 7 symlink
man 7 systemd.index #列举systemd有哪些内容 
man 7 systemd.special #列举systemd各target service的含义
man 7 utf8 url(查看转义 lynx man2html)
man 7 arp imcp

#各级别
man man         #帮助系统各级别说明 
man 7 hier file-hierarchy     #文件系统目录说明  
man runlevel    #


#查看文档快捷键


info -h
info -a printf #search all
info -k printf #search index
info -w nano   #where 说明nano手册的位置  /usr/share/info
cd $(dirname $(info -w nao)) && ls -l #查看info有哪些手册

#经典文档
info info

#查看文档快捷键
```



##  echo

```
-e   //转义生效  echo -e "print\tprint2"
-n   //不换行
```

## date/timedatectl

```
设置
	格式 date -s, --set=STRING #man date参考<http://www.gnu.org/software/coreutils/date>
	                          #        参考输入格式Date inpute format
	date [-u|--utc|--universal] [MMDDhhmm[[CC]YY][.ss]] #设置系统时间的格式
打印
	格式 date [-d,--date=String] [+FORMAT]
		-d 默认值now
    date --date='@2147483647'  
    date --date='@-1'
    date -d "$(date -R)" +%s
    date --date='2012-07-01 00:00:00 +0800' +%s #若不含时区时默认为计算机设置的系统时区

格式
	预定义格式
		-I[FMT],--iso-8601[=FMT]        #2006-08-14T02:34:56-06:00
			date (default)
			hours/minutes
			seconds
			ns
		-R, --rfc-email #RFC 5322 format #Mon, 14 Aug 2006 02:34:56 -0600
		--rfc-3339=FMT  #RFC 3339 format #2006-08-14 02:34:56-06:00
			date
			seconds
			ns
		-u, --utc, --universal #UTC
	自定义格式
		Date
			%[aAbBcCdDeFgGhjmuUVwWxyY]
			%Y 4位           %y2位
			%m    
			%d	             %D==%m/%d/%y
			%F == %Y-%m-%d
		Time
			%[aAbBcCdDeFgGhjmuUVwWxyY]
			%H 24小时制  %I 12小时制
			%M 
			%S               %s seconds since 1970-01-01 00:00:00 UTC
			%T == %H:%M:%S
		Zone
			%z     +hhmm numeric time zone (e.g., -0400)
			%:z    +hh:mm numeric time zone (e.g., -04:00)
			%::z   +hh:mm:ss numeric time zone (e.g., -04:00:00)
			%Z     alphabetic time zone abbreviation (e.g., EDT CST中国标准时间)
		Literal
			%[%nt]
		Padding and other flags

	

时间标准
    观察天体
        GMT: Greenwich Mean Time         格林威治标准时
                老的时间标准  根据地球自转和公转计时,每天中午12时经过格林威治天文台 
                由于地球自转正在缓慢变慢,尽管感觉不到差异,会不太精准
        UTC: Universal Time Coordinated  世界时
                新的时间标准  最精准的原子钟50亿年才误差1秒,可以说非常精准
    
    CST:  China Standard Time 中国标准时间
    DST:  Daylight Saving Time 
    	  夏令时 指在夏天太阳升起比较早时,将始终拨快1小时,以提早日光的使用. (中国不使用)

    GMT+8 == UTC+8 == CST

时区
    查看时区 
        date -R  
        timedatectl
    更改时区 
        先获取时区 
            方法1:  tzselect  #按照指引一路选择,就可以获取时区值
            特殊:  
                    CentOS/Linux:  timedatectl list-timezones    
                                    timeconfig --utc "Asia/Shanghai"
                    Debian:        dpkg-reconfigure tzdata
        再设置时区
            方法1:  export TZ='Asia/Shanghai';
            方法2:  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
            特殊:
                CentOS7/RHEL7/SLinux7: timedatectl set-timezone Asia/Shanghai

时间
    系统时间/软件时间/WallTime
        WallTime 系统时间  由系统维护,可以是临时的,可以是网络上同步来的,可以是硬件读取的,
                          前提是系统服务正常,如果系统关机了,就不存在WallTime
        查看
            date 
            timedatectl
        更改
            date -s  06/22/96
            date -s  17:55:55
            date -s "11/03/2009 17:55:55"
            date 1005113817.30              #格式MMDDhhmmYYYY.ss

            timedatectl set-time "2018-11-24 12:00:30"

            网络同步时间
                yum install ntp ntpdate sntp

                ntpdate -u ntp.api.bz  //断点式校正
                service ntpd start   //步进式校正
                service ntpd status
                ntpstat  //查看服务状态及NTP时钟源服务器
                systemctl enable ntpd.service//开机启动   
                						   #systemctl is-enabled chronyd.service   
                						   #systemctl disable chronyd.service
                #crontab -e 每天凌晨0点同步时间并写入硬件 假设NTP服务器IP为123.123.123.123
                0 0 * * * /usr/sbin/sntp -P no -r 123.123.123.123;hwclock -w 
                
    硬件时间
        RTC:     RealTimeClock  CMOS时间  BIOS时间   仅保存日期和时间,不保存时区和夏令时
        查看
            方法1:  clock -r   #hwclock是clock的软连接
            方法2:  clock --show
        更改
            clock --set --date="10/06/17 11:55"   #格式（月/日/年时:分:秒）

    软硬同步
        软同步到硬中
            clock -w         #将系统日期时间写入BIOS
            clock --systohc  #systeim-time to hardclock 
            timedatectl set-local-rtc 1 #将硬件时钟调整为与本地时钟一致  
                                        #0为将硬件时钟调整为与UTC时钟一致

        硬同步到软中
            clock --hctosys  #hardclock to  system-time  以硬件时间为准
```

```
timedatectl status
timedatectl set-ntp true
```

##  printf

```
printf "dev%03d" $machine_num
```

##  xargs

```
xargs -t  cmder #对传递过来的都执行一次命令cmder
     -d         #指定定界符 单行为空格 多行为\n
```

##  find

```
find / -type f -size +5M           # 查找大于 5M 的文件
find ~ -mmin 60 -type f            # 查找 $HOME 目录中，60 分钟内修改过的文件
find . -type f -newermt "2010-01-01" ! -newermt "2010-06-01"
```

##   grep/egrep/fgrep

```
grep
	-a //将binary file 当做 txt文件
	-n //行号
	-i //ignore case
	-H //with filename
	-r //recursive
	-v #忽略
	
	""  双引号中可以含有变量${var} ''不能含有变量
	^   行首
	$	行尾
	\<   单词开始
	\>   单词结束
	\b   单词锁定符 \bgrep\b
	\B   非单词锁定符
	
	.    任意不换行的字符
	\w   [_A-Za-z0-9]  [_[:alnum:]]
	\W   ^\w
	
	################################  ( { |属于扩展
	\(..\)   
	[-]
	[^]
	\{m\}
	\{m,\}
	\{m,n\}
	
	*             #####################  ? + 属于扩展
	
	posix
		[:alnum:]   字母数字
		[:xdigit:]   16进制
		[:alpha:]    字母
		[:digit:]    数字
		
		[:lower:]
		[:upper:]
		
		[:graph:]	非空字符(非空格 控制字符)
		[:print:]   非空字符
		[:cntrl:]	控制字符
		[:punct:]   标点符号
		[:space:]	空白字符(新行 空格 制表符)

grep -A 5 "foo"   file            # 前5行         
grep -B 5 "foo"   file            # 后5行
grep -C 5 "foo"   file            # 前后5行
grep -e "class" -e "vitural" file #多个匹配



egrep == grep -E
	{m,n}=\{m,n}
	?
	+
	a|b|c
	()  字符组 # 查找C++文件   ".*\.(cpp|hpp|c|h|hh|cxx|cc)" 
	           # 查找makefile  '(.*\.mak$)|(.*\.mk$)|(makefile)$'
	()()\1\2  模板匹配\1表示前一个模板 \2表示后一个模板
fgrep == grep -F  #fixed 即pattern不转义,为字面字符
```

##  sort

```
sort file                          # 排序文件
sort -u file                       # 去重排序
sort -f file                       # 忽略大小写 ignore case
sort -r file                       # 反向排序（降序）
sort -n file                       # 使用数字而不是字符串进行比较
sort -g file                       # 使用float进行比较
sort -h file                       # human-readable 1K 1M 1G
sort -t: -k 3n /etc/passwd         # 按 passwd 文件的第三列进行排序
arp -n | sort -t. -n -k1,1 -k2,2 -k3,3 -k4,4  #linux命令查询局域网内所有主机并按ip排序
```

##  uniq

```
-i    #ignore case
-s N  #skip跳过前面N个字符
-w N  #width最多比较不超过N个字符

-c   #count 显示重复次数  所有的行都显示, 且每重复的group统计次数

-d   #duplicate 只显示重复的行, 且每重复的group只显示一次
-D   #Duplicate 只显示重复的行, 且每重复的group都显示

-u   #只显示没有重复的行
```

##  tr

```
tr s d   #单字符转换
tr "mul_src" "mul_dst"  #多字符转换
tr -d '0-9'             #删除所有数字
tr -s  ' '              #压缩重复出现的多余的空格,只保留第一个 sequence repeate
tr -c  
```

##  paste

```
paste -s -d $delimiter file  #使用delimeter多行变一行
paste         file1 file2    #两文件各自取一行组成新的一行
paste -d '\n' file1 file2    #两文件轮流取行
```

##   join

```
join file1 file2  #根据file1的第一个字段和file2的第一个字段进行匹配,类似sql中的主键外键,组成新的一行
join -t ','    file1 file2  #定义分隔符
join -1 3 -2 1 file1 file2 #将file1的第3字段与file2的第1字段匹配
```

##  cut

```
范围表示
    N
    N-M     # [N,M]
    N-      # [N,$)
    -M      # [-1,M]

按byte
    cut      -c 1-16                   # 截取每行头16个字符
    cut      -c 1-16 file              # 截取指定文件中每行头 16个字符
    cut      -c 3-                     # 截取每行从第三个字符开始到行末的内容
按分隔符
    cut -d':' -f5                      # 截取用冒号分隔的第五列内容
    cut -d';' -f2,10,12                # 截取用分号分隔的第二和第十列 第十二列内容
    cut -d' ' -f3-7                    # 截取空格分隔的三到七列
    cut -d' ' -f3
取反
	cut -f3 --complete
```

##  sed

```
-e --expression=
-f --file=
-n --quiet --silent

范围scope
    # 数字行号
        2      #数字行号
        2,$    #数字行号 $最后一行
        2,+3   #数字行号 +-表示相对行号  +3后面连续3行
    # 正则表达式
        /$reg/
        /$reg/,$
        /$reg/,+3

//增
    '${scope}i${content}'   #insert ${content}中"\"表示换行
    '${scope}a${content}'   #append ${content}中"\"表示换行
//删
    '${scope}d'             #delete 整个${scope}删除
//查
    '${scope}p'             #print
//改
c
    '${scope}c${content}'   #change 整个${scope}改为${content}
s #类似于vi中:s
    '${scope}s/${src}/${dst}/${occure_scope}g'   #subsitute替换
    dst
        用&表示整个${src}, 类似于正则中group表示\1
        用\1表示group
    occure_scope
        1   #行内第一处
        N   #行内第N处
        Ng  #从行内第N处开始
        
sed -r 's/^[ \t]+(.*)[ \t]+$/\1/g'  #去掉收尾空格
sed -e 's/<[^>]*>//g' foo.html      #去掉html标签


sed 's/find/replace/' file         # 替换文件中首次出现的字符串并输出结果 
sed '10s/find/replace/' file       # 替换文件第 10 行内容
sed '10,20s/find/replace/' file    # 替换文件中 10-20 行内容
sed -r 's/regex/replace/g' file    # 替换文件中所有出现的字符串
sed -i 's/find/replace/g' file     # 替换文件中所有出现的字符并且覆盖文件
sed -i '/find/i\newline' file      # 在文件的匹配文本前插入行
sed -i '/find/a\newline' file      # 在文件的匹配文本后插入行
sed '/line/s/find/replace/' file   # 先搜索行特征再执行替换
sed -e 's/f/r/' -e 's/f/r' file    # 执行多次替换
sed 's#find#replace#' file         # 使用 # 替换 / 来避免 pattern 中有斜杆
sed -i -r 's/^\s+//g' file         # 删除文件每行头部空格
sed '/^$/d' file                   # 删除文件空行并打印
sed -i 's/\s\+$//' file            # 删除文件每行末尾多余空格
sed -n '2p' file                   # 打印文件第二行
sed -n '2,5p' file                 # 打印文件第二到第五行
```

##   awk

```
awk -F ',' '{s+=$1; print $5, $NF;} END {print s}' file  # 打印文件中以逗号分隔的第五列 最后一列
awk '/str/ {print $2}' file                              # 打印文件中包含 str 的所有行的第二列
awk '{s+=$1} END {print s}' file                         # 计算所有第一列的合
awk 'NR%3==1' file                                       # 从第一行开始，每隔三行打印一行
awk '{for (i=0; i<$NF; i++){print $i;}}'
awk '{i=1;while(i<NF) {printf(\"%s\n\", \$i);i++}}'

history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
netstat -n | awk '/^tcp/ {++tt[$NF]} END {for (a in tt) print a, tt[a]}'

awk -v n=4 'NR == n {next} {print}' a.sh #去掉第4行 当行号等于4时执行next就是处理下一行
                                         #v表示外面变量赋值并传入里面
                                         
options
	-F              #定义分隔符
	-v awkV=$outV   #传递外部变量到awk outV=100; awk -v awkV=outV '{print $awkV;}'
	
	'program-text'  #当命令较短时,
	-f program-file #当命令较长时,从文件$program-file而不是从cmdline, 可以有多个-f $file
	
	#a sequence of pattern {action} and user defined functions.
	#前面的BEGIN expression,expression END属于pattern 后面的{action}
	BEGIN{}
	expression, expression {}
	END{}
	function $userFuncName(arg1, ..., argN){}  #可以先引用后定义
	
	#seq 100| awk 'NR==4,NR==6{print}'
	#awk '/start_pattern/, /end_pattern/' filename

程序结构
    if (expr) else statement
    while(expr) 
    do statement while (expr)
    for(opt_exp;opt_exp;opt_exp){}
    for(var in array) {statement}
    continue break

数组
一维数组
	转化为关联数组,关联数组的下标为字符串 arr[1]  等价于 arr["1"]
	判断存在 if (arr[exp]) { print "sub exist"} else { print "not exist" }
	遍历    for(var in arr)
	删除    delete arr[exp]删除某个元素  delete arr删除整个数组
多维数组
	for ( (i,j) in arr) print arr[i,j]   #SUBSEP

正则匹配使用egrep
    exp  ~ /$reg/  {action}  #子正则匹配即可 //表示正则的起始
    exp !~ /$reg/  {action}  #!表示取反
    $0  ~  /$reg/  {action}  #
           /$reg/  {action}  #与上面一个等价

内置变量
    $0 $1 ... $NF #RS='\n' OFS   $0整行 
    ARGC    #mawk -f prg v=1 A t=hello B argc=5 argv[1]='v=1'
    ARGV
    CONVFMT 转化字符串为数值的默认值 默认值'%.6g'
    ENVIRON[var]=value
    FILENAME 文件名
    FNR      当前行在文件FILENAME中的行号
    FS       field separator
    NF       当前行有多少个field
    NR       当前行在所有文件中的行号
    OFMT     输出时格式化数值为字符串的默认值
    OFS      输出时field的分隔符
    ORS      输出时record的分隔符
    RLENGTH  length set by the last call to the built-in function, match().
    RS       输入时record的分隔符默认值\n
    RSTART   index set by the last call to match().
    SUBSEP    used to build multiple array subscripts, initially = "\034".

内置函数
	gsub(r,s,t) gsub(r,s) #将t中符合r的替换为s,返回替换次数 当t不存在时使用$0
	index(s,t)            #返回t中s的位置,从1开始计数 0表示没有找到
	lenght(s)
	math(s,r)             #返回s中符合正则贪婪匹配r的位置,从1开始计数
	split(s,A,r) split(s,A)  #将s中按照正则r分割并存放于数组A,返回数组元素数;r的默认值为FS
	sprintf(fmt,exp-list)
	sub(r,s,t) sub(r,s)  #至多一次替换
	substr(s,i,n) substr(s,i)  #返回s[i:i+n]
	tolower(s) toupper(s)
	sin cos atan log int sqrt rand srand rand
输入输出
	print #等价与print $0 ORS
	print exp1, exp2, ..., expN #输出exp1 OFS exp2 OFS ...
	printf fmt, exp-list
	
	getline                 #从stdin保存到$0
	getline var             #从stdin保存到var
	getline     < file      #从file中输入保存到$0
	getline var < file      #从file中输入保存到$var
	command | getline       #使用/bin/sh执行command,通过管道传递到$0
	command | getline var   #使用/bin/sh执行command,通过管道传递到$var
	
	close(exp)
	fflush(exp)
	system(exp)  #使用/bin/sh执行exp
	
	#echo | awk '{"grep root /etc/passwd" | getline cmdout; print cmdout }'
	
function
	function name( args ) {  #一般传值调用,数组是引用传递 
		return opt_exp; #不是必须有return
	}
	可以递归调用name(arg1,arg2), bash不可使用括号()
	可以先引用后定义
```

## lsof

```
用户
    -u $user      #支持正则  ^$user表示不是这个用户的其他用户
    -g $groupID
进程号
    -p $pid       #pid
进程名
    -c $progName  #cmd  列出进程以progName开始的文件  等价于lsof | grep  $progName
文件/目录
    $filename            #全路径 lsof `which httpd`
    -d $fd               #
    +d $dirName          #列出目录下打开的文件
    +D $dirName          #递归列出目录下打开的文件
网络
    -i[46] [protocol][@hostname|hostaddr][:service|port] [-r] [+r] [-n]
        46  #ip4 ip6 
        protocol #tcp udp 
        Hostname 
        hostaddr #ipAddr 
        service  #/etc/service中的serviceName,可以不止一个
        port     #可以不止一个    2150=2180
        -r       #一直执行,直到收到中断信号
        +r       #一直执行,直到没有档案显示,缺省15s刷新
        -n       #不将IP转换为hostname，缺省是不加上-n参数


-t   #只返回pid
+L1  #显示打开文件数小于1的进程,这通常（当不总是）表示某个攻击者正尝试通过删除文件入口来隐藏文件内容
    
lsof -P -i -n | cut -f 1 -d " "| uniq | tail -n +2 # 显示当前正在使用网络的进程
```

##  nc/netcat

```
Swiss-army knife for TCP/IP  瑞士军刀
由Hobbit于1996.3发布1.10版,之后没有再维护

传输文件  最初目的
	在192.168.2.34上： nc -l 1234 > test.txt
	在192.168.2.33上： nc 192.168.2.34 < test.txt
	
端口扫描
	nc -v -w 2 -z 102.168.1.106 $port1-$port2
		-v #verbose
		-w #waittime
		-z #z mode

监听
	TCP
		nc -v -l      $port       #TCP Listen
		nc -v     $ip $port
	UDP
        nc -v -l -u      $port       #UDP Listen
    	nv -v    -u $ip  $port
    
代理/端口转发PortForwarding
	#单向
	 ncat -l 8080 | ncat 192.168.1.200 80  #只能从8080到80
	 
	 #双向
	 mkfifo 2way
	 ncat -l 8080 0<2way | ncat www.google.com 80 1>2way
	 ###本地启动8080端口,然后转发到www.google.com的80端口
	 
后门
	server端: ncat -k -l $port -e /bin/bash #对每个连接后都执行/bin/bash,
	                                        #之后client就可以命令行操作
	client端: ncat $ip $port
```

ncat

```
nmap团队对nc改造的升级版
```

socat

```
netcat的升级版
```

##  nmap

```
network mapper
主要用于端口扫描 由Fyodor 1997年发布 一直在维护
渗透工具Metasploit、漏洞扫描工具openVAS等工具都内置了Nmap，而漏洞扫描工具Nessus也支持导入Nmap扫描结果

open:
closed:接收nmap探测报文并作出响应,但没有应用在监听
filtered:被过滤而无法确定是否open/closed,可能是由于防火墙路由规则等
unfiltered:未被过滤意味着端口可访问而无法确定是否open/closed
open|filtered:无法确定是open还是filtered,例如开放的port不响应
closed|filtered:无法确定是open还是filtered

#默认值扫描1-1024再加上nmap-service列出的端口,所以最好自定义扫描端口
nmap [-sU] [-Pn] $ip-range [-p$port-range] 
	sU      #UDP扫描,默认TCP
	Pn		#不对主机进行ping,即不判断主机是否在线
    ip-range
        10.0.1.161	  				#192.168.1.100
        10.0.1.161 10.0.1.162
        10.0.1.161,162
        10.0.1.161-200
        10.0.3.0/24
        -iL ip.txt
        --exclude 10.0.1.161,10.0.1.171-172
        --excludefile ex_ip.txt
    port-range
        1-65535
        1-5000,6000,7000-8000
```

#  性能状态

##  ps

```
axjf
```

##  top

```
-d 间隔时间 默认5秒
-p pid
?
P CPU M Mem N PID T cpu time+ k kill
```

##  mpstat

##  free

```
               1             2          3          4          5          6
1              total       used       free     shared    buffers     cached
2 Mem:      24677460   23276064    1401396          0     870540   12084008
3 -/+ buffers/cache:   10321516   14355944
4 Swap:     25151484     224188   24927296

#FO is short of freeOutput
FO[2][1] = 24677460	FO[3][2] = 10321516
total = used + free   #FO[2][1] = FO[2][2] + FO[2][3]
used – buffers – cached #FO[3][2] = FO[2][2] - FO[2][5] - FO[2][6]	
free + buffers + cached #FO[3][3] = FO[2][3] + FO[2][5] + FO[2][6]
//执行sync命令
A buffer is something that has yet to be "written" to disk.  
A cache is something that has been "read" from the disk and stored for later use.
//执行 echo N>/proc/sys/vm/drop_caches
也就是说buffer是用于存放要输出到disk（块设备）的数据的，而cache是存放从disk上读出的数据。这二者是为了提高IO性能的，并由OS管理。
对于FO[3][2]，即-buffers/cache，表示一个应用程序认为系统被用掉多少内存；
对于FO[3][3]，即+buffers/cache，表示一个应用程序认为系统还有多少内存；
因为被系统cache和buffer占用的内存可以被快速回收，所以通常FO[3][3]比FO[2][3]会大很多

https://www.kernel.org/doc/Documentation/sysctl/vm.txt

This is a non-destructive operation and will not free any dirty objects.
To increase the number of objects freed by this operation, the user may run
`sync' prior to writing to /proc/sys/vm/drop_caches.  This will minimize the
number of dirty objects on the system and create more candidates to be
dropped. 
To free pagecache:
	echo 1 > /proc/sys/vm/drop_caches
To free reclaimable slab objects (includes dentries and inodes):
	echo 2 > /proc/sys/vm/drop_caches
To free slab objects and pagecache:
	echo 3 > /proc/sys/vm/drop_caches
优先执行sync, 然后执行 echo N > /proc/sys/vm/drop_caches
```
```
##   vmstat

```
vmstat [delay [count]]
    -n  causes the headers not to be reprinted regularly

    输出
        r  正在running process, 一般小于CPU较好
        b  正在blocking process,
##  swap

```
dd if=/dev/zero of=/swapfile bs=1024 count=262144 #创建256M的文件
mkswap /swapfile #将这个文件变成swap文件
swapon /swapfile #启用这个swap文件
/swapfile swap swap default 0 0 #编辑/etc/fstab文件,每次开机自动加载swap文件

swapoff -a  && swapon -a
```

##  iotop

##  iostat

```
iostat [delay [count]]
    CPU
        -c 1 10 # 只显示CPU状态 每隔1秒显示显示10次

    Device
        -d []    # 默认显示所有设备磁盘 只显示某块磁盘device即磁盘状态
        -x       # 显示io的扩展数据,默认不显示扩展数据 有关键字段%util(使用率 如果%util接近100%,说明IO较大,有瓶颈) await(响应时间)
        -k       # 某些时候的block为单位的列强制转化为kilobytes为单位

典型用法
	iostat -c [delay [count]]     #查看CPU

	iostat    -k [delay [count]]  #查看TPS和吞吐量
	iostat -x -k [delay [count]]  #查看设备device磁盘的使用率(%util) 响应时间(await)
```

##  netstat

```
-l  tcp udp raw unixsocket

-t  tcp
-u  udp

-p  pid/progname

-n  localAddress 默认显示host:serviceName, 转化为ip:port

-s  Display summary statistics for each protocol
-i  Display a table of all network interfaces, or the specified iface.
-r  Display the kernel routing tables

经典用法
netstat -n | awk '/^tcp/ {++tt[$NF]} END {for (a in tt) print a, tt[a]}'
netstat -rn    #查看路由
```

##  ss

CentOS7中netstat的升级版   处理大量连接时更高效

##  iptraf

CentOS7 为iptraf-ng

iptraf -g //每个网卡从启动以来的流量

iptraf -d eth0 //eth0 总体流量、流入量、流出量、以及按协议分类的流量统计 

iptraf -s eth0 //各端口统计

iptraf -i eth0 //某端口统计

#  用户及权限

- 用户/组

  查看所有用户 /etc/passwd 所有组 /etc/group 所有密码 /etc/shadow

  查看某一用户属于哪些组  id  $user 中的groups字段

  查看某组有哪些用户

  ​	groupmems [opt]  [-g [root]]

  ​		-a $user #add 添加用户

  ​		-d $user #del 删除用户

  ​		-p            #purge 删除整个组成员

  ​		-l              #列举组成员

- su

  su   root

  su - root

- sudo

  让大家一起使用root用户, 分辨不出不同的用户的操作.

  为了让用户使用root权限,又为了分辨不同的用户,产生了sudo命令,又称为受限的root

  - sudo -l                                  #查看以超级用户运行时的权限,即当用户在root组中的权限
  - sudo -u yy $cmd                #以超级用户yy

- visudo   = vi /etc/sudoers + 检查文件格式 

  - 设置可以执行的命令 

    \#yy可以在192.168.175.136,192.168.175.138机器

    \#以root身份执行/usr/sbin/下的所有命令，除了/usr/sbin/useradd

    yy 192.168.175.136,192.168.175.138=(root) /usr/sbin/,!/usr/sbin/useradd

  - 

#  文件目录路径及权限

```
pwd 
	-L    #尽量使用link path
	-P    #尽量不使用link path, 使用物理路径

touch 
	-a  修改accesstime
	-c  修改状态改变时间
	-m  修改文件modifytime
	-d  后接date，默认为today
	-t  后接时间，默认为now   格式为YYYYMMDHHmm

文件的rwx都是相对内容来说，不能修改文件名/删除文件本身
目录的内容指的是下面的文件名列表
所以目录的读指的是只读取目录下面的文件名，不能读取文件的除文件名的其他属性（ls -l除了知道是文件和文件名之外，其他都不知道，用？表示）
    目录的写指的是+(新建子文件和子目录)-（删除子文件和子目录) 改(修改子文件名和子目录名)
    目录的执行指的是进入该目录 cd $dir 
	所以目录为了安全与方便， 一般给rx权限
	
mkdir -m 711 $dir

mytempdirname=$(mktemp -d)
pushd ${mytempdirname}     # 目录压栈并进入新目录
//do something
popd                # 弹出并进入栈顶的目录
tar czvf $(uname -n)-$(date +'%Y-%m-%dT%H:%M:%S%z').tar.gz -C $mytempdirname .
rm -rf ${mytempdirname}

dirs -v             # 列出当前目录栈

cd -                # 回到之前的目录
cd -{N}             # 切换到目录栈中的第 N个目录，比如 cd -2 将切换到第二个

stat {file}
du -sh {file|dir}
mkdir -p work/{project1,project2}/{src,bin,bak}

chmod -R  u=rwx,go=rx        $dir 
chown -R  $newUser:$newGroup $dir  
chown -R  $newUser.$newGroup $dir 
chown -R  $newUser           $dir 
chown -R .$newGroup          $dir
chgrp -R  $newGroup          $dir


umask #显示用户掩码  数字表示  mask是表示需要去掉的权限 
      #文件的默认权限是rw-rw-rw-(666) 文件夹的默认权限是rwxrwxrwx(777)
	  #所以当umask是0022时，关注后三位，说明owner不用去掉权限，group要去掉权限2/w，other要去掉权限2/w
		  #不是简单去掉（做减法去借位),而是有这个权限的前提下，即同位相减，不能借位
		  #所以拥有mask为022创建文件权限rw-r--r--(666-022=644) 文件夹rwxr-xr-x(777-022=755)
umask 002 #临时修改用户掩码
umask -S  #symbol表示
		  #默认root的umask为022，一般用户为002，即普通用户同组可以有写权限

rename  批量更名
head -n -100  #倒数100行不显示
tail -n +100  #前100行不显示

ls   默认按名称排序
   	-d        #显示目录，而不是目录下的内容
   	-i        #显示inode节点编号 
   	
   	-lS       #size 按大小排序
   	-lt       #time 按时间排序  
		--time-style=long-iso  等价于 --full-time
		--time={atime,ctime} 
				mtime 默认是modification time  如果之后未修改文件内容，这就是文件的建立时间
				atime访问文件内容 
				ctime改变文件属性(权限 用户 时间)
				
   -h  大小以人类可读形式
   -R 递归
   
ls -lsh 第一列为因为占块所占的大小 size为实际数据的大小

cp 
    -r   
    -p 连带文件属性复制 --preserve=mode,ownership,timestamps 否则文件的时间为执行复制的时间
    -d 连带链接属性复制 --no-dereference --preserve
    -a ==-rpd   打炮啊  #无法复制ctime这个属性
	
	-l 复制为一个软连接
	-l 复制为一个硬链接
	
####10位之内的特殊权限
SUID 
	chmod u+s  针对owner而言 所以ls -l中owner中的执行位为可能表现为S或s(S+x)  
	例如ls -l /usr/bin/passwd
	特点
		只针对二进制可执行程序而言
		该标志位可以使执行者仅在执行过程中具有owner权限
		如执行者other使用命令passwd可通过owner为root更新other没任何权限的/etc/passwd文件
SGID
	chmod g+s  针对group而言 所以ls -l中group中的执行位为可能表现为S或s(S+x)  
	例如ls -l /usr/bin/locate 或 ls -l /usr/bin/mlocate
	特点
		可针对二进制可执行程序而言，该标志位可以使执行者在执行过程中具有group权限
			执行者other使用命令locate可通过group为slocate查询执行者没有任何权限的mlocate.db
		可针对文件夹，用户对该目录具有rx权限
SBIT 
	chmod o+t  针对other而言 所以ls -l中other中的执行位为可能表现为T或t(T+x) 
	例如 ls -ld /tmp
	特点
		只针对目录而言 group或other用户对该目录具有wx权限
		在该目录下谁创建的文件、文件夹，这个新创建的文件或文件夹只有自己和root能够删除
		
	chmod (SUID+SGID+SBIT)xxx 以前C语言api中参数mode一般设置0777，现在这个0要设置值了
		                      SUID为4 SGID为2 SBIT为1
	S+x == s
	T+x == t
			man ls 在最后 info '(coreutils) ls invocation' 
		    执行info '(coreutils) ls invocation'
		    在*What information is listed按回车
     ‘s’
          If the set-user-ID or set-group-ID bit and the corresponding
          executable bit are both set.

     ‘S’
          If the set-user-ID or set-group-ID bit is set but the
          corresponding executable bit is not set.

     ‘t’
          If the restricted deletion flag or sticky bit, and the
          other-executable bit, are both set.  The restricted deletion
          flag is another name for the sticky bit.  *Note Mode
          Structure::.

     ‘T’
          If the restricted deletion flag or sticky bit is set but the
          other-executable bit is not set.

     ‘x’
          If the executable bit is set and none of the above apply.

####10位之外的特殊权限
lsattr  $file/dir  #列举mod10位之外的特殊属性  ls只会列举一些普通的mod10位的属性
chattr  $file/dir  #改变特殊属性  ex2~4全支持 xfs只支持aiAds
	+-=            #类似于chmod的action，但没有uog这些参数
	a  只能增加数据，不能删除和修改数据   只有root才有此权限
	i  root也不能直接增加删除数据 不能改名 不能删除 不能建立连接 只能读取属性和数据，简直固如磐石 
	   只有root才有此权限设置该属性 root也只能先通过去掉该属性后(chattr -i)才可以删除
	
	A 不会更改文件的accestime属性
	S  修改文件时，没有系统缓冲区，直接更改到文件 所以不需要执行sync命令
	c  读取和写入的时候会经过解压/压缩的步骤 一般针对大文件而言
	d  当dump程序执行时，该文件/目录不可dump
	s  当删除后， 数据就真删除了 神仙也无法恢复
	u  当删除后， 数据还是硬盘， 还是可以修复的
	
```

#  ssh

```
ssh -v      user@host           #打开debug模式  host既可为主机名也可为IP

ssh [-i /path/to/id_rsa]  user@host "$cmd"    # 远程执行命令
ssh host -l user “`cat cmd.txt`”  #ssh host -l user $(<cmd.txt)
ssh user@host cat /path/to/remotefile | diff /path/to/localfile –
ssh user@server 'bash -s' < local.script.sh
ssh user@server ARG1="arg1" ARG2="arg2" 'bash -s' < local_script.sh

挂载文件系统
sshfs -o pi@host:/home/pi ~/pi 	# 将远程目录/home/pi挂载到当前主机目录~/pi

#ls -l ~/.ssh      #chmod .ssh 700
authorized_keys    #chmod 600
id_rsa             #chmod 600
id_rsa.pub         #chmod 644
known_hosts        #chmod 644

################代理转发
ssh -t hostB ssh hostC # 在机器A中通过跳转机/中转机/堡垒机B ssh到主机C

################端口转发 ssh隧道



ssh-keygen -t rsa -b 1024 -P '' -f /home/yy/id_rsa
	-t type dsa ecdsa rsa
	-b bytes 
	-P 密码   若需为空,直接""即可
ssh-keygen -p //会进入交互模式 密码操作
              //如若原来没有密码,则直接设置新密码;
              //如若原来有密码,则先输入老密码,然后再输入新密码;若需新密码为空,直接回车即可
ssh-keygen -f /home/yy/id_rsa -y #-y表示根据私钥产生公钥

openssl
	openssl genrsa -out private.pem 2048
	openssl req -new -x509 -key private.pem -out public.crt -days 99999
```

##  无密码登录三部曲

- ssh-keygen             #一路回车,即使碰见输入密码id_rsa.pub的格式为type pubkey user@host

- ssh-copy-id -i .ssh/id_rsa.pub user@host

  等价于 cat ~/.ssh/id_rsa.pub | ssh user@machine “mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys”

- ssh user@host "chmod ~/.ssh/authorized_keys 600"

  一步到位  ssh-keygen; ssh-copy-id user@host; ssh user@host

有密码自动登录

yum -y install sshpass

sshpass -p $password ssh [ -i /path/to/pri_key] user@host

##  代理

```
# 反向代理：将外网主机（202.115.8.1）端口（8443）转发到内网主机 192.168.1.2:443
ssh -CqTnN -R 0.0.0.0:8443:192.168.1.2:443  user@202.115.8.1

# 正向代理：将本地主机的 8443 端口，通过 192.168.1.3 转发到 192.168.1.2:443 
ssh -CqTnN -L 0.0.0.0:8443:192.168.1.2:443  user@192.168.1.3

# socks5 代理：把本地 1080 端口的 socks5 的代理请求通过远程主机转发出去
ssh -CqTnN -D localhost:1080  user@202.115.8.1
```

#  防火墙

```
systemctl enable/disable     firewalld   #设置是否开机启动
systemctl start/stop/restart firewalld   #启动/停止
systemctl status             firewalld
firewall-cmd --stat
firewall-cmd --list-all                 #检查防火墙状态

firewall-cmd --zone=public --add-port=30303/tcp --permanent
firewall-cmd --zone=public --remove-port=80/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-all
firewall-cmd --query-port=8080/tcp


修改配置文件
sed IPV6=yes s/IPV6=yes/IPV6=no /etc/default/ufw #修改为不支持ipv6

ufw disable/enable          #设置开机是否启动
ufw default allow/deny      #设置默认策略, ufw默认不允许外部访问,但能访问外部
systemctl status ufw | grep -i loaded | cut -d';' -f 2 | sed -e 's/^[ ]*//'

ufw reload
ufw reset
ufw status verbose          #inactive !!!!!!!!!!!!!!!!!!!!
ufw status verbose | grep -i status | cut -d: -f2 | sed -e 's/^[ ]*//'

ufw logging on
ufw logging low/medium/high #tail -f /var/log/ufw.log

ufw        allow $port      #tcp和udp
ufw        allow $port/tcp
ufw        allow $port/udp
uf         allow $port1:$port2/tcp  #允许端口范围,当是范围时必须说明是tcp还是udp
ufw delete allow $port

ufw 	   allow from $ip
ufw        allow from $ip to any port 3306
ufw        allow  from $ip/24    #子网掩码方式

ufw        allow $service    #smtp  来自/etc/services
ufw delete allow $servie     #等价于ufw deny $service

ufw        deny   $port
ufw        deny   $port/tcp

ufw        deny   from $ip
ufw        deny   from $ip/24   #子网掩码方式
```

#  units资源/services

systemd-analyze 系统启动耗时

systemd-analyze blame每个服务的启动耗时

|                                  | SysVInit                                                     | systemd                                                      |
| -------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| pid==1的进程名                   | initd                                                        | systemd                                                      |
| 查看默认运行级别                 | 1.runlevel   2.who -r 3.cat /etc/inittab                     | /systemd/system/default.target systemctl get-default         |
| 编写脚本目录                     | cat /etc/init.d/redis.service                                | /lib/systemd/system/redis.service                            |
| 脚本快捷方式                     | cat /etc/rc5.d/*                                             | /etc/systemd/system/mult-*                                   |
| 设置运行级别                     | 见PS 1                                                       | 见PS 2                                                       |
| 重新载入使脚本生效               |                                                              | systemctl daemon-reload  && systemctl restart redis.service  |
| 查看安装了哪些服务并开机启动     | chkconfig --list                                             | systemctl list-unit-files                                    |
| 设置开机启动                     | chkconfig [--add/--del]  $service  on/off                    | systemctl enable/disable $service                            |
| 查看是否开机启动                 | chkconfig --list  $service                                   | systemctl is-enabled/status $service                         |
| 查看哪些服务在运行               | service --status-all \| grep                                 | systemctl list-unit -t service -a                            |
| 直接从脚本执行                   | /etc/init.d/redis.service start/stop/restart                 |                                                              |
| 启动/停止/重启/在运行才重启/状态 | service $service start/stop/restart/condrestart/reload/status | systemctl start/stop/restart/try-restart /reload/status $service |
PS:

​	1. ln -s /etc/init.d/\$servived /etc/rc.d/rc3.d/S100$service

 2. ln -s /lib/systemd/system/redis.service /etc/systemd/system/multi-user.target.wants/redis.service

    systemctl enable/disable 的区别就是在两者之间建立链接 

##  SysVInit

###  写脚本

在目录/etc/init.d下编写服务start/stop/status脚本

/etc/init        #配置文件.conf
/etc/init.d     #bash文件 start stop restart status

###  配置开机启动

- 手动方式 

  ​	 /etc/rc.d/rc[0-6].d  #快捷方式 ln -s /etc/init.d/redisd      /etc/rc.d/rc3.d/S100redis
  ​                                  \#多个运行级别,需要在多个rc[0-6]建立链接
  ​                                  \#	以S100为例, 
  ​                    		  \#		S表示开机启动; 可以替换为K表示开机关闭
  ​                                 \#		100表示启动顺序

- 命令行方式 chkconfig     ubuntu为apt-get install sysv-rc-conf

  ​	--list               [$service]                   #列出所有/某服务的运行级别  eg.  chkconfig --list httpd

  ​	--add/--del    $service                     #设置开机启动                           eg. chkconfig --add httpd 

  ​	[--level35]     $service   on/off        #设置开机启动                          eg. chkconfig --level35 http on

- TUI方式redhat之ntsysv

  ​	默认情况下，当前运行级别为多少，在ntsysv中设置的启动服务的级别便是多少
  ​    	比如，我当前的运行级别是3,那么我在伪图形界面中选择启动服务后，它的运行级别也会是3
  ​    	如果想自定义运行级别可使用ntsysv --level方式

###  临时启动

- 基础方式/etc/init.d/$service start
- 快捷方式service $service start         //service就是一脚本sh文件

###  命令总结

chkconfig --list              [service]   #配置状态

chkconfig --add/--del   $service

chkconfig [--level35]    $service on/off

service start/stop/restart/reload/status $service

service --status-all            #运行状态[+] 表示正在运行   [-]停止运行   [?]编写的service脚本不支持status命令

##  systemd

https://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html

systemctl [option][cmd]  cmd
  option
        -t,--type=TYPE：          #可以过滤某个类型的 unit    查看所有类型systemctl -t help
            automount
            freedesktop
            mount
            path
            service
            slice
            socket
            target
            timer
        **-a, --all**    #如果添加--all则未启动的也会列出
    cmd
	\#Unit Commands
             **list-units **#不带参数   默认命令.  列出已启动的unit 如果添加--all则未启动的也会列出 service --status-all
             list-sockets 
             list-timers
             list-dependencies [unit] [--reverse]  #--reverse 会反向追踪是谁在使用这个unit
             **start/stop/reload/restart/kill/status/is-active/is-failed/show  $unit** #service start/stop/status
   \#Unit File Commands
        	**list-unit-files**              #根据/lib/systemd/system/目录内的文件列出所有的unit  chkconfig --list
        	**enable/disable/is-enabled/mask/unmask  $unit**                                              #chkconfig --add/--del
        	get-default #系统的默认运行级别在/etc/systemd/system/default.target文件中指定
        	set-default TARGET.target
         \#Machine Commands
         \#Job Commands
         \#Snapshot Commands

### unit-file

systemctl list-unit-files 返回4中状态

​		enabled  已建立链接

​		disabled  没有建立链接

​		static       该服务的配置文件没有install部分,无法执行,只能作为其他配置文件的依赖

​         masked  该服务的配置文件禁止建立链接

systemctl is-enabled \$service  #查看服务是否开机启动
                                                     \#若返回static, 则表示不可以自己启动,只能被其他enable的unit唤醒
systemctl enable       \$service  #建立链接
systemctl disable      \$service   #
systemctl mask	     \$service   #注销
systemctl unmask     \$service   #取消注销

systemctl cat nginx.service  #快速查看unit的配置文件  man systemctl 最后 systemd.unit(5)  

​                                                  \# 查看unit配置文件格式  man 5 systemd.unit

###  unit

systemctl list-units [-t service]   \[-a\]        #-,--type 

systemctl start/stop/restart/kill \$service
systemctl reload       \$service
systemctl status        \$service  #active inactive 
                                                     \#active(exited)只执行一次就退出 
                                                     \#active(waiting)等待比如打印    
systemctl is-active  \$service

systemctl is-failed  \$service

systemctl show       \$service  #列出配置     systemctl -p MainPID show ssh.service

```
查看运行级别 who -r 或 runlevel
切换运行级别 init N   //init 0关机   init 6重启

SysVInit
运行级别0 - /etc/rc.d/rc0.d/
运行级别1 - /etc/rc.d/rc1.d/
运行级别2 - /etc/rc.d/rc2.d/
运行级别3 - /etc/rc.d/rc3.d/
运行级别4 - /etc/rc.d/rc4.d/
运行级别5 - /etc/rc.d/rc5.d/
运行级别6 - /etc/rc.d/rc6.d/
系统的默认运行级别在CentOS的/etc/inittab文件中指定。


开机自动执行/etc/rc.local
用户登录自动执行/etc/profile,然后在/etc/profile中遍历顺序执行/etc/profile.d中的文件

systemd系统
0：shutdown.target  		               系统停机状态，系统默认运行级别不能设为0，否则不能正常启动
1：/etc/systemd/system/rescue.target    单用户工作状态，root权限，用于系统维护，禁止远程登陆
2：/etc/systemd/system/multi-user.target.wants   多用户状态(没有联网NFS)
3：full multi-user.targe                 完全的多用户状态(有联网NFS)，登陆后进入控制台命令行模式
4：multi-user.target		                系统未使用，保留
5：/etc/systemd/system/graphical.target.wants  X11控制台，登陆后进入图形GUI模式
6：reboot.target    		系统正常关闭并重启，默认运行级别不能设为6，否则不能正常启动
systemctl get-default  #系统的默认运行级别在/etc/systemd/system/default.target文件中指定
systemctl set-default TARGET.target
```

##  journalctl

```
默认日志都在内存中
```

#  包管理

##  源码包安装 

​	一般为tar包,安装后都在/usr/local目录中

​	./configure --prefix=/usr/local            /usr/local/bin /usr/local/lib /usr/local/etc /usr/local/man

​	./configure --prefix=/usr/local/xxx      所有的都在/usr/local/xxx下

​	修改man的路径   man.conf manpath.conf 添加一行 MANPATH	/usr/local/xxx/man

##  二进制包安装

| distribution发行版       |      |      |
| ------------------------ | ---- | ---- |
| redhat/Fedora/CenOS/SuSE | rpm  | yum  |
| debian/ubuntu            | dpkg | apt  |

由于rpm和dpkg不自动提供依赖包,所以一般只用于安装后的查询;安装前的查找包/更新/卸载由yum和apt负责

###  rpm

- 软件包名格式:   

  ​	软件名称-版本号-发布次数.适合linux系统.硬件平台.rpm  #ftp-0.17-74.fc27.i686.rpm 

- 安装位置

  ​	/etc

  ​	/usr/bin

  ​	/usr/lib

  ​	/usr/share/doc     #一些基本的软件使用手册与说明文件 

  ​	/usr/share/man   #man手册

- 安装后的信息都保存在/var/lib/rpm目录中

  

- -ivh    *.rpm            //install  v:verbose h:进度条

- -e       $pkgName    //erase

- -Uvh   *.rpm           //update  更新

  

  rpm {-q|--query}  [select-options][query-options] [query-options]  通过查询数据库file /var/lib/rpm/packages

- -q    $pkgName #查询是否安装了该软件

- -qpl  *.rpm         #package Query an (uninstalled) package 列出有哪些文件类似于rpm -ql

- -qp *.rpm   --requires #查看包的依赖

- **-qa**                     #all    Query all installed packages

  ​                           \#yum list                  

- -qi   $pkgName #Display ***installed*** package information, including name, Install Date, and description. 

  ​                             \# yum ***info*** openssh-server

- **-ql**   $pkgName  #list 列出该软件所有的文件与目录所在完整文件名 

  ​			     \# yum install yum-utils && repoquery -ql dhcp

- -qc   $pkgName  #configures list only configuration files (找出在/etc/下面的文件名而已) 

- -qd   $pkgName  #document 列出该软件所有的帮助文档（List only documentation files） 

- **-qf**    $full-path-filename   #file 根据文件名查询属于哪个已安装的包 List file in package

  ​				\# yum whatprovidesd \`which sshd`

  ​			        \# yum provides \`which sshd`

- -qR   $pkgName #required List capabilities on which this depends. 

  ​                             \# yum deplist openssh-server

###  yum

Server将pkg根据类别存放到不同Repo中,包的依赖的关系存放在xml中

Client根据本地的配置文件/etc/yum.repo.d/*.repo中指定的server端下载依赖文件xml于本地/var/cache/yum中

- yum repolist [all|enabled|disabled]              #查询有哪些库Repo可以install

  yum repoinfo  [all|enabled|disabled]

- yum search [all]  $pkgName          #Name and summary matches only, use "search all" for everything

  ​                                                             \#decription and url

- 

  yum check-update                 #列出所有可更新的软件

  yum update  [$pkgName]     #更新所有已安装的软件
  
- list

  yum list                  #列出所有可安装的软件及安装过的

  yum list available 

  yum list installed 

  yum list updates  #可供升级

  yum list ssh*        #installed Packages已安装和可升级/安装Available Packages

- group
  yum group list
  yum group install      \$groupName
  yum group remove   ​\$groupName
  yum group info          $groupName                    #yum group info "Development Tools"
  
- yum install -y  \$pkgName
  yum remove   ​\$pkgName
  yum update   $pkgName
  
- history
  
  yum history list               #安装历史记录
  
  yum history info  $ID     #某一次安装历史记录
  
  yum history stats            #统计
  
- clean

  yum clean packages

  yum clean headers

  yum clean oldheaders

  yum clean 

  yum clean all == yum clean packages &&  yum clean oldheaders

只下载不安装 存放于/var/cache/yum/x86_64/7/updates/packages 7发行版本号CentOS7 updates仓库名

 yum install --downloadonly --downloaddir=.   dhcp
 rpm -qlp <下载后包的完整路径> 可以查看rpm包中的文件



流程

​	rmp -q          $pkgName   #查询是否安装了包 rpm -qa | grep ​\$pkgName

​	yum **search**  $pkgName #只匹配名字和summary, use "search all" match everything

​	yum **info**       $pkgName

​	yum install    $pkgName

###  dpkg

格式 Package_Version-Build_Architecture.deb  #nano_1.3.10-2_i386.deb 

主要用于对已下载到本地和已安装的软件包进行管理 

/etc/dpkg/dpkg.cfg              dpkg包管理软件的配置文件[Configuration file with default options]

/var/log/dpkg.log                dpkg包管理软件的日志文件[Default log file (see /etc/dpkg/dpkg.cfg(5)]

/var/lib/dpkg/available       存放系统所有安装过的软件包信息[List of available packages.]

/var/lib/dpkg/status            存放系统现在所有安装软件的状态信息和控制信息

/var/lib/dpkg/info                备份安装软件包控制目录的控制信息文件

/var/lib/dpkg/info/.list        记录安装文件的清单

/var/lib/dpkg/info /.mdasums  保存文件的md5编码

- dpkg **-l** [pkgName-pat]     #List packages matching given pattern

  ​                    \#dpkg-query: no packages found matching logwatch

  ​                    \#第一列期望Desired请求  iInstall安装 rRemove下载 pPurge清除 hHol锁定软件版本

  ​                    \#第二列请求结果Status状态 nNot未安装 iInst已安装 cConf-files以前安装过并卸载剩下配置文件

  ​                    \#                       uUnpacked被解包但未配置 fHalf-conf试图配置但失败 hHalf-inst试图安装但失败

  ​	           \#                        wTrig-await触发器等待 tTrig-pend触发器未决        

- dpkg **-s**  package-name...                     Report status 查看描述 依赖dep 大小size

  ​                                 \#dpkg-query: package 'logwatch' is not installed and no information is availabl

- dpkg -p package-name                         --print-avail 显示包的具体信息

- dpkg **-L** package-name...                      正查  List files 列举安装了哪些文件到文件系统

  ​                                                                  \#dpkg-query: package 'logwatch' is not installed

- dpkg **-S**  filename-search-pattern...    反查  Search 查询某一文件来源于哪一安装包

  ​                                                       			\# dpkg -S  \`which ag`
  ​																	\# silversearcher-ag: /usr/bin/ag

查看没有安装的deb包命令

dpkg -I *.deb                                                 Show information about a package.

dpkg --unpack *.deb                                     解开

dpkg --configure *.deb                                配置

dpkg -c *deb                                                  List contents of a deb package rpm -qlp 

安装卸载deb

dpkg -i *.deb                                                 文件的安装
dpkg -r  pkgName                                         下载remove,但保留配置文件
dpkg -P pkgName                                         彻底卸载Purge 包括软件的配置文件等等

###  apt

官方包源网址       http://packages.ubuntu.com/ 

镜像站点               /etc/apt/sources.list

镜像文件索引位置 /var/lib/apt/lists

下载保存位置       /var/cache/apt/archives 

更新源

```
ubuntu默认使用国外源,下载速度比较慢,不像centos yum会依赖fastestmirror插件自动选择站点, 所以需要更换源
mv /etc/apt/sources.list /etc/apt/sourses.list.backup

deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse

apt update
```



```
apt-get update     #更新源   可以频繁操作,类似于保存文件Ctl-s的频率
                   #依据/etc/apt/sources.list从镜像站点更新本地文件索引/var/lib/apt/lists

apt-get upgrade                       更新所有已安装的包
apt-get dist-upgrade                  根据source.list升级系统到相应的发行版
apt-get dselect-upgrade               使用 dselect 升级             

apt-cache search   package   搜索包
apt-cache show     package   获取包的相关信息，如说明、大小、版本等
apt-cache showpkg  package   获取包的大致信息
apt-cache depends  package   正向了解这个包使用了哪些依赖
apt-cache rdepends package   反向了解哪个包使用了这个包

apt-get 
	-u                          #显示软件更新列表
	-y                          #对所有的询问选择是

apt-get -d                   package   仅下载不安装  --download-only

apt-get install              package=version  安装包
apt-get install -f           package  强制安装
apt-get install --reinstall  package  重新安装包

apt-get remove         package        删除包
apt-get purge          package        删除包，包括删除配置文件等

apt-get autoclean                 清理那些已经被removed/purged软件的安装包*.deb,以释放磁盘空间
apt-get clean                     清理那些已经被安装了但还有安装包的*.deb,以释放磁盘空间

apt-get build-dep package             安装相关的编译环境
apt-get source package                下载该包的源代码
apt-get check                         检查是否有损坏的依赖

流程
    apt update
    apt list     $pkgName  #dpkg -l $pkgName
    apt search   $pkgName
    apt show     $pkgName  #apt showsrc $pkgName
    apt install  $pkgName
```

###  小结

|          | rpm/yum                     | dpkg/apt              |
| -------- | --------------------------- | --------------------- |
| 更新索引 | yum makecache | apt update           |
| 已安装   | rpm -qa                     | dpkg -l        [$pkgName] |
| 可安装 | yum list                    | apt list        [$pkgName] |
| 是否安装 | rpm -q           [$pkgName] | dpkg -s   $pkgName |
| 查询     | yum  search [all] $pkgName  | apt search   $pkgName |
| pkg信息  | yum **info**       $pkgName | apt **show**     $pkgName |
| 下载源码  |yumdownload **--source** $pkgName | apt **source** $pkgName |
| 安装历史 | yum history list | cat/var/log/[apt/history.logdpkg.log |
| 安装时间 | rpm -qi $pkgName  "Install Date"字段 |  |
| 正查pkg包含文件 | rpm -ql          $pkgName | dpkg -L        $pkgName |
| 反查文件属于哪个包pkg | rpm -qf         $full_path_fileName | dpkg -S        $full_path_fileName |
| 正查pkg的依赖 | rpm -qp *.rpm   -requires |  |
|  | rpm  -qR   $pkgName |  |
|  | yum deplist openssh-server | apt depends openssh-server |
| 反查pkg的依赖 | yum provides rssh | apt rdepends rssh |
|查询change log|rpm -q $pkgName --history|apt changelog openssh-server|

#  Tool

## ldd

##  nm -CA 

##  tcpdump

```
tcpdump [-i eth0] port 1234 -w a.cap &   #默认捕获eth0
kill -15 $!

tcpdump -l -i eth0 -w - src or dst port 3306 | strings #以行为单位显示可打印字符
                                                       #这样可以查看协议是否加密
	-l     linebuffered
	-w -   输出到stdout
	

wireshark
	以第二行为例
        第一个按钮 start
        第二个按钮 stop
        第三个按钮 restart
        第四个按钮 捕获选项  选择捕捉的网卡eth0
    以第三行为例
    	点击最左边的那个标签的按钮,会弹出一些提示 选择tcp or udp port is 80然后就自动填充了
charles
```

##  tee

```
tcpdump -l | tee dat
tcpdump -l > data & tail -f dat
```

##  pstree -c -p -al

```
-c      #disable compat 展开不压缩
-p      #processID  显示进程ID
-a -l   #arguments long当参数宽度超过环境变量COLUMNS(132)默认会截断,long就不会了
```

##  pstack

##  strace/ltrace

##  arp

​	address resolution protocol 将IP->MAC物理地址的转化

```
arp -n | sort -t. -n -k1,1 -k2,2 -k3,3 -k4,4  #linux命令查询局域网内所有主机并按ip排序
```

##hostname

```
主机名
	配置文件
		cat /etc/sysconfig/network
		NETWORKING=yes      #网络是否可用。
	　　 HOSTNAME=xxxx       #xxxx为新设置的主机名。

	命令
		查看
			hostname
		修改 
			hostname yy
```



```
IP
	本机
		配置文件
		cat /etc/sysconfig/network-scripts/ifcfg-eth0
            NAME=eth0                  ##指定网络链接的名字为eth0，个人习惯，开心就好
            DEVICE=eth0                ##指定文件管理的网卡名称
            ONBOOT=yes                 ##是否开机启动

            ####DHCP网络配置####
            BOOTPROTO=dhcp             ##dhcp动态获取，none和static都表示静态网络

            ####静态网络地址配置####
            BOOTPROTO=static            ##dhcp动态获取，none和static都表示静态网络
            IPADDR=10.0.0.10            ##设定ip为10.0.0.10
            NETMASK=255.0.0.0|PREFIX=8  ##子网掩码为255.0.0.0

            GATEWAY=10.0.0.1             ##网关地址,如果需要访问外网需要设置
            DNS=***.***.***.***          ##DNS地址，如需域名解析需要设置
            PEERDNS=yes|no               ##是否修改/etc/resolv.conf,no表示不修改
            ####IPADDR、NETMASK、PREFIX、GATEWAY、DNS后面加数字,可以同时设置多组IP地址
            ####更多的参数可以查看帮助文档/usr/share/doc/initscripts-*/sysconfig.txt

            命令
                ifconfig 
                    查看
                        查看active 和 loop
                        -a      所有接口,包括非活动的
                        eth0    特定接口

                    动态获取IP
                        ifconfig eth0 --dynamic    

                    临时修改,重启机器重新读取配置文件
                        ifconfig eth0 192.168.1.222   netmask 255.255.255.0
                        ifconfig eth0:1 192.168.1.222 netmask 255.0.0.0
                        ifconfig eth0 hw ether MAC地址 #修改mac地址ifdown eth0&&修改&&ifup eth0;

                    启动/停止
                        ifconfig eth0 up
                        ifconfig eth0 down
                        ifdown   eth0;
                        ifup     eth0;

                dhclient 可以从dhcp服务器申请新的网络配置(ip-gateway-dns)到当前主机

                nmcli device show eth0
                nmcli device status eth0
	网络


查看dns
	配置文件
		cat /etc/hosts       #类似于windows的host文件
		cat /etc/resolv.conf #格式 ServerName	IP  最多前面的3行生效 万能DNS 114.114.114.114
             # Generated by NetworkManager
             nameserver 202.96.128.86
             nameserver 202.96.134.33
             
    优先级
		先查询本地host 本地dns 根域dns服务器 .com服务器 baidu.com服务器
		
	命令 bind-utils
		dig  domain information groper
		host  www.google.com
		nslookup    直接模式一般用于查询域名对应的IP   交互模式用于对DNS服务器进行测试
			nslookup www.sohu.com.cn
				Server:		202.96.128.86                          #本地配置的dns的IP地址
				Address:	202.96.128.86#53

				Non-authoritative answer:
				www.sohu.com.cn	canonical name = gd.a.sohu.com.
				gd.a.sohu.com	canonical name = f7gz.a.sohu.com.
				Name:	f7gz.a.sohu.com
				Address: 14.18.240.77
gateway
	配置文件
		cat /etc/network/interfaces                    #Ubuntu
		cat /etc/sysconfig/network-scripts/ifcfg-eth0  #CentOS Linux
	
	命令
		route -n                 #第一行就是
		traceroute www.baidu.com #第一行就是  window是tracert
		
		netstat -rn
		ip route show
		
路由
	route
		启动 echo 1 > /proc/sys/netipv4/ip_forward  #1打开路由功能 0为关闭路由功能
		
    	查看主机路由信息
    	route -n #类似于netstat -tlpn中的n将主机名转化为IP default转化为0.0.0.0
            Kernel IP routing table
            Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
            default         gateway         0.0.0.0         UG    100    0        0 eth0
            192.168.1.0     0.0.0.0         255.255.255.0   U     100    0        0 eth0
            
        修改
            route del default gw   #route del –net 0.0.0.0 netmask 0.0.0.0 gw 192.168.0.1
            route add default gw   #route add –net 0.0.0.0 netmask 0.0.0.0 gw 192.168.0.1
        
    traceroute 一般用于查看到目录所经过的路径
    	traceroute www.baidu.com
```

##  ip

```
ip -f inet address show  | grep -A 1 -E "[[:digit:]]+\: eth0:" | tail -1 | awk -F"[ //]+" '{print $3}'
```

##  wget/curl

```
curl -o curl.output -v http://xx.html
	-POST
	
curl -fsSL http://www.baidu.com
wget -c -q -O - http://www.baidu.com
	-b 下载大文件时后台下载 输出信息会保存到同目录的wget-log文件中,可以使用tail -f wget-log查看
	-c continue 表示继续下载以前退出的 否则文件名在原来的文件名上再加1
	-q 不打印header
	-O 指定输出目的地 - 表示stdout  大写的O
```

##  scp/rsync

```
scp -P $dstHostPort $localfile $user@$host:/file
rsync -avzh   --verbose  -h进度条
```

#  文件系统

##  分区及加载

```
/dev         这个是真正的外部数据，系统会自动将cdrom安装到/dev
/mnt         用户手动或系统自动挂载/dev到/mnt目录    固定存储        以前
/media/cdrom 用户手动或系统自动挂载/dev到/media目录  移动存储 如USB  后来   有桌面图标

磁盘  磁盘名是hda中的最后一个a
				       某根IDE数据线第一块Master  某根IDE数据线第二块Slave
	主板插槽1primary	/dev/hda    			 /dev/hdb
	主板插槽2second     /dev/hdc    			 /dev/dhc
	
	磁盘名
		IDE实体硬盘 /dev/hd[a-p] 
        SCSI/SATA/USB实体磁盘 /dev/sd[a-p]
        虚拟磁盘 /dev/vd[a-p]
        RAID   /dev/md[0-128]
        LVM    /dev/$vgname/$lvname

分区partition	一块磁盘可以分区 分区名是hda1中的最后一个1
	分区类型
		Primary Partition 主分区
		Extend  Partition 扩展分区
		logic   Partition 逻辑分区
	分区表格式
		MBR(Master Boot Record 主要开机记录区) 为兼容Windows的MSDOS
		GPT(GUID partition table)
		
	由于硬盘的限制,主分区primary和扩展分区最多只能有4个
	由操作系统的限制, 一块磁盘最多可以有一个扩展Extend分区 
	逻辑分区只能由扩展分区而来,扩展分区名从数字5开始,最大根据操作系统不同而不同,一般是16或64两种情况
	只能格式化主分区和扩展分区,不能格式化扩展分区
	
	经典方案 P+P+P+E (3P+E)   P+E
	
文件系统类型
    ext2/3/4 由于ext3 ext4多了日志的记录,所以系统复原会比较快  已过时
    swap     并不会使用到目录树的挂载, 所以并不需要指定挂载点
    xfs      centos7预设的, 格式化好几T的空间速度快
    vfat     linux/windows都支持  如果windows和linux在硬盘中共存,为了数据交换,可以设置为这个
    
    linux通过操作linux VFS(virtual filesystem switch)抽象层来操作不同的实际的文件系统

	查看文件系统类型
    cat /proc/filessystem                     内存已加载的文件系统
    ls -l /lib/modules/$(uname -r)/kernel/fs  这个版本系统可支持的
    
    传统一个分区只能格式化为一种文件系统.但由于LVM/RAID,
    一个分区通过LVM可以格式化为多个文件系统;
    多个分区通过LVM/RAID可以合成一个文件系统. 
    所以现在说一个挂载点的文件系统类型
    
ex2/3/4 静态分配
    block 1K 2K 4K
	blockgroup1
        superblock  记录文件系统的整体信息 包括inode/data的总量使用量剩余量 文件系统的格式
                    挂载时间 最后一次写入数据时间 一个fsck时间 是否挂载
        filesystemdescription
        		每个blockgroup的起止的block号 每个区段(super/inodebitmap/databitmap)的起止号
        inodeblockbitmap
        datablockbitmap
        inodeblock
        	ls -l (文件的模式 owner/group size ctime/atime/mtime setUID 文件内容的指向)
        	每个inode大小固定128B/256B
        	每个文件仅占用一个inode节点
        	12个直接指向 1间接 1双间接 1三间接
xfs 动态分配
	data section (类似于meta ext4的blockgroup)
	log section (类似于ext的 log )
	realtime section
```

### 分区fdisk/gdisk/parted

```
先通过lsblk/blkid找到磁盘,再用parted /dev/x print找到分区表PartitionTable的类型为MBR还是GPT

fdisk  适用于分区表类型MBR
gdisk  适用于分区表类型GPT
parted 通用

fdisk -l /dev/vda       只能列出硬盘的分区表、容量大小以及分区类型，但看不到文件系统类型
gdisk -l /dev/vda       查看分区大小
parted   /dev/vda print

1 使用df查看磁盘名 如 /dev/hda
2 使用命令
  fdisk $disk_name  #如/dev/hda 千万不能跟数字, 数字就是分区了
  Command (m for help): m  #打印帮助
  
  Command (m for help): q  #quit
  Command (m for help): w  #write
  
  Command (m for help): F  #list free unpartitioned space
  Command (m for help): l  #list known partion space
  Command (m for help): n  #增加一个分区
  Command (m for help): d  #删除一个分区
3 partprob -s  #分区生效 让系统cat /proc/partitions识别(probe)到分区(partition)  否则只能重启生效
```

###  格式化mkfs

```
mkfs [opt]  $partitionName  #格式化分区并设定分区的文件系统类型 /dev/hda4
	-t	[ext2 ext2 xfs ]    #type 设定文件系统类型
	
blkid    查看分区的id和类型
lsblk    查看分区大小
	RM 可否移除   SIZE容量   RO 是否Readonly TYPE disk磁盘part分区只读rom
lsblk -f 查看分区类型

当为ext2/3/4
        superblock和filesystemdescription都可以通过命令dumpe2fs查看ext类型的,xfs的不可以
        dumpe2fs /dev/hda1   #dump ext2/3/4 filesystem
	    	-h  #只查看header部分,即superblock信息
当为xfs 查看superblock等meta信息
	xfs_info /dev/vda2
```

###  检查e2fsck/xfs_repair

```
e2fsck  /dev/hda4	确定inode/superBlock等meta 与 datablock的一致性
                  	ext3/4的日志式journaling文件系统保证meta与数据的一致性
xfs_repair /dev/hda4
```

### 挂载mount

```
mount     #查询系统中已挂载的设备
mount -a  #依据配置文件/etc/fstab的内容，自动挂载 
          #光盘/U盘不建议写入自动挂载中,否则开机时没有光盘/U盘的话, 系统会崩溃

mount [-t 文件系统] [-o 特殊选项] [设备文件名] [挂载点]
    -t 文件系统：加入文件系统类型来指定挂载的类型，ext3,ext4,光盘：iso9660等文件系统
    -o 特殊选项：可以指定挂载的额外选项

#挂载光盘
mount -t iso9660 /dev/sr0 /mnt/cdrom/
ll /mnt/cdrom/
umount /mnt/cdrom/ 或umount /dev/sr0

#挂载U盘
fdisk -l //查看系统中已经识别的硬盘  U盘一般为sdb1
mount -t vfat /dev/sdb1 /mnt/usb/ #vfat指的是fat32文件系统，单个文件不超过4GB
                            #Linux默认不支持NTFS文件系统的 可以下载ntfs-3g软件安装，
                            #但是ntfs格式只能是只读的 //一般为移动硬盘
 
开机挂载
/etc/fstab  #fs  table
/etc/mtab   #mount table
```
###  查看战果

```
ls -li #第一列为inode号码 若该inode号自身包含文件名 若为目录 则该inode指向的block包含该目录名
ls -sh #第一列为块容量 total为block_count*blockSize

du
	 默认不会列出当前目录下单个文件的大小，尽管最后表示当前目录的.会统计
	 -a 会列出当前目录下单个文件的大小
	 -Sh 不包括子目录的统计， 更准备 因为目录已经统计过一次了
	 -sh 
	
df  /   #重点找到磁盘名而已 例如/dev/hdc2中的磁盘名是/dev/hdc 是不含数字的， 数字是3分区             
	-T  增加文件类型列
	-h   
	-a  列出所有的文件系统  包括特殊的/proc  基本特殊的文件系统都不会占用硬盘空间
	-i  查看inode，默认为data
```

##  swap

分区方式

```
gdisk && partprobe && lsblk && 格式化mkswap /dev/vda6
swapon /dev/vda6  #类似于mount  swapoff /dev/vda6
#查看free 或swapon -s更清晰
echo "/dev/vda6 swap swap defaults 0 0" >> /etc/fstab #设置开机挂载
```

建立文件的方式

```
dd if=/dev/zero of=/tmp/swap bs=1M count=128 && mkswap /tmp/swap
swapon /tmp/swap
echo "/tmp/swap swap swap defaults 0 0" >> /etc/fstab #设置开机挂载
```

##  quota配额

```
限制某目录大小 某用户使用空间大小  某组使用空间大小  
超过waterLowerLevel警告 waterHighLevel禁止写入 在这两者之间有个存活期
xfs_quota
```

##  raid

```
目的
	读写效率  分区写
	安全     镜像
RAID
RAID0	
	2块磁盘  strip模式
	优点:  效率最高
	缺点:  不安全
RAID1 
	2块磁盘  mirror模式
	优点:  安全
	缺点:  效率低 容量以小的为准且容量减半
RAID 1+0 4块磁盘  先RAID1再RAID0
RAID 0+1 4块磁盘  先RAID0在RAID1
RAID5    3块磁盘支持一块磁盘坏  读优写劣 计算同位检验码Parity
RAID6          支持2块磁盘怀
RAID10
硬件	/dev/sd[a-p]
软件  /dev/md[0-]

mdadm --create /dev/md[0-9] --auto=yes --level=[015] --chunk=NK 
	  --raid-devicds=N --spare-devices=N /dev/vda{5,6,7}

查看
mdadm --detail /dev/md[0-9]
cat /proc/mdstat

格式化及挂载 开机挂载
mkfs.xfs -f -d su=256k,sw=3 -r extsize=768k /dev/md0
mkdir /srv/raid && mount /dev/md[0-9] /srv/raid

mdadm --manage /dev/md[0-9] 
	--add    /dev/vda5  #往lvm中添加
	--remove /dev/vda5  #往lvm中减少
	--fail   /dev/vda7  #设定错误有问题,然后remove
	
关闭RAID
```

##  lvm

```
PV阶段physical volume
	pvcreate /dev/vda{5,6,7,8}
	pvscan
	pvdisplay /dev/vda5
VG大磁盘阶段volume group
	vgcreate  $VGName $PVList   #与vgremove相反
	vgscan
	vgdisplay $VGName
	vgextend  $VGName $PV       #与vgreduce相反
LV分区阶段logical
	lvcreate -L 200G -n $lvName $vgName  #与lvremove相反
	lvscan
	lvdisplay $lvName
	lvextend  $lvreduce
	lvresize  -L +500M $lvName
文件系统阶段:格式化挂载
	mkfs.xfs /dev/$lv-fullName && mkdir /srv/lvm && mount
```

#  za

##  man/info

```
man           #针对未使用过的命令或文件格式manual 而$cmd --help针对的是曾经使用过的命令
man man       #从中可以查看各级别含义
    -h  for help
man [opt] $cmd
	-f      #查看命令的所有级别 
	        #######等价于whatis $cmd
	-k      #查看包含关键字key的所有级别
		    ######等价于apropos
	null    #默认查看最低级别  man 5 updatedb.conf  man 5 /etc/updatedb.conf
	$number 
	-a      #查看所有级别 按照cat /etc/man_db.conf其中定义的顺序依次查看


info  文件位于/usr/share/info
    'q' quits
    'H' lists all Info commands
    'mTexinfo RET' visits the Texinfo manual

    定位Coreutils按回车就进入了子页面,可以浏览基本的命令并其概述  
info info #
info $cmd
    ### 上一级
        u     up    进入上一层
    ### 下一级
        Enter 进入子帮助页面(带有*号)
    ### 同级不同页面
        n     next  进入下一个帮助小节
        p     pre   进入上一个帮助小节

    ### 当前页面
    tab   跳转到下一个链接/node节点
    b     begin  第一个节点
	e     end    最后一个节点

    空格  下一页
	PageDown 
	PageUp
	s|/  reg search 按s或/进行正则搜索
    h    help  帮助
    q    quit  退出
	
	__________
	    |_____
		|__u__
		      |_____
		      |__p__
			  |===b/e/===tab===回车
			  |__n__
```

##  查找四天王which find  whereis locate

```
##从环境变量$PATH中完全匹配查找可执行程序的位置 
which [-a] $filename  
                      #-a表示有多处时返回多处，默认只返回最前一次

#效率最低 功能最强
find     #按照ls -l的顺序
	-t TYPE         #一般正规文件(f)、设备文件(b、c)、目录（d）、socket(s)等
	
	-perm mode      #查找文件权限正好是mode的文件
	-perm -mode     #小于mode
	-perm +mode     #大于mode
		
    -user root
	-uid  0
	-group root
	-gid  0
	-nouser:        #寻找文件的所有者不在/etc/passwd的文件
	-nogroup:       #寻找文件的用户组不在/etc/group的文件
	
    -size +20k -a -size -50k  #+表示多于 -表示少于 c:代表byte k:代表1024byte -a表示and -o表示or
    -a #and
    -o #or
	
    -ctime +10      #10天前  file status change 列出n天之前(不包含n本身)被更改过的文件名
    -mtime 0        #今天修改    file data  modify 几天之前的"一天之内"被更改过的文件
    -atime -10      #10天内  列出n天之内(包含n本身)被更改过的文件名
	-newer $file    #比file更新的文件
	
	-name filename  #查找文件名为filename的文件
	
	-depth N        #深度
	-prune
	
	-fellow         #跟踪符号链接所指向的文件
	
	-fstype         #在某一特定的file system文件系统/etc/fstab中查找
	
	-print          #默认动作
	-cpio           #对匹配的文件执行cpio备份到磁带设备中
    -exec/ok $cmd {} \; #自定义动作 对搜索结果进行处理 使用\对;进行转义
	                    #cmd不能用alias只能全称如 ls -l不能 ll
						#有没有C语言的感觉 -exec ls -l {find / -t f} \;
						
	find . ! -name "*.txt" -print
	find . ( -name "*.txt" -o -name "*.pdf" ) -print
	find . -regex  ".*(.txt|.pdf)$"   #iregex 忽略大小写
	
						
	

##数据库一般查询
#whatis $cmd   使用whatis命令必须先sudo makewhatis(老版本)/mandb(新版本)建立数据库
whereis [opt] filename #只能在特定目录下(whereis -l或数据库/var/lib/slocate/slocate.db)中
                       #完全匹配查找可执行文件的位置+源文件、配置文件的位置+帮助文件的位置
					   #当提供的filename包含.后缀时会被截断，只留下.前面的
    -b  #binary 可执行文件
	-s  #source 源文件      eg： whereis stdio  whereis nginx  ##/usr/include/stdio.h
    -m  #manual 帮助文件    eg: ##/usr/share/man/man3/stdio.3.gz                           
	-l  #output effective lookup paths
	
#数据库正则匹配reg查询
locate [opt] $filename #默认一天更新一次数据库/var/lib/mlocate, 
					   #可以通过命令updatedb临时更新 
					   #只能按文件名搜索，而不能更复杂的搜索
                 #部分匹配模糊查找
	-i           #忽略大小写
	-r           #正则表达式支持* ？
	-n           #只返回前面n个
	-q           #安静模式 不会显示任何错误
    cat /etc/updatedb.conf
		PRUNE_BIND_MOUNTS="yes" #开启搜索限制
		PRUNEFS=                #搜索时,不搜索的文件系统
		PRUNENAMES              #搜索时,不搜索的文件类型
		PRUNEPATHS=             #搜索时,不搜索的路径
slocate #security locate locate的升级版
mlcoate #slocate的升级版 与locate公用一个数据库 
        #根据时间戳更新数据库，而不必重新读取一下文件系统 apt show mlocate
```

##  df/du

```
df
	-a  #默认不含特殊内存 swap
	-T  #列出文件分区格式
	-h/-i #以inode个数形式统计, 默认以容量统计 
du
	-a   #默认仅统计文件量,而没有统计到子目录
	-s   #列出总量,而不是分别统计各子目录
	-S   #不统计子目录
```

##  进程

```
pgrep {proName} 
pidof {progname}

pkill {proName}
killall {progname}

ps                        # 查看当前会话进程
ps ax                     # 查看所有进程，类似 ps -e
ps aux                    # 查看所有进程详细信息，类似 ps -ef
ps auxww                  # 查看所有进程，并且显示进程的完整启动命令
ps -u {user}              # 查看某用户进程
ps axjf                   # 列出进程树
ps xjf -u {user}          # 列出某用户的进程树
ps -eo pid,user,command   # 按用户指定的格式查看进程
ps aux | grep httpd       # 查看名为 httpd 的所有进程
ps --ppid {pid}           # 查看父进程为 pid 的所有进程
pstree                    # 树形列出所有进程，pstree 默认一般不带，需安装
pstree {user}             # 进程树列出某用户的进程
pstree -u                 # 树形列出所有进程以及所属用户
pgrep {procname}          # 搜索名字匹配的进程的 pid，比如 pgrep apache2

后台进程 使用&启动的程序  不能接受输入,但可以有输出
CTRL-Z 
jobs              查看后台进程
bg                查看后台进程,并切换过去
fg {n}            将后台进程切换到前台  如在vi某文件时,CTRL-Z,再fg
disown {pid|jid}  将进程从后台任务列表（jobs）移除
wait              等待所有后台进程任务结束
```



##  网络

```
ping -c N {host}
traceroute {host}         # 侦测路由连通情况
mtr {host}                # 高级版本 traceroute
host {domain}             # DNS 查询，{domain} 前面可加 -a 查看详细信息
whois {domain}            # 取得域名 whois 信息
dig {domain}              # 取得域名 dns 信息
route -n                  # 查看路由表

ip a                               # 显示所有网络地址，同 ip address
ip a show eth1                     # 显示网卡 IP 地址
ip a add 172.16.1.23/24 dev eth1   # 添加网卡 IP 地址
ip a del 172.16.1.23/24 dev eth1   # 删除网卡 IP 地址
ip link show dev eth0              # 显示网卡设备属性
ip link set eth1 up                # 激活网卡
ip link set eth1 down              # 关闭网卡
ip link set eth1 address {mac}     # 修改 MAC 地址
ip neighbour                       # 查看 ARP 缓存
ip route                           # 查看路由表
ip route add 10.1.0.0/24 via 10.0.0.253 dev eth0    # 添加静态路由
ip route del 10.1.0.0/24           # 删除静态路由

ifconfig                           # 显示所有网卡和接口信息
ifconfig -a                        # 显示所有网卡（包括开机没启动的）信息
ifconfig eth0                      # 指定设备显示信息
ifconfig eth0 up                   # 激活网卡
ifconfig eth0 down                 # 关闭网卡
ifconfig eth0 192.168.120.56       # 给网卡配置 IP 地址
ifconfig eth0 10.0.0.8 netmask 255.255.255.0 up     # 配置 IP 并启动
ifconfig eth0 hw ether 00:aa:bb:cc:dd:ee            # 修改 MAC 地址

nmap 10.0.0.12                     # 扫描主机 1-1000 端口
nmap -p 1024-65535 10.0.0.12       # 扫描给定端口
nmap 10.0.0.0/24                   # 给定网段扫描局域网内所有主机
nmap -O -sV 10.0.0.12              # 探测主机服务和操作系统版本
```

##   信号

```
man 7 signal

trap cmd sig1 sig2        # 在脚本中设置信号处理命令
trap "" sig1 sig2         # 在脚本中屏蔽某信号
trap - sig1 sig2          # 恢复默认信号处理行为
```

##  开关机

```
启动一开始就进入tty1
终端控制台界面Ctl+Alt+F2-6  tty2-6    #startx不灵啊
XWindow      Ctl+Alt+F1             

注销 exit logout
cal [[[day] month] year]

sync
shutdown 
	-k "msg"
	-h  now       #==0 默认是1 1分钟后关机
	-h  +10       #10分钟后关机
	-h  20:35     #24小时制20:35关机
	-r  now       #==0 立即
	-r  +30 "msg" 
    -c            #可用这条目录取消前一个shutdown命令 
	
halt       #屏幕可能会保留系统已停止的信息
poweroff   #没电了 屏幕空白
reboot

init 0     #关机
init 6     #重启

systemctl halt
systemctl poweroff
systemctl reboot
systemctl suspend     #休眠模式
```

##  系统版本

```
uname -a
    查看内核版本
lsb_release -a     #yum search lsb而不是yum search lsb_release
    查看版本CentOS Redhat Ubuntu
hostname
hostnamectl
```

##  系统启动

##  fdisk-mount-dd-unmount

```
#disk dump(destory)
dd if=/path/to/image of=/dev/sdx bs=4M count=1  
	#if inputfile默认为stdin
    #	skip=nBlocks  输入跳过几个block
	#of outputfile默认为stdout
    #	seek=nBlocks  输出跳过几个block
	#bs blockSize 一次同时指定读取输出多大的size
	#	ibs
	#	obs
	#count=nBlock 读取多少block
	#cbs=nByets   转换区的大小
	#conv=
	#	lcase     转换为小写
	#   ucase     转化为大小
	#	noerror   出现错误不停止
pkill –USR1 –n –x dd  #查看dd进度 或 ubuntu的pv命令
                      #主要是dd接受信号SIGUSR1并进行处理了

dd if=/dev/zero bs=1024 count=1000000 of=/root/1Gb.file #通过命令的执行时间可以计算出硬盘的读写速度
dd if=/root/1Gb.file bs=64k | dd of=/dev/null

dd if=/dev/zero bs=1024 count=1000000 of=/root/1Gb.file #通过调整blocksize可以确定硬盘的最佳块大小
dd if=/dev/zero bs=2048 count=500000 of=/root/1Gb.file
dd if=/dev/zero bs=4096 count=250000 of=/root/1Gb.file

#远程备份
##源主机
dd if=/dev/hda bs=1024 | netcat $remote_dst_ip 1234
##目的主机
netcat -l -p 1234 | dd of/dev/hdc bs=1024
netcat -l -p 1234 | bzip2 > partition.img

/dev/null  可以吸收无穷尽的值
/dev/zero  可以读出无穷尽的0x0值,一般用于填充文件
/dev/urandom 可以读出无穷尽的随机值,一般用户毁坏文件,rm还是可以恢复的  
#dd if=/dev/urandom of=/dev/hda1
```

##  ascii

```
showkey -a                # 查看终端发送的按键编码
man ascii                          # 显示 ascii 表
```

##  登录用户

```
显示以往用户登录情况
    last    [user]   #读取文件/var/log/wtmp,显示用户每次登录
    lastb            #读取文件/var/log/btmp, 显示用户登录失败bad
    lastlog [user]   #读取文件/var/log/lastlog,显示所有用户最后一次登录
        -u  $user
        -b  $n       #指定天数前
        -t  $n       #指定天数以来
显示当前在线用户登录情况
    w/who/users      
    users
    root
    
    who
    root     pts/0        2019-12-28 10:31 (61.140.46.101)
    
    w
    18:14:22 up 74 days,  2:54,  1 user,  load average: 2.11, 2.05, 2.01
    USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
    root     pts/0    61.140.46.101    10:31    0.00s  0.08s  0.00s w

write {user}    #向某人发送一段话

whoami
finger {user}   # 显示某用户信息，包括 id, 名字, 登陆状态等
id {user}       # 查看用户的 uid，gid 以及所属其他用户组
```

##  at/crontab/anacron

##  syslog

```
服务端
	进程       syslogd
	配置文件   /etc/syslog.conf
	日志文件   /var/log/message
	协议       UDP
客户端命令
	logger    #eg. logger [-t $TAG]  this is a msg send to log
	
*.info;mail.none;authpriv.none;cron.none                /var/log/messages
authpriv.*                                              /var/log/secure
mail.*                                                  -/var/log/maillog
cron.*                                                  /var/log/cron
uucp,news.crit                                          /var/log/spooler
```

##  logrotate

```
配置文件 /etc/logrotate.conf
```

##  logwatch

## SELinux

```
Policy: 政策 下面包含很多具体的规则rule
	targeted  针对网络服务限制多 针对本机限制少 是默认的政策
	minimum   针对选择的进程来保护 由target修改而来
	mls       完整的限制
安全性文本security context
	身份标识Identity
		unconfined_u
		system_u
	角色Role
		object_r
		system_r
	类型Type	
		type
		domain

模式Mode  在(enforcing|permissive)与(disable)切换之间,必须重启电脑
	enforcing
	permissive 宽容的 仅显示警告信息
	disable
查看模式 getenforce   #cat /etc/selinux/config
设置模式 setenforce  0Permissive模式  1Enforceing模式  #不能通过命令设置disable模式

查看状态 sestatus     #cat /etc/selinux/config
	#SELinux status:enabled        是否启用
	#Current mode: enforing        启用的模式
	#Loaded policy name: targeted  启用的政策
	
查看某个政策里哪些规则 getsebool -a $policyName
查看规则限制什么      yum install setools-console
                   seinfo  #统计状态
                   sesearch [-A] [-s $subject] [-t object]
```

## readline

```
readline 
	查看绑定 bind -p
	配置文件 /etc/inputrc ~/.inputrc格式 
		keyname: $function-name   #keyname为Control- RUBOUT- (就是delete) ESC  RET|RETURN SPA|SPACE TAB
		keyname: "$macro"         #macro 就是字符串
		"keyseq": $function-name  #keyseq为 \C-(control) \M-(esc) \e(alt) \\ \" \'
		"keyseq": "$macro"
	增量搜索 
		开始反向增量搜索 ctrl-r  #reverse 结合fzf屌爆了
		开始正向增量搜索 ctrl-s  #search
		取消增量搜索 ctrl-g
		确定增量搜索 esc ctrl-j 更喜欢esc \n
	非增量搜索
		反向非增量搜索 M-p
		正向非增量搜索 M-n
	Moving 在一行中移动
		c-a 行首
		c-e 行尾
		c-f forward-char
		c-b backward-char
		M-f forward-word 
		M-b backward-word
		c-l clear screen
	Change
		ctrl-d 删除一个字符
		backspace 删除前一个字符
		M-u   wordUppercase
		M-l   wordLowercase
		M-c   wordCapatical
		
	history 在历史所有命令中
		M-< 历史的第一行
		ctrl-p prep 可重复按
		ctrl-n next 可重复按(适用于先重复按ctrl-p多次，然后再回过来)
		M-> 历史的最后一行
```

##  glob

```
man 7 glob 
globbing  wildcard pattern 通配符表达式, 一般只能匹配filenames
    ?        any signal character 
    *        any length string, including empty              
             diff from reg which zero or more copies of preceding things 
    [aeiou]  离散的
    [a-z]    连续的范围 
    [!]      negation 对应正则中的^  diff from reg which is ^
    "[[?*\]" 双引号"[]"中的失去特殊含义,代表[ ? * \四个字符

    特殊情况pathnames
    /        pathname中不能由?和*代替, 也不能由[.-o]范围表示
    .        以.为首的文件名不能由?和*代替, 所以rm -rf *并不能删除隐藏文件

reg expression 正则表达式 posix表达方式
    [:alnum:]  [:alpha:]  [:blank:]  [:cntrl:]
    [:digit:]  [:graph:]  [:lower:]  [:print:]
    [:punct:]  [:space:]  [:upper:]  [:xdigit:]
```



#  docker

```
安装
	阿里云加速
启动docker服务
	systemctl start docker
repo
image
	制作dockfile 都是相对contain来说
	    # Use an official Python runtime as a parent image
	    # FROM一定是dockfile的第一条指令, 后面是一父类image 祖先是CentOS,类似于java的Object类
        FROM python:2.7-slim
        
        # Define environment variable
        # 设置环境变量
        ENV NAME World
        
        # Set the working directory to /app
        # 设置当前工作目录
        WORKDIR /app

        # Copy the current directory contents into the container at /app
        # 拷贝宿主的当前目录到image的/app目录
        ADD  .          /app
        # 拷贝宿主机根目录到image的/app目录并解压
        COPY /a.tar.gz  /app

        # Install any needed packages specified in requirements.txt
        RUN pip install --trusted-host pypi.python.org -r requirements.txt
        ##cat requirements.txt
        ##Flask
        ##Redis
        #第二个RUN
        # RUN yum install y vim net-tools

        # Make port 80 available to the world outside this container
        EXPOSE 80
        # 第二个EXPOSE
        # EXPOSE 22
        
        #文件映射       

        # Run app.py when the container launches
        # 只有最后一条有效 被命令行参数覆盖
        CMD ["python", "app.py"]    
        # 被命令行参数追加

        
        #cat app.py
        from flask import Flask
        from redis import Redis, RedisError
        import os
        import socket

        # Connect to Redis
        redis = Redis(host="redis", db=0, socket_connect_timeout=2, socket_timeout=2)

    	app = Flask(__name__)

        @app.route("/")
        def hello():
            try:
            	visits = redis.incr("counter")
            except RedisError:
            	visits = "<i>cannot connect to Redis, counter disabled</i>"

            html = "<h3>Hello {name}!</h3>" \
            	"<b>Hostname:</b> {hostname}<br/>" \
            	"<b>Visits:</b> {visits}"
            	return html.format(name=os.getenv("NAME", "world"), 
                	hostname=socket.gethostname(), visits=visits)

        if __name__ == "__main__":
        	app.run(host='0.0.0.0', port=80)
		
	编译dockfile
		docker build -f dockfile -t $image:tag .
		
		docker commit options $container-id $image-tag
			-m "commit msg"
			-a "author"
		docer login
		docker tag iamge username/reposity:image:tag
		docker push username/reposity:image-tag
	
	搜索	
		docker search -s 30 nginx
		
	拉取
		docker pull nginx          #默认从docker hub拉取
	删除	
		docker rm
    查看
        docker images
    运行
        
    拉取并运行
        docker run options username/repo:image:tag  $app $app-args /bin/bash
            -p 3306:3306    #端口固定映射 主机host端口:containerPort
            -P              #端口随机映射 默认127.0.0.1:5000:5000/udp

            -it             #interactive 交互方式
            -d              #daemon

            -name $myname   #指定container名字,否则又docker随意指定
            -v $hostDirectory:$contianerDirectory   #文件映射 主机目录:contain目录 可以多个
            -v $hostDirectory:$contianerDirectory
	
	
container
	查看
		docker container ls
		docker ps
		docker top     $container-id   
		docker port    $container-id   #查看端口映射
        
         docker log     $container-id	#查看日志
		docker inspect $container-id    
	删除
		docker rm $container-id
	停止
		docker restart      $container-id
		docker stop         $container-id
		docker kill -s -HUP $container-id

#当container启动以后,在宿主机上docker attch上去,类似于gdb attach,之后就可以操作container了
docker attach

exit			#退出登陆container且container也退出 离开且关门
ctrl+p+q         #退出登陆container且container不退出 离开不关门

#当container启动以后,在宿主机上输入命令让docker container执行,而不用登陆上去
docker exec  "$cmd"
```

# FAQ

##  src.rpm dev  rpm区别

```
源码包src.rpm             rpm2cpio $pkgName.src.rpm | cpio -div 解压为一个tar.gz
开发包dev       .h和lib   readline-devel.x86_64
运行包rpm       lib和exe  readline.x86_64

yum search readline
rpm -ql readline-devel.x86_64  #Files needed to develop programs 
							   #which use the readline library
rpm -ql readline.x86_64	       #A library for editing typed command lines

yum search libstdc++  && yum install -y libstdc++-docs && man std::string

命令行中vi和emacs的快捷键
yum search readline  && yum install readline-devel.x86_64 && man readline
```

## 登录无色 ls无色 vi无色 vim才有色 echo有色

```
ubuntu登录无色,那是因为.bashrc中的颜色未生效
默认shell是dash,不是bash, 所以默认不存在.bash_profile. 如果使用.bash_profile,记得使.bashrc生效
解决方法就是在~/.bash_profile添加代码 [ -f ~/.bashrc ] && source ~/.bashrc

alias ls='ls --color=auto '
alias grep='grep --color=auto '
alias egrep='egrep --color=auto '
alias fgrep='fgrep --color=auto '

echo -e "\e[显示方式;前景色;背景色m"   #\e也可以写成8进制的\033
                                   #显示方式 前景色 背景色 都是数字
                                   #不是按;;位置来判别,而是用数值范围来确定各位置数值
                                   #这三个参数可以都使用,也可以只使用前景色和背景色
                                   # \e[0m表示结束
显示方式0终端默认 1高亮 4使用下划线 5闪烁 7反白显示 8不可见
前景色 黑30 红31 绿32 黄33 蓝34 紫红35 青蓝36 白37
背景色 黑40 红41 绿42 黄43 蓝44 紫红45 青蓝46 白47
\33[nA   光标上移n行 
\33[nB   光标下移n行 
\33[nC   光标右移n行 
\33[nD   光标左移n行 
\33[y;xH 设置光标位置 
\33[2J   清屏 
\33[K    清除从光标到行尾的内容 
\33[s    保存光标位置 
\33[u    恢复光标位置 
\33[?25l 隐藏光标 
\33[?25h 显示光标
```

命令行中输入错误按删除键多出字符^H

```
原因是^H没有映射到erase信号上
解决方法是 stty erase ^H

stty -echo    #关闭回显。比如在脚本中用于输入密码时。
stty echo     #打开回显。
```

##  解决grep无header  

```
($cmd |head -n 1)  && ($cmd | grep xx)   #第一步解决输出head的问题
```

##  如何判定应用是否绑定127.0.0.1

```
telnet 127.0.0.1 $port  #OK
telnet $ip       $port  #Fail ip为为127.0.0.1
```

##   由于修改配置文件而启动服务

```
man  rsyslog.conf   && #定位到最后可得知是rsyslogd这个服务  systemctl restart rsyslog
```

##  清除shell cmd历史

```
#操作前可以不记录之后的命令
export HISTSIZE=0

[space]set +o history  #在export HISTCONTROL=ignorespace情况下,shell不会记录cmd到历史中
#cmder1 cmder2........
[space]set -o history  #这也是默认情况 即在命令前添加一个空格 shell就不会记录

#操作后删除所有命令记录
#cmder1 cmder2 ...
history -cw

#手动删除某条命令方式一
num=$(history | grep $mycmd | cut -f 1)
[space]history -d $num                    
#手动删除某条命令方式二
ctrl-p ctrl-p 找到希望删除的命令后ctrl-u    

HISTTIMEFORMAT
echo 'HISTTIMEFORMAT="%F %T "' >> ~/.bashrc
```

