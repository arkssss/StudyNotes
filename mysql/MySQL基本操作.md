# MySQL 基本操作

[TOC]



## DML, DDL, DCL 的区别

### DML(data manipulation language）

就是数据记录的 **增删改查**

它们是SELECT、UPDATE、INSERT、DELETE，就象它的名字一样，这4条命令是用来对数据库里的数据进行操作的语言 



### DDL(data definition language)

主要的命令有CREATE、ALTER、DROP等，DDL主要是用在 **定义或改变表（TABLE）的结构，数据类型，表之间的链接和约束等初始化**工作上，他们大多在 **建立表时使用**





### DCL(Data Control Language)

是数据库控制功能。是用来 **设置或更改数据库用户或角色权限的语句**，包括（grant,deny,revoke等）语句。在默认状态下，只有sysadmin,dbcreator,db_owner或db_securityadmin等人员才有权力执行DCL 





## MySQL 的数据类型

通常只涉及到三种基本的数据类型

- 字符
- 数值
- 日期

### 1. 字符类型

**注意 mysql 字符类型 一律只能用单引号阔起来**

mysql中对于字符的制定**必须先声明该字段可能到达的最大的字节长度**

注意后面设置的表示为 **字节**

char 和 varchar 使用方式类似

- char(5)
- varchar (10)

不同的是 char 最大长度可以设置为 255,  varchar 可以设置为 65535



#### 字符集

由于全世界的语种有很多, 所以对应的不同的字符集, 也对应不同的存储方式.

- gbk : 简体中文字符集
- 🌟 utf-8 : 全世界通用字符集, 一般的我们使用这个字符集, 可以使得世界范围内的字符自动解析, 而不用下载相应的语言包



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

```sql
/** 声明的时候, 如果是无符号的, 可以在后面加上unsigned标志, 从而增加数据的范围*/
age smallint unsigned,
```



## 客户端登陆 MySQL

#### 1. 查看数据库服务器是否运行

注意要链接mysql数据库, 首先我们需要启动mysql服务器, 这是常识

mysqld是一个可执行脚本, 用来启用我们的mysql服务器

我们可以利用 ps命令查看mysql服务器 => mysqld 是否处于后台运行状态 : 

```shell
# mysqld 是运行在后台的mysql的服务器
ps aux | grep mysqld
```



#### 2. 登陆mysql 客户端

**普通的方式登陆**

在保证mysqld运行在后台后, 我们便可以利用mysql命令链接上mysql数据库了

```shell
# 登陆 mysql 客户端
mysql -u root -p

# 登陆 mysql 的时候同时指定要使用数据库
mysql -u root -p bank
```



**查看xml的方式登陆**

这种方式我们可以通过 select 语句去返回对应的 XML 文件 

```shell
# xml 形式登陆
mysql -u root -p --xml
```





## MySQL 数据库操作 DDL



### 建立一个新的数据库

```sql
create database bank;
```



### 查看当前mysql服务器下的所有数据库

```sql
show databases;
```



### 选择进入一个数据库

```sql
/*use databases_name;*/
use bank;
```



### 查看当前数据库的所有表格

```sql
/* 查看当前数据库下的所有表格*/
show tables;
```



## MySQL 数据表操作

### MySQL 表查看

```sql
/* 
   desc table_name;
   OR
   describe table_name;
*/
desc table_name;
```



### MySQL 表创建

利用 **create** 语句, 我们可以创建一个数据表. 

一般创建数据表,由两个部分组成

- 字段名
- 约束条件, 可以有以下几种类型
  - 主键约束 (**primary key**): 标志一列 或者 多列, 保证在表内的唯一性
  - 外键约束 (**foreign key**): 限制的一列或者多列 **必须保证包含在另一个表的外键列中**.
  - 唯一约束 (**unique**): 限制一列或者多列在表中的唯一性 **主键约束是一种特殊类型的约束**
  - 检查约束 (**check**): 限制一列的可用值范围

```mysql
/*
create table person(
	-----------------
	--- 字段定义
	person_id smallint unsigned auto_increment,
	name varchar(40),
	age smallint,
	... 
	-----------------
	--- 约束定义
	constraint person_pk primary_key(person_id),
	...
    -----------------
)
*/
```

#### 创建一个带主键的数据表

```sql
create table person (
	person_id samllint unsigned,
	fname varchar(20),
	lastname varchar(20),
    /* 表示gender 只能在枚举类型M, F里选择一个*/
    gender enum('M', 'F'),
    /* 表示给person表加一个限制, 即限制person_id为这个表的主键 */
    /* 注意 pk_person 仅为这个主键的别名, 并不是新的字段名 */
	constraint pk_person primary key (person_id)
)
```



#### 创建一个带外建的数据表

假设我们要创建一个人喜爱的食物 favorite_food 的数据表, 这个表要对 person 表产生关联, 所有要考虑一下几点因素 :

- 一个人不应该只有一种喜欢的食物, 所以 favorite_food 这个表的主键不应该只为 person_id
- favorite_food 表的 person_id 必须为 person 表存在的 id, 既可以理解为 person表的 **外键**

```sql
create table favorite_food(
    person_id smallint unsigned,
    food varchar(40),
    /* 加入约束 */
    
    /* 主键约束 */
    /* 考虑到第一点 所以将person_id, food同时设置为主键*/                    
	constraint pk_fa_food primary key (person_id, food),
    
    /* 外键约束*/
    constraint fk_fa_food_person_id foreign key (person_id) references person (person_id)
	)
```



#### 创建含有多个约束调节的数据表 Department

```sql
CREATE TABLE DEPARTMENT(
 name               VARCHAR(50)        NOT NULL,
 code               CHAR(5)            NOT NULL,
 total_staff_number NUMBER(2)          NOT NULL,
 chair              VARCHAR(50)            NULL,
 budget             NUMBER(9,1)            NULL, /* In this presentation */
    CONSTRAINT dept_pkey PRIMARY KEY(name),        /*  budget can be NULL  */
    /* 要求 code 是唯一的*/
    CONSTRAINT dept_ckey1 UNIQUE(code),
    /* 要求 chair 是唯一的*/
    CONSTRAINT dept_ckey2 UNIQUE(chair),
    /* 要求 total_staff_number 是属于 1 到 50的*/
    CONSTRAINT dept_check1 CHECK (total_staff_number BETWEEN 1 AND 50)
);

 CREATE TABLE COURSE(
 cnum               CHAR(7)           NOT NULL,
 title              VARCHAR(200)      NOT NULL,
 credits            NUMBER(2)         NOT NULL,
 offered_by         VARCHAR(50)           NULL,
  CONSTRAINT course_pkey PRIMARY KEY(cnum),
  /* 要求credits是6或者12 */
  CONSTRAINT course_check1 CHECK (credits IN (6, 12)),
  /* 定义offered_by 为 DEPARTMENT (name)的外键*/
  CONSTRAINT course_fkey1 FOREIGN KEY(offered_by)
     /* ON DELETE CASCADE 级连删除规则 说明了如果DEPARTMENT表中某个name被删除, COURSE所有的offered_by都要被删除*/
     REFERENCES DEPARTMENT(name) ON DELETE CASCADE );

```



#### 🌟 MySQL外键级连动作

此节是对外键作用的一个扩展, 考虑一个主表和从表, 从表外键为主表主键关联.

那么 **从表的外键, 一定是主表的主键的一个, 不可以不存在于主表中**, 从而 如果我们删除了主表的一个记录, 随之而来的可能对我们的从表带来影响, 所以数据库服务器必须做出处理, 处理方式可以分为下面几种:

- cascade 操作, 主要可以分为两种 :

  ```sql
  /*
  on delete cascade 级连删除
  就是如果主表的记录删除, 从表的相应外键记录也会被删除
  */
  alter table t_student add
  constraint t_student_classno_fk
  foreign key(classno) references t_class(cno) on delete cascade;
  /*
  on update cascade 级连更新
  就是如果主表的记录更新, 从表的相应外键记录也会被更新
  */
  alter table t_student add
  constraint t_student_classno_fk
  foreign key(classno) references t_class(cno) on update cascade;
  ```

- NO ACTION(非活动), RESTRICT

  这种为默认情况, 如果我们的不指定其他操作, 那么数据库为默认为这种操作

  如果删除主表, 但是相关从表有主表外键存在, 那么删除操作 **会被数据库拒绝**

- SET NULL

  如果删除主表, 但是相关从表有主表外键存在, 相关外键子段会被设置为NULL











### MySQL 表删除

利用drop语句可以 **删除一个数据表**

```sql
/*drop table table_name*/
drop table person;
```



### MySQL 表修改

#### 表 增加 & 修改 字段

我们利用 **alter table** 语句可以去修改 已经创建的一个表 比如 :

```sql
/* 给表增加一个字段 */
/*
alter table 
	table_name
add
	field def
*/
alter table person add age smallint unsigned;

/* 删除表的字段*/
/*
alter table
	table_name
drop 
	field_name
*/
alter table person drop age;
```

```sql
/* 修改表的字段 */
/* 
	alter table 
		table_name
	modify
		new field def
*/

/* 字段修改为非空*/
alter table user modify user_id not null

/* 字段修改为自增*/
alter table person modify person_id samllint unsigned auto_increment;
```

#### 表 增加 & 删除 约束

在约束上, **主键, 外键的增加语法和字段约束的稍有不同**

主键, 外键的增加 : 

```sql
/* 主键约束*/

/*
增加一个主键约束
alter table
	table_name
add primary key 
	'pk_name'(field_name) // pk_name为主键的名称, 可以不写
*/
alter table person add primary key(person_id);
/*
删除一个主键约束
alter table
	table_name
drop primary key
*/
alter table person drop primary key;

/* 外键约束 */
/* 给表添加一个外键 */
alter table favorite_food add foreign key fk_f_p(person_id) references person(person_id)
```

字段约束 :

```sql
/* 字段约束 */
/*
alter table 
	table_name
add constraint
	constraint_name
	constraint_def
*/

/* 唯一性约束 */
/* title 增加唯一约束*/
alter table person add constraint uni_title unique(title)
/* title, date 两字段唯一约束*/
alter table person add constraint uni_title unique(date, title)



/* 检查约束 */
/* trip_length 大于0小于10000约束 */
alter table trip add constraint value_trip check(trip_length betweem 0 and 10000)
/* trip_length 大于0 */
alter table trip add constraint value_trip check(trip_length > 0)
```





## MySQL 记录操作 DML

一个MySQL表无非四种操作 : **增(insert), 删(delete), 改(uodate), 查(select)**. 下面我们一个一个来说



### 增加数据

利用 insert 语句

```sql
/* 
	insert table_name (field_names) values (values)
	注意规定了非空的字段 (自增主键除外)
	插入数据时必须要规定值
*/
insert person (food, age) values ('fz', 18);
```





### 查询数据

利用 select 语句

```sql
/* 	
	基本的语法 : 
	select field_names 
	from table_name
    where field_name = value	
    order by field_name
    从 tabel_name 表里面选择所有 field_name 等于 value 的 field_names 字段, 且通过 field_name 排序
*/
selecr * from person;
```



### 更新数据

使用 update 语句

```sql
/*
	update table_name
	set fild_name = new_value
	where condition
	将 table_name 表里面满足条件 condition 字段将 fild_name 设置为 new_value
*/
update person set age = 'fa' where person_id = 1;
```

- 注意如果不加 where 条件语句, 那么数据库 **所有, 所有, 所有** 字段都会被改变 !!!!!



### 删除数据

使用 delete 语法

```sql
/*
	delete from table_name
	where condition
*/
delete from person where person_id = 1;
```

- 如果没有加 where 条件限制那么**所有 所有 所有 所有**记录都被删除 !!!





## 高级操作

### 插入语句实现在插入的时候检查是否有重复的情况, 否则不插入

如果插入一条语句在 **唯一性约束上重复了** , 插入语句是会报错的, 但是如果在插入之前先检查, 再插入又会引发安全问题 :

~~~php
/*
	安全问题
	高并发情况下 语句之间不存在原子性
*/
$res = "select * from student id = 10;"
    if($res){
        // ...
        // 在多线程的环境下, 这里可能突然被插入一条字段. 导致了下面的 insert 报错
        "insert into table() values ()";
    }else{
        //...
    }
~~~

**解决方法 :  **

`on deplicate key update` 语句, 可以实现原子性的, 如果存在某一个记录就不插入的操作

~~~sql
-- 在数据库中不存在 id = 1 的时候, 才插入.
insert into students(id, name) values (1, 'fz') 
on deplicate key update id = 1;
~~~





## MySQL 内建函数及命令

### 一般函数

#### 1. 查看当前的时间

```sql
/* mysql 使用的可以直接不加from限定*/
select now();

/* 但是其他一些关系型数据库 e.g. orcale 就必须加上一个限定的表格才能完成选择语句*/
/* 所以我们需要给它加上一个特殊的表 dual*/
select now() from dual;
```



#### 2.查看当前版本

```sql
select version();
```



#### 3.查看当前用户

```sql
select user();
```



##### 4.查看当前数据库

```sql
select database();
```



### 行函数 Row function

**针对一个记录的操作**

#### 5. 将字母全部转为大写

```sql
select upper(name) from person		
```



#### 6. 截取函数

```sql
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
```



### 组函数(聚合函数) **group function** 

针对一组数据的操作

#### 7. 统计一组数据的个数

```sql
/* 统计person所有记录的个数 */
select count(*) from person
```

#### 8. 对所有的记录的某一列求和

```sql
/* 对所有记录的age求和 */
select sum(age) from employee;
```

#### 9. 对指定记录列求平均值

```sql
/* 求平均*/
select avg(age) from preson;
```

#### 10. 求最大值

```sql
/* 求最大值*/
select max(age) from preson;
```



















































