## 	linux 常用命令 && 协议(baidu)

### service 命令

一般用于操作某个进程

~~~shell
#启动/停止/重启/查看状态 sshd 服务
$service sshd start/stop/restart/status
#启动httpd 服务
$service httpd start/stop/restart/status
~~~



### SSH 协议

默认占用端口是22 

可以利用telnet 命令查看端口的占用情况 : 

~~~shell
telnet ip 22
~~~

关于端口的配置文件, 位于 /etc/sysconfig/iptables中, 里面规定了本机的防火墙中屏蔽了哪些端口

