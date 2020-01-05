# MySQL 基本操作

[TOC]



## 一. DML, DDL, DCL 的区别

### DML(data manipulation language）

就是数据记录的 **增删改查**

它们是SELECT、UPDATE、INSERT、DELETE，就象它的名字一样，这4条命令是用来对数据库里的数据进行操作的语言 



### DDL(data definition language)

主要的命令有CREATE、ALTER、DROP等，DDL主要是用在 **定义或改变表（TABLE）的结构，数据类型，表之间的链接和约束等初始化**工作上，他们大多在 **建立表时使用**





### DCL(Data Control Language)

是数据库控制功能。是用来 **设置或更改数据库用户或角色权限的语句**，包括（grant,deny,revoke等）语句。在默认状态下，只有sysadmin,dbcreator,db_owner或db_securityadmin等人员才有权力执行DCL 



## 二. MySQL 数据库操作 DDL



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



## 三. MySQL 数据表操作

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





## 四. MySQL 记录操作 DML

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





## 五. 查询入门

现在开始 **详细** 的讲讲查询语句



### select query 子句汇总

一个 **select 查询** 一般 只包含 2~3 个字句, 但是标准下一个select拥有6个字句

| 子句     | 作用                                                 |
| -------- | ---------------------------------------------------- |
| select   | 确定查询结果包含哪几列, 如果后面接 *, 则包含所有.    |
| from     | 指出要提取的数据表                                   |
| where    | 利用条件过滤不需要的记录                             |
| group by | 用于对 **具有相同列值** 的行进行分组                 |
| having   | 过滤不需要的组                                       |
| order by | 按一列或者多列进行排序输出, 如果不加, 则对顺序不保证 |

<center style='font-size:30px;color:red'> 注意在语句中, 我们的各个子句的先后顺序个上面的出现次序一致



### select 子句

select 可以选择这个结果集返回记录的哪些列, 或者用 * 表所有列.

select 选择的同时, 我们可以 **对相应返回的列值做以下操作**:

- 对列值加一个表达式, 比如:

  ```sql
  /* 对选择出来的 age 做乘100 操作 */
  select age * 100 from person;
  ```

- 对列值加上内建函数, 比如:

  ```sql
  /* 将name所有的字母变为大写*/
  select upper(name) from person;
  ```

- 给返回列加上别名

  ```sql
  /* 现在新的列名为 new_name, new_age*/
  select upper(name) new_name, age*10 new_age from person;
  
  /* 同样使用 AS 关键字也是一样的效果*/
  select upper(name) as new_name, age*10 as new_age from person;
  ```

- 删除某列中 **数值重复的记录**

  注意使用 distinct 会大量的耗时, 我们应该 **尽量减少 distinct 的使用**

  ```sql
  /* 删除重复*/
  select distinct food from favorite_food;
  ```

### from 子句

from 子句定义了表查询中所使用的表



<center style='font-size:20px'> 表的概念及种类



**定义, 表的该脸并不局限于我们create的表, 而包括以下三个概念**

- 永久表 : 通过 create 创建的表
- 临时表 : 通过查询语句 select 返回的表, 也就是说, 我们使用 **select查询后的结果也是一个表**
- 虚拟表 : 使用视图 create view 子句所创建的 **视图**



<hr>

**我们来看看什么是 临时表, 虚拟表**

临时表 (子表查询产生的表)

```sql
/* 注意我们要给子表查询的结果命名 e.g: 取名为 e */
/* 然后我们才能利用 e.age的形式去选择里面的列   */
select e.age from (select * from person) e;
```

虚拟表 (通过视图创建)

视图是什么 : **视图就是存储于数据字典的数据查询** 注意我们的视图并没有任何数据, 而只是一个定义. 我们调用他的时候, 服务器也只是简单的去掉用这个定义.

```sql
/* 定义视图 */
create view person_v as select age from person;

/* 此时person_v 就被定义为这个查询*/
/* 从而我们直接对视图进行查询即可 */
select * from person_v;

/* 删除一个视图*/
drop view person_v;
```

- 视图会存在于我们的真实表中, 即可以通过 show tables 显示出来

<hr>

with 语句

和 视图类似的, 我们还有 **with 语句**, 也可以创建一个虚拟表, 但是show tables不能显示

```sql
/* 下面我们就可以用 table_name 代替 select * from account 语句*/
with table_name as (select * from account)
```

<center style='font-size:30px ;color:red'> MySQL 并不支持 with语句





<center style='font-size:20px'> 连接表



我们可以在查询的时候合并多个表, 然后对这个合并表执行查询操作. 比如 :

```sql
/* 通过person_id 连接 person 表 和 favorite_food 表*/
/* ... inner join ... on... */
select person.person_id, person.age, favorite_food.food from 
person inner join favorite_food 
on
person.person_id = favorite_food.person_id;
```

**此时返回的就是 两个表的合并表**

由于我们在字段的选择以及其他的地方我们需要 **指定我们选择的是哪一个表 e.g person.person_id**

为了简便操作, 我们对其使用别名 : 

```sql
/* 通过person_id 连接 person 表 和 favorite_food 表*/
/* ... inner join ... on... */
select p.person_id, person.age, f.food from 
person p inner join favorite_food f
on
p.person_id = f.person_id;

/* 当然也可以加 AS 增加可读性*/
select p.person_id, person.age, f.food from 
person AS p inner join favorite_food AS f
on
p.person_id = f.person_id;
```



### where 子句

where 语句中可以用到的符号

#### 比较运算符

- = 等于

- <> 或者 != 都表示不等于

- <=> 安全的等于

  ```sql
  /* 返回null */
  select null=null
  
  /* 返回1 */
  select null<=>null
  ```

- <= 

- <

- \>=

- \>

#### 逻辑运算符

可以通过条件限定查找的记录是什么, 主要就是两个逻辑符号:

- AND

- ALL , ANY

  all 运算符会和结果集的所有的元素比较一遍

  ```sql
  /* 表示要大于所有的结果集中的元素 */
  /* 大于所有才为真*/
  select * from account where blance > all (1, 2, 3)
  
  /* 大于一个就为真*/
  select * from account where blance > any (1, 2, 3)
  ```

- NOT 

- EXISTS, NOT EXISTS

  多用于判断 **子查询中返回的数据集存在与否**

  ```sql
  /* 如果存在子查询的数据集, 那么就之前父查询 */
  select * from account where exists (select * from product where product_cd = 'chk')
  ```

- OR

- IN  , NOT IN

  可以限定一个范围 e.g:

  ```sql
  /* 选择年纪为18, 19, 20的人*/
  
  select * from person where age in (18, 19, 22);
  ```

- LIKE 模糊查找 

  %STRING% 匹配表示 字符串含有STRING且左边, 右边的字符任意

  %STRING 匹配表示, 结尾必须为STRING, 左边字符任意

  STRING% 匹配表示, 开头必须为STRING, 右边字符任意

  ```sql
  /* 选择名字中带有fang的人 */
  select * from person where name like '%fang%';
  ```

通过逻辑符号可以执行多个限定条件



#### group by 和 having子句

group by 可以对 **结果集进行分组** , 分组的依据就是 **如果group by后面的字段值相等, 那么就可以归为一组**, e.g.

```sql
/* 语法 */
/* aggregate_function 为聚合函数 */
SELECT column_name, aggregate_function(column_name)
FROM table_name
WHERE condition

/* 在结果集中, column_name1相同的列, 被归位一组 */
/* 然后通过select 里面的聚合函数, 对这些组聚合操作 */
GROUP BY column_name

/* having 语句加上筛选项, 对结果进行过滤, having 里面一般都是聚合函数的一些逻辑条件 */
having aggregate_function(column_name) condition
```

- group by 和 having 一般是一起出现的.
- group by 语句一般用来结合 **聚合函数** 一起使用的

##### having 子句 和 where 子句的区别

- Where 是一个 **约束声明** ，使用Where约束来自数据库的数据，Where是在结果返回之前起作用的，**Where中不能使用聚合函数**
- Having是一个 **过滤声明**，是在查询返回结果集以后对查询结果进行的过滤操作，**在Having中可以使用聚合函数**



#### 关于聚合函数

1. 常用的聚合函数有 : 

- count() 计数
- sum() 求和
- avg() 平均数
- max() 最大值
- min() 最小值

1. 注意聚合函数不一定只能在 group by 语句中才能使用
2. count(*) 会统计所有的记录,且不会忽略null记录,  count(val)会自动的忽略null记录



#### 关于Group by 的几点问题:

1. select 子句选择的是一定是 : 

   - group by 的字段
   - 包含在聚合函数其他列

   **即 select 不能选择另一个不是 group by 的列**

   ```sql
   /* 这种是不允许 ❌ 的 */
   select a from user group by b
   ```

1. 多个字段 group by

   ```sql
   /* 可以选择的字段, 仅限于group by的字段中  */
   /* 此时只有 a, b 都一样, 才会被当做一个分组 */
   select a, b from user group by a, b;
   ```



### order by 子句

**直接对某一列进行排序**

可以使得结果根据某个字段进行排序, 同时可以指定是 **升序asc** , 还是 **降序desc**

```sql
select * from person order by age;
/* 不指定默认为升序 */
/* 上下结果相同 */
select * from person order by age asc; 

/* 结果降序 */
select * from person order by age desc; 
```



**依据两列及以上进行排序**

```mysql
/* 例如依据 age 和 name 进行排序 */
/* 注意先对列明重命名 */
select age a, name n from person order by a, n
```





## 六. 高级操作

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























































