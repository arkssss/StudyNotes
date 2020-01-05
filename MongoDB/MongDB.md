# MongDB

[TOC]

作为缓存层而存在, 和 `redis` 最大的区别在于, `MongoDB` 存储的数据为 `BSON` 数据, 即为结构化的数据 

所谓 `BSON` 其实即为 `JSON` 的扩展版本

`MongDB` 支持可类似 `SQL` 的结构化查询操作

以下为 `MongDB` 和 `SQL` 语句之间的 概念对比

| SQL      | MongoDB    |
| -------- | ---------- |
| Database | Database   |
| table    | collection |
| row      | document   |
| column   | field      |
| index    | index      |



# 插入一条数据 

~~~json
// db不变, solution2即为我们此时的 table
db.solution2.insert(
... {"GAME":{ "ID":["game number"],
...           "game number":1,
...           "venue":"Anfield",
...           "referee":"Sal Monella",
...           "home team":"FC Liverpool",
...           "score home team":1,
...           "away team":"IF Brommapojkarna",
...           "score away team":1 
...         }
... }
... );
~~~



# find()

`db.collection.find(query, projection)`

-- query 可选 => 指定查询条件

-- projection 可选 => 指定返回的字段

`>db.col.find().pretty()` 使用 `pretty()` 可以让其更加的易读



## query 从句

**query 限定语句和 where 之间的比较 :**

| 等于       | `{<key>:<value>`}        | `db.col.find({"by":"菜鸟教程"}).pretty()`   | `where by = '菜鸟教程'` |
| ---------- | ------------------------ | ------------------------------------------- | ----------------------- |
| 小于       | `{<key>:{$lt:<value>}}`  | `db.col.find({"likes":{$lt:50}}).pretty()`  | `where likes < 50`      |
| 小于或等于 | `{<key>:{$lte:<value>}}` | `db.col.find({"likes":{$lte:50}}).pretty()` | `where likes <= 50`     |
| 大于       | `{<key>:{$gt:<value>}}`  | `db.col.find({"likes":{$gt:50}}).pretty()`  | `where likes > 50`      |
| 大于或等于 | `{<key>:{$gte:<value>}}` | `db.col.find({"likes":{$gte:50}}).pretty()` | `where likes >= 50`     |
| 不等于     | `{<key>:{$ne:<value>}}`  | `db.col.find({"likes":{$ne:50}}).pretty()`  | `where likes != 50`     |

~~~json
// where 100 < age < 200
db.col.find({"age" : {$lt:200, $gt100}}).pretty();
~~~





**quert 中 AND**

要 **AND** 查询条件, 直接在 **query中** 增加一个键值对就好了

e.g. : 	

~~~json
// 返回 集合中 name = fz AND gae = 18 的记录
db.col.find({"name":"fz", "age" : 18}).pretty()
~~~



**query 中 OR**

**使用 OR 则需要使用特殊的 链接词 $or : [{}, {}, ...]**

e.g.

```
>db.col.find(
   {
      $or: [
         {key1: value1}, {key2:value2}
      ]
   }
).pretty()
```

~~~json
// 即为 where name='fz' or age = 18
db.col.find({$or : [{"name":"fz"}, {"age" : 18}]}).pretty()
~~~



**AND 和 OR 联合使用**

**直接在 将 {} 和 or 并列即可**

~~~json
// where class=18 and (name='fz' or age = 19)
db.col.find({"class":"18", $or:["name":'fz', "age" : 18]}).pretty();
~~~



**ALL 语句**

~~~
db.col.find(
	{“age” : {"$all" : [a, b, v]}}
)
~~~







**$type 操作符**

可以在 qeury 中限定我们要查找的语句的类型

找出 `title`	中 type 为string 的记录

`db.col.find({"title":{$type : "string"}})`







## projection 从句

可以指定返回的 字段

e.g. 则只返回 name 字段

~~~
db.col.find({{"name":"fz"}, {"age" : 18}}}, {"name" : 1}).pretty()
~~~



# update() 更新

更新一个表的字段

~~~json
db.col().update(
	<query>,
	<update>,	// "$set" : {//字段}
	{
        upsert : <bool>,
        multi : <bool>,
        wirteConcern : <doc>
	}
)
~~~

例如 :

~~~json
db.col.update(
	{"name" : "fz"},
	{"$set" : {"age" : "18", "class" : "20"}},
)
~~~

以上的 `update` 默认只会去修改发现的第一个文档, 如果修改多条相同的文档吗, 则需要设置 `Multi true` :

~~~
db.col.update(
	{"name" : "fz"},
	{"$set" : {"age" : "18", "class" : "20"}},
	{"Multi" : true},
)
~~~



#remove() 删除记录

`db.col.remove()`  删除一个距离

~~~json
db.collection.remove(
   <query>,
   {
     justOne: <boolean>,
     writeConcern: <document>
   }
)
~~~

默认是删除第一个查找到的记录

justOne 可以设置为删除所有

e.g

~~~json
db.col.remove(
	{"title" : "fz"},
    // 全删除
	{"justOne" : false}
)
~~~









# Limit() 方法

用来限制返回数据的记录的个数

`db.col.find().limit(2) ` 只返回 2 条记录



# Skip() 方法

用于指定跳过一定数量的记录

`db.col.find().Limit(1).Skip(1)`

即返回一条, 跳过一条

即为返回第二条



# Sort() 方法

类似乎 `order by()` 方法

`db.col.find().sort({key : 1})`

可以使得查询出来的集合 `升序` , `降序` 排列

其中 1 为生序, -1 为 降序



# createIndex() 方法

给  `MongoDB`  添加索引

例如 : 给某一个字段添加一个索引.

`db.col.createIndex({"title" : 1})`

给 title 添加一个升序索引



# aggregate() 方法



## $group 属性

聚合函数, 类似于 `group by()` 语句.

用法如下 :

~~~json
db.col.aggregate([
    {
        "$group" : {
            // group by title 
            "_id" : "title",
            // 自定义字段
            // ...
            "myFiled" : {
                // 表示 myField 是对 by的所有记录个数求和
                // 等于 count(*)
                "$sum" : 1
            }, 
            "myFiled2" : {
                // sum 后是 字段名, 表示对该字段 group by 的求和
                "$sum" : "age",
            },
            // 类似的还有取平均的操作
            "myFiled3" : {
                "$avg" : "age",
            }
            
        }
    
    }
])
~~~





## $project 属性
































































