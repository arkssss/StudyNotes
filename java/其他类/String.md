[TOC]

# 一. 字符串的不可变性

字符串对象 一旦初始化就不可以被改变 , 例如 :

🌟 字符串对象的不变性

```java
/*
    此时 "abc" 为一个字符串对象
    s 为指向 "abc" 的引用
*/
String s = "abc";
int s_hash_abc = s.hasCode();

/*
	此时 "xyx" 为新创建的字符串对象
	s 重新指向这个新的对象
	而 "abc" 对象并没有改变
*/
s = "xyx";
int s_hash_xyx = s.hashCode();

// 输出 false;
// 证明上下的 s 并不是一个对象的引用
System.out.println(s_hash_abc == s_hash_xyx)
```

字符串的不可变性说明了 : 

**无论以什么方式修改了字符串, 得到的都不再是原来的字符串了, 而是返回的一个新的字符串对象.**

e.g. 利用 ‘+’ , substr() , 等等, 都不是在原来的字符串的基础上进行修改的, 而是利用了原来的字符串对象, 返回了一个新的字符串 !!

我们可以看到关于 String 类的一部分源码:

String 类的 char 存储果然是 final 类型

~~~java
/** The value is used for character storage. */
private final char value[];
~~~







# 二. 两种初始化方式

~~~java
/*
	String 类型的两种初始化方法
*/
// Method I
String s = "abc";

// Method II
String X = new String("abc");
~~~



## Method I :  直接创建于字符串常量池

~~~java
/*
	s, s1 实则一个对象的引用
*/
String s = "abc";
String s1 = "abc";

// 输出 true
System.out.println(s == s1)
 
~~~

这种方法创建的 字符串对象在 **字符串常量池**

字符串常量池概念 Same As 字符串缓冲区 , 以上创建步骤可以被如下描述:

1. JVM 发现需要创建一个 "abc" 对象, 首先寻找 **字符串常量池**, 看是否存在 "abc" 对象
2. JVM 发现 **不存在 “abc” 对象** , 则创建一个新的 "abc" 对象, 且将 s 指向该对象
3. JVM 需要创建第二个 "abc" 对象的时候, 发现常量池 **已经有了 "abc" 对象**, 此时便直接将 s1 赋予 该对象
4. 所以 s, s1指向的 **其实为同一个对象**



## Method II : 使用 New 方法创建于堆区

~~~java
String s = new String("abc");
~~~

这种方法创建的 字符串对象在 **堆区**

这种方法,  实际上创建了 **两个** 字符串对象

1. 首先在字符串常量区 创建一个 "abc" 对象 (注意如果常量池中有 “abc” 对象 , 则不需要再创建)

2. 将这个对象做为 构造函数的传参 , 然后返回一个和 “abc” 值相同的新对象



## Method I, II 结合的疑问

~~~java
String a = "abc";
String b = new String(a);
String c = "abc"
    
// true
// a, c 都是指向位于字符串常量池的 “abc" 对象
// 所以 a,c 地址相等
System.out.println(a == c)
    

// false
// b 指向堆区新创建的 "abc" 对象
// a, b 地址不同
System.out.println(a == b)
    

// true
// 本来在 Object 类中, a.equeals(b) 比较的是 a,b的地址, 如果比较地址, 则应该输出 false
// 但是 String 类中, 对 equeals 进行了重写: 为比较两个字符串的值, 所以是相同的 输出 true
System.out.println(a.equeals(b))
~~~



# 三. String类 成员方法



## String类 共有方法

~~~java
/*
	String 类的长度
*/
int len = myString.length();
int len = myStringBuffer.length();
~~~







## 构造函数

我们可以用 **多种方式** 去构造一个 String 对象

~~~java
/* char 数组的形式创建String对象 */
char[] arr = {'a', 'b', 'c', 'd', 'e'};
String s = new String(arr)	     // 输出 “abcde”
String s = new String(arr, 1, 3) // 输出 “bcd”
    

/* 
	byte 字节数组的形式创建 String对象 
	会自动将 byte 字节数组里面的字节对照 ASCII 码转化为 字符
*/    
byte[] arr = {97, 98, 99};
String s = new String(arr)	     // 输出 “abc”
String s = new String(arr, 0, 2) // 输出 “bc”
~~~



## String类 其他常用成员方法

### 查找方法

String 类提供的各种查找方法

<hr>
**获取字符串内容**

~~~java
// 1 根据字符串获取字符串长度
	int length();


// 2 根据位置获取字符, 相当于 c++ 的 [] 运算符, 可能抛出越界异常
	char charAt(int index);

~~~



<hr>

**定位 字符 或者 子字符串** : 

~~~java

// 3  根据字符, 获得该字符在字符串第一次出现的位置, 如果不存在返回 -1
	
	/*
	这里传递的为字符的可以有两种形式 : 
		* 字符的ASCII码 
		* 字符本身
	*/
	int indexOf(int ch)
        
	// fromIndex 可以规定查询的起始位置
    int indexOf(int ch, int fromIndex);
	
	// 子字符串匹配
	// 查看 子字符串 第一次出现的 位置
	int indexOf(String str)
	int indexOf(String str, int fromIndex);

	
// 4 根据字符, 获得该字符在字符串 最后一次 出现的位置, 如果不存在返回 -1
	int lastIndexOf(int ch)
    int lastIndexOf(int ch, int fromIndex);
	int lastIndexOf(String str)
	int lastIndexOf(String str, int fromIndex);
~~~



<hr>

### 截取方法


* `public String subString(int beginIndex, int endIndex);`
* `public String[] split(String regex)`

~~~java
/*
	 获取 字符串中的一部分字符串
	 从指定的 beginIndex 开始, 从 endIndex-1 次结束
*/
	String subString(int beginIndex, int endIndex);


	

/*
	通过一个匹配模式, 将字符串拆分, 返回 String[]
	public String[] split(String regex)
*/

    String test = "boo:and:foo";

    // 返回 ["boo", "and", "foo"]
    test.split(":");

    // 返回 ["b", "", ":and:f"]
    test.split("o")
~~~

<hr>

### 判断方法 

java 中判断 

~~~java
// 判读两个字符串内容是否相同
boolean equals (String str);

// 判断是否包含子字符串
boolean contains (String str);

// 字符串是否以指定字符串 开头 结尾 的
boolean startWith(String str);
boolean endWith(String str);
~~~



<hr>

### 比较方法 🌟 

~~~java
/*
	按照字典顺序(ASCII 表示顺序) 比较两个字符串 的大小
	如 "abc" < "acc"
	

	等于返回 0
	this 大 返回正数
	antherString 大 返回负数
	
*/
int compareTo(String antherString);
~~~



<hr>



### 转化方法 🌟

可以将基本数据类型 转化为 String 类型 

~~~java
/*
	调用 String 类的静态方法
	可以将其他的基本数据类型, 转化为 String 格式的
*/
static String valueOf();


// e.g. int -> String
String stringInt = String.valueOf(123)
....
    
    
//e.g  char -> String
String StringChar = String.valueOf('a');
~~~







# 四. StringBuffer 类



## StringBuffer 类的特点

StringBuffer 是字符串缓冲区, 是用于存储数据的 **容器**

**长度动态** 可变, 且可以存储不同类型的数据

**不同于 `String` 的是,  `StringBuffer` 可以动态的修改里面的值, 而不是去重新创建一个对象**



~~~java
/*
	StringBuffer 可以动态的修改值
*/
StringBuffer sb = new StringBuffer(); 

// 此时 sb, sb1 同时指向一个容器
StringBuffer sb1 = sb.append(1);

// true
System.out.println(sb == sb1)
    
    
/*
	对比与 不可变的 String 
*/
String s = "a";
s += "b";
// 此时 s 将原来的对象抛弃, 而重新创建一个新的对象 "ab"
~~~













## StringBuffer 功能

### 构造方法

~~~java
/*
	StringBuffer 的构造方法
*/

// 不带参数的构造方法
// 默认的大小为 16个字符
StringBuffer sb = new StringBuffer(); 

// 带String参数的构造
StringBuffer sb = new StringBuffer("hello"); 
~~~



### 添加

在缓冲区进行数据在 **尾部添加 :**

~~~java
/*
	append()方法
	可以对StringBuffer 实例类添加任意的类型数据 (Byte, Short除外)
*/
StringBuffer sb = new StringBuffer();
sb.append(1); 
sb.append(false);
sb.append("hello");
// ...


// 此时容器 sb里面已经有了元素 1, 即可以打印 : 
// 输出 1
System.out.printf(sb);
~~~



在缓冲区在 **指定位置添加:**

~~~java
/*
	在缓冲区的指定位置添加元素
*/
StringBuffer insert(somteType, index)
~~~



### 删除

删除缓冲区里面的元素

~~~java
/*
	sb.delete(begin, end);
	删除缓冲区的  [begin, end) 的元素
	"hello" delete(0, 1) => "ello"
*/
StringBuffer delete(int startIndex, int endIndex);

/*
	deleteCharAt(int index)
	删除缓冲区的指定元素
	“hello” deleteCharAt(4) => "hell"
*/
StringBuffer deleteCharAt(int index);
~~~



###查找

查找StringBuffer的相关元素

~~~java
/*
	查找元素
*/
char charAt(int index);

int indexOf(String str);

int lastIndexOf(String str);
~~~



### 修改 (不同于String类型)🌟 

不同于String类型, Stringbuffer类型可以执行修改操作

~~~java
/*
	将index位置, 替换一个指定为值的字符ch
*/
void setCharAt(int index, char ch);


/*
	将 StringBuffer 从 [startIndex, endIndex) 的字符串替换为 str.
*/
StringBuffer replace(int startIndex, int endIndex, String str);
~~~



# 六. StringBuilder 类

`StringBuilder` 类为 `Java 1.5` 版本后才引入的

在功能上, `StringBuilder` 和 `StringBuffer` 类完全一样 (增, 删, 改, 查 等各种函数)

但是不同点在于 : 

`StringBuffer` 在设计上, 考虑了 **多线程的安全性** , 所以导致在单线程影响下, 速度非常慢.

`StringBuilder` 类没有考虑多线程安全, 就是说没有对各个方法进行同步, **优先考虑使用在 单线程的情况下**

~~~java
/*
	StringBuffer 是线程安全的
*/

void synchronized setCharAt(int index, char ch){}

StringBuffer synchronized append(anyType t){}
~~~

















































