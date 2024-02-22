# 反向代理

## [proxy_pass]

Nginx可以代理转发Http请求, 使用默认自带的模块 `proxy_pass` 即可

分别使用 http://{nginx_host:80}/api/hello 访问以下配置

* ~~~
  server {
  	  listen: 80
  
      location  /api/ {
  	    // 后面没有 '/'
  	    proxy_pass http://127.0.0.1:8899;
      } 
  }
  ~~~

  会被代理到 `http://127.0.0.1:8899/api/hello` 下

* ~~~
  server {
  	  listen: 80
  
      location  /api/ {
  	    // 后面带有 '/'
  	    proxy_pass http://127.0.0.1:8899/;
      } 
  }
  ~~~

  会被代理到 `http://127.0.0.1:8899/hello` 下

## [upstream]

`upstream` 模块可以给一个对外暴露的 host 配置多个内部转发的 sever, 并且可以 **按照自定义的策略** 进行转发

~~~
// 定一个名为 backend-gin 的server
// 如果不指定转发策略, 则公平分配到所有server上去
upstream backend-gin {
   server host.docker.internal:8899;
   server host.docker.internal:8898;	
}


server {
    location  /api/ {
      // 将请求打到 backend-gin server 上去
			proxy_pass http://backend-gin;
    } 
}
~~~

常用的配置参数如下

* `backup` 可以标记 svr 为备用服务器, 当主服务器不可用时, 才会切换为备用服务器

  ~~~
  upstream backend-gin {
     server host.docker.internal:8899;
     server host.docker.internal:8898;	
     
     // 备用服务器
     server xxx backup;
  }
  ~~~

* `down` 可以标记某个 svr 不可用

  ~~~
  upstream backend-gin {
     server host.docker.internal:8899;
     server host.docker.internal:8898;	
     
     // 停用服务器
     server xxx down;
  }
  ~~~

* `keepalive` 规定了 nginx 进程和 upstream 进程中保持长连接的数量, 相当于连接池的最大数量.

  ~~~
  upstream backend-gin {
     server host.docker.internal:8899;
     server host.docker.internal:8898;	
     
  	 keepalive: 32;   
  }
  ~~~

  

### 加权轮训 - 默认

默认情况下, nginx的负载策略就是加权轮训, 如果不指定权, 则权都为 1. 已上配置为例, 流量分发到 `host.docker.internal:8899`, `host.docker.internal:8898` 的比例为 1:1 且为轮训分配。同时可以给各个server分配不同的权值:

~~~
// 此时则为比例为 2:1 的轮询转发
upstream backend-gin {
   server host.docker.internal:8899 weight=2;
   server host.docker.internal:8898;	
}
~~~

如果其中有 svr 通信时发生错误, 则 nginx 会自动转发给下一个 svr 保证可用性, 当所有的 srv 都尝试失败时, 才会返回给客户端失败



### ip_hash

根据客户端请求的ip做hash后固定分配到某个svr中, 对于同一个客户端请求, 转发到后端的服务器是一致的

~~~
upstream backend-gin {
	 ip_hash;
	 
   server host.docker.internal:8899;
   server host.docker.internal:8898;	
}
~~~



## root / alias

当将 `nginx` 作为文件服务器使用时,  `root / alias` 可以指定对应请求所在服务器中的路径然后返回

* `root ` 会将路径做为根地址, 再匹配 location 

  ~~~
  # 将 domain/data/xxxx 请求的文件转发到 
  # domain/home/data/xxxx 下
  location  /data/ {
  		root /home/;
  }
  ~~~

* `alias` 会将路径作为 location中的替换

  ~~~
  # 将 domain/data/xxxx 请求的文件转发到 
  # domain/home/xxxx 下
  location  /data/ {
  		alias /home/;
  }
  ~~~

