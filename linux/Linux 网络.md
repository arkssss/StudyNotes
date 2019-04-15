## FLinux 网络



### 1. 域名结构



~~~shell
以域名 : www.ryxfzhome.top 为例子

top 为顶级域名
ryxfzhome 为二级域名
www 为标示需要提供的为万维网的服务 (其实现在去掉 www 同样可以访问到web serve)
~~~



### 2. 三层地址(MAC , IP , FQHN(主机的域名))之间的相互查找



####2.1 MAC 和 IP (MAC 和 IP 的相互查找只涉及在局域网)



* **知道 对方机器的IP 需要找到 对方机器的 MAC : ARP协议**

  Step 1 : 机器先广播一个ARP的请求包 , 局域网的所有机器都会收到

  Step 2 : 和该IP符合的机器应答, 再广播一个ARP包

  Step 3 : 查找机器便可以知道这个IP对应的MAC地址



  **现实中不可能每次传输都去找一下MAC地址, 从而有了ARP缓存表**

  ~~~shell
  # linux 下查找到该ARP 缓存表的内容
  arp -a 
  
  # 删除一条 arp记录
  arp -d [IP]
  
  # 在该缓存表添加一条静态记录(永久生效)
  # 谨慎添加, 小心写错了访问不了
  arp -s [IP] [MAC]
  ~~~

* **知道 自己机器的MAC 询问自己机器的IP : RARP协议**

  因为IP地址都是自动分配的, 不一定每天都一样, 所以需要询问





####2.2 IP 和 域名之间的查找



以访问 www.ryxfzhome.top 为例子

当系统第一次访问这个网站的时候

Step 1 : 查找DNS缓存看有没有对应的记录, 若没有

Step 2 : 查找hosts 静态文件, 若没有

Step 3 : 递归询问本机的DNS服务器, 若没有

Step 4 : 询问跟目录 . 从而找到 .top DNS服务的IP地址

Step 5 : 询问 .top , 从而找到  ryxfzhome.top DNS服务器的IP地址

Step 6 : 返回结果给DNS 服务器  (客户端的那台, 而不是跟目录的那台 **此为递归查询和迭代查询的区别 **) 

Step 7 : 返回给客户端

* 经过此过程 , .top DNS服务器的IP被写入 DNS缓存
* ryxfzhome.top DNS服务器的IP被写入DNS缓存



**DNS 缓存和 hosts 文件的区别 ?**

* DNS 缓存是一种缓存策略, 具有时间周期, 超过生命周期了之后就需要重新询问
* Hosts 是本地的静态记录





#### 2.4 总结问题



#####一个MAC 地址可以绑定多个IP 地址 !! 



##### 一个IP地址可以对呀多个MAC地址 !!

*  例如 : 集群服务器, 即一个域名可以对应一个集群的服务器组 , 从而达到负载均衡



##### 	一个域名对应多个IP地址 !!



##### 一个IP地址可以对应多个域名

* 例如 : 一个服务器可以放多个网站serve





### 3 相应工具及文件

#### 3.1 nmap 命令

~~~shell
# 如果没有安装则先用homebrew安装

brew install nmap
~~~

这个命令可以扫描一台主机的开启的服务以及对应的协议和端口

~~~shell
 # nmap servename
 mnamp www.ryxfzhome.top
~~~



#### 3.2 traceroute 命令

~~~shell
# 可以显示访问这个serve的时候 经过了哪些路由器
traceroute servername
~~~



#### 3.3 netstat 命令

~~~shell
# 查看本机有哪些服务正在启用(监听)
netstat -an |more
~~~









​	






























