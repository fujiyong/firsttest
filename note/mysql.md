# 理论

## 架构

```
数据库架构
    share everthing  一般针对单个主机，完全共享CPU MEM IO 并行处理能力最差，
        典型代表是sql server
    share disk 各个处理器有自己的CPU和MEM，共享disk  
               由于是数据共享，可以通过增加节点来提高并行处理能力 扩展较好
        类似于SMP(对称多处理) 但当存储器接口达到饱和时，增加节点并不能提高性能
        典型代表是oracle rac
    share nothing    各个处理器有自己的CPU MEM disk，不存在共享资源
        类似于MPP(大规模并行处理) 各个单元通过协议通讯，并行处理和扩展能力良好。
        各个节点相互独立，各自处理自己的数据，处理后的结果向上汇报并在节点间流转
        典型代表是DB2 DPF和hadoop 
        亦是我们常说的sharding  碎片，分片， 不是share分享

纵向扩展
横向扩展
    MasterSlave
    Clustering(shardEverything|shardDisk架构)  最著名的是Oracle的RAC
        适用于读密集型的应用，如数据仓库和BI
    Sharding(shardingNothing架构)
        分区Partition是库内， sharding是库外，也叫分库分表

mongodb的三大优势
    灵活性 json
    高可用 replica set
    可扩展 sharded cluster  
```



## 三大约束

```
 #3大约束:主键 外键 唯一性
 alter table tbl_name disable keys    #使用alter可以跳过flush tables;
 set foreigin_key_check = 0;  #当往子表中导入数据时，默认会立即执行外键检查，而不是像oracle延时检查
 SET UNIQUE_CHECKS=0;
 alter table tbl_name enable keys;
 set foreign_key_check=1;
 set unique_checks=1;
```

## 外键

```

create table parent(id int not null, 
	                primary key(id)) engine=innodb;
create table  child(id int not null, parent_id int, 
                    index par_ind(parent_id),
                    foreign key(parent_id) reference parent(id)) 
                    [on update {restrict|cascade|set null|no action}]
                    [on delete {restrict|cascade|set null|no action}]
                    engine=innodb;
                    
on parent update|delete, child should do
	cascade:  父表update/delete,子表也update/delete
    set null: 父表update/delete，子表该字段设置为null
    no action:父表update/delete, 
    restrict: 父表update/delete,抛出错误，不允许这样的操作发生。
              #如果定义外键时没有指定on delete或on update,这就是默认值。
```

## 索引

### 来源

```
二分查找(binary search)
    优点：固定长度
    缺点：变长时，需移动大量元素
二叉查找树/二叉排序树(sorted binary tree)  
    缺点： 有可能退化成线性树
平衡树(balance search tree)
AVL(通过树的旋转保证2棵子树最大差为1)
    缺点: 以上都是单纯考虑算法本身的复杂度，没考虑与外部设备之间的读写效率。
          二叉树的每个node都只能保存一条数据(record),并且最多有2个childNode，查找效率有点低。
          因此，可不可以在一个node保存多条数据(data)和多个childNode?
          这一个node保存多条数据和多个childNode就是B-Tree.
B-Tree
    2-3Tree: 每个node保存1,2条数据
    2-3-4tree:每个node保存1,2,3条数据
    优点：实际应用中，会根据page大小来调整n的值，这样一次io读取就能读取n条数据，
         并且树的高度明显减小，减少开销。
    缺点：伸缩性不好。 如果将多条数据保存到一个page中且某个字段太长，则一个page的记录数将受到限制，
                    最坏的情况，一个page只保存一个记录，这样就退化成二叉树。
                    另外，无法修改字段的最大长度，除非调整page大小，重建整个数据库。
B+Tree
    特点：非叶子节点(内节点)不再保存recode,而只保存key，并且所有的叶子结点使用链表连接。
          这样可以方便范围查询，只要找到起始位置，然后按链表查找，一直到结束位置。
          MyISAM:  
                   叶子节点只保存指向recode的指针,所以需要2次读取。（第二次读取也称回表)
                   将独立的数据文件(.MYD)以堆表的形式存储，每条数据都有一个唯一的地址。所以也称堆组织表(HeapOrganizedTable HOT)
                   对PrimaryKey与SecondKey这2中索引存储没有区别。
                   表中的record没有特定的顺序，所有的新行被添加到表尾
                   所以没有clusterIndex。

          InnoDB:  
                    PrimaryKey:  叶子节点保存真实的record,也称索引组织表(IndexOrganizedTable IOT)
                    SecondKey:   辅助索引  类似于myisam， 叶子节点保存的是主键索引值
                    对于插入操作，根据索引找到对应的索引页，然后通过挪动已有的记录来为新数据腾出空间，最后插入数据。
                    如果数据页已满，则调整索引指针（如果还有非ClusterIndex,则还需要更新这些索引指向新的数据页)


ClusterIndex：聚集索引  索引与整行记录数据聚集在一块。
              又被称为主键索引(一级索引)。
              表数据按照索引顺序来存储，也就是说索引项的顺序与表中的物理record的顺序一致。
              叶子节点即存储了真实的record，而不是数据指针，不再需要单独的数据页。
              在一张表中最多只能有一个ClusterIndex，因为真实的数据的物理顺序只有一种。
非ClusterIndex：非聚集索引  索引与整行记录数据不在一起。
             又被称为second index(二级索引 辅助索引)
             表数据存储与索引顺序无关，叶子节点只包含数据行的逻辑指针或主键。 
covering index： 覆盖索引  指通过查询索引就能获取结果而不必通过查询数据表而获取。
              比如index_k1_k2(col1,col2), 执行select k2 from where col=k1;
```

```
索引
    可以只使用某一字段的前几个字节 col(n)  alter table t add index idx_b(b(100))
    主键索引 需要重建表
        添加/删除 先create tmp_t -> import data -> drop old table -> rename tmp_t old_table
    辅助索引 不需要重建table
        添加  先加S锁   （在加锁S期间，只能read)
        删除  将辅助索引的空间标记为不可用 ，并在内部视图上删除该索引的定义即可

isam  indexed sequential access method 索引顺序存取方法
show index from t
    collation    排序(ascending descending null)
    cardinality  基数 势 
        == 索引的唯一的行数   
        如果该值除以表的总行数，越接近1，越接近unique index， 越有可能被使用
        并非每次索引的更新都会引起该值的实时更新，否则代价太大， 因此不太准确 
        强制更新该值,执行命令analyze table $tableName
索引
    选择性
        高选择性：可取值的范围很大， 如unique index的字段
        低选择性：可取值的范围很小， 如性别
    只有在高选择性的列和小的返回结果行数(即总行数的20%)时，mysql才会选择该索引
    强制使用索引
        select 
        into outfile 'a' 
        from t 
        force index($index_name) 
        where 
    查看是否使用除了index外的sort的步骤
        mysql>show variables like 'sort_rows';
        mysql>select * from t order by col1 limit 3;
        mysql>show variables like 'sort_rows';
```

## 事务

```
原子性：  atomicity  
一致性：  consistency 从一个一致性状态转向另外一个一致性状态
隔离性：  isolation   一个事务在提交数据前其他事务是不可见的
持久性：  durability  事务一旦提交就是永久性的

隔离性是通过锁实现，其余都是通过redo/undo实现

Redo 
    innodb_log_buffer_size  
    show engine innodb status中log段
        log sequence number 最新的lsn
        log flushed up to   写入到innodb_log_buffer的最新lsn
        last checkpoint at  写入到redo日志文件(iblog_file0 iblog_file1)的最新lsn

    开始一事务时，产生一个LSN(LogSequenceNumber)日志序列号
    事务执行时，会往InnodbLogBuffer中插入事务日志
    事务提交前，如果事务的运行时长超过1秒，也会有InnodbLogBuffer中的日志刷新到磁盘
    事务提交前一刻，会将InnodbLogBuffer中的日志刷新到磁盘(innodb_flush_log_at_trx_commit=1)
    最后事务提交

    这种先flush log，然后再flush data的方式成为预写日志方式WAL(write-adhead log)

undo
    tableSpace的undo segment
    insert <-> delete
    delete <-> insert
    update <-> update

控制语句
	select @@global.transaction_isolation;
	show variables like '%isolation%';
	show [global|session] variables like '%isolation%';
	set global transaction_isolation='REPEATABLE-READ';
	set [global|session] transaction isolation level 
		{read uncommited | read commited | repeated read | serializable}
		
    begin|start transaction|set autocommit=0
    savepoint $spid;  #release savepoint $spid;
    rollback [to [savepoint] $spid];
    commit [work]
        当completion_type=0(NO CHAIN)时(默认值)， commit work == commit; 
        	表示没有任何操作。
        当completion_type=1(CHAIN)时， commit work == commit and chain; 
        	表示马上开启一个相同隔离级别的事务
        当completion_type=2(Release)时,  commit work == commit and release; 
        	表示提交之后断开与服务器的连接

统计
    com_commit com_rollback 只能统计显式，不能统计隐式如autocommit=1和ddl
    handle_commit handle_rollback


分布式事务
    innodb事务隔离级别必须设置在seriable
    show variables like 'innodb_support_xa' #默认为on
    2P提交方式
        第一阶段Prepare,节点将自己的执行结果汇报给txManager
        第二阶段commit/rollback，txManager通知节点是commit还是rollback
    mysql是在体系架构就支持xa，而不是只有具体的存储引擎层面支持，所以mysql内部不同存储引擎也会使用xa事务。
        begin;
        insert into engine_innodb_t1 select 1;
        insert into engine_ndb_t2    select 2;
        commit;
        
例子
set autocommit=0; #show global VARIABLES like 'autocommit';
start transaction;#开始一项事务会隐式地造成unlock tables;
                #在tx中，如果ddl lock/unlock tables，rename table, truncate table会隐式造成commit
select @A:=sum(salary) from t1 where type=1;
savepoint $spid;
rollback to savepoint $spid;   #release savepoint $spid;
update t2 set summary=@A where type=1;
commit;

xa #与本地非xa(即本地普通的tx)互斥
xa start 'xatest';   #执行完这句时进入active状态
xa end 'xatest';     #执行完这句时进入idle状态
xa prepare 'xatest'; #执行完这句进入prepare状态
xa recover;          #可以打印gtxid
xa commit 'xatest';  #对于prepare状态, 可以xa commit或xa rollback
```



## 锁

```
除bdb页锁和innodb行锁外, 基本都是表锁myisam/memory
表级
	不可能死锁,因为在事务前就已获取锁
	write优先级高于read, 因为更新一般认为比select更重要
页行锁
	因为在sql语句处理时获取锁,而不是事务启动时,所以可能死锁
查看行级锁 show variabeles like '%table%'  tables_locks_waited tables_locks_immediate

建议锁 GET_LOCK()/RELEASE_LOCK()

表
	写lock tables a write, b write;
	读lock tables a read, b read;
行
	写select * from t for update;
	读select * from t in share mode;


row
    读
        快照读SnapshotRead 也是非阻塞读NonblockingRead 或不加锁读
            何为一致性，何为非一致性？ 一致(2次读取到的数据是一样的) 非一致(2次读取到的数据时不一样的)
            RC级别下为非一致性非阻塞读
            RR级别下为一致性非阻塞读ConsistenctNonblockingRead
            select                      
                如果正在读取的行正在delete/update,这时读取操作不需要等待X锁的释放，
                而是去读取undo段的历史数据，也就是该行之前版本的数据
                因为没必要对历史段数据进行修改，所以没必要加锁。
        当前读CurrentRead  也是阻塞读blockingReader 或加锁读LockingRead
            select  Lock in share mode:  加S锁
            select  for update:          加X锁
            必须将2者置于一个tx中，当事务提交了，锁就释放了
    写
        dml(insert/delete/updaet):       当前读,加X锁
表
    ddl(alter table create table)
    lock tables $t1 read/write, $t2 read/write    unlock tables;

配置
    innodb_lock_wait_timeout=50
    innodb_rollback_on_timeout=OFF 超时不回滚 innodb并不会回滚大部分的错误异常，但死锁除外
    
释放锁的途径
    unlock tables $t1;
    在持有表锁的前提下再次lock tables,将会释放之前获取的lock;
    在持有表锁的前提下start transaction/begin,将会释放之前获取的lock;
    session断开
```

## 存储过程

```
存储过程
    在oracle中，是一个事务
    在mysql不是一个事务，只是一些sql的组合； 由于mysql存储过程必须有begin-end，所以开启事务只能begin|start tranaction.

    DROP PROCEDURE IF EXISTS  test_sp1   
    CREATE PROCEDURE test_sp1( )    
        BEGIN    
        DECLARE t_error INTEGER DEFAULT 0;  

        -- 其实一般不在存储过程中处理异常，而是让存储过程抛出异常，让应用处理异常，比如打印异常内容然后执行回滚  
        --  try
        --     con := 
        --     cur = con.cursor()
        --     cur.execute("set autocommit=0;")
        --     cur.execute("call $storeProcedureName")
        --     cur.execute("commit")
        --  except Exception,e:
        --     cur.execute("rollback")
        --

        #DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET t_error=1;  end;
        #declare exit handler for sqlexception begin rollback; select -2; end; #当发生异常时回滚并返回-2  
        
            START TRANSACTION;    
                INSERT INTO test VALUES(NULL, 'test sql 001');       
                INSERT INTO test VALUES('1', 'test sql 002');       
        
            IF t_error = 1 THEN    
                ROLLBACK;    
            ELSE    
                COMMIT;    
            END IF;    
       select t_error;   //返回标识位的结果集；  
    END 
```

## 视图

```
view
    可更新视图updatable view
        create table t(id int);
        CREATE VIEW v_t as select * from t where id < 20;
            insert into v_t select 200; 即使不符合view的数据都可以通过view往t插入数据，但通过view查不到数据
        CREATE VIEW v_t as select * from t where id < 20 with check option;
        insert into v_t select 200; 插入不了数据
    Oracle的物化视图或MSServer的索引视图
        view不是基于基表baseTable的虚表，而是根据虚表实际存在的实表
        预先计算并保存表连接或聚集等耗时较多的操作，这样在执行复杂查询时，就可以快速获取结果。
        Oracle
            创建的方式
                build immediate  创建的时候就生成数据(默认方式)
                build deferenced 根据需要再生成数据
            查询重写query rewrite
                当对物化视图的基表进行查询时，oracle会自动判断是否可以根据物化视图来获取结果。如果可以，则从物化视图获取。
            刷新
                当基表发生了dml操作后，物化视图以何种方式与基表同步。
                刷新时机
                    on demand: 在用户需要的时候
                    on commit: 当对基表commit时
                刷新方式
                    fast: 采用增量刷新，只刷新自上次刷新以后的更改
                    complete:采用全量刷新(清空表，再导入数据)
                    force:oracle在刷新时会去判断采用fast或complete方式，优先选择fast。
                    never: 不进行任何刷新
```



#  基础

## 安装

```
mysql sqlserver oracle(windows)都是单进程多线程 oracle(linux)是多进程

1. 初始化生成密码
方式一 官方推荐方式
mysqld --initialize --user=mysql #会初始化data目录并将password打印到控制台
                          #如果不加console， 会写入日志/var/log/mysqld.err
                          #a temporary password is generated for root@localhost: $passwd
                          # sed -n '/password/p' |  cut -d":" -f2 | tr ' ' ''
方式二
mysql_install_db --user=mysql #会在~/.mysql_secret中存放密码man mysql_install_db得知已过时  
                              #创建data目录 mysql数据库(初始化授权表 访问控制) test数据库
2. 启动
mysqld_safe --user=mysql --defaults-file="my.ini" --init-file="init.txt" --log-warnings=2 &
    --init-file #里面包含可以在mysql客户端执行的命令 
                #如SET PASSWORD FOR 'root'@'localhost' = PASSWORD('MyNewPassword');
    --log-warnings #更多日志


3. 使用初始密码登录 修改密码并可远程登录， 实际就是设置mysql.user表  mysql.host表 mysql.db表
mysql -uroot -p   #host默认为localhost user默认为登录linux的用户
Enter password:   #输入上步的密码
mysql>show databases;
mysql>use mysql;

#方式一 使用环境变量方式 第一个password是环境变量 第二个是函数
mysql>SET PASSWORD FOR 'root'@'%' = password('111111'); 

mysql>CREATE USER 'yy'@'%' IDENTIFIED BY '111111';     #这步只能查看infomation_schema
mysql>ALTER USER "root"@"%" IDENTIFIED WITH auth_plugin BY "111111"; #可以使用默认的加密方法
            #show plugins;可以得知2种密码加密方式mysql_native_password和sha256_password
            #show variables like '%default%';得知5.7默认是mysql_native_password;8.0是caching_sha2_password
			#mysql8.0需要修改为以前的加密方式，否则一般的gui client由于不支持新的默认加密方式而无法登录
			#	default_authentication_plugin=mysql_native_password


mysql>insert into mysql.user(host,user,authentication_string) values('%','root',password('111111'));
mysql>UPDATE mysql.user SET authentication_string = password('111111') where user='root';
	  #5.6及以前是password字段, 5.7及以后是authentication_string字段
	  #plugin是密码的加密方式 authentication_string是密码加密后的字符串

#方式三 这种更方便
mysqladmin -u root -h host_name password "111111"       

#方式四 适用于8.0之前，8.0之后创建账户create user和授权grant必须分开
mysql>GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '111111' WITH GRANT OPTION;   #一气呵成  创建用户 远程访问 设置权限
                          #host的通配符为%或_ %表示任意ip都可以登录，默认是localhost 
                          #	  root@192.168.1.2/255.255.255.0 只能局域网内访问
                          #   root@192.168.1.%
                          #   root@%.loc.gov
                          #on $db.$table TO $user@$host  db和table的通配符为*
                          #全局权限是在mysql.user设置,某个具体数据库的权限是在mysql.db表
                          
mysql>show grants for yy;   
mysql>show grants for yy@%;
mysql>flush privileges;   #与mysqladmin flush-privileges; 或 mysqladmin reload;效果相同 否则mysql服务需要重启
```

## 卸载

```
官方方法
    apt remove mysql-server
    apt autoremove
    dpkg -l | grep mysql | grep ii
试验过的方法
    apt purge mysql-server
    apt purge mysql-server-5.7
    updatedb 
    locate mysql

任何时候出现错误都可以删掉数据目录的所有文件，重新再来  
	rm -rf /var/lib/mysql/*
	chown -R mysql:mysql /var/lib/mysql
```

## 启动停止帮助

```
service mysql status;
service mysql restart;

systemctl list-unit-files;
systemctl status mysql;
systemctl restart mysql;

mysql>system ls -l *  #执行bash命令
>help;   #最后提示
>status; #查看server db client connection字符集  slow-query数
#下面的都可以通过delphi编写的heidisql的帮助(F1)查看
#>help contents;
#>help show;
#>help set;
#>help alter {database|table}
#>help {create|drop} {database|table|index}
#>help select insert delete update replace truncate
#>help {do|handler|load data infile}
#>help use $dbName;
#>help desc $tableName;
#>help explain
```

## 查看

```
用户
    select user();             #root@113.109.21.208
	select current_user();     #root@%
版本
	select version();
存储引擎
    show engines;
    show engine $engineName {status | mutex}
连接
	select connection_id();
数据库
    select database();
    show databases;
    show create database $dbName;
    use $dbName
    drop database $dbName;
表
    select * from information_schema.tables;
    show tables [from $dbName] [like ''];

    show create table $tableName;
    desc $tableName
    show table status [from $dbName] [like ''];
索引
	show index from $tableName;
存储过程/函数
    select * from information_schema.routines;
    select name from mysql.proc where db=$dbName and type='procedure|function';
    show procedure status [from $dbName] [like $proName];
    show function  status [from $dbName] [like $funcName]; 

    show create procedure $proName;
    show create function $funcName;
触发器
    select * from information_schema.triggers;
    show triggers [from $dbName] [like ''];

    show create trigger $trigName;
视图
    select * from information_schema.views;
    
    show create view $viewName;
```



## 配置文件

```
/etc/mysql/mysql.conf.d/
/var/lib/mysql/
/var/lib/mysql/data/  #show variables like '%datadir%';
/var/log/mysql/
/var/run/mysqld   
	mysqld.pid     #show variables like '%pid%';
	mysqld.sock    #show variables like '%sock%';
	mysqld.sock.lock

locate mysqld.cnf
locate mysql.cnf 
locate my.cnf

验证配置文件的有效性
    mysqld --verbose --help
    
美化my.cnf
perl -ne ‘m/^([^#][^\s=]+)\s*(=.*|)/ && printf(“%-35s%s\n”, $1, $2)’ /etc/mysql/my.cnf 

windows下是my.ini  
linux下是my.cnf  /etc/mysql/mysql.conf.d/mysqld.cnf  
         mysqld --verbose --help | grep defaults-file
mysql.cnf是mysql各应用的集中配置的地方

#query_cache5.7可以手动设置 8.0彻底不用设置了
    #query_cache_size=0
    #query_cache_type=0
#innodb_undo_logs在8.0中彻底不能设置，默认开启且为2个undo,但不能指定回滚段大小默认为128
#innodb_undo_logs

[client]
host=        #对应环境变量MYSQL_HOST
user=        #对应环境变量USER
password=    #对应环境变量MYSQL_PWD
default-character-set=utf8
[mysql]
default-character-set=utf8
[mysqld]   #选项组
basedir=
datadir=
bind-addr=0.0.0.0  #不能是127.0.0.1
port=3306
server_id=1
character-set-server=utf8
#skip-grant-tables  #忘记密码时使用
default_authentication_plugin=mysql_native_password #默认的密码加密方式是caching_sha2_password，但很多gui客户端不支持默认加密方式，所以不能登录
explicit_defaults_for_timestamp = true
time_zone=system    #使用linux操作系统的时区   SELECT @@global.time_zone, @@session.time_zone;
[mysqldump]
```

## 日志

### 设置日志参数

```
mysql>flush logs;
mysqladmin flush-logs;
mysqladmin refresh;

错误日志
    log-error[=$hostname.err]  #show variables like '%log_error%';
    log_error_verbosity=3;     #mysqld --verbose --help | grep -A 5 log-error
    
通用日志
    general_log=ON                   #show VARIABLES like '%general_log%';
    general_log_file=[$hostname.log] #mysqld --verbose --help | grep -A 5 general_log
    
慢查日志  mysqldumpslow -s al -n 10 mysql-slow.log
    slow_query_log=ON                #show VARIABLES like '%slow%';
    log-output[=FILE|Table]          #若为table则输出到Mysql.slow_log csv格式表中  
    log-slow-queries[=$hostname-slow.log]  #
    long_query_time=10               #测试mysql>sleep(15); select * from mysql.slow_log
    log_queries_not_using_indexes=1  #使用mysqld --log-short-format避免记录不适用index的query
    log_slow_admin_statements=0      #默认alter optimize analyze table不记录, 因为这样的语句很耗时
    log_slow_slave_statements=0
    
bin日志  
	#mysqlbinlog  -v mysql-bin.000001  
	#若binlog格式为statment则可mysqlbinlog 
	#若binlog格式为row则可mysqlbinlog -v  -vv(字段数据类型)
    server-id       = 1        #启动binlog必须设置该项  否则启动不了mysqld!!!!
    log_bin=ON  #show VARIABLES like '%bin%'; mysqld --verbose --help | grep -A 5 log-bin
    log_bin_basename[=/dataPath/bin.$hostName]     #文件名后缀会被忽略
    log_bin_index[=/dataPath/bin.$hostName.index]  #包含所有binlog文件名。 
                            #删除所有二进制日志
                            #mysql>reset master;      
                            #只删除部分二进制日志
                            #   mysql>purge master logs TO $logName ;                     
                            #   mysql>purge master los before ''2003-04-02 22:46:26';
    max_binlog_size[=100M]  #但也必须确保一个tx写入同一个文件
    expire_logs_days=10     #
    binlog_format=ROW       #statement  5.1以前的只有这个 但now() rand()  uuid()
                            #mixed
                            #row        造成数据量的增加
    binlog_cache_size=
         #show global status like binlog_cache_use        使用缓冲的次数
         #show global status like binlog_cache_disk_use   当内存不够使，使用disk当内存缓冲的次数
    sync_binlog=1   #每写几次内存缓冲就写入日志 默认值为0 
                    #1为每写一次内存缓冲就同步到日志，不使用操作系统的缓冲
    innodb_support_xa=1     #解决了innodb在崩溃时由于写入binlog但并没有commit的情况
    log_slave_updates=1     #Master-slave-slave
    
    #show VARIABLES like 'innodb%log%'
    innodb_log_buffer_size=16M
    innodb_flush_log_at_trx_commit=[0|1|2]  #0每秒 1commit 2os
    innodb_log_file_size=48M
    innodb_log_files_in_group=2
    innodb_log_group_home_dir=./
    
    
    http://blog.itpub.net/31452896/viewspace-2137379/
              binlog     innodblog(redoLog)   
    enginge   all        innodb
    来源                  1 先将这个事物的lsn(log sequence number)写到
                           innodb_log_buffer(redo log buffer)，
                         2 再通过innodb_flush_log_at_trx_commit写入
                           ib_logfile0 ib_logfile1这2个redo log
                           (这步叫write-ahead logging) 
                         3 最后将data通过读取innodb_buf_pool内存中的数据写入磁盘的物理数据页
                           (这步叫write)
    内容      一个tx      page的修改(spaceid pageNo OpCode Data)
    时间      tx提交前    tx过程中不断写
```

### bin日志

```
格式
	statement-based replication(SBR)  基于sql语句
		只记录修改节约IO
		准确性查,不能now() UUID()
	row-based replication(RBR)        基于行
		记录记录每个字段变化前后的值,准确性强
		文件大,耗磁盘与带宽
	mixed-based replication           混合模式
		文件大小适中
		有可能主从不一致
存在形式
	   .index 记录所有的binlog名，以便跟踪日志循环
	bin.log
命令
	查看是否开启 
		show variables like '%log_bin%';  
		select @@log_bin;
	查看状态
		binlog_cache_size
		binlog_cache_use
		binlog_cache_disk_use
	刷新
		flush logs;
```

#### master

```
set
    set sql_log_bin={0|1}; #启用或禁用log
show
    show master logs;   #列出所有的logs文件名及大小  #master与binary是同义词
    show master status; #列出正在使用的log及其位置
    show binlog events [in '$log-name'] [from $pos] [limit [offset,] row_count]
    show slave hosts;
purge
    purge {master|binary} logs to 'mysql-bin.010';  #清除日志到这个文件但这个文件不清除
    perge {master|binary} logs before '2003-04-02 22:46:26'; #清除日志到这个时间点
reset
    reset master; #删除索引文件中的所有二进制日志，将二进制索引文件置空，并创建一个新的二进制文件
```

#### slave

```
change #保存到master.info 和 relay_log.info中
    change master to
        master_host='$hostName'  #主机名或ip地址
        master_port='$port'
        master_user='$userName'
        master_password='$password'
        master_log_file='$master_log_name'
        master_log_pos=$master_log_pos
        relay_log_file='$relay_log_name'
        relay_log_pos=$relay_log_pos
        master_ssl={0|1}
        master_ssl_ca='$ca_file_name'
        master_ssl_capath='$ca_dir_name'
        master_ssl_cert='$cert_file_name'
        master_ssl_key='$key_file_name'
        master_ssl_ciper='ciper_list'
    #change默认会删除所有relay log并启动一个新的log，除非制定了relay_log_file或relay_log_pos，
    #      在此种情况下，relaylog被保持且全局变量relay_log_purge设置为0。
    #若change语句中出现master_host或master_port时，则mysql则假定
    #      原来的master_log_file和master_log_pos不再有效；
    #      若没有提供，则假定master_log_file=和master_log_pos=4
    #若master_log_file和master_log_pos只指定了其中一个，
    #      则不能指定relay_log_file或relay_log_pos
    #若master_log_file和master_log_pos都没有指定，
    #      则使用在发布change指定前的最后一个slave sql thread的数值

reset
    reset slave;  #忘记其在主服务器二进制中的复制位置(删除文件master.info和relay-log.info) 
                  #并删除原有的中继日志 并开始一个新的中继日志
                  
master_pos_wait
    select master_pos_wait('$log_file_name',$log_file_pos) #执行函数，用于确认slave到达指定位置

set
    set global sql_slave_skip_count=$n;  #前提条件: slave_sql_thread没有在运行  
                                         #一般用于发生错误时跳过n条sql语句 
show
   show slave status; #显示slave_io_runing  yes 判定slave是否连接上master还是只是在running
                      # slave_sql_running  yes
                      # slave_io_status 即show processlist中status字段
                      # last_error:  当出现错误时，关注此字段
                      # skip_counter: 即sql_slave_skip_count
                      # master_host master_port master_user
                      # master_log_file master_log_pos relay_log_file relay_log_pos
                      # seconds_behind_master 当为Null时表示slave未能感知master 0表示没有时间差
                      !!!!关注seconds_behind_master字段, 这是salve的sql线程分析relaylog得到的,当前要执行的sql与master执行这条sql时相差的时间.
                      !!!!show processlist中的sql线程time字段为 从master复制而来的最后一次事件/最后一条sql与slave现在的时间差, 从这个地方可以看出master最后一次发送binlog的时间

start  
    start slave $threadType UNIT
    IO_THREAD   MASTER_LOG_FILE = 'log_name', MASTER_LOG_POS = log_pos
    SQL_THREAD  RELAY_LOG_FILE = 'log_name', RELAY_LOG_POS = log_pos

stop
    stop slave [io_thread|sql_thread]
```

#### 清除

```
清理log的步骤
master                                 slave
                                       #正在读取哪个日志
                                       show slave status; 
#获取master上所有日志
show master logs;
#从所有的slave判断哪个是最早log,以这个日志为目标log
#删除比这个最早log更早的log
purge {master|binary} logs to 'mysql-bin.010'
perge {master|binary} logs before '2003-04-02 22:46:26';
```



##  类型

### bit

```
CREATE TABLE t (b BIT(8));INSERT INTO t SET b = b'11111111';
```

###  字符串

```
BLOB  binary large object  memcpy
TEXT                       strcpy
```

###  数值

```
M 显示宽度
用于显示宽度小于指定的列宽度的值时从左侧填满宽度
一般结合zerofill使用可以显式的查看占用宽度情况
显示宽度并不限制可以在列内保存的值的范围，也不限制超过列的指定宽度的值的显示。
M的最大值为255，根据具体的类型M会适当变化
整数
    tinyint(M)   [UNSIGNED] [ZEROFILL]	1     255
    smallint(M)  [UNSIGNED] [ZEROFILL]	2  65,535
    mediumint(M) [UNSIGNED] [ZEROFILL]	3  16,777,215                   8位千万
    int(M)       [UNSIGNED] [ZEROFILL]	4   4,294,967,295               10位42亿
    integer(M)                                                          #与int是同义词
    bigint(M)    [UNSIGNED] [ZEROFILL]	8  18,446,744,073,709,551,615   20位
小数
	精度: 不包括+-.在内的其他所有位数和
	标度：小数点后面的位数
	
	浮点数
        单精度	FLOAT(M,D)  [unsigned] [zerofill] M表示总位数,D表示小数点后面的位数 精确到7位数
        双精度	DOUBLE(M,D) [unsigned] [zerofill] M表示总位数,D表示小数点后面的位数 精确到15位数

		REAL默认为double的同义词，除非设定了选项REAL_AS_FLOAT
		FLOAT(p) [UNSIGNED] [ZEROFILL]  若精度p属于[0,24]则表示单精度;
		                                若精度p属于[25,53]则表示双精度浮点数
	定点数  以字符串形式存储
		DECIMAL[(M[,D])] [UNSIGNED] [ZEROFILL] #M的最大值65 D的最大值为30 
		                                       #M的默认值为0 D的默认值为10
        DEC[(M[,D])]     [UNSIGNED] [ZEROFILL]
        NUMERIC[(M[,D])] [UNSIGNED] [ZEROFILL]
        FIXED[(M[,D])]   [UNSIGNED] [ZEROFILL]
```

###  时间日期

```
curdate()      curtime() 
current_date() current_time() current_timestamp()  from_unixtime() #本地时区
utc_date()     utc_time()     utc_timestamp()
	
date
    curdate() current_date() current_date
    adddate(date, interval expr type)
    adddate(expr, days)
    date_add()
    date(exp)
    datediff(exp1,exp2)
time
    curtime() current_time() current_time
    addtime(exp1,exp2)
timestamp
	current_timestamp() current_timestamp now()
	localtime() localtime
	localtimestamp() localtimestamp
tz
	convert_tz(dt,from_tz,to_tz)  #时区时间转换

		date_format(exp, fmt)
datetime <-> timestamp
	from_unixtime(875996580)
	unix_timestamp() unix_timestamp('1997-10-04 22:23:00')  #默认值为now() 875996580
	
#current_timestamp current_timestamp() now()等价 
create table t (ts timestamp)  #等价于下面这句 默认值为now()并自动更新
create table t (ts timestamp default current_timestamp on update current_timestamp)
create table t (ts timestamp default current_timestamp)    #默认值为now()但不自动更新
create table t (ts timestamp on update current_timestamp)  #默认值为0并自动更新
```

### enum/set

```
enum 最多65536个成员，序数从1,2,3开始，只能是其中的一个
	 如果你想要确定一个ENUM列的所有可能的值，使用
	 SHOW COLUMNS FROM tbl_name LIKE enum_col，并解析输出中第2列的ENUM定义
	 
set  最多64个成员， 序数从1,2,4,8开始，可能是其中的一部分set('one','two'，'three') 
	有以下(''，'one','two','three','one,two','one,three','two,three','one,two,three')
	      (0,  1,    2,    4,      1+2,       1+4,       2+4,        1+2+4)
     SELECT * FROM tbl_name WHERE FIND_IN_SET('value',set_col)>0; #包含value
     SELECT * FROM tbl_name WHERE set_col LIKE '%value%';
     SELECT * FROM tbl_name WHERE set_col & 1;    #寻找包含第1个set成员的值
     SELECT * FROM tbl_name WHERE set_col = 'val1,val2'; #不同于‘val2,val1'
	 如果想要为SET列确定所有可能的值，使用
	 SHOW COLUMNS FROM tbl_name LIKE set_col并解析输出中第2列的SET定义。
	 
	select now()+0;  
	select $enumColumn+0 from t order by concat($enumColumn) #按照column中定义的字母顺序排序
```

### 类型转换函数

```
cast(expr AS type) 类型转换 binary(N) char(N) signed unsigned date time datetime
convert(expr, type) 
convert(expr using transcoding_name) 字符串的字符集转换
```

## 变量

```
变量
	系统变量
		set 必须明确
			global
				set @@global.$var
				set global $var
			session/local
				set @@session.$var
				set session $var
				set $var
		get
			global
				select @@global.$var
				select global $var
				show   @@global.$var
				show   global variables like $var
			session/local
				select @@session.$var
				select session $var
				show   @@session.$var
				show   session variables like $var

        当set全局变量时必须显式使用global关键字但查询时不需要的原因是防止将来出问题
		SELECT @@var_name  优先返回session global
		show   variables   返回session
	用户变量
		set  未被初始化的变量值为NULL，类型为字符串
			set @useVar1=1, @userVar2:=2  #set语句既可以使用=也可以使用:=
			select @userVar:=1             #非set语句只能使用:=, 因为非set中=作为一个比较操作符
		get
			select @userVar1, @userVar2

    小结： 全局变量一定要global  用户变量一定要@
    
show variables [like '%a%'];
set [session|global] $variableName=$value;  #global表示全局的，默认是session级别。
show status    [like '%a%'];
```



# SQL

## 连接

```
t1           [inner|cross] join t2
t1                straight_join t2
t1 left           [outer]  join t2
t1 right          [outer]  join t2
t1 natural [left  [outer]] join t2
t1 natural [right [outer]] join t2

from t1, t2, t3 等价于 from t1 cross join t2 cross t3
在标准sql中inner join和cross是不同的，但在mysql中从语法上市等同的。
inner join与on同时使用

union [all | distinct]  #默认distinct
```

## 预处理

```
预处理语句mysql_stmt_prepare()
    prepare $stateName from $sqlStatement
    execute $stateName using @userVar1, @userVar2;
    deallocate|drop prepare $stateName
```



```
3种注释  #  --   /* */

where 语句中不能使用列别名，因为在运行where的时候还没有确定列别名，只有到了返回group by  having时才可以使用别名过滤


快速建表
	create table $tableName1 
	select * from $tableName2 limit 0
快速插入
	insert [into] myt1 [(col,col2,...,coln)] 
	select * from myt2 
	[on duplicate key update col1=1, col2=values(col1)]
        #on duplicate key update col1=col2+col3                    #使用旧表旧值
        #on duplicate key update col1=values(col1) + values(col2)  #使用sql语句中新值
导入数据
	LOAD DATA 
	LOCAL INFILE '/path/pet.txt' 
	INTO TABLE pet 
	FIELDS TERMINATED BY '\t' 
	OPTIONALLY ENCLOSED BY '"' 
	ESCAPED BY '\\' 
	LINES TERMINATED BY '\r\n'; 
导出数据
    select 
    into outfile $outFileName
    from $t


select count(*) from t            #计算行数,包括null
select count($colName) from t     #计算行数,不包括null
select count(distinct col) from t #不包括null 
last_insert_id()返回的插入的第一条记录的值即使一条sql插入多条记录。
default(col_name) 返回列的默认值

在not null其实可以插入0或"", 因为0或“” is NOT NULL
group by NULL;  2个NULL视为相同
order by $field asc; NULL排在最前，即NULL最小

模式匹配
标准SQL like '_'表示单个字符 '%'表示任意长度的字符串(包括0个字符)
MySQL  vi sed grep  一般情况下(除^$外)，只要子匹配即可
	REGEXP|RLIKE  NOT REGEXP|RLIKE    #类似于like not like

mysql>select LAST_INSERT_ID();  #session级别的 亦可以使用CAPI mysql_insert_id()
insert into $t values ($rowA) [,($rowB) ...] 

mysql>ALTER TABLE tbl AUTO_INCREMENT = 100; #设auto列的初始值
mysql>SELECT @min_price:=MIN(price),@max_price:=MAX(price) FROM shop;
mysql>SELECT * FROM shop WHERE price=@min_price OR price=@max_price;
```

## 导入导出数据

```
调整参数key_buffer_size bulk_insert_buffer_size
mysql -t   #批模式下一般比较精简，为得到如交互模式格式的输出
mysql -vvv #回显在批模式下所执行的语句

mysql -h -p -u -P < a.sql   
mysql>source /root/a.sql      #为了显示进度， 可以在文件中插入 select 'progress1' AS ' ';
mysql>\.     /root/a.sql

mysql>
   #3大约束:主键 外键 唯一性
   alter table tbl_name disable keys    #使用alter可以跳过flush tables;
   set foreigin_key_check = 0;  #当往子表中导入数据时，默认会立即执行外键检查，而不是像oracle延时检查
   SET UNIQUE_CHECKS=0;
   set autocommit = 0;
   LOAD DATA LOCAL INFILE '/path/pet.txt'
       INTO TABLE pet 
       FIELDS TERMINATED BY '\t'
       OPTIONALLY 
       ENCLOSED BY '"' 
       ESCAPED BY '\\' 
       LINES TERMINATED BY '\r\n';
   alter table tbl_name enable keys;
   set foreign_key_check=1;
   set unique_checks=1;
   set autocommit=1;
                                #local可以装在client端文件(运行mysqlcli的客户端),否则只能装在server端文件(运行mysqld的服务器)
                                #local当是绝对路径时 当是相对路径时，是相对于启动客户端的路径来说
                                #当不是local时另说 所以最好使用绝对路径  
                                #默认从show variable like '%load%';加载数据文件,所以一般用绝对路径
mysql>lock tables a write; \             #只锁定部分表
       insert into a values (), (), ()  \
       insert into a values (), (), ()  \
       unlock tables;                    #释放这个session所有获取的lock
msyql>begin; \           #对于事务表
       insert into a values (), (), ()  \
       insert into a values (), (), ()  \
      commit;
mysql>lock tables real_t write, temp_t write; \
       insert into real_t select * from temp_t; \
       truncate table temp_t; \
       unlock tables;
mysql>select * from  pet into outfile '/path/pet.txt'  TERMINATED BY '\t' \
            OPTIONALLY ENCLOSED BY '"' ESCAPED BY '\\' LINES TERMINATED BY '\r\n'
```

# 存储引擎

```
     myisam   innodb
外键  no       yes
索引 BTree    BTree
              hash
     full
锁   table    row
事务  no      yes

select count(*) fron myisam_t #不能有where语句,直接读内存计数器
为什么innodb不保存行数?
因为是事务特性,同一时刻表中的行数对不同的事务而言是不一样的.
在where中使用别名是不允许的 因为当where执行时列值还没有确定
```

## myisam

```
对于myisam，如果加表锁lock tables $t read; 默认即是加read lock，自身这个session不能访问未被自身session锁定的表。其他session不能写被别的session锁定的表。
```

## innodb

```
insert buffer 插入缓冲
double write  双写
adaptive hash index 自适应hash索引
read ahead    预读

特性
    row lock
    tx
    外键
    类似于oracle的非锁定读

线程
    select thread_id, name, processlist_id from performance_schema.threads;
    
内存
  innodb_buffer_pool_size #show engine innodb status;的BUFFER POOL AND MEMORY查看使用情况
                            # Buffer pool size: 已分配的buf大小， 单位为page = 16K
                            # Free buffers    : 未使用的buf大小
                            # modified db pages: 脏页
      data dict           数据字典
      datapage            数据页 即表的行记录数据
      indexpage           索引页 即表的index
      adaptive hash idnex 自适应hash索引
      lock info           锁信息
      insert buffer       插入缓冲  提高性能，多次写入合并为一次写入 
                            合并insertbuffer中的辅助索引到buffer_pool中
      double write        双写      提高安全性                     将page写合并为1M写
        show global status like 'innodb_dblwr%';
         Innodb_dblwr_pages_written/Innodb_dblwr_writes=1M/16K=64 如果此值远小于64，则写无压力
    innodb_log_buffer_size(redo log buffer) #写入ib_logfile0 ib_logfile1这2个redo log

record
    2个隐藏列
        6字节的最后一个插入、删除、更新事务的txid  
        7字节的rollback指针指向undo记录undoPtr
    1个rowid
        若表未定义primaryKey,则自动产生一个6字节的rowID  //6字节的类似于next域将连续记录连在一起
    flag
        delete_flag
        min_rec_flag
        n_owned
        heap_no
        record_type
        next_recorder
index
    clustered index
        唯一且升序插入，所以二分查找
        候选
            primaryKey
            第一个仅有非null列的unique索引
            自动产生一个6字节的recordID
    secondKey
        不唯一，所以随机磁盘IO读取


    auto-rehash 自适用hash
        如果使用hash查找的方式优于B+时，innodb会使用auto-rehash方式，毕竟hash查找的复杂度为O(1)
        所以有mysqld --no-auto-rehash项

表  innodb_file_per_table
    tablespace
        segment 段
            extend  区(64页=1M)  在启动innodb_file_per_table之后，创建的表默认大小为96K,
                                可见表的初始大小在extend与page之间
                page(block) 页（16K）
                    row(txid fields rollbackPointer)
```



# 复制MS

## 各种框架

```
优点
	高可用   故障检测及迁移 多节点备份
	可伸缩性 新增节点方便扩容
	负载均衡
缺点
	网络分裂 由于网络故障分成多个部分，每部分节点之内可以互联，部分之间不能
	脑裂
	
单主
多主
	虽然是先到先得，但事务冲突的几率也高。
```

#### 原厂出品

```
mysql replication
		特点
			一主多从
		优点
		缺点
			主从时间滞后，数据滞后，可能造成数据不一致
			主节点crash，不能对外提供服务
mysql fabric
		特点
			一主多从
			增加了故障检测及转移，自动数据分片
		优点
			由于有转移，可以选择一个从节点来做主节点，不影响对外提供服务
		缺点
			事务及查询只支持在同一个分片内，事务中更新的数据不能跨分片，查询语句返回的数据也不能跨分片
			节点故障恢复30秒或更长（采用InnoDB存储引擎的都这样）
mysql cluster
		特点
			多主多从
			多主 没有单点故障，故障恢复小于1秒
			可伸缩性优秀 能自动切分数据，方便数据库的水平拓展
			负载均衡优秀 看同时用于切分读写密集型应用，也可以使用sql或非sql接口访问数据
			高可用 数据自动切分，即使是同一张表，数据都存储在多个物理节点datanode
		缺点
			只能是用ndb引擎，与innodb有许多明显的差距。比如事务只支持RC 外键的支持
			节点间需要大量的通讯，对带宽要求高 所有的访问都需要经过一个节点(至少一个sql节点和ndb节点)才能完成
			datanode数据会被尽量存放于内存中 对内存要求大 而且重启的时候 将数据load到内存需要很长时间
```

#### 第三方优化

```
MMM(master-master management google出品)双主多从
    优点
        双主failover3秒以内切换
        多个读从节点负载均衡
    缺点
        无法保证数据一致性 如M1crash M2由于还没有完全同步M1的数据而被切换成主对外提供服务
        使用VIP浮动技术，类似于keepalived，
        所以虚ip(vip)需要和真实ip(rip)在同一网段内，
        	如果不在同一网段内，需要用到虚拟路由技术。
        	但绝对要在一个IDC机房，不可跨IDC机房
MHA(master high availability 日本DeNA公司youshimaton开发)
    特点
        多主节点，但缺少vip(虚拟ip)，需要配合keepalived等一起使用
        类似于多套mysql replication
    优点
        可进行故障的自动检测和转移
        具备自动数据补偿能力，在主库异常crash时能最大程度的保证数据的一致性
Galera cluster(由codeship开发)
	特点
			都是主节点，也都是从节点
			主节点互为其他节点的从节点
			不同于mysql原生的主从异步复制，gelera采用多主同步复制，并针对同步复制过程中，
				会大概率出现的事务冲突和死锁进行优化，而是基于gelera复制插件，重写了wsrep api
	优点
		多主多活下 对任何一个节点进行读写操作，就算某个节点挂了，也不需要其他节点的读写，也不需要故障转移切换
			      也不会中断整个集群对外提供服务
		拓展性    新增节点会自动拉取在线节点的数据（当有新节点加入时，集群会选择衣蛾donor node为新数据提供数据
			     最终急群众所有数据一致，而不需要手动备份
	劣势
		为了数据的强一致性，也是以牺牲性能为代价的
```

#### 借助硬件

```
不同主机的数据同步不再依赖mysql的原生复制功能，而是通过同步磁盘数据来保证数据的一致性
故障处理是借助headbeat来监控和管理各个节点之间的网络连接，当节点出现故障或不可用时，自动在其他节点启动集群服务

heartbeat + SAN
    SAN storage area network
    优点
        SAN 共享存储，保证数据的一致性
    缺点
        SAN价格较贵
heartbeat + drdb
    drdb distributed replicated block device
         这是linux内核实现块级别的同步复制技术。通过各主机之间的网络，复制对方磁盘的内容。
    优点
        相比于san，价格低廉
        保证数据的强一致性
        与mysql解耦，不会由于mysql的逻辑错误发生数据不一致的情况
    缺点
        对io性能影响较大
        从库不提供读
```

#### 其他

```
zk+proxy
paxos
```

```
不复制table的存储引擎类别 以便在不同的存储引擎间复制; 为提高速度,salve一般使用myisam来代替innodb和bdb
双主复制  只是减少了锁竞争  
```

## 传统

### 搭建

#### 1配置

#### Master

```
#binlog binlog.index

gtid_mode=ON
enforce-gtid-consistency=ON

server-id=$ip$port (1-2^32-1)
sql_log_bin=1     #是否允许写入binlog 
logs_bin=mysql-bin #定义文件

sync_binlog=1     #定义写入文件的频率  

innodb_flush_log_at_trx_commit=1

slave_skip_errors=1 #跳过错误 继续复制

binlog_do_db=mydb1      #必须写入binlog的db
binlog_do_db=mydb2
binlog_ignore_db=mydb3  #必须忽略写入binlog的db
binlog_ignore_db=mydb4

binlog_format=mixed
expire_log_days=7
max_binlog_size=100m
binlog_cache_size=4M
max_binlog_cache_size=512M

auto_increment_offset=1
auto_increment_increment=1  
#innodb只会创建文件 不会创建目录 所以如果需要创建目录，只能手动
```

#### Slave

```
#relaylog relaylog.index master.info relay-log.info

server-id=$ip$port (1-2^32-1)
logs_bin=mysql-bin #定义文件
logs_slave-update=1 #当这个slave又作为其他slave的master时，否则不会给更新的记录写入到binlog
master-connect-retry[=60] #从服务器若失去连接隔多长时间去重试

replicate-do-db=mydb1     #必须复制的数据库     
replicate-do-db=mydb1     #必须复制的数据库
replicate-ignore-db=mydb3
replicate-ignore-db=mydb4
replicate-ignore-table=mydb1.mytabl1

max-relay-logs-size=size
```

#### 2设置账号并授权

```
mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'192.168.0.%' IDENTIFIED BY 'repl';
```

#### 3主全量备份

```
方式一：
mysql>flush tables with read lock;
tar czvf 数据文件或目录
mysql>show master status;
mysql>unlock tables;

方式二：#mysqldump效率较低 相对于拷贝文件
mysqldump -S /tmp/mysql3306.sock -p --master-data=2 --single-transaction -A |gzip >3306-`date +%F`.tar.gz
```

#### 4从复制

```
mysqld                                                                             
	--skip-slave-start 不立即连接master, 即以后start slave
    --log-warnings     默认启动  记录更多信息
    
mysql>reset master;  #清除GTID_EXECUTED值

还原数据
gunzip < 3306-2019-10-13.sql.gz | mysql -S /tmp/mysql3306.sock -p
mysql>CHANGE MASTER TO
       MASTER_HOST='192.168.0.106',
       MASTER_PORT=3306,
       MASTER_USER='repl',
       MASTER_PASSWORD='repl',
       MASTER_AUTO_POSITION=1;  #使用GTID模式
       master_log_file=
       master_log_pos=
mysql>start slave;
mysql>show slave status;  #!!!!!Slave_IO_Running: Yes   Slave_SQL_Running: Yes
                          #seconds_behind_master
```

### 强制同步

```
Master				             Slave
mysql>flush tables with read lock;
mysql>show master status;
	  #此时master只读,等待slave
	                             mysql>select master_pos_wait('binlog_file', binlog_pos);
	                     #执行这条sql会阻塞直到slave达到指定的file和pos,此时master/slave同步,返回
mysql>unlock tables;	                     
```

### 出现问题

```
 slave
 	mysql>stop slave;
 	mysql>reset master;
 master
 	mysql>reset master
 slave
 	mysql>reset slave;
 	mysql>start slave;

 	mysql>SET GLOBAL SQL_slave_SKIP_COUNTER = n; 
#当next为AUTO_INCREMENT或LAST_INSERT_ID()的语句使用值2的原因是它们从主服务器的二进制日志中取两个事件
#当是其他时为1

 	mysql>start slave;
```

### 主从切换

```
在每个slave上,先
    mysql>stop io_thread; 不再复制
    循环执行mysql>show processlist; 直到status为has read all relay log
在被选举为master的slave上
    mysql>stop slave;
    mysql>reset master;
在未被选为master的slave上
    mysql>stop slave;
    mysql>change master to master_host="" master_port= master_user= master_password=;               #file使用默认值(第一个bin'log), pos使用默认值(4)
    msyql>start slave;
```

## MGR

```
mysql group replication(MGR2016.12)
	参考mariaDB Galera Cluster和Percona XtraDB cluster，
	是建立在paxos的xcom之上，每个数据库节点都维护一个状态机，事务的提交需经半数以上节点同意才可提交
	保证节点间事务的一致性。
	
	同一个group最多为9个节点。
	服务器配置最好一致，因为和pxc一样，会有木桶短板效应
	

优点
    高一致性C 
        基于原生复制和paxos协议的组复制
    高容错性  
        有自动检测机制， 当出现宕机时，会自动剔除问题节点，其他节点可以正常使用
        当不同节点争用资源冲突时，会按照先到先得处理，并内置自动化脑裂防护机制
    高扩展性 
        可随时在线添加和移除节点，会自动同步所有节点上的状态，直到新节点和其他节点保持一致，自动维护新的组信息
    高灵活性
        直接以插件形式(.so)形式安装 
        单主模式下，只有主库可以读写，其他从库会加上super_read_only状态，只能读取不可写入， 出现故障会自动选主
        多主模式下

理论局限性
	不支持非事务引擎
	不允许一个sql同时更新一个事务引擎和非事务引擎
	不支持create table ... select，在主库执行直接报错。 可以手动修改为create table && insert ... select ... 
	不支持create temporary table 和 drop temporary table
	
实际缺点
	不稳定，性能略差于pxc  对网络要求很高，至少是同机房
	
	
主从异步0  默认
	一般模式下，是主从异步，即主不管从的任何状态，如果从有漏了主也不管，这就是我们所说的主从不一致的根本原因。
主从半同步1 mysql5.5 一开半同步插件
	一个事务在主库执行完不行，还必须至少在一个从库执行成功，事务才算完成；而其他还没有执行的从库则执行异步操作。
	客户端提交sql给master
	master自身执行sql
	master提交sql给所有slave并等待其中任何一个返回成功
	master返回给client
主从完全同步all 依靠集群软件，如pxc
	一个事务不仅在主库执行成功，还必须在所有从库执行成功，事务才算完成。
	
	只有一台从库的主从半同步也是概念上的主从完全同步。
	性能上说： 主从异步 > 主从半同步 > 主从完全同步
	
基本参数
    #主开启了gtid模式,从也必须开启该模式
    #5.6的新功能,不能在线修改; 
    #5.7.6可以在线修改,不停机切换gtid方法
    #在线修改经历传统事务-匿名事务-gtid事务，其中匿名事务既接受传统事务，也接受gtid业务，2者可以共存，但复制效率比2者都低
    gtid_mode=on
    enforce_gtid_consistency=1
    binlog_format=row  #最好是row格式
```

### 安装插件

#### 安装半同步插件

```
一般mysql并没有预装该插件，但自带了。所以只需手动加载
	mysql>show plugins;                     #查看插件没有安装
	mysql>show variables like 'plugin_dir'; #查看插件位置
	mysql>system ll $plugin_dir | grep 'semisync_(master|slave).so' 
主库
    安装
    mysql>install plugin rpl_semi_sync_master soname 'semisync_master.so'
    mysql>show plugins like 'semisync_master'; #确定安装成功
    启动
    mysql>set global rpl_semi_sync_master_enabled = on;

从库
    安装
    mysql>install plugin rpl_semi_sync_slave  soname 'semisync_slave.so'
    mysql>show plugins like 'semisync_slave'; #确定安装成功
    启动
    mysql>set global rpl_semi_sync_slave_enabled = on;
    msyql>stop slave io_thread; #重启iothread，否则还是异步复制数据
    mysql>start slave io_thread;
```

#### 安装group replication

```
mysql>show plugins;
mysql>show variables like 'group%'; #查看参数没有加载
mysql>show variables like 'plugin_dir';
mysql>system ll $plugin_dir | grep group_replication
mysql>install plugin group_replication soname 'group_replication.so';
mysql>show variables like 'group%';
```

### 全新

#### 配置

```
#必须
gtid_mode=on
enforce_gtid_consistency=on

#公共
server_id=$ip$version
binlog_format=row     #MGR强制要求row
binlog_checksum=NONE  #binlog校验规则5.6版本之前是NONE，5.6之后是CRC32， 但MGR要求NONE
log_slave_update=1    #集群在故障时会相互检查binlog，
                      #所以需要记录集群内其他服务器发过来已经执行的binlog，按gtid来区分是否执行过
transaction_isolation=read-commited #MGR使用乐观锁，GMR建议RC，减少锁粒度
master_info_reposity=table          #基于安全考虑，MGR强制要求
relay_log_info_repository=table     #基于安全考虑，MGR强制要求

#独有
transaction_write_set_extraction=xxhash64 #记录事务的算法，MGR建议使用该参数
loose_group_replication_group_name=`uuidgen` #用来区分内网各个不同的group，而且也是这个group内的gtid值的uuid
loose_group_replication_ip_whitelist='127.0.0.1/8,192.168.1.0/24' #安全需要白名单，不许外部主机的连接
loose_group_replication_start_on_boot=off #是否随服务启动而启动组复制，不建议，
                #1.以防故障恢复时扰乱数据的准确性
                #2.以防影响一些添加或删除节点的操作
loose_group_replication_local_address='$ip:33061' #本地MGR的ip和端口
loose_group_replication_group_seeds='$myip:33061,$ip2:33061,$ip3:33061'#接受本MGR控制的MGR地址
loose_group_replication_bootstrap_group=off #开启引导模式，添加组成员。一个group内只需一台引导服务器
                                            #默认off。如果有需要，再set global来开启
loose-group_replication_single_primary_mode=off #是否启动单主模式
                 #如果启动，则本实例是主库，提供读写;其他实例仅提供读
                 #如果off，则是多主模式
loose-group_replication_enforce_update_everywhere_checks=on
    #多主模式下，强制检查每一个实例是否允许该操作；如果不是，不存在多主操作的可能，可以关闭
```

#### 启动

```
主库必须先启动,随时观察err日志
mysql>set global group_replication_bootstrap_group=on; #一个group只能有一个引导库，且这个引导库必须是主库
                                                       #主库必须要有这步操作，从库不能有
mysql>create user 'sroot'@'%' identified by '111111'
mysql>grant replication slaveon *.* to 'sroot'@'%' with grant option;
mysql>reset master; #删除所以gtid
mysql>change master to #创建同步认证规则信息，与一般的主从规则写法不一样
      master_user='sroot' master_password='111111' for channel 'group_replication_recovery';
mysql>start group_replication; #启动MGR
mysql>select * from performance_schema.replication_group_members;
      channel_name:group_replication_applier
         member_id: a29a1b91-4908-11e8-848b-08002778eea7
       member_host: ubuntu
       member_port: 3308
      member_state: online   #表示成功连接；如果错误，会被踢出集群且显示error
       member_role: primary  #单主只有一个primary，其余为secondary；多主可以多个primary
    member_version: 8.0.11
mysql>set global group_replication_bootstrap_group=off; #这是可以关闭引导



从库
mysql>create user 'sroot'@'%' identified by '111111';
mysql>grant replication slaveon *.* to 'sroot'@'%' with grant option;
mysql>reset master; #删除所以gtid
mysql>change master to #创建同步认证规则信息，与一般的主从规则写法不一样
      master_user='sroot' master_password='111111' for channel 'group_replication_recovery';
mysql>start group_replication; #启动MGR
mysql>select * from performance_schema.replication_group_members;
```

#### 管理

```
主
mysql>show master status;
      File:mysql-bin.000003
      Position:4801
      Binlog_Do_DB:
      Binlog_Ignore_DB:
      Executed_Gtid_Set:`uuidgen`:1-23:000003
mysql>select * from performance_schema.replication_group_status;
			*************************** 1. row ***************************
                              CHANNEL_NAME: group_replication_applier
                                   VIEW_ID: 15258529121778212:5
                                 MEMBER_ID: a29a1b91-4908-11e8-848b-08002778eea7
               COUNT_TRANSACTIONS_IN_QUEUE: 0
                COUNT_TRANSACTIONS_CHECKED: 9
                  COUNT_CONFLICTS_DETECTED: 0
        COUNT_TRANSACTIONS_ROWS_VALIDATING: 0
        TRANSACTIONS_COMMITTED_ALL_MEMBERS: cc5e2627-2285-451f-86e6-0be21581539f:1-23:1000003
            LAST_CONFLICT_FREE_TRANSACTION: cc5e2627-2285-451f-86e6-0be21581539f:23
COUNT_TRANSACTIONS_REMOTE_IN_APPLIER_QUEUE: 0
         COUNT_TRANSACTIONS_REMOTE_APPLIED: 3
         COUNT_TRANSACTIONS_LOCAL_PROPOSED: 9
         COUNT_TRANSACTIONS_LOCAL_ROLLBACK: 0
*************************** 2. row ***************************
                              CHANNEL_NAME: group_replication_applier
                                   VIEW_ID: 15258529121778212:5
                                 MEMBER_ID: af892b6e-49ca-11e8-9c9e-080027b04376
               COUNT_TRANSACTIONS_IN_QUEUE: 0
                COUNT_TRANSACTIONS_CHECKED: 9
                  COUNT_CONFLICTS_DETECTED: 0
        COUNT_TRANSACTIONS_ROWS_VALIDATING: 0
        TRANSACTIONS_COMMITTED_ALL_MEMBERS: cc5e2627-2285-451f-86e6-0be21581539f:1-23:1000003
            LAST_CONFLICT_FREE_TRANSACTION: cc5e2627-2285-451f-86e6-0be21581539f:23
COUNT_TRANSACTIONS_REMOTE_IN_APPLIER_QUEUE: 0
         COUNT_TRANSACTIONS_REMOTE_APPLIED: 10
         COUNT_TRANSACTIONS_LOCAL_PROPOSED: 0
         COUNT_TRANSACTIONS_LOCAL_ROLLBACK: 0
         
mysql>select * from performance_schema.replication_connection_status; #查看server中各个通道channel的使用情况
    *************************** 1. row ***************************
                                      CHANNEL_NAME: group_replication_applier
                                        GROUP_NAME: cc5e2627-2285-451f-86e6-0be21581539f
                                       SOURCE_UUID: cc5e2627-2285-451f-86e6-0be21581539f
                                         THREAD_ID: NULL
                                     SERVICE_STATE: ON
                         COUNT_RECEIVED_HEARTBEATS: 0
                          LAST_HEARTBEAT_TIMESTAMP: 0000-00-00 00:00:00.000000
                          RECEIVED_TRANSACTION_SET: cc5e2627-2285-451f-86e6-0be21581539f:1-23:1000003
                                 LAST_ERROR_NUMBER: 0
                                LAST_ERROR_MESSAGE: 
                              LAST_ERROR_TIMESTAMP: 0000-00-00 00:00:00.000000
                           LAST_QUEUED_TRANSACTION: cc5e2627-2285-451f-86e6-0be21581539f:23
 LAST_QUEUED_TRANSACTION_ORIGINAL_COMMIT_TIMESTAMP: 2018-05-09 16:38:08.035692
LAST_QUEUED_TRANSACTION_IMMEDIATE_COMMIT_TIMESTAMP: 0000-00-00 00:00:00.000000
     LAST_QUEUED_TRANSACTION_START_QUEUE_TIMESTAMP: 2018-05-09 16:38:08.031639
       LAST_QUEUED_TRANSACTION_END_QUEUE_TIMESTAMP: 2018-05-09 16:38:08.031753
                              QUEUEING_TRANSACTION: 
    QUEUEING_TRANSACTION_ORIGINAL_COMMIT_TIMESTAMP: 0000-00-00 00:00:00.000000
   QUEUEING_TRANSACTION_IMMEDIATE_COMMIT_TIMESTAMP: 0000-00-00 00:00:00.000000
        QUEUEING_TRANSACTION_START_QUEUE_TIMESTAMP: 0000-00-00 00:00:00.000000
	mysql>select * from performance_schema.replication_applier_status; #检查通道channel是否启用
		              channel_name: group_replication_applier
		            service_status: on
		           remaining_delay: null
		count_transactions_retries: 0
mysql>select * from performance_schema.global_status where variabl_name='group_replication_primary_member'
mysql>show global variables like 'server_uuid';
mysql>show global variables like 'super_read_only'; #查看是否是从库
```

### 在线

```
#开启GTID语法限制警报参数
#观察err log是否有不满足要求的sql出现。如果有发现任何warning，需要通知应用进行调整相关sql，直到不出现warning为止。
set global ENFORCE_GTID_CONSISTENCY = WARN;
#确保没有警报了,也就是说当前这个实例没有语法上的冲突,那就可以完全开启语法限制了,这个时候如果有限制的语句进来,会有报错给对方
set global ENFORCE_GTID_CONSISTENCY = ON;
#开启匿名事务模式记录binlog,slave可以兼容GTID事务和普通pos事务,不过这个时候还没有GTID事务,需要确保所有主从都执行
set global GTID_MODE = OFF_PERMISSIVE;
#开启产生GTID事务,这时Slave即接受不带GTID的事务,也接受带GTID的事务,需要确保所有主从都执行
set global GTID_MODE = ON_PERMISSIVE;
###以下命令属于检测命令,按指示操作
#查看匿名事务执行情况,必须所有主从都为零才能执行下一步,不然就会丢掉一部分事务
SHOW STATUS LIKE 'ONGOING_ANONYMOUS_TRANSACTION_COUNT';
#也可以在每一台slave上都执行下列命令,查看Executed_Gtid_Set是否有值,如果不为空了,说明已经开始使用GTID复制了.
#也就是匿名事务全部执行完毕,一切复制都走向了GTID模式,一般来说你也能看到ONGOING_ANONYMOUS_TRANSACTION_COUNT值为零了
show slave status\G
#等待所有的从库都复制完成,延迟相差不太大,再做一次flush logs,将前面的日志purge掉这些日志包含带GTID和不带GTID的事务.
flush logs

#然后就是在所有主从实例上执行下面命令,完全开启GTID复制模式.
set global GTID_MODE = ON;
set global enforce_gtid_consistency = on;

#最后在从库执行以下语句,把复制模式也切换成GTID模式,那就完成了
stop slave;
CHANGE MASTER TO MASTER_AUTO_POSITION = 1;
START SLAVE;

###在从库可以选择性开启，主库加不加都不影响使用
#用来配置从服务器的更新是否写入二进制日志,如果有层级从库就必须开,没有的话建议关闭,能有效提高性能
log_slave_updates
#设置从库SQL线程并行重放events(事务)的worker线程数量,默认值为0，最大值为1024.在5.6.x版本中设置这个参数大于0时，
#则SQL线程充当worker线程的协调者，在多个worker线程之间分发基于库级别的events,也就是库级别并行复制，
#5.7.x版本的并行复制可以设置基于组提交事务的并行复制,更加好用.
slave_parallel_workers = 8
#5.7新参数，指定并行复制方式，为了兼容5.6的模式，默认的并行复制方式是基于库级别的，即默认值是：DATABASE，
#我们要设置成5.7支持的基于组提交事务的并行复制方式，则需要设置成：LOGICAL_CLOCK，速度更快。
#slave_parallel_type = LOGICAL_CLOCK

#当然,别忘了在my.cnf配置文件里加上参数,不然重启就失效了
gtid_mode = on
enforce_gtid_consistency = on


5.7新增功能
 	rpl_semi_sync_master_wait_point = AFTER_SYNC
    	控制主库在返回给回话事务成功之前提交事务的方式。
    	旧模式是AFTER_COMMIT，新模式是AFTER_SYNC，默认值是AFTER_SYNC(这种更好).
    	在AFTER_SYNC模式下，所有的客户端在同一时刻查看已经提交的数据。假如主库crash，所有主库上的已经提交的事务会同步到slave
    	并记录到relay log。此时切换从库，可以保证最小的数据损失。
    rpl_semi_sync_master_wait_for_slave_count=${slaveNumbers}
        半同步参数，默认是1。 若这个参数为从库数量，则效果等价于全同步
    rpl_semi_sync_master_wait_no_slave=[0|1]
    	如果rpl_semi_sync_master_wait_for_slave_count为${slaveNumbers},但实际上少于该值，则取决于该值
    	如果为0，立即变成异步复制
    	如果为1，等待直至超时
    rpl_semi_sync_master_timeout=
    	该值应该小于连接池的连接时间，否则一直抛出异常
    	
主从之版本不一致导致 由于主库表的更改导致从库报错，所以从库最好忽略这些库或表的语句
	#5.6及之前只能通过配置文件
	replicate_wild_do_table=test.%,mysql.user
	replicate_wild_ignore_table=mysql.%,test.fucking
	#5.7及以后
	change replication filter replicate_wild_do_table=(''test.%',''mysql.user');
	change replication filter replicate_wild_ignore_table=(''test.%',''mysql.user');
```

### 查看

#### 半同步

```
主库
mysql>show variabels like '%rpl';
    +------------------------------------+----------+
    | Variable_name                      | Value    |
    +------------------------------------+----------+
    | rpl_semi_sync_master_enabled       | ON       |  #是否开启
    | rpl_semi_sync_master_timeout       | 10000    |
    | rpl_semi_sync_master_trace_level   | 32       |
    | rpl_semi_sync_master_wait_no_slave | ON       |
    | rpl_semi_sync_slave_enabled        | OFF      |
    | rpl_semi_sync_slave_trace_level    | 32       |
    | rpl_stop_slave_timeout             | 31536000 |
    +------------------------------------+----------+
        rpl_semi_sync_master_timeout       超时
            master等待slave的响应时间，单位是毫秒，默认值是10秒。
            超过这个时间，slave无响应，将自动转换成异步；如果探测slave恢复，又转成semi
        rpl_semi_sync_master_trace_level   监控登记
            1  genneral  记录时间函数失效
            16 detail    
            32 new wait  包含网络等待
            64 function  包含函数进入退出
        rpl_semi_sync_master_wait_no_slave
            是否允许master在每个事物提交后都等待slave的receipt信号
            默认是on 如果slave down之后，当slave重新追上master的lig日志时，可以自动的切换为semi
            如果是off 如果slavedown之后，当slave追上之后也不会切换为semi
mysql>show status like'%rpl_semi_sysnc%';
    +--------------------------------------------+---------+
    | Variable_name                              | Value   |
    +--------------------------------------------+---------+
    | Rpl_semi_sync_master_clients               | 1       | #slave的数量
    | Rpl_semi_sync_master_net_avg_wait_time     | 746     |
    | Rpl_semi_sync_master_net_wait_time         | 3788497 |
    | Rpl_semi_sync_master_net_waits             | 5077    |
    | Rpl_semi_sync_master_no_times              | 0       |
    | Rpl_semi_sync_master_no_tx                 | 0       |  #发送给slave失败数量，最好为0
    | Rpl_semi_sync_master_status                | ON      |  #是否启动semi(可能网络超时导致切换成异步)
    | Rpl_semi_sync_master_timefunc_failures     | 0       |
    | Rpl_semi_sync_master_tx_avg_wait_time      | 614     |
    | Rpl_semi_sync_master_tx_wait_time          | 2797020 |
    | Rpl_semi_sync_master_tx_waits              | 4552    |
    | Rpl_semi_sync_master_wait_pos_backtraverse | 0       |
    | Rpl_semi_sync_master_wait_sessions         | 0       |
    | Rpl_semi_sync_master_yes_tx                | 5077    |  #发送给slave成功数量
    | Rpl_semi_sync_slave_status                 | OFF     |
    +--------------------------------------------+---------+
    

从库
mysql>show variables like '%rpl%';
    +------------------------------------+----------+
    | Variable_name                      | Value    |
    +------------------------------------+----------+
    | rpl_semi_sync_master_enabled       | OFF      |
    | rpl_semi_sync_master_timeout       | 10000    |
    | rpl_semi_sync_master_trace_level   | 32       |  #默认32
    | rpl_semi_sync_master_wait_no_slave | ON       |
    | rpl_semi_sync_slave_enabled        | ON       |  #是否开启
    | rpl_semi_sync_slave_trace_level    | 32       |
    | rpl_stop_slave_timeout             | 31536000 |
    +------------------------------------+----------+
        rpl_stop_slave_timeout 控制stop slave的时间
            在重放一个大的事务时，如果突然执行stop slave命令会执行很久，这个时候可能产生死锁或阻塞
            这个参数可以控制stop slave的时间
mysql>show status like'%rpl_semi_sysnc%';
    +--------------------------------------------+-------+
    | Variable_name                              | Value |
    +--------------------------------------------+-------+
    | Rpl_semi_sync_master_clients               | 0     |
    | Rpl_semi_sync_master_net_avg_wait_time     | 0     |
    | Rpl_semi_sync_master_net_wait_time         | 0     |
    | Rpl_semi_sync_master_net_waits             | 0     |
    | Rpl_semi_sync_master_no_times              | 0     |
    | Rpl_semi_sync_master_no_tx                 | 0     |
    | Rpl_semi_sync_master_status                | OFF   |
    | Rpl_semi_sync_master_timefunc_failures     | 0     |
    | Rpl_semi_sync_master_tx_avg_wait_time      | 0     |
    | Rpl_semi_sync_master_tx_wait_time          | 0     |
    | Rpl_semi_sync_master_tx_waits              | 0     |
    | Rpl_semi_sync_master_wait_pos_backtraverse | 0     |
    | Rpl_semi_sync_master_wait_sessions         | 0     |
    | Rpl_semi_sync_master_yes_tx                | 0     |
    | Rpl_semi_sync_slave_status                 | ON    | #证明连接上
    +--------------------------------------------+-------+
```

## 状态详解

### Master

```
master (show processlist中Command: Binlog Dump)

Sending binlog event to slave  
线程已经从二进制日志读取了一个事件并且正将它发送到从服务器

Finished reading one binlog; switching to next binlog  
线程已经读完二进制日志文件并且正打开下一个要发送到从服务器的日志文件

Has sent all binlog to slave; waiting for binlog to be updated 
线程已经从二进制日志读取所有主要的更新并已经发送到了从服务器。
线程现在正空闲，等待由主服务器上新的更新导致的出现在二进制日志中的新事件

Waiting to finalize termination 线程停止时发生的一个很简单的状态
```

### Slave::iothread

```
io thread (show processlist中command: connect)

Connecting to master     
线程正试图连接主服务器

Checking master version  
建立同主服务器之间的连接后立即临时出现的状态

Registering slave on master 
建立同主服务器之间的连接后立即临时出现的状态

Requesting binlog dump  
建立同主服务器之间的连接后立即临时出现的状态。
线程向主服务器发送一条请求，索取从请求的二进制日志文件名和位置开始的二进制日志的内容

Waiting to reconnect after a failed binlog dump request 
如果二进制日志转储请求失败(由于没有连接)，线程进入睡眠状态，然后定期尝试重新连接。
可以使用--master-connect-retry选项指定重试之间的间隔

Reconnecting after a failed binlog dump request 
线程正尝试重新连接主服务器

Waiting for master to send event 
线程已经连接上主服务器，正等待二进制日志事件到达。
如果主服务器正空闲，会持续较长的时间。
如果等待持续slave_read_timeout秒，则发生超时。
此时，线程认为连接被中断并企图重新连接

Queueing master event to the relay log 
线程已经读取一个事件，正将它复制到中继日志供SQL线程来处理

Waiting to reconnect after a failed master event read 
读取时(由于没有连接)出现错误。线程企图重新连接前将睡眠master-connect-retry秒

Reconnecting after a failed master event read  
线程正尝试重新连接主服务器。当连接重新建立后，状态变为Waiting for master to send event

Waiting for the slave SQL thread to free enough relay log space 
正使用一个非零relay_log_space_limit值，中继日志已经增长到其组合大小超过该值。
I/O线程正等待直到SQL线程处理中继日志内容并删除部分中继日志文件来释放足够的空间

Waiting for slave mutex on exit 线程停止时发生的一个很简单的状态
```

### slave::sqlthread

```
sql thread (show processlist中command: connect)

Reading event from the relay log  
线程已经从中继日志读取一个事件，可以对事件进行处理了

Has read all relay log; waiting for the slave I/O thread to update it 
线程已经处理了中继日志文件中的所有事件，现在正等待I/O线程将新事件写入中继日志

Waiting for slave mutex on exit 
线程停止时发生的一个很简单的状态
```

# 命令

```
--silent 沉默模式. 只有在错误时才输出.
--verbose 冗长模式. 写过程及结果.

mysqld --verbose --help 可以查看加载配置文件的顺序及默认值 
mysqld --print-defaults 最后提示查看运行的mysqld的变量可以使用mysqladmin variables 

mysql --help 可以查看加载配置文件的顺序及默认值 
mysql --print-defaults

mysqld和mysql使用同一个配置文件my.cnf
```

## mysql

```
mysql -s -N -e "select user,host from mysql.user;"
    -s --silent  以\t分割
    -N           no header
    -q --quick   不是缓存所有的结果后才输出,而是找到一行就输出一行. 如果输出被挂起,服务器会慢下来.使用该选项,mysql不使用历史文件
    -r --raw     列的值不进行转义
       --show-warinings
       --reconnect
       --tee=a.tee 将输出添加到文件
    -t --table   以table形式
    -v --verbose 打印sql语句
    -E --vertical 等价于\G
    -e  "$sql_statement"
    --auto-rehash  自动完成  以前是关闭的 现在是开的
    --tee=a.log    记录日志
    
mysql -uroot -p -N -e " select * from user where user='root'; "
--disable-column-names --skip-column-names --column-names=0
--enable-column-names  --column-names      --column-names=1

--silent 沉默模式. 只有在错误时才输出.
--verbose 冗长模式. 写过程及结果.
ln -s /dev/null $HOME/.mysql_history #一般来说,在mysql中执行的命令都会.mysql_history中保存
```

## mysqld

```
mysqld --skip-networking #禁止tcp/ip连接
mysqld --key_buffer_size=32M --verbose --help  #立即查看更改效果
```

## mysqladmin

```
mysqladmin -uroot -p111111 
	create|drop $databaseName
	variables | status | exteneded-status
	processlist 
	kill $pid
	shutdown
	password  '$newPassword'
	start-slave|stop-slave 
    execute
    
mysqladmin processlist status
```

## mysqlbinlog

```
mysqlbinlog -j $pos $file1.[0-9]* $f2.[0-9]* | head
	--read-from-remote-server 
	--host 
	--port 
	--user 
	--password 
	--protocol{TCP/SOCKET/PIPE|MEMORY} 
	--socket
	
	--database=   -d  #只显示某数据库
    --force-read  -f  #读取不能识别的二进制日志文件 打印警告并继续， 否则立即停止
    --offset      -o  #跳过n条sql
    --short-form  -s  #只显示sql语句
    --start-datetime="2004-12-25 11:25:56" 或timestamp #相对于运行mysqlbinlog的机器的本地时区
	--stop-datetime=""
	--start-position=
	--stop-position=
	--to-last-log -t 到当前这个binlog不停止，而是继续直至最后一个binlog的结尾。 如果在ms，就无限循环
	
不能如下，防止f1中提供的ctx由于session中断而导致f2不能顺利进行,如f1中create temporary table
	mysqlbinlog f1 | mysql
	mysqlbinlog f2 | mysql
可以 
	mysqlbinlog f1 > f.sql
	mysqlbinlog f2 >> f.sql
	mysql -e "source ./f.sql"
	
	
mysqlbinlog -v -vv mysqld-bin.01 | more #at是起始位置 end_log_pos是结束位置  [at end_log_pos)
	/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
	/*!40019 SET @@session.max_insert_delayed_threads=0*/;
	/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
	DELIMITER /*!*/;
	# at 180   ##############################################################################################################起始点#####
	#180410 17:57:32 server id 1  end_log_pos 496     Query    thread_id=89    exec_time=0    error_code=0
	use `employees`/*!*/;
	SET TIMESTAMP=1523354252/*!*/;
	INSERT INTO `departments` VALUES 
	('d001','Marketing'),
	('d002','Finance'),
	/*!*/;
```

## mysqldump

```
mysqldump
    --single-transaction              #dumping all tables in a single transaction
    --fields-terminated-by=name 
    --fields-enclosed-by=name 
    --fields-optionally-enclosed-by=name 
    --fields-escaped-by=name
    
mysqldump -d mydb    > mydb.sql  #导出数据库mydb所有表的定义 -d,--no-data no row information
mysqldump -d mydb --ignore-table=mydb.myt > mydb.sql #导出数据库mydb所有表的定义,但不包括表mydb.myt
mysqldump -d mydb myt > myt.sql   #导出数据库表mydb.myt的定义
mysqldump    mydb     > mydb.sql  #导出数据库mydb所有表的定义和数据

mysqldump -uroot --single-transaction --master-data --where='id<10' $db $table > a.sql; 
cat a.sql
lock tables $table write;
#一些ddl dml
unlock tables; 
```

## mysqlimport

```
mysqlimport   #Load data infile 命令行版
    --fields-terminated-by=name 
    --fields-enclosed-by=name 
    --fields-optionally-enclosed-by=name 
    --fields-escaped-by=name 
    --compress -C  #在client与server之间进行压缩
    --delete -D  #导入文本文件前清空表
    --force -f   #忽略错误
    --ignore-lines=n #忽略前几行
    --lock-tables -l #锁定所有表，这样保证所有表在服务器上都保持同步
    --silent -s      #只有错误时才输出
    --ignore -i      #当存在重复的唯一键时，跳过
    --replace -r     #当存在重复的唯一键时，替换  如果不指定-i/-r则判断为错误并忽略文本的剩余部分
```

## explain

```
id                  查询序号

select_type
    simple          简单select,不使用uniion或subquery
    primary         最外面的select
    union           union中的第二个或后面的select
    dependent union union中的第二个或后面的select
    union result    union的结果
    subquery        子查询中的第一个select
    dependent subquery 子查询中的第一个select,取决于外面的查询
    derived         导出表的select(from子句的子查询)
    table           输出的行所引用的表
    partition
    
type 联结类型,从优到此排序
    system          表仅有一行(系统表),这是const联结类型的特列
    const           表最多有一个匹配行,它将在查询开始使被读取.
        因为仅有一行,在这行的数据可被优化器剩余部分认为是常熟.
        const表很快,因为之读取一次.
        用于常数值比较primaryKey或unique索引的所有部分时
        select * from t where pk=1;
        select * from t where pk_part1=1 and pk_part2=2;
    eq_ref   对于每个来自前面的表的行组合,从该表中读取一行.
             这可能是除了const外最好的情形.
             它用在一个索引的所有部分被联结使用并且链接是unique或pk
             可用于使用=操作符比较的带索引的列.比较值可以为常量或一个使用在该表前面所读取的表的列的表达式
             select * from ref_t, other_t 
             where ref_t.key_column = other_t.column;
             select * from ref_t, other_t 
             where ref_t.key_column_part1 = other_t.column and ref_t.key_column_part2=2;
    ref  对于每个来自于前面的表的行组合，所有有匹配索引值的行将从这张表中读取
         如果联接只使用键的最左边的前缀，或如果键不是UNIQUE或PRIMARY KEY
         （换句话说，如果联接不能基于关键字选择单个行的话），则使用ref
         如果使用的键仅仅匹配少量行，该联接类型是不错的
         ref可以用于使用=或<=>操作符的带索引的列
         select * from ref_t where key_column=expr;
         select * from ref_t, other_t where ref_t.key_column = other_t.column;
         select * from ref_t, other_t 
         	where ref_t.key_column_part1 = other_t.column and ref_t.key_column_part2=2;
    ref_or_null 该联接类型如同ref，但是添加了MySQL可以专门搜索包含NULL值的行。
    			在解决子查询中经常使用该联接类型的优化
                select * from ref_t where key_column=expr or key_column is null;
    index_merge 该链接类型使用了索引合并优化
                key列包含了使用的索引的清单,key_len包含了使用的索引的最长的关键元素
    unique_subquery 该类型替换了下面形式的IN子查询的ref
                        v  in (select pk from t where some_exp) 
    index_subquery  类似于unique_subquery. 只适用于子查询的非唯一索引
                        v  in (select k_column from t where some_exp)  
    range      只检索给定范围的行，使用一个索引来选择行。key列显示使用了哪个索引。
               key_len包含所使用索引的最长关键元素。在该类型中ref列为NULL。
                当使用=、<>、>、>=、<、<=、IS NULL、<=>、BETWEEN或者IN操作符，
                用常量比较关键字列时，可以使用range
                    select * from t where k=10;
                    select * from t where k between 10 and 20;
                    select * from t where k in (10,20,30)
                    select * from t where k_part1=1 and k_part2 in (10,20,30)
    index
    all        对每个来自先前表的行的组合,进行完整的表扫描
        
possible_keys       可以使用哪个索引. 如果该列为NULL,则没有相关的索引.
    
key                 实际使用的哪个索引. 如果该列为NULL,则没有相关的索引.
                    可以强制使用force index, use index, 或 ignore index.
                        
key_len             实际使用的键的长度. 如果key为null,则长度为null.
                    通过key_len可以确定实际使用一个多字段为index的哪些部分
ref                 显示选择使用其他表的哪些列或常数与key
rows                显示执行query时必须检查的行数
filtered            显示结果返回多少行
extra               详细信息
    distinct        发现一行后停止扫描
    not exists 
    range checked for each record
    using filesort   order by
    using index
    using temporary  需要创建临时表来容纳结果,如查询包含可以按不同情况出列的group by和order by
    using where
    using sort_union(), using union(), using intersect()
    using index for group_by
```

## profile

```
set profiling = 1;
select * from mysql.user;
show profile;
set profiling = 0;
```

## 杀死进程

```
mysqladmin processlist; mysqladmin kill
show processlist
select * from information_schema.processlist;   #show processlist;
select thread_id, name, processlist_id from performance_schema.threads;

mysql>select concat('KILL ',id,';') from information_schema.processlist where user='root' into outfile '/tmp/a.txt';
mysql>source /tmp/a.txt;
mysqladmin -uroot -p processlist|awk -F "|" '{if($3 == "Mike")print $2}'|xargs -n 1 mysqladmin -uroot -p kill
for id in `mysqladmin processlist|grep -i locked|awk '{print $1}'`;do
    mysqladmin kill ${id}
done

使用工具Maatkit提供的命令
mk-kill -busy-time 60 -kill
mk-kill -busy-time 60 -print
mk-kill -busy-time 60 -print –kill

kill connection $tid;  #这个连接被kill
kill query      $tid;  #这个语句的执行被kill但仍然保持连接
```

## show

```
有可能你在mysql>show variables like 'performance_schema_max_socket_classes';
但mysqld --verbose --help | grep -A performance-schema-max-socket-classes, 下划线变成中划线

mysql -s -e  "show variables" | column -t
show variables like '%character%';  #character_set_client 
                                    #character_set_server 
                                    #character_set_database 
                                    #character_set_filesystem 
                                    #character_set_results character_set_system
                                    
set names $character  只是设置character_set_client, 
                             character_set_connection和
                             character_set_results这三个变量
                             
show variables like '%datadir%';
show variables like '%log%';
show variables like '%isolation%';
show engines|privileges|character set|;     
show VARIABLES like '%ENGINE%';  
show VARIABLES like 'default_storage_engine';
show variables like '%default%';   #default-table-type=innodb

show full tables; #查表和view
show triggers [from db_name] [like expr]; #INFORMATION_SCHEMA.TRIGGERS ACTION_STATEMENT
show triggers; 
show create trigger $triggerName;
use sys;show create view processlist;
```

```
mysql>show variables like '%query_cache%'
mysql> SHOW STATUS LIKE 'Qcache%';
have_query_cache=YES/NO;  指示查询缓存是否可用
query_cache_type=on/off;  0/off表示禁用 1/on允许缓存，尽明确使用select sql_no_cache除外 2/demand仅针对select SQL_CACHE可以启用缓存  
select SQL_CACHE    id from t;
select SQL_NO_CACHE id from t;
query_cache_min_res_unit[=4k]；  #每次分配一次select查询结果至少使用多少缓存 
query_cache_limit[=1M]           #每次分配一次select查询结果至多使用多少缓存 
query_cache_size[=0]             #默认值0表示禁用缓存,至少40K
Qcache_lowmem_prunes=            #因为缓存太少而被踢除的数量
                                 #它计算为了缓存新的查询而从查询缓冲区中移出到自由内存中的查询的数目。查询缓冲区使用最近最少使用(LRU)策略来确定哪些查询从缓冲区中移出
Qcache_queries_in_cache=

Qcache_total_blocks=             #总块多少
Qcache_free_blocks=              #空闲块多少 total与free blocks可知querycache碎片程度
mysql>flush query cache          #清理query,只保留一个块 cache内存碎片整理而提高查询速度

select数量=Qcache_hits(命中缓存数) + com_select(普通查询数) + queries with errors found by parser
com_select=Qcache_inserts + Qcache_not_cached + queries with errors found during columns/rights check

Qcache_hits +1 而不是 com_select
mysql>reset query cache   #重置清空query cache

当执行sql语句或设置SET GLOBAL query_cache_size = 4000;时，会提示有warning，因为至少需要40Kquery_cache.这时可以使用show warning查看具体warning;


innodb_buffer_pool_size 
+ key_buffer_size
+ max_connections*(sort_buffer_size+read_buffer_size+binlog_cache_size)
+ max_connections*2M  #2M通常是一个stack size

key_buff_size
table_cache
sort_buffer_size
read_buffer_size  对表进行顺序扫描时分配的区域
read_rnd_bufer_size 对表按任意顺序(如排序顺序)分配的随机读缓存
临时表一般是基于内存的heap表(tmp_table_size)
每个连接 stack(默认64K) net_buffer_length(连接缓冲区) net_buffer_length(结果缓冲区) 
        连接缓存区和结果缓存区可以根据需要动态扩充到max_allowed_packet
```



# 四大系统库

```
information_schema  数据库表 列 函数 存储过程 视图 触发器的定义
    SELECT * 
    FROM `information_schema`.`COLUMNS` 
    WHERE TABLE_SCHEMA='yy' AND TABLE_NAME='t1' 
    ORDER BY ORDINAL_POSITION;
    
    SHOW INDEXES FROM `t1` FROM `yy`;
    
    SELECT * 
    FROM information_schema.REFERENTIAL_CONSTRAINTS 
    WHERE CONSTRAINT_SCHEMA='yy'   
    	AND TABLE_NAME='t1'   
    	AND REFERENCED_TABLE_NAME IS NOT NULL;
    	
    SELECT * 
    FROM information_schema.KEY_COLUMN_USAGE 
    WHERE   CONSTRAINT_SCHEMA='yy'   
    	AND TABLE_NAME='t1'   
    	AND REFERENCED_TABLE_NAME IS NOT NULL;
    	
mysql  用户管理 权限
	user
	proc	procedure/function
	
performance_schema  inspect the internal execution of the server at runtime 
                    查看服务器运行状况
    global_status
    global_variables
    session_status
    session_variables
    status_by_account  //accounts
    status_by_user     //users
    status_by_host     //hosts
    status_by_thread   //threads
    user_variables_by_thread 
    variables_by_thread 
    
sys                 提供一系列对象更好地查看performance schema
```

# 查看死锁

```
以前：  
    show full processlist;  #status： lock
    show engine innodb status; #只能拿到最近一次死锁日志
        #set global innodb_status_output = on;          #开启标准监控
        #set global innodb_status_output_locks = on;    #开启锁监控
        #set global innodb_print_all_deadlocks = on;    #打印所有死锁到err日志
        #backgroud thread, semaphores, transaction(including locks)
        #file io, insert buffer and adaptive hash index
        #log, buffer pool and memory, row operation and so on
现在：
    set global innodb_lock_wait_timeout 30;  #默认值是50
    select * from information_schema.innodb_locks;  #只有出现锁竞争时才有记录
    select * from information_schema.innodb_lock_waits;
    select * from information_schema.innodb_trx;
    
    show open tables where in_use > 0;            #查看哪些表可能被锁住了
```

# 压力测试

```
mysqlslap mysql自带的
sysbench
```

# 小技巧

## api

```
mysql_options(..., MYSQL_OPT_WRITE_TIMEOUT,...)
mysql_options(..., MYSQL_OPT_READ_TIMEOUT,...)
int value = 1;
mysql_options(&mysql, MYSQL_OPT_RECONNECT, (char *)&value);  #show variables like '%timeout%'; wait_timeout和interactive_timeout默认值是28800也就是8小时，最大值只允许2147483（24天左右）

保护数据最简单的方法是使用''
 ';drop database test'                  #
 select * from t where id='12 or 1=1';  #没''则检出所有所有数据  mysql在数字列会自动将字符串转换为数字，非数字的自动舍弃。
```

## 丢失密码

```
service mysqld stop
#进入安全模式
mysqld_safe --skip-grant-tables --skip-networking & 
mysql -uroot
mysql>update mysql.user set authentication_password='' where user='root'
mysql>flush privileges;
#如果有必要，升级版本以便主从版本一致
mysql_upgrade -uroot -p--defaults-file=mysql.cnf
service mysqld restart
#检查是否正常
mysql -uroot -p
mysql>show databases;
```

# 常混淆点

```
基于binlog的复制，在配置文件中binlog_format[=row|mixed|statement]
innodb_default_row_format=dynamic
innodb_file_format=Barracuda

xbackup
	导出主数据
	innobackupex --defaults-file=mysql.cnf -uroot -p --stream=tar "/data/mysql" 2>/data/mysql/backup.log | gzip > /data/mysql/test.tgz
	
	从
	清除数据
	service mysqld stop
	rm -rf /var/lib/mysql/data/*
	导入数据
	innobackupex --defaults-file=mysql.cnf --apply-log /data/mysql
	innobackupex --defaults-file=mysql.cnf --copy-back /data/mysql
	chown -R mysql.mysql /data/mysql
	service mysqld start
	mysql -uroot
	
	cat /data/mysql/xtrabackup_binlog_info 包含非innodb引擎的数据位置
		mysql-bin.000020        8454162 16fdabc7-30f9-11e6-9234-0800273e5680:1-22037
	cat /data/mysql/xtrabackup_binlog_pos_innodb 只包含innodb引擎的数据位置
	
	配置主从
	
	
mysqldump
	优点：官方自带，适用性强
	缺点：由于是逻辑备份，如果数据量大的话，导出导入需要较长时间
	
主
	导出主新数据
	mysqldump -uroot -p123123 --opt --default-character-set=utf8 --triggers -R --hex-blob --single-transaction --no-autocommit --master-data=2 -A >test.sql
	
从
	清除从老数据
    service mysqld stop
    rm -rf /var/lib/mysql/data/*
    service mysqld start

    导入数据
    mysql -uroot -p
    mysql>reset master;
    mysql>source test.sql
    mysql>show variables like '%gtid%';
    
    配置主从
    mysql>reset slave all;
    	一般模式下
        mysql>change master to 
              master_host='',
              master_user='',
              master_password='',
              master_port='',
              master_log_file='',
              master_log_pos=;
        gtid模式下
     	mysql>set @@global.gtid_purged='';
     	mysql>change master to
     		  master_host='',
     		  master_port='',
     		  master_user='',
     		  master_password='',
     		  master_auto_position=1;
     mysql>start slave;
     mysql>show slave status;  #auto_position retrieved_gtid_set executed_gtid_set
     		  
     		  
reset master:
	delete all existing binary log files
	reset the bin log index file
	create a new empty bin log file
	reset its state before starting bin logging
    
	reset the gtid history execution history #reset slave has no effect on gtid history
		set gloabl gtid_purged=''
		set global gtid_executed=''
		trucate mysql.gtid_executed
		
reset slave
```

