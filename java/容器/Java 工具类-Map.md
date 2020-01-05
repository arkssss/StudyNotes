[TOC]

# Java 工具类-Map



## 一. 概述

* Key => Value的存储结构 : 给定一个键和一个值，你可以将该值存储在一个Map对象. 之后，你可以通过键来访问对应的值。

* **键值对可以是 任意的 Object**

* 初始化方式 :

  ~~~java
  /*
  	e.g. 初始化HashMap
  	注意存放的 ArrayList 只是各个 String 里的引用
  	也就是说, 取出ArrayList, 赋给变量, 此时修改变量会导致Map里面的值发生变化
  */
  HashMap<String, ArrayList<String> > myMap = new HashMap<>();
  
  
  
  
  ~~~






## 二. Map相应子类



![img](https://github.com/CyC2018/CS-Notes/raw/master/notes/pics/774d756b-902a-41a3-a3fd-81ca3ef688dc.png)

Map父亲类方法, 依然从 增, 删, 该, 查入手





**查看 : **

~~~java
/*
	查看Map中是否包含 Key 值的映射
	boolean containsKey(Object key)
	
	Exception: 
		NullPointerException : 如果传递的Key为Null, 则抛出.
		ClassCastException : 如果传递的Key值不是该 Map 规定的类型, 则抛出
*/	

// 如果 myMap 存在 "hello" 为 key 的键值对, 返回 True, 否则返回false
myMap.containsKey("hello");

~~~



<hr>

### HashMap

HashMap 基于哈希表实现



#### HashMap 的几种遍历方式

~~~java
/*
	1. 利用迭代器
*/
Map map = new HashMap();
Iterator iter = map.entrySet().iterator();
while (iter.hasNext()) {
    Map.Entry entry = (Map.Entry) iter.next();
    Object key = entry.getKey();
    Object val = entry.getValue();
}
~~~





~~~java
/*
	2. 先获得 keySet
	   再通过 get 获得
*/
Map map = new HashMap();
for(E key : map.keySet()){
    value = map.get(key);
}
~~~





























