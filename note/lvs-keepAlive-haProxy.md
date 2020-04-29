# lvs

```

```

# keepAlived

```
https://www.keepalived.org/manpage.html
高可用
	早期 heartbeat
	目前 
	
工作于3 4 7层
功能
	监控检查
	vrrp冗余协议
	
	
Layer3 定期向服务器群中的服务器发送icmp包，如果发现某台服务器无法ping通，ka则报告该服务器失效并将它剔除。
Layer4 定期向服务器群中的服务器某端口发起连接，如果发送某台服务器无法telnet通，ka则报告该服务器失效并将它剔除。
Layer7 根据用户的设定检查服务器是否运行正常，如果与用户的设定不相符，ka则报告该服务器失效并将它剔除。

vrrp(virtual router redundancy protocol)
现实中，2台需要通讯的物理机一般不会直接直接的物理连接。对于这种情况，他们之间的路由怎么选择？主机如何选择到达目的主机的下一跳路由？一般有2种解决方案
	使用动态路由协议rip、ospf。但非常不切实际，因为管理维护成本以及是否支持等诸多问题
	使用静态路由。但路由器(或默认网关default gateway)经常成为单点故障。vrrp就是为了解决单点故障的。

安装
	tar -zxvf && cd
	./configure --prefix=/usr/local/keepalived
	make && make install
	ln -s /usr/local/keepalived/sbin/keepalived /usr/sbin
	cp    /usr/local/keepalived/etc/sysconfig/keepalived   /etc/sysconfig
	cp    /usr/local/keepalived/etc/rc.d/init.d/keepalived /etc/init.d
	chkconfig --add keepalived
	chkconfig keepalived on
	mkdir /etc/keepalived
	cp    /usr/local/keepalived/etc/keepalived/keepalived.conf /etc/keepalived
	
配置
global_defs {
    notification_email {
        675583110@qq.com
    }

    notification_email_from 675583110@qq.com
    smtp_server 127.0.0.1
    smtp_connect_timeout 30
    router_id LVS_DEVEL
}

vrrp_script chk_nginx {
    script "/data/shell/check_nginx.sh"
    interval 2
    weight 2
}

vrrp_instance VI_1 {
    state MASTER                #角色 master or backup       
    interface eth0
    virtual_router_id 51
    mcast_src_ip 192.168.60.93  #实际地址
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass xiaoqi
    }
    virtual_ipaddress {
        192.168.60.88           #virtual ip
    }
    track_script {
        chk_nginx
    }
}

#cat check_nginx.sh
Time=$(date +%Y%m%d:%H:%M)
Code=$(ps -ef | grep -v grep | grep -c "nginx: master process")
if [ ${Code} -eq 0 ];then
    /etc/init.d/keepalived stop
    echo "${Time} Keepalived is stop Success..." >> /tmp/nginx_keepalived.log
fi
```

# HAProxy

```
事件驱动 单一进程模型
工作于4 7层
功能
	后端检测
	支持虚拟主机，
	支持连接拒绝 防范蠕虫(attack bots)、DDOs攻击
	支持全透明代理，可以使用客户端ip或其他任何地址连接后端服务器
	对mysql，支持url的后端检测和负载均衡
	对nginx，保持session Cookie的代理
```

配置

```
#安装
yum list | grep haproxy
yum install -y haproxy
apt install haproxy
dpkg -L haproxy

#验证
haproxy -f /etc/haproxy/haproxy.cfg -c
#启动
systemctl start haproxy
#负载均衡算法
source     基于请求源的ip,使来自于同一ip的请求始终发送给某一服务器 hash(ip)%sum(weight)
uri        对整个uri或部分uri进行hash  hash(uri)%sum(weight)
uri_param  hash(uri_param)%sum(weight)
hdr        根据http header进行转发 如果http header不存在，则使用roundrobin

roundrobin 基于权重的轮巡
static-rr  基于权重的轮巡 不过为静态算法，在运行时调整其服务器权重不会生效
leastconn  将新的连接请求发送给最少连接数的后端服务器  在会话较长的场景中推荐使用此算法，如数据库负载均衡



#cat /etc/haproxy/haproxy.cfg
##global 全局配置 属于进程级的配置
global
log 127.0.0.1 local2 info #使用127.0.0.1的rsyslog中的local2日志设备，日志等级info [debug info warning err]
chroot /var/lib/haproxy
pidfile /var/run/haproxy.pid
maxconn 4000      #设置每个proxy进程可接受的最大并发数
user haproxy      #设置proxy进程的用户和组
group haproxy
daemon            #推荐的运行模式
nbproc 1          #前提是daemon，默认值为1. 设置proxy可创建的进程数，建议小于cpu数量
stats socket /var/lib/haproxy/stats

##默认参数的配置
defaults
mode http        #设置运行mode tcp:默认不做任何检查，常用语ssl/ssh/smtp等应用 http:不符合rfc格式会被过滤掉 
log global
option httplog    #默认情况下是不记录http请求的，使用该项记录http请求
option dontlognull
retries 3      #连接后端失败重试的次数 超过该值该后端服务器会被标记为不可用
timeout http-request 10s
timeout connect 10s #成功连接到后端服务器的最长等待时间 单位默认为毫秒
timeout client 1m
timeout server 1m
timeout http-keep-alive 10s
timeout check 10s   #设置对后端服务器的检测超时时间 单位默认为毫秒
maxconn 3000

option httpchk Get /index.php #启用http健康监测功能
option forwardfor except 127.0.0.0/8 #保证后端服务器可以获取client的真实ip
cookie SERVERID    #表示允许向cookie中插入serverid
option redispatch  #用于关于保持cookie。
                   #默认情况下，haproxy会将后端服务器的serverid插入到cookie中，以保证会话cookie的持久性。 
                   #而如果后端服务器出现故障，客户端的cookie是不会刷新的，这就造成无法访问。
                   #如果设置了该参数，就会将用户请求强制定向到另外一台健康的服务器上以保证服务正常。
timeout queue 1m
option abortonclose #在服务器高负载下，自动结束当前队列中处理时间比较长的连接
option http-server-close   
option abortonclose #表示客户端和服务器完成一次请求后，haproxy将主动关闭连接。 对性能非常有帮助


##用于接收用户请求的前端虚拟节点，可以根据acl规则直接指定要使用的后端backend
frontend main     #定义一个名为main的前端虚拟节点
bind *:80         #定义监听socket 格式为 bind [<addr>:[port_range]] [interface]
acl url_static path_beg -i /static /images /javascript /stylesheets
acl url_static path_end -i .jpg .gif .png .css .js
use_backend static if url_static
default_backend web #指定默认的后端

##用于设置后端，以处理前端的请求
backend static
balance roundrobin
server static 127.0.0.1:4331 check
backend web
balance roundrobin
server web1 192.168.31.66:80 cookie server1 weight 6 check inter 2000 rise 2 fall 3
server web2 192.168.31.55:80 cookie server2 weight 6 check inter 2000 rise 2 fall 3

##设置监控页面
listen admin_status
bind 0.0.0.0:9188
mode http
log 127.0.0.1 local0 err
stats refresh 30s             #设置统计自动刷新间隔
stats uri     /haproxy-status #设置haproxy监控页面的访问地址
stats realm welcom login      #设置登录监控页面时，密码框上的提示信息
stats auth admin:admin        #设置登录页面的用户名和密码 可以设置多个，每行一个
stats auth guest:guest
stats hide-version            #设置在监控页面隐藏版本
stats admin if TRUE           #在版本1.4.9版本后，设置此选项，可在监控页面上启用禁用服务器
```