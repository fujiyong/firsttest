#!/usr/bin/env bash

set -eu

rc_root="${HOME}/.local/rc"
if [ ! -d "$rc_root" ]; then
    mkdir -p "$rc_root"
fi
misc_file="${HOME}/.local/misc"

colorForgRed="\e[31m"
colorForgYellow="\e[33m"
colorEnd="\e[0m"


osType=$( hostnamectl | grep 'Operating' | cut -d: -f 2 | cut -d' ' -f 2 | tr "[:upper:]" "[:lower:]" )
echo -e "$colorForgYellow your os is  $osType $colorEnd"


function help(){
    echo "bash $0"
    echo "快速安装工具软件"
}

function gvlog() {
    # local filename=$0s
    # local lineno=$2
    # local msg=$3
    :
}


function update_aliyun_source(){
    echo -e "\n\n\n$colorForgYellow start to update aliyun source $colorEnd"
    if [[ $osType == ubuntu ]]; then
        #Lucid(10.04) Precise(12.04) Trusty(14.04) Utopic(14.10) xenial(16.04) bionic(18.04)
        old_source=$(apt-cache policy | grep com | head -n 1 | cut -d' ' -f 3 | awk -F. '{print $(NF-1)}' )
        if [[ $old_source == ubuntu ]]; then
            mv /etc/apt/sources.list /etc/apt/sources.list.raw
            cat > /etc/apt/sources.list << EOF
# https://opsx.alibaba.com/mirror
deb https://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse 
deb https://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse 
deb https://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse 
deb https://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse 

deb-src https://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse 
deb-src https://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse 
deb-src https://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse 
deb-src https://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse 
deb-src https://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
EOF
        fi
        apt update
        # apt upgrade
    elif [[ $osType == centos ]]; then
        #yum repolist all
        # old_source=$(yum repolist | grep -A 3 cached | grep base | cut -d' ' -f 4)
        old_source=$( yum repolist | grep -A 3 cached | grep -c -i centos )
        if [[ $old_source -gt  0 ]]; then
            mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.raw
            wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
        fi
        yum makecaches
    fi
    echo -e "$colorForgYellow updating aliyun source ends $colorEnd"
}





function __install_item() {
    name=$1

    if [[ $osType == ubuntu ]]; then
        # apt update
        # apt upgrade
        sudo apt install -y "$name"
    elif [[ $osType == centos ]]; then
        sudo yum install -y "$name"
    else
        echo "your os is $osType"
    fi

    if [ $? ]; then
        echo -e "$colorForgYellow install $name ok  $colorEnd"
    else
        echo -e "$colorForgRed install $name failed  $colorEnd"
    fi

    return $?
}


function install_item() {
    name=$1
    echo -e "\n\n\n $colorForgYellow start to install $name $colorEnd"
    if [ -n "$(which $name)" ]; then
        echo -e "$colorForgYellow $name installed $colorEnd"
        return 0
    fi

    __install_item "$name"
}

function install_items(){
    for item in "$@"; do
        install_item "$item"
    done
}

function source_rc_file() {
    if [ !  $# -eq 2 ]; then 
        echo "your must set 2 parameter for source_rc_file"
        return 1
    fi
    filename=$1
    keyword=$2
    if [ -f "${HOME}/.bashrc" ] && ! $( grep "$keyword" "${HOME}/.bashrc" ) ; then
        echo "source $filename" >> "${HOME}/.bashrc"
        source "${HOME}/.bashrc"
    fi
    if [ -f "${HOME}/.zshrc" ] && ! $( grep "$keyword" "${HOME}/.zshrc" ) ; then
        echo "source $filename" >> "${HOME}/.zshrc"
        source "${HOME}/.zshrc"
    fi
}

function enable_firewall(){
    echo -e "\n\n\n $colorForgYellow start to enable and start firewall $colorEnd"
    if [[ $osType == ubuntu ]]; then
        local enable_status=$( systemctl status ufw | grep -i loaded | cut -d';' -f 2 | sed -e 's/^[ ]*//' )
        echo "your firewall default is $enable_status"
        if [[ $enable_status == disabled ]]; then
            systemctl enable ufw
        fi
        local current_status=$( ufw status verbose | grep -i status | cut -d: -f2 | sed -e 's/^[ ]*//' )
        echo "your firewall pre status is $current_status"
        if [[ $current_status == inactive ]]; then
            systemctl start ufw
        fi
        echo "----"
        ufw reload
        systemctl status ufw 
        ufw status verbose
        echo "----"
    elif [[ $osType == centos ]]; then
        local enable_status=$( systemctl status firewalld | grep -i loaded | cut -d';' -f 2 | sed -e 's/^[ ]*//' )
        echo "your firewalld default is $enable_status"
        if [[ $enable_status == disabled ]]; then
            systemctl enable firewalld
        fi
        local current_status=$( firewall-cmd --stat )
        echo "your firewall pre status is $current_status"
        if [[ $current_status == "not running" ]]; then
            systemctl start firewalld
        fi
        echo "----"
        firewall-cmd --reload
        systemctl status firewalld 
        firewall-cmd --list-all
        echo "----"
    else
        :
    fi
   echo -e "$colorForgYellow firewall enabled and starts $colorEnd"
}

function install_compile_tool_chain() {
    echo -e "\n\n\n $colorForgYellow start to install compile tool chain $colorEnd"
    if [ -f "$( which gcc )" ]; then
        echo -e "$colorForgYellow gcc compile tool chain installed $colorEnd"
        return 0
    fi
    
    if [[ $osType == ubuntu ]]; then
        sudo apt install -y "build-essential"      #apt search build | grep ess  
    elif [[ $osType == centos ]]; then
        sudo yum install -y "Development Tools"    #yum grouplist
    # elif [[ $osType == maxos ]]; then
    fi

    if [ $? ]; then
        echo -e "$colorForgYellow install compile_tool_chain ok $colorEnd"
    else
        echo -e "$colorForgYellow install compile_tool_chain failed $colorEnd"
    fi

    return $?
}

function install_chinese_man( ) {
    #https://github.com/man-pages-zh/manpages-zh
    if [[ $osType == ubuntu ]]; then
        sudo apt install -y manpages-zh
    elif [[ $osType == centos ]]; then
        sudo yum install -y man-pages-zh-CN
    # elif [[ $osType == maxos ]]; then
    fi

    if [ $? ]; then
        echo "install chinese_man ok"
    else
        echo "install chinese_man failed"
    fi

    return $?
}

function install_chinese_support_pkg(){
    if [ $( locale -a | grep -c zh ) -gt 0 ]; then    #查询系统中目前所有支持的语言
        echo "your os has support chinese now"
    else
        echo "your os doesn't support chinese now and to install"
        if [[ $osType == ubuntu ]]; then
            apt-get install -y language-pack-zh-hans   #install chinese language pkg
            # locale-gen zh_CN.UTF-8                   #add chinese support
        elif [[ $osType == centos ]]; then
            yum install -y kde-l10n-Chinese
            if [ $( yum list installed | grep -c glibc-common ) -gt 0 ]; then
                yum reinstall -y glibc-common
            else
                yum install -y glibc-common
            fi
        fi
    fi
}



############################## vi #############################################
cat > "$HOME/.vimrc" << EOF
":h '\$item'
set nocompatible
syntax on
set nu rnu
set cul

set is
set hls
set smartcase
set showmatch

set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent
set expandtab
EOF
fi
############################## color man ######################################
rc_file=${rc_root}/man/.mancolor_rc
mkdir -p $(dirname $rc_file)
cat > "${rc_file}" << EOF
export LESS_TERMCAP_mb=$'\E[1m\E[32m'
export LESS_TERMCAP_mh=$'\E[2m'
export LESS_TERMCAP_mr=$'\E[7m'
export LESS_TERMCAP_md=$'\E[1m\E[36m'
export LESS_TERMCAP_ZW=""
export LESS_TERMCAP_us=$'\E[4m\E[1m\E[37m'
export LESS_TERMCAP_me=$'\E(B\E[m'
export LESS_TERMCAP_ue=$'\E[24m\E(B\E[m'
export LESS_TERMCAP_ZO=""
export LESS_TERMCAP_ZN=""
export LESS_TERMCAP_se=$'\E[27m\E(B\E[m'
export LESS_TERMCAP_ZV=""
export LESS_TERMCAP_so=$'\E[1m\E[33m\E[44m'
EOF
fi
source_rc_file "$rc_file" ".mancolor_rc"
########################### misc         #####################################
cat > $misc_file << EOF
set -o vi
function blines(){
	blanklinesCount=50
	if [ $# -gt 2 ]; then
		blanklinesCount=$1
	fi
	for line in $(seq $blanklinesCount); do
		echo ""
	done
	clear
}
EOF
source_rc_file "$misc_file" ".misc"

########################### history time format ###############################
#echo 'HISTTIMEFORMAT="%F %T "' >> ~/.bashrc



########################### firewalld    ######################################
enable_firewall



############################ update repo source ###############################
update_aliyun_source
############################ update git address ###############################
############################ update datetime #################################
    # install_item ntpdate
    # install_item crontab
    # cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    # ntpdate us.pool.ntp.org
    # echo "0-59/10 * * * * /usr/sbin/ntpdate us.pool.ntp.org | logger -t NTP" >> /etc/crontab
############################ compile tool chain ###############################
## just for c/c++
install_compile_tool_chain
############################ wget/curl  #######################################
install_items "wget" "curl"
############################### git ###########################################
install_item git
#####git configure
git config --global user.name "yy"
git config --global user.email "fujiyong2000@126.com"
git config --global alias.st status
git config --global alias.ci commit
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.unstage 'reset HEAD'
git config --global alias.last 'log -1'
#git config --global alias.lg     "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.lg     "log --all --graph  --oneline  --date-order --date iso --pretty=format:'%C(cyan)%h%Creset %C(black bold)%cd%Creset %C(bold blue)<%cn>%Creset %C(auto)%d %s'"
git config --global alias.lgstat "log --all --graph  --stat     --date-order --date iso --pretty=format:'%C(cyan)%h%Creset %C(black bold)%cd%Creset %C(bold blue)<%cn>%Creset %C(auto)%d %s'"
git config --global color.ui always
#git config --global log.date iso
git config --global log.date format:'%Y-%m-%d %H:%M:%S'
################################## dir ########################################
install_item "tree"
################################# process #####################################
install_items "htop" "atop" "glances"
install_item "pstree"
# install item "procps"        #pkill
# install item "psmisc"        #killall
################################# net #########################################
# install_item "net-tools"   #netstat



############################### bman ##########################################
# busybox $cmd --help
#   eg:  buybox top --help
############################### cman  #########################################
install_chinese_support_pkg
install_chinese_man
rc_file=${rc_root}/cman/.chinese_man_rc
if [ -f "$rc_file" ]; then
    echo "rc_file $rc_file exist"
else
    echo "rc_file $rc_file not exist"
    mkdir -p $(dirname $rc_file)
    cat > "$rc_file" << EOF
alias cman='LANG=zh_CN.utf8 man'
EOF
    source_rc_file "$rc_file" ".chinese_man_rc"
fi
################################ sman #########################################
# tldr  apt install tldr
#git clone https://github.com/tldr-pages/tldr.git  #总页面
#https://github.com/raylee/tldr                    #bash client page
if [ $(which tldr) ]; then
    echo "tldr exist"
else
    echo "start to install tldr"
    mkdir -p "$HOME/tldrbin"
    curl -o "$HOME/tldrbin/tldr" "https://raw.githubusercontent.com/raylee/tldr/master/tldr"
    cp "$HOME/tldrbin/tldr" /usr/bin
    rc_file=${rc_root}/sman/.tldr_rc
    mkdir -p $(dirname $rc_file)
    cat > "$rc_file" << EOF
export PATH=$PATH:~/bin
alias sman='tldr'
complete -W "$(tldr 2>/dev/null --list)" tldr
EOF
    source_rc_file "$rc_file" ".tldr_rc"
    rm -rf "$HOME/tldrbin"
    echo "installing tldr ends"
fi
if [ -d $HOME/.tldr ]; then
    echo "dir .tldr exist and to update"
    # tldr --update
else
    echo "start to install tldr reference"
    tldr --update
    echo "installing tldr reference ends"
fi





##############################install tmux ####################################
install_item "tmux"
if [ -f "$HOME/.tmux.conf.local" ]; then
    echo "oh my tmux installed"
else
    cd "$HOME"
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    scp .tmux/.tmux.conf.local .
    sed -i 's/mouse off/mouse on/' .tmux.conf.locals
fi
################################ fzf ##########################################
if [ `which fzf` ]; then
    echo "fzf has installed"
else
    # if [ ! `install_item fzf`]; then
        echo "start to install fzf"
        git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
        # cd $HOME/.fzf && git pull && ./install && cd
        echo "installing fzf ends"
    # fi
fi
################################# ag ##########################################
if [ $(which ag) ]; then
    echo "ag installed"
else
    install_item "silversearcher-ag"
fi

################################ jq ###########################################
git clone https://github.com/stedolan/jq.git
cd && cd jq
autoreconf -i
./configure --disable-maintainer-mode
make && make install
cd 

###############################################################################
install_item "axel"
install_item "cloc"
install_item "elinks"
install_item "mycli"
install_item "multitail"
install_item "lynx"
install_item "jq"
install_item "shellcheck"
install_item "tig"



############################### redis #########################################
############################### nginx #########################################
install_item "nginx"
############################### mysql #########################################
if [ -f $(which mysqld) || -f $(which mysql) ]; then
	echo "mysql installed"
else 
	echo "start install mysql server"
	if [[ $osType == ubuntu ]]; then
		apt install -y mysql-server mysql mysql-devel
	elif [[ $osType == centos ]]; then
		yum install -y mysql-server mysql mysql-devel
	end
	/usr/sbin/groupadd mysql
    /usr/sbin/useradd -r -g mysql -s /bin/false mysql

	sed -i 's/bind-address=127.0.0.1/bind-address=0.0.0.0/' $(locate mysql.conf.d)
	mysqld_safe --user=mysql --skip-grant-tables  >/dev/null 2>&1 &  #启动mysql

	defaultmysqlpwd=`grep 'A temporary password' /usr/local/mysql/log/error.log | awk -F"root@localhost: " '{ print $2}'`
	#echo $defaultmysqlpwd
	#mysqladmin -uroot password 12345678
	PSWD=`cat /root/.mysql_secret | awk -F ':' '{print substr($4,2,16)}'`
	PSWD=` grep -v '^$' /root/.mysql_secret | awk -F ':' '{print substr($4,2,16)}'`
	##PSWD=${PWD:1:16}
	mysql -uroot -e "set password for 'root'@'localhost'=password('system')"
	mysql -uroot -p12345678 <<EOF
#若root的plugin='auth_socket'并不是本地密码，因此需要修改它
SELECT user, plugin FROM mysql.user;
SET GLOBAL validate_password_policy=0;
SET GLOBAL validate_password_mixed_case_count=0;
SET GLOBAL validate_password_number_count=3;
SET GLOBAL validate_password_special_char_count=0;
SET GLOBAL validate_password_length=3;
grant all privileges on *.* to root@'%' identified by '12345678';
UPDATE mysql.user SET authentication_string=PASSWORD('123'), plugin='mysql_native_password' WHERE user='root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@''IDENTIFIED BY 'rootpassword' WITH GRANT OPTION;
flush privileges;
EOF
	mysql -uroot -p12345678
fi



################################ go ###########################################
# if [ $(which go) ]; then
#     echo "go has installed and version is $(go version)"
# else
#     echo "start to install go v1.13"
#     mkdir -p $HOME/cots && cd $HOME/cots
#     wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz
#     tar -zxvf go1.13*
#     rc_file=${rc_root}/go/.go_rc
#     mkdir -p $(dirname $rc_file)
#     cat > "$rc_file" << EOF
# export GOROOT=~/cots/go
# export GOBIN=$GOROOT/bin
# export PATH=$PATH:$GOBIN
# export GOPATH=~/code/go
# EOF
#     source_rc_file "$rc_file" ".go_rc"
#     echo "installing go v1.13 ends"
# fi
################################ java #########################################
################################# npm #########################################
#
#
#
#
#

mysql.conf  有三个地方设置1配置文件2环境变量3命令行指定
[mysql]
user=root
password=111111

>show engines;
>mysqld --chroot 影响LOAD DATA INFILE和SELECT ... INTO OUTFILE
--log[=host_name.log] 日志链接和对文件的查询
--log-bin[=host_name-bin] 更改数据
--log-bin-index[=host_name-bin.index]
--log-error[=host_name.err] 错误及启动消息
--log-isam[=file] 更改myisam记录到该文件
--log-queries-not-using-index
--log-slow-queries[=file]
--log-slow-admin-statements 记录optimize analyze alter到log-slow-query
--long_query_time 默认值10秒

set k=v          默认session
set global k=v
set sesseion k=v