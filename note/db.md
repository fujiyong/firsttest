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

忘记密码
重新启动免授权服务端 mysqld --skip-grant-tables
启动客户端
	mysql -u root -p
	UPDATE mysql.user SET authentication_string=PASSWORD('password') WHERE user='root';
	flush privileges;
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

##  数据库基本操作

- 数据库

  ```
  show databases;
  CREATE DATABASE db_example DEFAULT CHARACTER  SET utf8 COLLATE utf8_croatian_ci;
  use $db_example;
  ```

- 表

  ```
  use $db_example;
  show tables;
  
  CREATE TABLE IF NOT EXISTS sex (
    sex_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '性别id',
    sex_name VARBINARY(10) NOT NULL COMMENT '实际性别'
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;
  
  TRUNCATE TABLE databases_example.user_info;
  DROP TABLE databases_example.user_info;
  
  添加/删除列
  ALTER TABLE databases_example.user_info ADD add_col VARCHAR(20) COMMENT '表添加的列';
  ALTER TABLE databases_example.user_info DROP COLUMN add_col2;
  
  修改列
  ALTER TABLE databases_example.user_info MODIFY COLUMN add_col INT COMMENT '表修改的列';
  ALTER TABLE databases_example.user_info CHANGE COLUMN add_col2 change_col INT COMMENT '修改列名和该列的类型';
  
  添加/删除主键
  ALTER TABLE databases_example.user_info ADD PRIMARY KEY(add_col);
  ALTER TABLE databases_example.user_info DROP PRIMARY KEY;
  
  添加/删除外键
  ALTER TABLE '从表' ADD constraint '外键名称_FK_从表_主表' FOREIGN KEY '从表'('外键字段') REFERENCES '主表'('主键字段');
  ALTER TABLE databases_example.user_info ADD constraint '外键名称_FK_从表_主表' FOREIGN KEY '从表'('外键字段') REFERENCES '主表'('主键字段');
  ALTER TABLE databases_example.user_info DROP FOREIGN KEY '外键名称';
  
  添加/删除默认值
  ALTER TABLE databases_example.user_info ALTER add_col SET DEFAULT 1000;
  ALTER TABLE databases_example.user_info ALTER add_col DROP DEFAULT;
  ```

  

##  授权管理

- 创建用户	CREATE USER '用户名'@'IP地址' IDENTIFIED BY '密码';
- 删除用户    DROP USER '用户名'@'IP地址';
- 修改用户    RENAME USER '用户名'@'IP地址' TO '新用户名'@'新IP地址';
- 修改密码    SET PASSWORD FOR '用户名'@'IP地址' = PASSWORD('新密码');

```
数据存储在mysql库中user表中
https://juejin.im/post/5d8962c06fb9a06afe12d5fc
```



##  存储过程

##  索引

##  慢查询

##  binlog

##  主从

##  集群

#  pg

#  MongoDB

#  Redis

```
https://mp.weixin.qq.com/s/2JcJqhweJOHeKnYmdpR0MQ
```

