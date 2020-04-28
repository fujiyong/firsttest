# keepAlived

```
高可用
	早期 heartbeat
	目前 
	
工作于3 4 7层
功能
	监控检查
	vrrp冗余协议
	
	
Layer3 定期向服务器群中的服务器发送icmp包，如果发现某台服务器无法ping通，ka则报告该服务器失效并将它剔除。
Layer4 定期向服务器群中的服务器某端口发起连接，如果发送某台服务器无法telnet通，ka则报告该服务器失效并将它剔除。
```

# HAProxy

```
事件驱动 单一进程模型
工作于4 7层
功能
	支持虚拟主机，
	支持连接拒绝 防范蠕虫(attack bots)、DDOs攻击
	支持全透明代理，可以使用客户端ip或其他任何地址连接后端服务器
	对mysql，支持url的后端检测和负载均衡
	对nginx，保持session Cookie的代理
	
	
```

配置

```
#yum list | grep haproxy
#yum install -y haproxy

#cat /etc/haproxy/haproxy.cnf
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

##设置监控界面
listen

#验证
haproxy -f /etc/haproxy/haproxy.cfg -c
#启动
systemctl start haproxy


安装apach
yum install -y httpd httpd-devel
echo "$ip" > /var/www/html/index.html
systemctl start httpd
```

