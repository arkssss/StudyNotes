[TOC]

# #1. 事务

事务事务的概念ACID1. 原子性 (Atomicity)2. 一致性 (Consistency)3. 隔离性 (Isolation)4. 持久性 (Durability)AUTOCOMMIT数据库锁	锁的粒度MyISAM 表锁MyISAM 如何加表锁InnoDB 锁隐式和显式锁定隔离级别

## 事务的概念

可以将多个 **一条或者多条SQL语句聚合在一起, 且这些语句, 要么所有都可以正确的执行, 要么都不能执行(原子性)**

事务可以被更专业的定义为 : **事务指的是满足 ACID 特性的一组操作**

如下图, 启动事务之后, 数据库的 **相关行进入中间态**, 直到commit之后, 如果所有的都被正确执行, 才将这一系列SQL的结果提交, 如果有失败, 则执行roolback操作, 从而保证数据的一致性.

![img](file:///Users/ark/%E6%96%87%E6%A1%A3%E7%AC%94%E8%AE%B0/%E5%90%8E%E7%AB%AF%E6%8A%80%E6%9C%AF%E6%96%87%E6%A1%A3%E7%AC%94%E8%AE%B0/MySQL/image/2019-7-19-transaction.png?lastModify=1631464854)

从sql表述上如下: 

```
/* 启动事务*/
start transaction;
  /*
  sql code
  ...
  */
if sql exc success 
  commit;
else 
  roolback;
```

## ACID

1. 原子性 (Atomicity)

   事务被视为 **最小的不可分割的单元**, 要么事物内的SQL被全部提交, 要被全部失败则回滚

   回滚操作是实现依赖于 **回滚日志** , 可以记录事务执行的操作, 失败则反向执行即可

2. 一致性 (Consistency)

   数据库在事务的执行前后都是保持一致性的, 所有事务对一个数据的读取结果都是相同的.

3. 隔离性 (Isolation)

   一个事务所做的修改在最终提交以前，对其它事务是不可见的。

   举个例子 : 在一个事务的执行过程中, 就算此时对某一行进行了修改. 此时其他用户对这一行进行 **查询时候**

   **查询的还是之前的值**, 只到事务commit后, 才能查询到新的值

4. 持久性 (Durability)

   一旦事务提交, 就会被 **永久保存**, 即使服务器崩溃, 结果也不会丢失

实现方式 : 利用 **重做日志**

[1] 实际上, MySQL的事务过程对某一行实行的写锁, 及其他用户对相关行还是可以进行读取 

## AUTOCOMMIT

MySQL 默认采取了自动提交的方式, **即使不显示的 start transaction 开启一个事务**, 服务器也会将每个操作作为一个事物提交

MySQL 允许关闭自动提交模式 :

```
/* 
  关闭自动提交模式 
  一旦关闭自动提交模式, 所有的SQL语句都会被认为在同一个事务范围
  并且必须显示的对事务进行 提交 或者 回滚
*/
set autocommit = 0
```

在 **InnoDB based** 的数据库上, 事务是一个最小的逻辑处理单元. 默认在没有开启事物的情况下, **InnoDB 一个语句就是一个事物 (隐式的开启, 提交)**

## 隔离级别

| 隔离级别         | 描述                                                         | 导致问题                                                     |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| READ-UNCOMMITTED | 事务之间可以读取 **未提交** 的数据。                         | 脏读： 事务1读取了事务2对某个字段 **未提交的修改**, 然后事务2 Rollback, 此时事务1使用的数据即为脏数据 |
| READ-COMMITTED   | 事务之间只能读取 **提交** 的数据。                           | 不可重读：事务1, 读取事物2提交前后的字段结果不一样           |
| REPEATABLE-READ  | 解决了不可重复度的问题，保证同一个事务内读取同一数据结果一样。 | 幻读：事务1执行时，事务2在该范围插入新的记录，从而导致幻行。 |
| SERIALIZABLE     | 强制事务串行执行，避免幻读的问题。                           | 过度使用锁，导致执行时间长，很少用这种级别。                 |

第三种 REPEATABLE-READ 可重复读的隔离级别为 MySQL 的默认隔离级别。

一个事务便可以看成一个线程, 和并发程序一样, 多事务并行的话, 可能会造成下列一些问题 :

- **脏读（Dirty read）** :  一个事物对一个数据进行了修改, **但是还没有提交的时候**, 此时另一个事务读取了这个 **还没有提交的** 的数据, 从而形成了不正确的操作 e.g.

  ![DirtyRead](file:///Users/ark/%E6%96%87%E6%A1%A3%E7%AC%94%E8%AE%B0/%E5%90%8E%E7%AB%AF%E6%8A%80%E6%9C%AF%E6%96%87%E6%A1%A3%E7%AC%94%E8%AE%B0/MySQL/image/DirtyRead.png?lastModify=1631464854)

- **丢失修改（Lost to modify)** : 两个事务同时对一个数据进行了修改, 便可能造成其中一个修改丢失 .e.g. 事务一 执行 A = A +1 的时候, 事务B执行 A = A + 10, 由于两个事务读取的 A 一样, 从而, 最后会丢失一次修改

- **不可重复读（Unrepeatableread）:** 值在一个事务内, 多次读取一个数据, 在前一次读取后, 另一个事务对这个数据进行了修改, 从而下一次读取造成了 **两次读取不一致的** 的情况 e.g.

  ![Non-repeatable](file:///Users/ark/%E6%96%87%E6%A1%A3%E7%AC%94%E8%AE%B0/%E5%90%8E%E7%AB%AF%E6%8A%80%E6%9C%AF%E6%96%87%E6%A1%A3%E7%AC%94%E8%AE%B0/MySQL/image/Non-repeatable.png?lastModify=1631464854)

- **幻读（Phantom read）:** 在一个 事务T1 读取多行数据的时候, 另一个事务T2 在对这多行数据进行了 **删除 OR 新增** , 从而事务T1 再次读取的时候 便发现可原来并不存在的数据

![Phantom_read](file:///Users/ark/%E6%96%87%E6%A1%A3%E7%AC%94%E8%AE%B0/%E5%90%8E%E7%AB%AF%E6%8A%80%E6%9C%AF%E6%96%87%E6%A1%A3%E7%AC%94%E8%AE%B0/MySQL/image/Phantom_read.png?lastModify=1631464854)

**不可重复度和幻读区别：**

不可重复读的重点是 **修改**，幻读的重点在于 **新增或者删除**

```
例1（同样的条件, 你读取过的数据, 再次读取出来发现值不一样了 ）：事务1中的A先生读取自己的工资为 1000的操作还没完成，事务2中的B先生就修改了A的工资为2000，导 致A再读自己的工资时工资变为 2000；这就是不可重复读。

例2（同样的条件, 第1次和第2次读出来的记录数不一样 ）：假某工资单表中工资大于3000的有4人，事务1读取了所有工资大于3000的人，共查到4条记录，这时事务2 又插入了一条工资大于3000的记录，事务1再次读取时查到的记录就变为了5条，这样就导致了幻读。
```



## InnoDB事务

### MVCC

多版本并发控制允许不同事务在不加锁的情况下**查询数据**, 极大的提高了事务并发量

在InnoDB设计中, `select xxx` 语句是不会加锁的, **如果此时查询的记录正在被修改, 则会查询记录记录之前的版本, 而不会等待修改完成**

~~~mermaid
flowchart TD
	query --> Con{XLock}
	Con --> |No|Record[Record]
	Con --> |yes|Snapshot[Snapshot]
	Snapshot --> return
	Record --> return
~~~

* snapshot : 即数据版本快照, 记录于undo-log, mvcc随机读取

* 不同隔离级别下, 读取的版本规则不同, 以下数据为例

  | id   |
  | ---- |
  | 1    |

  `READ-COMMIT` 读以提交的隔离级别下, 事务会读取当前数据 **已提交的最新版本**

  ~~~mermaid
  sequenceDiagram
  	tran1 ->> svr: begin trans
  	tran2 ->> svr: begin trans
  	tran2 ->> svr: select * from t where id = 1
  	svr ->> tran2: row: 1
  	tran1 ->> svr: update t set id=2 where id = 1
    tran2 ->> svr: select * from t where id = 1
    svr ->> tran2: row: 1
    tran1 ->> svr: commit
    tran2 ->> svr: select * from t where id = 1
    rect rgba(0, 255, 0, .1)
    svr ->> tran2: empty
    end
  ~~~

  `REPEATED-READ` : 可重读的隔离级别下, 事务周期内会读取 **当前事务开始时的版本**

  ~~~mermaid
  sequenceDiagram
  	tran1 ->> svr: begin trans
  	tran2 ->> svr: begin trans
  	tran2 ->> svr: select * from t where id = 1
  	svr ->> tran2: row: 1
  	tran1 ->> svr: update t set id=2 where id = 1
    tran2 ->> svr: select * from t where id = 1
    svr ->> tran2: row: 1
    tran1 ->> svr: commit
    tran2 ->> svr: select * from t where id = 1
    rect rgba(0, 255, 0, .1)
    svr ->> tran2: row: 1
    end
  ~~~

### Redo-Log 

* redo log 保证事务的持久性, 是InnoDB层产生的
* redo log 时物理层log, 不记录逻辑语句, 而是当前数据页的物理状态

~~~mermaid
sequenceDiagram
	trans ->> svr: begin trans
	trans ->> svr: update xxx
	svr ->> redoLogBuffer: 变化记录到缓冲区
	trans ->> svr: delete xxx
	svr ->> redoLogBuffer: 变化记录到缓冲区
	trans ->> svr: commit
	svr ->> redoLogBuffer: fsync 刷盘
	redoLogBuffer ->> redoLogFile: 持久化到文件
	redoLogFile ->> redoLogBuffer: ok
	redoLogBuffer ->> svr: ok
	svr ->> trans: ok
~~~

一般情况下, **每当事务提交时, InnoDB都会将Redo log 持久到文件进行存储, 存储成功后才会结束事务** 通过这种机制保证了事务的持久性

fsync 的时机可以通过 `innodb_flush_log_at_trx_commit` 进行配置

* 值1: commit 时进行刷盘 (默认)
* 值2: 定时刷盘 fsync, 默认为1s, 可能丢失数据, 违反ACID的持久性原则
* 值3: redoLogBuffer 超过内存一半时进行刷盘



### Redo-Log 和 Binlog 的区别

| 层面     | binlog                                                       | redolog                                    |
| -------- | ------------------------------------------------------------ | ------------------------------------------ |
| 日志性质 | mysql 层产生, 是逻辑日志, 记录数据变更(update, insert, delete)语句 | InnoDB引擎产生, 物理日志, 记录物理页的状态 |
| 记录时机 | 事务提交时记录                                               | 每次变更语句都记录                         |



### Undo-Log

undo日志确保了InnoDB的 **事务回滚, MVCC** 功能

undo log 内容存放于特定的 undo segment, **是逻辑日志** 如当事务执行了一个 INSERT, 则 undo 会对应记录 DELETE 操作

undo-Log 可以分为以下几类

* `Insert undo log` : Insert 操作中产生的 undo log, 这类可以在事务提交后直接删除
* `Update undo log` : delete, update 操作产生的 undo log, 这类在事务提交后不能立即删除, 因为可能有别的事物需要访问(MVCC), 这类会加入一个删除链表中, 由 `purge` 线程负责删除







# #2. 数据库锁	

> [数据库锁](https://www.cnblogs.com/leedaily/p/8378779.html)



## 锁的粒度

数据库的锁分为三种:

- 行锁 : 表中的一行记录被锁定
- 页锁 : 这里的页指的是一个内存页的数据
- 表锁 : 整个表都被锁定

各个粒度的选择各有利弊 : 粒度越细的锁, 所占的资源越多, 但是用户的自由性越大

在选择锁的时候, 需要做锁开销和并发行的权衡



**从数据库类型上看 :** 

| 数据库类型 | 支持类型         |
| ---------- | ---------------- |
| MySQL      | 行锁, 页锁, 表锁 |
| SQL Server | 行锁, 页锁, 表锁 |
| Oracle     | 仅支持 行锁      |



**从数据库引擎上看 :**

| Engine             | 支持锁类型             |
| ------------------ | ---------------------- |
| InnoDB (Mysql默认) | **行锁 (默认)** / 表锁 |
| MyISAM             | 表级锁                 |
| MEMORY             | 表级锁                 |
| BDB                | 页面锁                 |





## MyISAM 表锁

对于 **MyISAM** 表级锁有两种模式, **读锁, 写锁**

- 如果一个表被加了读锁, 那么 **不会阻塞其他用户的读操作, 但是会阻塞其他用户的写操作**
- 如果一个表被加了写锁, 那么 **会阻塞其他用户的读写操作**



## MyISAM 如何加表锁

给 **MyISAM** 添加表锁有 **两种方式**

1. 自动添加

   MyISAM 在执行一个 `select` 语句的时候, 会自动的给数据表加上一个读锁

   MyISAM 在执行 `delete, update,insert 等` 语句的时候, 会自动给表上一个写锁

2. 显示添加

   由于 **MyISAM 不支持事物的操作, 所以显示的添加锁一定程度上是为了模拟事物的操作**

   ```
   -- 表示给 myTable 添加一个读锁
   Lock table myTable read local
   
   select ...
   select ...
   
   Unlock table;
   ```

## InnoDB 锁

和 **MyISAM** 最的不同是

1. InnoDB 支持事务
2. InnoDB 支持行锁

InnoDB 实现了两种类型的行锁, **共享和排他锁** 

### XS 锁

| 锁类型   | 功能                                                         |
| -------- | ------------------------------------------------------------ |
| 共享锁 S | 事务在读取一行数据记录时候, 会加上 S 锁, 此时再有读请求过来会被满足, 但是写请求被阻塞. 如果一个事务 A 对一个数据集上了 S 锁, 那么 事物 A 无法对数据集进行修改, 只能读相关的数据集. 且此时其他的事务可与对这个数据集上 S 锁, 但是还是无法上 X 锁 |
| 排他锁 X | 阻止其他事物取得相同数据集的 S, X 锁. 如果事务 A 对于一个数据集上了 X 锁, 那么会阻止其他事务上 S, X 锁 |

**InnoDB 下 :**  

| 操作                     | 锁               |
| ------------------------ | ---------------- |
| select xxx               | 无锁, mvcc读快照 |
| select xxx in share mode | S                |
| select xxx for update    | X                |
| update                   | X                |
| insert                   | X                |
| delete                   | X                |
| ------                   |                  |
| alter                    | 表X  							|
| drop                  | 表X  |
| lock tables xxx read  | 表S  |
| lock tables xxx write | 表X  |

### IX, IS锁

IX, IS 分别解释为意向共享, 意向排他锁

他们一般是表级别的, 用与表示当前表 **是否有记录存在上锁的情况**, 当记录被加 X 或者 S锁时, 其所在的表会同时被加上 IX 或者 IS 锁, 表明此表中有记录已经被上了锁

这样做的好处可以让下面的场景以 O(1) 的时间复杂度执行

* 当操作需要给某个表加表X锁时, 如果表已经存在IX,IS锁, 则可以直接阻塞, 避免了去遍历所有记录的加锁情况



### Next-Key Lock 间隙锁

InnoDB 通过 `Next-Key Lock` 的机制在 `REPEATED READ` 的隔离级别下解决了幻读的问题

以如下表为例, id 为主键, age 为辅助索引

| id   | amout | age  |
| ---- | ----- | ---- |
| 1    | 100   | 10   |
| 2    | 200   | 20   |
| 3    | 300   | 51   |
| 4    | 400   | 25   |

`update xxx where age = 20`

此时 age 为普通索引, 执行此操作时, 数据库将锁定 (10, 20], [20, 25) 范围内的的数据, 比如此时要插入一条 age = 15 的数据就会阻塞

`update xxx where id = 2 `

此时 id 为唯一索引, 数据库仅锁定 id=2 的记录, 其他记录不受影响

`update xxx where amout = 200`

此时 amout 不是索引, 数据库将会锁定所有记录

### 加锁图

~~~mermaid
flowchart TD
A[开始] --> B{是否走索引?}
B -- No --> E[全记录锁-性能最差]
B -- Yes --> C{唯一索引?}
C -- Yes --> G{ '=' 查询条件? }
G -- Yes --> D[记录行锁-性能最优]
G -- No --> F[间隙锁]
C -- NO --> H{ '=' 查询条件? }
H -- Yes --> I[间隙锁]
H -- No --> J[间隙锁]
~~~





# #3. 索引

在向表中插入一行数据的时候, 数据库并不会试图将数据放到表的任何特定的地方, 即数据库 **并不会** 依据某一个字段的大小顺序, 去存储一条记录

相反, 服务器只是 **简单的将数据放在了下一个可以被存放的位置**

所以这就导致了, 如果我们要寻找一条数据, 很可能要通过 **表扫描$^{[1]}$** 的方式才能找到它. 

从而当表中记录特别多的时候, 通过表扫描的方式查找数据便会非常的耗时, 至此我们引出索引概念. 以减小我们查找数据时候的时间复杂度

<small>[1] 表扫描就是依次访问数据库中所有的记录, 找出符合的加入结果集</small>.

## 索引类型

数据库的 **索引类型** 包括如下几种类型 : 

* 唯一索引

  ~~~sql
  /*
  	添加唯一性束缚 的时候, 数据库都会自动的给这些字段去添加唯一性索引
  */
  
  /* 通过建表的时候创建 */
  create table test_unique_index( 
      id smallint unsigned, age smallint,
      constraint pk_table primary key(id), 
      constraint unq_table unique(age)
  );
  
  /* 后期通过 alter table 天添加 */
  alter table student add unique uni_index (id) 
  /* OR */
  alter table student add constraint uni_index unique(id)
  ~~~

  **唯一性索引** 和 **主键索引的区别** 

  1. 主键索引是唯一性索引的一个特殊类
  2. 唯一性索引是允许字段为 NULL 的 
  3. 主键索引是不允许字段为 NULL 的

* 联合索引

* 普通索引

* 主键索引

## 索引数据结构

数据库的 **索引数据结构** 包括如下几种类型 : 

* 🌟 B+  树索引
* 哈希索引
* 全文索引
* 空间数据索引



### B+ 树索引

* B+ 树是一个多阶的平衡搜索树, 所有的叶节点同高

* 节点保存索引值, 且父节点的值一定存在于子节点中, 叶节点保存所有的数据

* 父节点保存的为子节点序列的最大或最小值

* 在树的高度而言 B+ 树的高度为 $log_mN$ , 是小于传统的平衡二叉树, 从而查找效率比平衡二叉树更高

* B+ 树所有叶子结点有序首尾相连形成一个链表, 这样做的目的是 极大了方便了范围查询的查询效率

  ~~~sql
  -- B+ 数先找到 id 为1 的叶子结点, 然后往后遍历到100 即可
  select * from student where id > 1 and id < 100
  ~~~

  **注意虽然 B+ 数的叶子结点首尾顺序相连形成一个链表, 但是查找的时候, 还是需要从跟结点出发, 而不能直接从叶头出发**



### 哈希索引

基于 `Hash` 的索引, 可以实现 数据的 `O(1)` 查找

## MySQL 下索引操作

注意 索引是在存储引擎下实现的,  而不是在服务层实现的, 所以不同的存储引擎有着不同的索引实现

`MySQL (8.0)` 下默认的索引为 **B+ 树** 的形式.

如果MySQL建立一张表, 引擎会自动的将 **表的主键, 外键** 作为此表的索引. 也就是说, 一个表的索引可以有多个

~~~sql
/*
	* 增加一个索引
	* 删除一个索引
	* 查看一个索引
	注意以下为 MySQL 下的索引语句, 不同的数据库服务器, 或许有不同的语句
*/


/*
	查看当前表的索引
*/
show index from table_name



/*
	给一个表创建一个索引
	alter table 
		table_name 
	add index 
		index_name (field_name)
*/
alter table student add index my_index (student_id)


/*
	删除一个索引
	alter tabel
		table_bane 
	 drop index
		index_name
*/
alter table student drop index my_index;
~~~

## 主键索引和非主键索引

* **主键索引 :** 默认是数据库创建, 且不能为空, 且数据库一般默认主键索引是 **聚集索引**,  但是也可以在创建表的时候进行指定为 **非聚集索引**

* **非主键索引 :** 需要人工创建, 且数据可以为空, 且可以声明为 **唯一性索引**

## 聚集索引和非聚集索引

**聚集索引** 在一个表里面只能有一个, 且就是记录排列的物理顺序

* 对于 **聚集索引** 来说, 在 `B+` 树的叶节点, 存储的就是要查找的数据了, 一般来聚集所有即为 **主键索引**, 一个搜索过程如下

* 但是对于 **非聚集索引** , `B+` 树的叶节点 **存储的是聚集索引的key**		

## 联合索引与最左原则

* 需要使用 索引 查询的字段要加在 **Where** 语句中
* 如果 **Where 条件是 OR 关系** , 那么加索引不起作用
* 索引匹配符合 **最左原则**

对于 联合索引的查找, 满足最左匹配原则, 即一次查询可以只使用索引中的一部分, 但一定要是最左侧的部分 e.g : 

~~~
(a, b, c) 的联合索引 可以支持如下的查询
1. a
2. a, b
3. a, b, c
~~~







# #4. 数据库查询优化方案

## 数据库缓存

如果查询有大量的相同重复的 `sql` 语句, 可以直接利用数据库缓存的机制, 将这个查询的结果存储于 **内存** 

且通过一个 `hashMap` 去保存 `key` 即为这个 `sql` 语句. 如果运用到相同的 `sql` 那么直接通过这个散列表获得

不需要再去解析, 优化, 执行 `sql` 了

**如果这个表修改了, 那么使用了这个表的所有的缓存将不再有效, 查询缓存会被清空**

## 通过 Expain 分析索引使用情况

~~~mysql
# 可以通过 exapin 语句分析出某一个 select 的执行情况
expain select xxx
~~~

| Column                                                       | JSON Name       | Meaning                                        |
| :----------------------------------------------------------- | :-------------- | :--------------------------------------------- |
| [`id`](https://dev.mysql.com/doc/refman/5.7/en/explain-output.html#explain_id) | `select_id`     | The `SELECT` identifier                        |
| [`select_type`](https://dev.mysql.com/doc/refman/5.7/en/explain-output.html#explain_select_type) | None            | The `SELECT` type                              |
| [`table`](https://dev.mysql.com/doc/refman/5.7/en/explain-output.html#explain_table) | `table_name`    | The table for the output row                   |
| [`partitions`](https://dev.mysql.com/doc/refman/5.7/en/explain-output.html#explain_partitions) | `partitions`    | The matching partitions                        |
| [`type`](https://dev.mysql.com/doc/refman/5.7/en/explain-output.html#explain_type) | `access_type`   | The join type                                  |
| [`possible_keys`](https://dev.mysql.com/doc/refman/5.7/en/explain-output.html#explain_possible_keys) | `possible_keys` | The possible indexes to choose                 |
| [`key`](https://dev.mysql.com/doc/refman/5.7/en/explain-output.html#explain_key) | `key`           | The index actually chosen                      |
| [`key_len`](https://dev.mysql.com/doc/refman/5.7/en/explain-output.html#explain_key_len) | `key_length`    | The length of the chosen key                   |
| [`ref`](https://dev.mysql.com/doc/refman/5.7/en/explain-output.html#explain_ref) | `ref`           | The columns compared to the index              |
| [`rows`](https://dev.mysql.com/doc/refman/5.7/en/explain-output.html#explain_rows) | `rows`          | Estimate of rows to be examined                |
| [`filtered`](https://dev.mysql.com/doc/refman/5.7/en/explain-output.html#explain_filtered) | `filtered`      | Percentage of rows filtered by table condition |
| [`Extra`](https://dev.mysql.com/doc/refman/5.7/en/explain-output.html#explain_extra) | None            | Additional information                         |

* type 描述此次sql的查询类型, 分为以下等级

  1. `system` : 此时查询为系统行, 通常只有一行

  2. `const` : 此时 sql 最多只有一个匹配行, 一般用于 **主键索引, 唯一索引** 的相等的情况

     ~~~mysql
     # primary_key 主键索引
     SELECT * FROM tbl_name WHERE primary_key=1;
     
     # primary_key_part1, primary_key_part2 唯一索引
     SELECT * FROM tbl_name
       WHERE primary_key_part1=1 AND primary_key_part2=2;
     ~~~

  3. `ref` : 此时 sql 匹配可能有多行, 且用到了索引但非主键索引, 唯一性索引

     ~~~mysql
     # unque_index a, b, c
     SELECT * FROM tbl_name WHERE key_column=a;
     ~~~

  4. `range`: 当使用索引列做范围查询时, 会出现这种类型

     范围包括  [`=`](https://dev.mysql.com/doc/refman/5.7/en/comparison-operators.html#operator_equal), [`<>`](https://dev.mysql.com/doc/refman/5.7/en/comparison-operators.html#operator_not-equal), [`>`](https://dev.mysql.com/doc/refman/5.7/en/comparison-operators.html#operator_greater-than), [`>=`](https://dev.mysql.com/doc/refman/5.7/en/comparison-operators.html#operator_greater-than-or-equal), [`<`](https://dev.mysql.com/doc/refman/5.7/en/comparison-operators.html#operator_less-than), [`<=`](https://dev.mysql.com/doc/refman/5.7/en/comparison-operators.html#operator_less-than-or-equal), [`IS NULL`](https://dev.mysql.com/doc/refman/5.7/en/comparison-operators.html#operator_is-null), [`<=>`](https://dev.mysql.com/doc/refman/5.7/en/comparison-operators.html#operator_equal-to), [`BETWEEN`](https://dev.mysql.com/doc/refman/5.7/en/comparison-operators.html#operator_between), [`LIKE`](https://dev.mysql.com/doc/refman/5.7/en/string-comparison-functions.html#operator_like), or [`IN()`](https://dev.mysql.com/doc/refman/5.7/en/comparison-operators.html#operator_in) 

     **注意 <> 也是可能走索引的**

     ~~~mysql
     SELECT * FROM tbl_name
       WHERE key_column = 10;
     
     SELECT * FROM tbl_name
       WHERE key_column BETWEEN 10 and 20;
     
     SELECT * FROM tbl_name
       WHERE key_column IN (10,20,30);
     
     SELECT * FROM tbl_name
       WHERE key_part1 = 10 AND key_part2 IN (10,20,30);
     ~~~

  5. `all`: 没有走索引, 全表扫描

# #5. MySQL 分布式设计

一般来说, 为了应对高并发的问题, MySQL 可以设计为 分布式, 也就是 **主从表设计模式** , 实现请求的 **读写分离**, 从而提高并发性能.

* 主表  : 主数据库一般是准实时的业务数据库, 用来进行 **写操作**
* 从表  : 和主数据库完全一样的数据库环境, 一般用来 进行 **读操作**

## 主从复制的好处

从不同的方面来说, 有以下三个好处 : 

1. 安全性 : 数据分散存储, 可以避免单机意外事故的发生

2. 高并发 : 多库存储, 降低单机上磁盘的 I/O, 提高响应速度. e.g. 对于有些报表的系统, 前台用 master, 报表生成用 slave, 那么可以极大的提高并发量

## 复制过程

1. ##### 数据库有个bin-log二进制文件，记录了所有sql语句。

2. ##### 我们的目标就是把主数据库的bin-log文件的sql语句复制到从数据库。

3. ##### 然后在从数据的relay-log重做日志文件中再执行一次这些sql语句.

<img src = "/Users/ark/文档笔记/后端技术文档笔记/MySQL/image/2019-7-31-Distrbuted-MySQL.png" />



可以看到一共有三个线程配合工作 

1. Thread_1:  主库都创建一个线程然后发送 **binlog** 内容到从库
2. Thread_2 : 从库创建一个线程将 binlog 的文件 更新到 自己本地的 Relay log 中
3. Thread_3 : 执行刚刚更新的 SQL 语句



## 复制延时排查





































































