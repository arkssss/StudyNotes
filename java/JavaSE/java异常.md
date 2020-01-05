# java 异常

[TOC]

## 一. 异常概述

### 什么是异常?

* java程序运行时期发生的**不正常的情况**
* 注意编译器并**不会因为异常报错**

异常就是java封装的专门用于异常问题处理的类, 一切皆对象!!!. 这个异常类里面, 包含了关于这个异常问题的一些信息



#### 异常情形和普通问题

异常情形指阻挡当前环境和作用域继续执行的情况, 异常指在当前的环境下已经找不到如何处理这个问题的信息, 只有将问题返回给上一个环境去处理



### 为什么要用异常?

在以往的语言中, 例如C语言, 是没有异常类机制的.

所以, 为了加强代码的健壮性, 我们必须在一段代码中加入一些if代码去处理那些异常流程.

**这样导致我们代码的可读性很差**

例如 :

~~~c++
int sleep(int time){
    if (time < 0){
        // 异常处理流程
    }
    if (time > 10000){
        // 处理
    }
    // ....
    // 正常code 部分可读性变差
}
~~~



### 如何加入异常?

在原来的处理流程中, 我们全部封装到Exception对象中. 然后我们直接在异常位置实例化这个Exception对象就可以了. **Simple as that**

**注意在异常处理还有一个特殊的关键字 throw, 表示抛出这个异常**

**何为抛出, 就是在中止函数功能的同时, 向该异常的调用函数提供相关的不正常信息** 

**和return不同, 异常抛出不涉及返回值的情况**

还是以上面的例子:

~~~java
public int sleep(int time){
    if (time < 0){
        // 负时间异常
		throw new NageTimeException();
    }
    if (time > 10000){
		// 大时间异常
        throw new BigTimeException();
    }
    // ....
    // 正常code 部分可读性变差
}
~~~

**通过异常类的方式, 我们便可以非常简洁直观的提供函数的主功能, 且提供直观的错误处理流程**



## 二. 异常体系

**java核心思想 : 提取共性, 变为基类**

java的异常机制可以分为两个子类

* Error : 它表示 **不希望被程序捕获** 或者是 **程序无法处理** 的错误

* Exception : 它表示 **用户程序可能捕捉的异常情况** 或者说是 **程序可以处理的异常**


这两类有一个共同的基类 **Throwable** , 即都是可抛出的. 更通俗可以理解为, **都可以使用throw关键字去抛出这个对象.**

层次结构可以如图表示 :	

<img src = 'image/2019-07-19-java-exception.png' />



<hr>

Error 和 Excepetion 的区别 ;

* Error 通常是 **灾难性的致命的错误** ，是程序无法控制和处理的，当出现这些异常时，Java虚拟机（JVM）一般会 **选择终止线程** , 我们程序是不会处理的
* Excepetion 通常是可以被 **程序正常处理的**



## 三. 自定义异常

* 只需要让自定义异常继承我们的 Exception 类 **或者他的一些子类**

  ~~~java
  class RandomException extends Exception{
      // 继承便可以保证它是可以被抛出的    
  }
  ~~~

* 注意我们使用自定义异常的时候, 需要在调用它的那一些函数栈里面对它进行**抛出说明**

  **如果是直接继承了Exception作为父类, 那么我们就要进行抛出说明**

  ~~~java
  // 注意只要调用了自定义异常, 我们就要进行抛出声明, 不然就会编译报错
  public void time() throws RandomException
  {
      
      throw new RandomException();
      
  }
  ~~~



## 四. 检查异常 和 非检查异常

Exception 异常有两种分类:

* **检查异常 : IOException, SQLException 等** : 

  对于检查异常来说, 如果一个函数需会抛出异常, 那么他的调用函数, 要么处理这个异常(try-catch), 要么继续抛出, 注意, 如果继续抛出那么调用函数也会被终止执行, **如果所有的调用函数都没有处理这个异常**, 那么这个异常最终右JVM处理.

* **不受检查异常 :** **RuntimeException及其子类 **: 

  对于不检查异常来说, 可以不做抛出声明, 也可以不做(try-catch)捕获.

**如果希望自定义的异常可以不做抛出声面只需要自定义异常去继承这个RuntimeException异常即可**





## 五. 异常抛出

关于异常的抛出, 有以下几个注意的地方:

- 异常的抛出的同时, **会自动将方法终止于异常抛出的地方**, 类似于return,但是还是不同于return

- 异常的抛出是自动抛出给自己的调用函数, 举个例子:
  A call B, B call C

  此时C抛出异常, 且给了B, 那么B会终止于调用C的那一行.同理会抛给A, 如果这些函数都没有处理机制, 那么最终会抛出给JVM, 然后JVM最终将异常打印.







## 六. 异常捕获

对于非Runtime异常, 我们**必须在程序运行前对它进行处理**, 方式为以下两个中的一种, 否则编译不通过: 

1. 向更外层抛出该异常

   如果选择向更外层去抛出该异常, 那么一旦出现了异常, 程序只有在这一层函数终止去执行它的调用函数.

2. 直接使用try catch语言进行捕获处理

   使用try catch进行异常的捕获处理之后, **程序可以继续顺序执行 !!!!!**



### 单 catch 捕获

~~~java
/*
	单 catch 捕获
*/
// 使用 try 语句块从而 控制台不再显示该异常
try {
    // 此时即使抛次的自定义异常类里面使用了带有字符串说明的构造函数
    // 由于异常被捕获, 从而不在控制台显示这个异常说明了
    ED.time(10000);
}catch (BigTimeException e){
    // catch 里面才是真正对于异常BigTimeException的处理方式
    // catch 只有在相应的异常抛出之后才能执行
    // e 的作用域只在 catch 里面
    // e 就是这个异常的实例化类, 从而可以调用这个类的一些成员
    System.out.println("Error occur My name is  " + e.name);
}finally {
    // finally 不管有没有异常的发生，都要被执行的
    System.out.println("Error occur i have no idea" );
}

// 程序继续执行
// program continue ...
~~~

​				

<hr>

### 多 catch 捕获

~~~java
/*
	1. 多 catch 捕获
	2. 捕获所有的异常的父类
*/
// 如果 try 语句里面可能抛出多个异常, 那么我们可以使用多catch语句去捕获
// 多 catch 语句默认我们一旦有一个catch捕获成功, 那么就直接跳到finally语句
try {
}
catch (SomeException1 e){
// deal code
}
catch (SomeException2 e){
// deal code
}
catch (Exception e){
 // 这种情况一定要, 写在多catch语句的最后 !!! 否则编译失败. 
 // 
}
finally {
    System.out.println("Error occur i have no idea" );
}
~~~



<hr>

### 利用 Throwable 成员函数打印异常消息

在catch 里面输出 异常构造函数的描述字符串

可抛出(trownable)的异常继承了一个共同的类 => **Throwable**, 可以利用这个 **类的成员函数** 去打印我们异常的相应的构造函数传参 !

~~~java
try {
	// code..
    // 这里可能抛出异常 SommeException
}catch (SommeException e){
    // e.getMessage() 可以返回e的构造函数的传参
	System.out.print(e.getMessage());
	
    // JVM默认的异常处理函数, 可以直接打印关于异常的所有信息
    e.printStackTrace()
        
    // 当然可以直接利用 toString函数去打印异常
    System.out.print(e);
}finally {
	// code..
}
~~~



<hr>

### finally 语句执行时机 return & eixt

~~~java
try{
    
}
catch(AException e){
 	
   // 如果在catch里买执行了return语句
   // code part 2 将不会被执行
   // code part 1 仍然会被执行
   return ; 		// 退出该调用函数	🌟
    
   // code part 2 将不会被执行
   // code part 1 将不会被执行
   System.exit(0)	// 直接退出 jvm	  🌟
    
}
finally {   
    // code part 1
    // 这个代码块通常用于 返回系统资源
    // 因为这个代码块一定会执行, 即使被return
}
// ...
// code part 2


~~~



### Try Catch Finally 语句组合

一个捕获代码块不必非要拥有完成的 try-catch-finally 语句, 可以拥有其中的部分也是可以的. 

~~~java
/*
	一. 单 catch
*/
try{
    
}catch{
    
}finally{
    
}

/*
	二. 多 catch
*/
try{
    
}catch{
    
}
catch{
    
}
...
finally{
    
}

/*
	三. 无 catch
		一般的使用情况如下: 在try里面声明了资源, 但是可能抛出异常又需要返回上一级处理
		所以此时我们在finally语句里面处理异常, 保证异常可以被处理掉
		注意无catch等于没捕获, 所以还是需要抛出声明
*/
try {
    // 开启资源
    throw new Exception();
}finally{
    // 即使异常抛出, 也会执行到我们的finally中
    // 关闭资源
}

~~~





























