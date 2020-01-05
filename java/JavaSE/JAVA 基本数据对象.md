[TOC]

# 基本数据类型 对象封装

Java 对基本的数据类型进行了封装

为了方便操作基本类型值, 将 **基本数据类型封装 成了类**,

且在对象中 **定义了属性和行为丰富了该数据的操作.** 

一共有八个数据类型, 所有基本类型封装类有八个, 对应关系如下 :

* byte :	 Byte
* short :     Short
* int :          Integer
* long :       Long
* float :       Float
* double :   Double 
* char :       Character
* boolean : Boolean



```java
// java 的基本数据类型 后面的值是 不进行初始化时的默认值
boolean ;// false	
char ;	 // null
byte ;	 // 0
short ;	 // 0
int ; 	 // 0
long ;	 // 0L
float ;  // 0.0f
double ; // 0.0d

// 当以这种方式声明的时候, 会被直接存放在堆栈区 而不是堆区
int a = 10 ;
```



## 一. String 和 基本数据类型相关转化问题	

### 基本数据类型 To String

#### Method I

~~~java
/*
	直接利用 ‘+’ 号运算符号
*/

String hello = "hello world" + 2019;
~~~



#### Method II

~~~java
/*
	利用 String 静态类的 valueOf 方法
*/

String hello = "hello world" + String.valueOf(2019);
~~~



### String To 基本数据类型

~~~java
/*
	利用各个类提供的 静态方法, 格式如下:
	
	String -> int
	int parseInt(String)
	
	String -> doule
	double parseDouble(String)
	
	即如果 String -> xxx
	xxx parseXxx (String)
	...
*/

int i = Integer.parseInt("123");
boolean j = Boolean.parseboolean("false");
...
~~~







## 二. Interger 类

### 构造方法

Interger 对象包含一个 int 值

构造的时候需要传递一个 int 变量 , 或者传递一个数字类的String:

~~~java
void Interger(int i);
void Interger(String number);
~~~

Interger类 包含了封装了许多方法, 如下:





### 静态方法

~~~java
/*
	静态方法
*/

/*
	1. 字符串转化为 int 类型
	   int Integer.parseInt(String s)
*/
int j = Integer.parseInt("123")

~~~



<hr>

**Integer 进制转换**



十进制 转化 为其他进制

~~~java
/*
	JAVA Integer 类静态方法, 可以将一个数字 转化为相应进制的 字符串形式
*/

/* 十进制 ==> 二进制字符串 */
Integer.toBinaryString(60);

/* 十进制 ==> 十六进制字符串 */
Integer.toHexString(60);

/* 十进制 ==> 八进制字符串 */
Integer.toOctalString(60);
~~~



其他进制 转化 十进制

~~~java
/*
	JAVA 中的 parseInt 方法创建 重载方法
	注意返回为 十进制 int 类型
	int parseInt(String number,int base);
*/

/* 二进制 ==> 十进制 */
Integer.parseInt("100010", 2);

/* 十六进制 ==> 十进制 */
Integer.parseInt("ac", 16);

/* 八进制 ==> 十进制 */
Integer.parseInt("77", 8);
~~~





### 非静态方法



#### 获得对象绑定值 intValue

~~~java
/*
	非静态方法
*/

/*
	获得对象内的int值 int intValue() 方法
*/

Integer i = new Integer("123");


/*
	给 int 类型 赋值 Integer 类型的两种方式
*/
int j = i.intValue();
// OR
int j = i;
~~~



#### == 和 equals

~~~java
/*
	'==' 和 equals 方法, 注意:
    '==' 一直是比较的 对象的地址
    equals 在Integer类里面进行了重写, 为比较的 两个整数对象的数值
*/

Integer a = new Integer("1");
Integer b = new Integer("1");

// false 
a == b
// true
a.equals(b)
~~~





#### compareTo 比较

~~~java
/*
	比较 两个 Integer 对象的大小, 常规比较
	如果 a > b 返回 1
	如果 a == b 返回 0
	如果 a < b 返回 -1
*/
a.compareTo(b)
~~~



 

#### 运算符重载 🌟



**= 等于号重载 (自动装箱)**

~~~java
/*
	直接利用 = 进行复制运算
*/
// 其实在内部也调用了 new Integer()
Integer i = 10;




/*
	🌟🌟🌟🌟🌟🌟🌟
	JDK 1.5 以后, 如果利用自动装箱功能 声明的整数对象
	那么, 如果声明的值 小于一个字节的 signed int [-128, 127], 那么
	会先把这个 数放在常量池,类似于 String 常量池 而不是在堆中声明新对象
	所有的 Integer 公用一个 地址
*/
Integer a = 127;
Integer b = 127;

// true
a == b


Integer a = 128;
Integer b = 128;

// false
a == b
~~~



<hr>



**+ 加号重载**

~~~java
/*
	+ 运算符号 可以用于 Integer 对象
*/

Integer i = 10;

// i 输出 21;
i = i + 11
~~~





































