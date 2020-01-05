### Linux 软件包管理

* 二进制包,  RPM包的管理

RPM软件包的格式

sudo(软件名) - 1.7.2pl (版本号) - el5.i386(硬件平台).rmp





#### rpm 命令

* 卸载命令

~~~shell
#sudo为软件的名称
$rpm -e sudo
#如果有其他软件包和sudo有依赖关系, --nodeps表示有依赖关系也强行卸载
$rpm -e --nodeps sudo
~~~

* 安装命令

~~~shell

~~~

