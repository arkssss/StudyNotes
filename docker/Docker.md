# Docker

# 一. 安装

[阿里云镜像下载 for MacOS](<http://mirrors.aliyun.com/docker-toolbox/mac/docker-for-mac/?spm=5176.8351553.0.0.7f231991HGal1K>)

设置本地国内仓库源:

~~~json
{
  "experimental": false,
  "debug": true,
    
  /* 设置国内阿里云仓库镜像 */
  "registry-mirrors": [
    "https://******.mirror.aliyuncs.com"
  ]
}
~~~

# 二. 入门指令

## Hello world - 启动一个 ubuntu 的容器

~~~shell
# -i 表示容器 Stdin 开启
# -t 表示分配一个伪tty终端
# ubuntu 为告诉 docker 创建的镜像容器 类似的如 : fedora,debian,centos...
# bin/bash 告诉docker采用的交互 shell
$docker run -i -t ubuntu /bin/bash
~~~

执行命令后，首先 `docker` 会在本地寻找 `ubuntu` 镜像，如果本地不存在则在配置的 `registry-mirrors` 中寻找且下载至本机，此时便启动可一个 ubuntu 系统的 docker 容器。

在执行`run`命令后，便可以进入 `ubuntu` 的系统 `shell` 中。

~~~bash
# 退出docker容器，回到宿主机
exit
~~~



## 容器列表

~~~shell
# 可以查看当前系统中所有容器的列表
# 可以列出如容器 ID, IMAGE, NAMES 等信息
$docker ps -a
~~~



## 容器命名

我们可以在创建容器的同时给容器命名:

~~~shell
# 容器的命名必须是唯一的，可以用于容器的辨认
$docker run --name myContainer -i -t ubuntu /bin/bash
~~~



## 重启容器

在使用 `exit` 命令后的容器便会自动停止，我们可以分别用 **ID**, **Name** 的方式对容器进行重启:

~~~shell
# 使用名称重启
$docker start myContainer

# 使用ID重启
$docker start 5bbba0b5aef1
~~~



## 附着容器 (进入容器)

在容器重启后，我们便可以重新进入容器中:

~~~shell
# 使用名称进入
$docker attach myContainer

# 使用ID进入
$docker attach 5bbba0b5aef1
~~~



## 停止容器

~~~shell
$docker stop myContainer 

$docker stop 5bbba0b5aef1 
~~~



## 删除容器

删除容器需要在停止容器后才能执行

~~~shell
$docker rm myContainer

# 删除全部容器
$docer rm `docker ps -a -q`
~~~



## `apt-get` 命令加速

一般而言 docker apt-get速度很慢，我们需要设置docker ubuntu apt-get 源.

~~~shell
# 设置阿里云源
> sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
> apt-get clean
~~~

~~~shell
# 更新加速
> apt-get update
~~~

# 三. 镜像和仓库

## 列出镜像

~~~shell
➜  ~ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              latest              1d622ef86b13        7 days ago          73.9MB
hello-world         latest              bf756fb1ae65        3 months ago        13.3kB
~~~

下载下来的镜像被放置于宿主机的 `/var/lib/docker` 目录下。

## 构建自定义镜像

更新和管理自定义镜像的方法主要有以下两种

* 使用 docker commit 
* 使用 **docker build 和 Dockerfile 文件** 🌟 推荐使用

### Docker commit 构建自定义镜像

* 首先我们需要登陆到 hub.docker 上

  ~~~shell
  >sudo docker login
  ~~~

* 然后我们开一个 ubuntu 容器

  ~~~shell
  $docker run -i -t ubuntu /bin/bash
  ~~~

* 然后下载 `apache` 

  ~~~shell
  # in container
  >apt-get update
  >apt-get -y install apache2
  ~~~

  我们日后希望生成的web应用的容器可以不用再重新去下载 `apache`

* 退出 ubuntu 然后 commit

  ~~~shell
  # exit from container
  >exit
  # in macOs
  $sudo docker commit [containerID] username/apache2
  # 在 commit 之后，便可以将刚容器中的环境设置保存到用户仓库中，且提交的时候仅保存 创建容器和当前状态之间的差异部分 从而使得更新非常轻量
  ~~~

* 获取用户仓库中的镜像

  ~~~shell
  # 此时获得的镜像即为刚用户保存的自定义镜像
  $sudo docker run -t -i username/apache2 /bin/bash
  ~~~

### 🌟 Dockerfile 构建自定义镜像









