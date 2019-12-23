#  mysql

##  安装

```
$apt-get remove mysql-server 
$apt-get autoremove mysql-client
$apt-get remove mysql-common
$apt-get update
$apt-get install mysql

##解除绑定127.0.0.1
$从mysqld --print-defaults可以得知mysqld绑定127.0.0.1
#修改配置文件mysqld.cnf
#bind-address           = 127.0.0.1
bind-address            = 0.0.0.0

##设置root密码
方法一:使用账户debian-sys-maint
$mysql -u debian-sys-maint -p  #用户debian-sys-maint的密码保存在/etc/mysql/debian.cnf
>update mysql.user set authentication_string=password('111111') where user='root'
方法二:直接使用root账户
$mysql -uroot -p  ##提示输入设置密码

##在数据库中修改root权限可以远程登录
$mysql -u root -p
>use mysql;
>select host, user from user;
>update user set host='%' where user = 'root';
>grant all privileges on *.* to 'root'@'%' identified by '111111' with grant option;
>flush privileges;

##防火墙开通3306端口
$ufw status 
$ufw allow 3306
$ufw reload 
$ufw status

$systemctl restart mysql
```

##  帮助

###  Client

```
mysql --help
#读取顺序/etc/my.cnf /etc/mysql/my.cnf ~/.my.cnf
#默认值
```

###  Server

```
# "/etc/mysql/my.cnf" to set global options,
# "~/.my.cnf"         to set user-specific options.

#默认命令行参数
mysqld --print-defaults

#系统变量的含义
http://dev.mysql.com/doc/mysql/en/server-system-variables.html 

mysqld --help             #提示建议使用下面
mysqld --verbose --help

变量
状态变量
```

##  存储过程

##  索引

##  慢查询

##  binlog

##  主从

##  集群

#  pg

#  MongoDB