#!/bin/bash

set -e

function getOSType() {
    return $(hostnamectl | grep 'Operating' | cut -d: -f 2 | cut -d' ' -f 2 | tr A-Z a-z)
}


function __install_item(name){
    if [[ $(getOSType) == ubuntu ]]; then
        sudo apt install -y $name
    elif [[ $(getOSType) == centos ]]; then
        sudo yum install -y $name
    # elif [[ $(getOSType) == maxos ]]; then
    else
        echo "your os is $(getOSType)"
    fi

    if [ $? -eq 0 ]; then
        echo "install $name ok"
    else
        echo "install $name failed"
    fi

    return $?
}


function install_item(name) {
    if [ $(which name) ]; then
        echo "$name installed"
        return 0
    fi

    __install_item($name)
}

function source_rc_file(name) {
    if [ -f $HOME/.bashrc ] && ! $( grep "$name" $HOME/.bashrc ) ; then
        echo "source $HOME/$name" >> $HOME/.bashrc
        source $HOME/.bashrc
    fi
    if [ -f $HOME/.zshrc ] && ! $( grep "$name" $HOME/.zshrc ) ; then
        echo "source $HOME/$name" >> $HOME/.zshrc    
        source $HOME/.zshrc
    fi
}

function install_compile_tool_chain(){
    if [[ $(getOSType) == ubuntu ]]; then
        sudo apt install -y "build-essential"      #apt search build | grep ess  
    elif [[ $(getOSType) == centos ]]; then
        sudo yum install -y "Development Tools"    #yum grouplist
    # elif [[ $(getOSType) == maxos ]]; then
    fi

    if [ $? -eq 0 ]; then
        echo "install compile_tool_chain ok"
    else
        echo "install compile_tool_chain failed"
    fi

    return $?
}

function install_chinese_man(){
    #https://github.com/man-pages-zh/manpages-zh
    if [[ $(getOSType) == ubuntu ]]; then
        sudo apt install --y manpages-zh
    elif [[ $(getOSType) == centos ]]; then
        sudo yum install -y man-pages-zh-CN 
    # elif [[ $(getOSType) == maxos ]]; then
    fi

    if [ $? -eq 0 ]; then
        echo "install chinese_man ok"
    else
        echo "install chinese_man failed"
    fi

    return $?
}



############################## vi #################################
if [ -f $HOME/.vimrc ]; then
    echo "~/.vimrc exists"
else
    echo "~/.vimrc not exist"
cat >> $HOME/.vimrc << EOF
set nu
set cul
set is
set hls
set syntax on
EOF
fi


############################## color man ###########################
if [ -f $HOME/.mancolor_rc ]; then
    echo "~/.mancolor exist"
else
    echo "~/.mancolor not exist"
cat >> $HOME/.mancolor_rc << EOF
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
export LESS_TERMCAP_ZV=""s
export LESS_TERMCAP_so=$'\E[1m\E[33m\E[44m's
EOF
fi
source_rc_file ".mancolor_rc"



############################ compile tool chain ##################################
install_compile_tool_chain

############################ wget/curl  #########################################
install_item curl 


############################### git ###################################
install_item git
#####git configure


############################### bman ################################
# busybox $cmd --help
#   eg:  buybox top --help

############################### cman  ################################
install_chinese_man
if [ ! $HOME/.cman_rc ]; then
    cat > $HOME/.cman_rc << EOF
alias cman='LANG=zh_CN.uf8 man'
EOF
source_rc_file ".cman_rc"
fi





################################ sman ##################################
# tldr  apt install tldr
#git clone https://github.com/tldr-pages/tldr.git
#https://github.com/raylee/tldr
if [ ! $(which tldr) ]; then
    mkdir -p $HOME/bin
    curl -o $HOME/bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr
    chmod +x $HOME/bin/tldr
cat > $HOME/.tldr_rc << EOF
export PATH=$PATH:~/bin
complete -W "$(tldr 2>/dev/null --list)" tldr
EOF
    source_rc_file ".tldr_rc"
fi



##############################install tmux ############################
install_item "tmux"

if [ -f '$HOME/.tmux.conf.local' ]; then
    echo "oh my tmux installed"
else
    cd $HOME
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    scp .tmux/.tmux.conf.local .
    sed -i 's/mouse off/mouse on/' .tmux.conf.locals
fi


################################ fzf ######################################
# if [ ! `which fzf` ]; then
#     if [ ! `install_item fzf`]; then
#         git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
#         cd $HOME/.fzf && git pull && ./install
#     fi
# fi


################################# ag #######################################
if [ ! `which ag` ]; then
    echo "ag installed"
else
    __install_item silversearcher-ag
fi


################################ color mysqlclient #########################
install_item "mycli"


################################# check shell #############################
install_item "shellcheck"


################################ axel ######################################
install_item "axel"

############################### web browser ###############################
install_item "lynx"
install_item "elinks"


################################ cloc ######################################
install_item "cloc"

################################ git client ################################
install_item "tig"


install_item "multitail"

################################## top #####################################
install_item "htop"
install_item "atop"
install_item "glancess"


############################### redis #####################################




############################### nginx #####################################
install_item "nginx"




############################### mysql ##########################################