[TOC]

# Java 工具类-集合



## 一. 概述

集合是 用于 **存储对象** 的容器, 注意, 存放的为 **对象的地址**

集合是一个 **动态大小的容器, 即长度可变**

集合可以 **添加不同的对象** 

~~~java
/*
	注意集合不可以添加基本数据对象, e.g.
*/
// ❌
ArrayList<int> 
~~~



各个集合 **数据结构不同**, 从而出现了不同的集合

集合体系 结构图 : 



![img](https://github.com/CyC2018/CS-Notes/raw/master/notes/pics/73403d84-d921-49f1-93a9-d8fe050f3497.png)

也就是说, 集合接口下面有三大实现 

* **Set**	: 无重复的数据元集合
* **List : ** 支持随机返回的动态数组
* **Queue : ** 先进先出的队列





## 二. Collection 集合体系共同的父类

### Collection 方法

为所有集合元素的共有方法

#### 添加

~~~java
// 添加一个对象
boolean add(Object o);


// 添加一堆对象
boolean addAll(Collection c)
~~~



#### 删除

~~~java
// 删除一个对象
boolean remove(Object o);

// 删除一堆对象, 删除成功返回 true
// 注意传递的也是该 Collection 对象
boolean removeAll(Collection c)
    
// 移除所有的对象
void clear();
~~~



#### 判断

~~~java
// 判断是否包含一个对象
boolean contain(Object o);


// 判断是否有一堆对象
boolean containAll(Collection c);


// 判断集合是否为空
boolean ifEmpty();
~~~



#### 获取

~~~java
// 获取集合长度
// 注意不是length
int size();


// 获取一个迭代器对象
Iterator iterator();
~~~



#### 其他 (并, 交, 差 集) 🌟

~~~java
/*
    和 c 取交集
    和 removeAll 功能相反
*/
boolean retainAll(Collection c);

/*
	对 A, 求B的差集
	A.removeAll(B)
*/
boolean removeAll(Collection B);
    
/*
	对 A, B 集合取并集
	A.addAll(B)
*/
boolean addAll(Collection B);


// 将集合的元素转为数组
Object[] toArray()
    
// 对集合打印, 直接用 System 打印
System.out.println(Collection);
~~~







#### 利用迭代器 遍历集合

~~~java
Collection coll = new ArrayList();
coll.add("hello");
coll.add("world");

/*
	利用 for 循环读取
*/
for(Iterator it = coll.iterator(); it.hasNext();){
    // operator
    // it.next() 便返回此时集合的元素对象
    // 此时 it 执行完栈next() 语句之后, 会自动的跳到下一个集合元素中
    it.next()
}


/*
	 利用 while 读取
*/
Iterator it = coll.iterator();
while(it.hasNext()){
    // operator
    it.next();
}
~~~



<hr>

**迭代器原理**

迭代器 iterator(), 为一个容器的内部类, **且在各个容器中的实现方式不同, 因为每个容器的数据结构不同. ** 但是暴露在外面的接口一样. iterator为所有容器去取出的对象



## 三. List 子类



### List 常用实现及list特点

**List 子类常用的为 : **  

* **ArrayList**
* **LinkedList**
* **Vector**

1. 首先三个实现都是支持角标访问的, 这也是`List`接口定义要实现的方法. 但是由于数据接口的不同访问的时间复杂度不同. 

   ArrayList 底层采用动态数组的结构实现, 所以通过角标访问元素是 O(1)

   LinkedList 底层采用双向链表, 通过角标访问元素是 O(n)

2. 数据安全性上看 : ArrayList, LinkedList 不是数据安全的, 也就是说, 在访问的时候不需要加锁, 从而效率很高, Vector为数据安全的



### list 常用操作

<hr>

List 支持 增, 删, 改, 查 四种操作

**添加**

~~~java
/*
	支持角标的方法插入
*/
void add(int index, element e);
void add(int index, collection coll);
~~~



**删除**

~~~java
/*
	返回被删除的元素
*/
Object remove(index);
~~~



**修改**

~~~java
Object set(int index, element e);
~~~



**获取**

~~~java
/*
	通过角标获取
*/
Object get(int index);
~~~



#### ListIterator 列表迭代器

可以在列表的遍历过程中, 对列表进行 增, 删, 改 操作.











## 四. Set 子类

* 元素 **不能重复**

### TreeSet

基于红黑树, 所以插入元素的时候, 如果对象不能比较, 那么需要自定义比较接口

~~~java
class Person implements Compareable{
    // 然后实现 Compareable 方法
    // 注意返回的为 int, 而不是 boolean
    // 一般是 大返回 1, 小返回-1
    @Override
    public int compareTo(Object o) {
		// 注意这个里面要 强制转换 o
        Person p = (Person)o;
    }
}

~~~

TreeSet 是一种平衡排序二叉树, 所以在插入的时候, 需要插入对象有比较的功能. 再取出值的时候, 可以实现遍历 TreeSet 出来的元素就是顺序的功能.

































