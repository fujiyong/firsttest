

[TOC]



帮助



```
whereis        #搜索可执行，头文件和帮助信息的位置，使用系统内建数据库
man yum.conf   #查看配置文件的说明

```



# bash

##  命令

```
source a.sh   #source 包含函数的脚本, 然后可以在shell中直接使用: $ $func_name $arg1 $arg2
env
set
unset
    unset
	unset f
declare
    declare -a                # 查看所有数组
    declare -f                # 查看所有函数
    declare -F                # 查看所有函数，仅显示函数名
    declare -i                # 查看所有整数
    declare -r                # 查看所有只读变量
    declare -x                # 查看所有被导出成环境变量的东西
    declare -p varname        # 输出变量是怎么定义的（类型+值）
    
command ls                         # 忽略 alias 直接执行程序或者内建命令 ls
builtin cd                         # 忽略 alias 直接运行内建的 cd 命令
enable                             # 列出所有 bash 内置命令，或禁止某命令
help {builtin_command}             # 查看内置命令的帮助（仅限 bash 内置命令）

man hier                           # 查看文件系统的结构和含义
man test                           # 查看 posix sh 的条件判断帮助
man set
man bash
getconf LONG_BIT                   # 查看系统是 32 位还是 64 位
bind -P                            # 列出所有 bash 的快捷键

eval $script                       # 对 script 变量中的字符串求值（执行）
```

## 变量

```
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

case expression in 
    pattern1 )
    	statements ;;
    pattern2 )
    	statements ;;
    * )
    	otherwise ;;
esac

select name [in list]; do
	statements that can use $name
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
read $line # 读取一行
read $v1 $v2 $n #将一行按照IFS分割赋值给各变量 若变量数小于切片数,则最后一个变量再获取其余值; 若变量数大于切片数,则多余变量值为空

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
set -u    //检测未定义的变量        在shell脚本中或在命令行都可以使用
set +x    //扩展shell中变量并打印   在shell脚本中或在命令行都可以使用

bash -n  //语法检查

#!/bin/bash
set -o nounset #默认情况下 遇到未定义的变量仍然会继续往下执行
set -o errexit #默认情况下 遇到错误仍然会继续往下执行
set -o verbose #bash -v		跟踪每个命令的执行
set -o xtrace  #bash -x
```

#  命令

## date

##  printf

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
	""  双引号中可以含有变量${var} ''不能含有变量
	^   行首
	$	行尾
	\<   单词开始
	\>   单词结束
	\b   单词锁定符 \bgrep\b
	
	.    任意不换行的字符
	\w   [A-Za-z0-9]
	\W   ^\w
	
	[-]
	[^]
	\(..\)
	
	{m}
	{m,}
	{m,n}
	*
	
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

-i   #忽略大小写
-v   #忽略
-n   #行号

-r   #递归  相对于文件夹来说

egrep == grep -E
	{m,n}=\{m,n}
	?
	+
	a|b|c
	()  字符组
	()()\1\2  模板匹配\1表示前一个模板 \2表示后一个模板
fgrep == grep -F  #fixed 即pattern不转义,为字面字符
```

##  sort

```
sort file                          # 排序文件
sort -u file                       # 去重排序
sort -r file                       # 反向排序（降序）
sort -n file                       # 使用数字而不是字符串进行比较
sort -t: -k 3n /etc/passwd         # 按 passwd 文件的第三列进行排序
```

##  cut

```
按byte
    cut -c 1-16                        # 截取每行头16个字符
    cut -c 1-16 file                   # 截取指定文件中每行头 16个字符
    cut -c3-                           # 截取每行从第三个字符开始到行末的内容
按分隔符
    cut -d':' -f5                      # 截取用冒号分隔的第五列内容
    cut -d';' -f2,10,12                # 截取用分号分隔的第二和第十列 第十二列内容
    cut -d' ' -f3-7                    # 截取空格分隔的三到七列
    cut -d' ' -f3
```

##  sed

```
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

history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
netstat -n | awk '/^tcp/ {++tt[$NF]} END {for (a in tt) print a, tt[a]}'
```

## lsof

```
lsof -i [$proto_name]:80
lsof -P -i -n | cut -f 1 -d " "| uniq | tail -n +2 # 显示当前正在使用网络的进程
```



#  性能状态

##  ps

##  top

##  iotop

##   vmstat

```
vmstat [delay [count]]
    -n  causes the headers not to be reprinted regularly

    输出
        r  正在running process, 一般小于CPU较好
        b  正在blocking process,
```

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
```

#  ssh

```
ssh-copy-id user@host     # 拷贝你的 ssh key 到远程主机，避免重复输入密码

# 通过主机 A 直接 ssh 到主机 B
ssh -t hostA ssh hostB
```

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
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --remove-port=80/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-all
firewall-cmd --query-port=8080/tcp
//临时关闭防火墙,重启后会重新自动打开
systemctl restart firewalld
//检查防火墙状态
firewall-cmd --state
firewall-cmd --list-all
//Disable firewall
systemctl disable firewalld
systemctl stop firewalld
systemctl status firewalld
//Enable firewall
systemctl enable firewalld
systemctl start firewalld
systemctl status firewalld
```

#  services

```
ntsysv 图形界面
chkconfig --list
service --status-all 
rpm -qa
rpm -ql

systemctl is-enabled $service  //查看服务是否开机启动
systemctl enable $service
systemctl disable $service
systemctl start $service
systemctl stop $service
systemctl status $service
```

# yum

```
 * base: mirror.bit.edu.cn
 * epel: hkg.mirror.rackspace.com
 * extras: mirrors.aliyun.com
 * updates: mirror.bit.edu.cn
 
 # 只下载不安装 存放于/var/cache/yum/x86_64/7/updates/packages 7发行版本号CentOS7 updates仓库名
 yum install --downloadonly dhcp
rpm -qlp <下载后包的完整路径> 可以查看rpm包中的文件
 yum install yum-utils
 repoquery -q -l dhcp
 
 yum deplsit openssh-server
 yum info openssh-server
 yum provides openssh-server   // yum whatprovidesd "*bin/nc"

```



#  za

##  目录

```
pushd {dirname}     # 目录压栈并进入新目录
popd                # 弹出并进入栈顶的目录
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

##  ascii

```
showkey -a                # 查看终端发送的按键编码
man ascii                          # 显示 ascii 表
```

##  登录用户

```
last {user}
lastlog {user}

w/who/user      #显示在线用户

whoami
finger {user}   # 显示某用户信息，包括 id, 名字, 登陆状态等
id {user}       # 查看用户的 uid，gid 以及所属其他用户组

write {user}    #向某人发送一段话
```

# FAQ

## ls无色

```
alias ls='ls --color=auto '
alias grep='grep --color=auto '
alias egrep='egrep --color=auto '
alias fgrep='fgrep --color=auto '
```

