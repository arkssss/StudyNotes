# MySQL 数据库基础

[TOC]



## 一. shell mysql命令

#### 1. 查看数据库服务器是否运行

注意要链接mysql数据库, 首先我们需要启动mysql服务器, 这是常识

mysqld是一个可执行脚本, 用来启用我们的mysql服务器

我们可以利用 ps命令查看mysql服务器 => mysqld 是否处于后台运行状态 : 

~~~shell
# mysqld 是运行在后台的mysql的服务器
ps aux | grep mysqld
~~~



#### 2. 登陆mysql 客户端

**普通的方式登陆**

在保证mysqld运行在后台后, 我们便可以利用mysql命令链接上mysql数据库了

~~~shell
# 登陆 mysql 客户端
mysql -u root -p

# 登陆 mysql 的时候同时指定要使用数据库
mysql -u root -p bank
~~~



**查看xml的方式登陆**

这种方式我们可以通过 select 语句去返回对应的 XML 文件 

~~~shell
# xml 形式登陆
mysql -u root -p --xml
~~~







## 二. MySQL 内建函数及命令

### 一般函数

#### 1. 查看当前的时间

~~~sql
/* mysql 使用的可以直接不加from限定*/
select now();

/* 但是其他一些关系型数据库 e.g. orcale 就必须加上一个限定的表格才能完成选择语句*/
/* 所以我们需要给它加上一个特殊的表 dual*/
select now() from dual;
~~~



#### 2.查看当前版本

~~~sql
select version();
~~~



#### 3.查看当前用户

~~~sql
select user();
~~~



##### 4.查看当前数据库

~~~sql
select database();
~~~



###  行函数 Row function

**针对一个记录的操作**

#### 5. 将字母全部转为大写

~~~sql
select upper(name) from person		
~~~



#### 6. 截取函数

~~~sql
/* 
可以截取 value 的后 number 个值
注意不管 value 是字符类型, 还是数字类型, 都可以使用
right(10, 1) => 0
*/
select right(value, number) from table_name

/*
当然对于字符类型的, 我们还可以使用 substr 函数
表示截取 name 开始的 1到3个字符
‘fangzhou’ => 'fan'
*/
select substr(name, 1, 3) from person
~~~



### 组函数(聚合函数) **group function** 

针对一组数据的操作

#### 7. 统计一组数据的个数

~~~sql
/* 统计person所有记录的个数 */
select count(*) from person
~~~

#### 8. 对所有的记录的某一列求和

~~~sql
/* 对所有记录的age求和 */
select sum(age) from employee;
~~~

#### 9. 对指定记录列求平均值

~~~sql
/* 求平均*/
select avg(age) from preson;
~~~

#### 10. 求最大值

~~~sql
/* 求最大值*/
select max(age) from preson;
~~~



## 三. MySQL 的数据类型

通常只涉及到三种基本的数据类型

* 字符
* 数值
* 日期

### 1. 字符类型

**注意 mysql 字符类型 一律只能用单引号阔起来**

mysql中对于字符的制定**必须先声明该字段可能到达的最大的字节长度**

注意后面设置的表示为 **字节**

char 和 varchar 使用方式类似

* char(5)
* varchar (10)

不同的是 char 最大长度可以设置为 255,  varchar 可以设置为 65535



#### 字符集

由于全世界的语种有很多, 所以对应的不同的字符集, 也对应不同的存储方式.

* gbk : 简体中文字符集
* 🌟 utf-8 : 全世界通用字符集, 一般的我们使用这个字符集, 可以使得世界范围内的字符自动解析, 而不用下载相应的语言包



#### 文本数据

如果存储数据大小超过了 64KB, 那么我们不能再使用 varchar了

| 文本类型   | 最大存储字节 |
| ---------- | ------------ |
| tinytext   | 255          |
| text       | 65535        |
| mediumtext |              |
| longtext   |              |



### 2. 数值型

包括了 **整数** 和 **浮点数** . 

~~~sql
/** 声明的时候, 如果是无符号的, 可以在后面加上unsigned标志, 从而增加数据的范围*/
age smallint unsigned,
~~~



















