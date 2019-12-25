

帮助

```
whereis        #搜索可执行，头文件和帮助信息的位置，使用系统内建数据库
man yum.conf   #查看配置文件的说明

linux各家族  Yellow dog Updater, Modified
    Debian	ubuntu	linux Mint                   apt-get install jq      advanced package tool
    fedora	RHEL	centos  	Oracle Linux     dnf     install jq     Dandified YUM
    SUSE    SLES	OpenSUSE                     zypper   install jq
    Arch                                          pacman   -Sy    jq     packageMan
BSD各家族
    freeBSD	                                     pkg install jq
    mac                                          brew install jq
    solaries                                     pkgutil -i jq
 windows                                         chocolatey install jq

col  vs column -t

命令自动完成
    compgen 
        -c #有哪些可用命令complete
        -b #所有bash内置命令
        -k #所有bash关键字
        -A #所有函数
        #compgen -w "aa ab bb cc" --"a" #从"aa ab bb cc"中找出以"a"开始的单词
    complete  -F $func	$cmd #当执行命令cmd时,该命令的参数由函数$func获取
    compopt
    	-o nospace

man bash | col -bx > bash.txt
方法1:转化为md
    :%s/^\([A-Z]\)/#\1/g                     #在行首有字母的行前添加#使之成为一级标题
    :%s/^[ ]\{3\}\([A-Z]\)/##\1/g            #在行首为3个空格的非空白行前添加##使之成为二级标题
    mv bash.txt bash.md
方法2: 直接使用vscode, 根据缩进折叠展开
```

# bash

##  命令

```
cat /etc/shells   #查看系统支持的shell
chsh -l           #等价cat /etc/shells
echo $SHELL       #查看使用哪种shell  env | grep SHELL
chsh -s /bin/bash #更改默认shell
export PS1="[\u@\h \W $(getGitBranchFuncName) ]$\n$"    #man bash 搜索PS1,根据提示搜索PROMPTING

主要就是为了设置PS1这个环境变量,也就是shell输入命令的前缀
/etc/profile                                 #system-wide .profile file for the Bourne shell
(~/.bash_profile|~/.bash_login|~/.profile)   #executed by Bourne-compatible login shells.
~/.bashrc                                    #executed by bash(1) for non-login shells
/etc/bashrc                          # System-wide .bashrc file for interactive bash(1) shells.
~/.bash_logout
```

###  内置命令

```
enable                   #查看bash的所有内置命令, 或禁止某命令
help    ${builtin_cmd}   #查看bash的内置命令的帮助,类似于查看用户命令的帮助man {user_cmd}
builtin ${builtin-cmd}   #忽略alias, 直接运行内置命令
command ${buildin_cmd}   #忽略alias, 直接运行内置命令或执行程序

bind -P                       # 列出所有 bash 的快捷键
declare
    declare -a                # 查看所有数组
    declare -f                # 查看所有函数
    declare -F                # 查看所有函数，仅显示函数名
    declare -i                # 查看所有整数
    declare -r                # 查看所有只读变量
    declare -x                # 查看所有被导出成环境变量的东西
    declare -p varname        # 输出变量是怎么定义的（类型+值）
eval $script                       # 对 script 变量中的字符串求值（执行）
source a.sh   #source 包含函数的脚本, 然后可以在shell中直接使用: $ $func_name $arg1 $arg2
set -o vi     #设置在命令行的操作方式  默认是emacs
type function  user_cmd builtin_cmd 
unset
    unset
	unset f
```

###  用户命令

```
man bash                           # 查看命令行的快捷方式
man hier                           # 查看文件系统的结构和含义
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

## 变量

```
环境变量
	set
预定义变量
    echo $$                   # 查看当前 shell 的进程号
    echo $!                   # 查看最近调用的后台任务进程号
    echo $?                   # 查看最近一条命令的返回码
用户定义变量
	local var=''   #在单引号里不能进行任何变量转义
	local var="x ${var2} yy"   #在等号前不能有空格 左边不需要,右边引用变量需要 在双引号$变量可以转义
	local var=`id -u user`
	local var=$(id -u user)   #运行命令，并将标准输出内容捕获并将返回值赋值
	                          #相对于``,$()能够转义,支持内嵌
	
变量定界符  主要是拼接字符串变量
	local var="visitor"; 
	${var}or        #visitor 拼接字符串,为了明确变量的边界,需要添加{}
   	${var}${var2}
 查看变量
 	echo $var
```

##  数值

```
if (( ))
计算
    number=(( number_var + 1))  #双括号内的 $ 可以省略
    [ number_var + 1 ]
    let number_var = $number_var + 1 
    number_var = expr $number + 1   # 兼容 posix sh 的计算，使用 expr 命令计算结果
比较
    num1 -eq num2             # 数字判断：num1 == num2
    num1 -ne num2             # 数字判断：num1 != num2
    num1 -lt num2             # 数字判断：num1 < num2
    num1 -le num2             # 数字判断：num1 <= num2
    num1 -gt num2             # 数字判断：num1 > num2
    num1 -ge num2             # 数字判断：num1 >= num2
```

##  字符串

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
    str1 = str2               # 判断字符串相等，如 [ "$x" = "$y" ] && echo yes
    str1 != str2              # 判断字符串不等，如 [ "$x" != "$y" ] && echo yes
    str1 < str2               # 字符串小于，如 [ "$x" \< "$y" ] && echo yes
    str2 > str2               # 字符串大于，注意 < 或 > 是字面量，输入时要加反斜杆
    -n str1                   # 判断字符串不为空（长度大于零）
    -z str1                   # 判断字符串为空（长度等于零）

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

##  数组

```
遍历
	for ((i=1; i<=j; i++)); do  done
    for i in "a" "b"
    for i in {1..10}
    for i in 192.168.1.{1..254}
    for i in “file1” “file2” “file3”
    for i in /boot/*
    for i in /etc/*.conf
    for i in $(seq 10)     #man seq   $(seq 5 -1 1)  start=5 step=-1 end=1
    for i in $(ls)
    for I in $(<file)
    for i in "$@"   #$#变量个数 $@ $*变量内容 $0文件名 $9 ${10} ${11}当变量个数大约9时,需要{},也就是要明确边界

定义数组
    array=([0]=valA [1]=valB [2]=valC)   
    array=(valA valB valC)
旋转门
    转入数组
        array=($text)             # 按空格分隔 text 成数组，并赋值给变量
        IFS="/" array=($text)     # 按斜杆分隔字符串 text 成数组，并赋值给变量 
    转出数组
        text="${array[*]}"        # 用空格链接数组并赋值给变量
        text=$(IFS=/; echo "${array[*]}")  # 用斜杠链接数组并赋值给变量             
获取数组元素            ${array[i]}
获取数组长度            ${#array[@]}
获取数组中某变量长度     ${#array[i]}
数组切片
    A=( foo bar "a  b c" 42 ) # 数组定义
    B=("${A[@]:1:2}")         # 数组切片：B=( bar "a  b c" )
    C=("${A[@]:1}")           # 数组切片：C=( bar "a  b c" 42 )
    echo "${B[@]}"            # bar a  b c
    echo "${B[1]}"            # a  b c
    echo "${C[@]}"            # bar a  b c 42
    echo "${C[@]: -2:2}"      # a  b c 42  减号前的空格是必须的
```

##  map

## 逻辑运算

```
test {expression}         # 判断条件为真的话 test 程序返回0 否则非零
[ expression ]            # 判断条件为真的话返回0 否则非零
[ \( $x -gt 10 \) ]

statement1 && statement2  # and 操作符
statement1 || statement2  # or 操作符
! expression              # 如果 expression 为假那返回真

exp1 -a exp2              # exp1 和 exp2 同时为真时返回真（POSIX XSI扩展）
exp1 -o exp2              # exp1 和 exp2 有一个为真就返回真（POSIX XSI扩展）

-a file                   # 判断文件存在，如 [ -a /tmp/abc ] && echo "exists"
-d file                   # 判断文件存在，且该文件是一个目录
-e file                   # 判断文件存在，和 -a 等价
-f file                   # 判断文件存在，且该文件是一个普通文件（非目录等）
-r file                   # 判断文件存在，且可读
-s file                   # 判断文件存在，且尺寸大于0
-w file                   # 判断文件存在，且可写
-x file                   # 判断文件存在，且执行
-N file                   # 文件上次修改过后还没有读取过
-O file                   # 文件存在且属于当前用户
-G file                   # 文件存在且匹配你的用户组
file1 -nt file2           # 文件1 比 文件2 新
file1 -ot file2           # 文件1 比 文件2 旧

建议使用[[]]代替[],理由如下 避免转义
[ "$x" \< "$y" ]    [[ $x < $y ]]

在bash3.2之后,加""就是字面比较;如若需要通配或正则比较,则不能使用"",如果通配或正则中含有空格,则需定义变量
t="abc123"
[[ $t ==  abc*         ]] #true 通配符globbing比较
[[ $t =~  [abc]+[123]+ ]] #true 正则比较
[[ $t == "abc*" ]]        #false 字面比较
```

##  流程控制

```
if [condition]; then
elif [condition]; then
else
fi

for ;do 
done

while [condition]; do
done

until condition; do
statements
done

#菜单选择
select name [in list]; do 
	case $name in 
    pattern1 )
    	statements ;;
    pattern2 )
    	statements ;;
    * )
    	otherwise ;;
	esac
done
```

##  函数 

```
function myfunc() {
    # $1 代表第一个参数，$N 代表第 N 个参数
    # $# 代表参数个数
    # $0 代表被调用者自身的名字
    # $@ 代表所有参数，类型是个数组，想传递所有参数给其他命令用 cmd "$@" 
    # $* 空格链接起来的所有参数，类型是字符串
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

##  输入输出重定向

```
read [-p "prompt"] $line # 读取一行
read [-p "prompt"] $v1 $v2 $n #将一行按照IFS分割赋值给各变量 若变量数小于切片数,则最后一个变量再获取其余值; 若变量数大于切片数,则多余变量值为空

cmd1 | cmd2                        # 管道，cmd1 的标准输出接到 cmd2 的标准输入
< file                             # 将文件内容重定向为命令的标准输入
> file                             # 将命令的标准输出重定向到文件，会覆盖文件
>> file                            # 将命令的标准输出重定向到文件，追加不覆盖
>| file                            # 强制输出到文件，即便设置过：set -o noclobber
n>| file                           # 强制将文件描述符 n的输出重定向到文件
<> file                            # 同时使用该文件作为标准输入和标准输出
n<> file                           # 同时使用文件作为文件描述符 n 的输出和输入
n> file                            # 重定向文件描述符 n 的输出到文件
n< file                            # 重定向文件描述符 n 的输入为文件内容
n>&                                # 将标准输出 dup/合并 到文件描述符 n
n<&                                # 将标准输入 dump/合并 定向为描述符 n
n>&m                               # 文件描述符 n 被作为描述符 m 的副本，输出用
n<&m                               # 文件描述符 n 被作为描述符 m 的副本，输入用
&>file                             # 将标准输出和标准错误重定向到文件
<&-                                # 关闭标准输入
>&-                                # 关闭标准输出
n>&-                               # 关闭作为输出的文件描述符 n
n<&-                               # 关闭作为输入的文件描述符 n
diff <(cmd1) <(cmd2)               # 比较两个命令的输出
```

##  调试

```
$help set
Set or unset values of shell options and positional parameters

set +x    #扩展shell中变量并打印   在shell脚本中或在命令行都可以使用
          #Using + rather than - causes these flags to be turned off.  
    	  #The flags can also be used upon invocation of the shell. eg bash -euo pipefail x.sh
    	  #The current set of flags may be found in $-   eg  echo $-
    	  #The remaining n ARGs are positional parameters and are assigned,in order,to $1,.. $n
    	  #If no ARGs are given, all shell variables are printed

#!/bin/bash
bash -n        #语法检查Read commands but do not execute them
set -o noexec
set -n

bash -e
set -o errexit #默认情况下 遇到错误仍然会继续往下执行
set -e         #Exit immediately if a command exits with a non-zero status

bash -u
set -o nounset #默认情况下 遇到未定义的变量仍然会继续往下执行
set -u         #Treat unset variables as an error when substituting

bash -v        #Print shell input lines as they are read
set -o verbose #跟踪每个命令的执行
set -v

bash -x
set -o xtrace  # Print commands and their arguments as they are executed
set -x

set -o pipefail #the return value of a pipeline is the status of
                #the last command to exit with a non-zero status,
                #or zero if no command exited with a non-zero status
```

#  命令
##  echo

```
-e   //转义生效  echo -e "print\tprint2"
-n   //不换行
```

## date/timedatectl

```
date --date='@2147483647'

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

```

ncat

socat

##  nmap

```
network mapper
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

##  top

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

#  用户权限

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

firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --remove-port=80/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-all
firewall-cmd --query-port=8080/tcp


ufw disable/enable          #设置开机是否启动
ufw default allow/deny      #设置默认策略, ufw默认不允许外部访问,但能访问外部

ufw status verbose          #inactive

ufw        allow $port
ufw delete allow $port

ufw        allow $service    #smtp  来自/etc/services
ufw delete allow $servie     #等价于ufw deny $service

ufw reload
ufw status            	     #inactive
```

#  services/units
|                    | SysVInit                                     | systemd                              |
| ------------------ | -------------------------------------------- | ------------------------------------ |
| pid==1的进程名     | init                                         | systemd                              |
| 查看默认运行级别   | 1.runlevel   2.who -r 3.cat /etc/inittab     | /systemd/system/default.target       |
| 编写脚本目录       | cat /etc/init.d/redis.service                | /lib/systemd/system/redis.service    |
| 设置运行级别       | 见PS 1                                       | 见PS 2                               |
| 重新载入使脚本生效 |                                              | systemctl daemon-reload              |
| 查看安装了哪些服务 | chkconfig --list                             | systemctl list-unit-files            |
| 设置开机启动       | chkconfig --add/--del  $service  on/off      | systemctrl enable/disable $service   |
| 查看是否开机启动   | chkconfig --list  $service                   | systemctl is-enabled $service        |
| 查看哪些服务在运行 | service --status-all \| grep                 | systemctl list-unit -t service -a    |
| 直接从脚本执行     | /etc/init.d/redis.service start/stop/restart |                                      |
| 启动/停止/重启     | service $service start/stop/restart          | systemctl start/stop/restart $servic |
PS:

​	1. ln -s /etc/init.d/$servived /etc/rc.d/rc3.d/S100$service

​	2.  ln -s /lib/systemd/system/redis.service /etc/systemd/system/multi-user.target.wants/redis.service 

##  SysVInit

###  写脚本

在目录/etc/init.d下编写服务start/stop/status脚本

/etc/init        #配置文件.conf
/etc/init.d     #bash文件 start stop restart status

###  配置开机启动

- 手动方式 

  ​	 /etc/rc.d/rc[0-6].d  #快捷方式 ln -s /etc/init.d/redisd      /etc/rc.d/rc3.d/S100redis
                                    \#多个运行级别,需要在多个rc[0-6]建立链接
                                    \#	以S100为例, 
                      		  \#		S表示开机启动; 可以替换为K表示开机关闭
                                   \#		100表示启动顺序

- 命令行方式 chkconfig     ubuntu为apt-get install sysv-rc-conf

  ​	--list               [$service]                   #列出所有/某服务的运行级别  eg.  chkconfig --list httpd

  ​	--add/--del    $service                     #设置开机启动                           eg. chkconfig --add httpd 

  ​	[--level35]     $service   on/off        #设置开机启动                          eg. chkconfig --level35 http on

- TUI方式redhat之ntsysv

  ​	默认情况下，当前运行级别为多少，在ntsysv中设置的启动服务的级别便是多少
      	比如，我当前的运行级别是3,那么我在伪图形界面中选择启动服务后，它的运行级别也会是3
      	如果想自定义运行级别可使用ntsysv --level方式

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

systemctl [option][cmd]  cmd
  option
        -t,--type=TYPE：          #可以过滤某个类型的 unit
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
             **start/stop/reload/restart/kill/status/is-active/show  $unit**                            #service start/stop
       	 \#Unit File Commands
        	**list-unit-files**              #根据/lib/systemd/system/目录内的文件列出所有的unit  chkconfig --list
        	**enable/disable/is-enabled/mask/unmask  $unit**                                              #chkconfig --add/--del
        	get-default #系统的默认运行级别在/etc/systemd/system/default.target文件中指定
        	set-default TARGET.target
         \#Machine Commands
         \#Job Commands
         \#Snapshot Commands

### unit-file

systemctl list-unit-files

systemctl is-enabled $service  #查看服务是否开机启动
                                                     \#若返回static, 则表示不可以自己启动,只能被其他enable的unit唤醒
systemctl enable       $service
systemctl disable      $service
systemctl mask	     $service   #注销
systemctl unmask     $service   #取消注销

###  unit

systemctl list-units [-t service]   \[-a\]        #-,--type 

systemctl start/stop/restart/kill $service
systemctl reload       $service
systemctl status        $service  #active inactive 
                                                     \#active(exited)只执行一次就退出 
                                                     \#active(waiting)等待比如打印    
systemctl is-active  $service
systemctl show       $service  #列出配置

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

  

  rpm {-q|--query}  [select-options][query-options] [query-options]

- -q    $pkgName #查询是否安装了该软件

- -qp  *.rpm         #package Query an (uninstalled) package

- **-qa**                     #all    Query all installed packages

  ​                           \#yum list                  

- -qi   $pkgName #Display ***installed*** package information, including name, Install Date, and description. 

  ​                             \# yum ***info*** openssh-server

- **-ql**   $pkgName  #list 列出该软件所有的文件与目录所在完整文件名 

  ​			     \# yum install yum-utils && repoquery -ql dhcp

- -qc   $pkgName  #configures list only configuration files (找出在/etc/下面的文件名而已) 

- -qd   $pkgName  #document 列出该软件所有的帮助文档（List only documentation files） 

- **-qf**    $filename   #file 根据文件名查询属于哪个已安装的包 List file in package

  ​				\# yum whatprovidesd \`which sshd`

  ​			        \# yum provides \`which sshd`

- -qR   $pkgName #required List capabilities on which this depends. 

  ​                             \# yum deplist openssh-server

###  yum

Server将pkg根据类别存放到不同Repo中,包的依赖的关系存放在xml中

Client根据本地的配置文件/etc/yum.repo.d/*.repo中指定的server端下载依赖文件xml于本地/var/cache/yum中

- yum repolist all                                #查询有哪些库Repo可以install

- yum search [all]  $pkgName          #
- 

  yum check-update  #列出所有可更新的软件

  yum update             #更新所有软件
- list

  yum list                  #列出所有可安装的软件

  yum list updates  #可供升级

  yum list ssh*        #installed Packages已安装和可升级/安装Available Packages

- group
  yum group list          
  yum group install      $groupName
  yum group remove   $groupName
  yum group info          $groupName                    #yum group info "Development Tools"
- 
  yum install -y  $pkgName
  yum remove   $pkgName
  yum update   $pkgName
- clean

  yum clean packages

  yum clean headers

  yum clean oldheaders

  yum clean 

  yum clean all == yum clean packages &&  yum clean oldheaders

yum makecache



只下载不安装 存放于/var/cache/yum/x86_64/7/updates/packages 7发行版本号CentOS7 updates仓库名

 yum install --downloadonly dhcp
 rpm -qlp <下载后包的完整路径> 可以查看rpm包中的文件



流程

​	rmp -q          $pkgName   #查询是否安装了包 rpm -qa | grep pkgName

​	yum search  $pkgName 

​	yum info       $pkgName

​	yum install    $pkgName

###  dpkg

格式 Package_Version-Build_Architecture.deb  #nano_1.3.10-2_i386.deb 

主要用于对已下载到本地和已安装的软件包进行管理 

/etc/dpkg/dpkg.cfg              dpkg包管理软件的配置文件【Configuration file with default options】

/var/log/dpkg.log                dpkg包管理软件的日志文件【Default log file (see /etc/dpkg/dpkg.cfg(5) 】

/var/lib/dpkg/available       存放系统所有安装过的软件包信息【List of available packages.】

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

apt-get -d                   package   仅下载不安装

apt-get install              package=version  安装包
apt-get install -f           package  强制安装
apt-get install --reinstall  package  重新安装包

apt-get remove         package        删除包
apt-get purge          package        删除包，包括删除配置文件等

apt-get autoclean                     清理那些已经被removed/purged软件的安装包*.deb,以释放磁盘空间
apt-get clean                         清理那些已经被安装了但还有安装包的*.deb,以释放磁盘空间

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

#  Tool

## ldd

##  nm -CA 

##  tcpdump

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
```

##  scp/rsync

```
rsync -avzh   --verbose  -h进度条
```

#  za

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

##  目录

```
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
trap cmd sig1 sig2        # 在脚本中设置信号处理命令
trap "" sig1 sig2         # 在脚本中屏蔽某信号
trap - sig1 sig2          # 恢复默认信号处理行为
```

##  系统版本

```
uname -a
    查看内核版本
lsb_release -a     #yum search lsb而不是yum search lsb_release
    查看版本CentOS Redhat Ubuntu
hostname
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
    lastb            #读取文件/var/log/btmp, 显示用户登录失败
    lastlog [user]   #读取文件/var/log/lastlog,显示所有用户最后一次登录
        -u  $user
        -b  $n       #指定天数前
        -t  $n       #指定天数以来
显示当前用户登录情况
    w/who/user      #显示在线用户

write {user}    #向某人发送一段话

whoami
finger {user}   # 显示某用户信息，包括 id, 名字, 登陆状态等
id {user}       # 查看用户的 uid，gid 以及所属其他用户组
```

##  crontab

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

## ls无色

```
alias ls='ls --color=auto '
alias grep='grep --color=auto '
alias egrep='egrep --color=auto '
alias fgrep='fgrep --color=auto '
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
