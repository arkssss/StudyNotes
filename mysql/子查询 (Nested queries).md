## 子查询 (Nested queries)

* 什么是子查询
* 子查询类型
  * 非关联子查询
  * 关联子查询





### What is 子查询?

1. 子查询就是 包含在另一个SQL语句中 **内部的查询** 通常用括号()包起来.  

2. 子查询发生在 包含在语句执行之前

3. 子查询返回的结果也是一个数据集
   * 单行单列 => **标量子查询**  从而可以被用于常用比较运算符(=, <, >, <>, >=, <=)中.
   * 单行多列 => 不可以用常用比较运算符, 但是可以用于 in, not in
   * 多行多列 => 也可以用 in, not in语法

4. 子查询返回的数据在查询结束以后会被丢弃

子查询的例子 :

#### 单行单列

~~~sql
/* 在where中设置子查询语句*/
/* select max(account_id) from account 也可以做一个独立的查询语句*/
/* 此处的子查询变为标量子查询 */
select * from account where account_id = (select max(account_id) from account);
~~~

#### 单行多列



#### 多行多列

~~~sql
/* in, not in 同样也可以处理多行多列的比较情况 */
/* 在要查询的多列用括号包起来 */
select email, age from person where (email, age) not in (select email, age from preson_2);
~~~





### 子查询类型

* 在 from 子句后面使用子查询, 我们需要对其进行重命名

  ~~~sql
  /* 如果不加 as p 则会报错*/
  select * from (select * from person) as p
  ~~~

* 在 where 子句后面可以不用重命名



#### 非关联子查询

子查询中的 **SQL可以单独执行** , 而不需要包含语句中的任何内容.

我们大部分开发中, 遇到的都是非关联类型的





#### 关联子查询

子查询的内容包含了父查询的内容, 从而不能被单独执行

~~~sql
/* 可以看到子查询内部引用了外部的表 c*/
/* 从而造成了关联*/
select * from customer c
where 2 = (select count(*) from account a where a.cust_id = c.cust_id)
~~~











 