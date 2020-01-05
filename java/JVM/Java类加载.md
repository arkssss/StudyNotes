[TOC]

# JVM

* JVM 可以不只运行 Java 文件, 而是可以运行所有的 可以编译成字节码文件的 语言

* 虚拟机的实现不只一种, 我们最常用的为 HotSpot 虚拟机

JVM 结束生命周期:

- 执行了 System.exit();
- 正常结束
- 遇到 Exception (而没有Catch导致一直抛到 JVM), Error
- 操作系统的错误



# 类加载

Java 代码中, 类型 的加载, 链接, 初始化的过程都是在程序 **运行期** 间完成的

类型 : Class, Interface, … 是类的本身而不是实例化的对象

常见的加载 : 磁盘上的定义的类 加载到内存

初始化 : 静态变量的赋值 等等 ..







# 类加载器

每一个类型, 都是由类加载器加载到内存中的 :

**Jvm 中内置三类重要的 类加载器 ClassLoad** 除了 BootstrapClassLoader 其他类加载器均由 Java 实现且全部继承自`java.lang.ClassLoader`：

分别负责加载  `lib` , `lib/ext` , `userApp` 下的 `jar` 包

1. `BootstrapClassLoader` **(启动类加载器) ** : 最顶层的加载类，由C++实现，负责加载 `%JAVA_HOME%/lib`目录下的jar包和类或者或被 `-Xbootclasspath`参数指定的路径中的所有类。
2. `ExtensionClassLoader` **(扩展类加载器)** ：主要负责加载目录 `%JRE_HOME%/lib/ext` 目录下的jar包和类，或被 `java.ext.dirs` 系统变量所指定的路径下的jar包。
3. `AppClassLoader` **(应用程序类加载器)** :面向我们用户的加载器，负责加载当前应用classpath下的所有jar包和类。



`Java` 中的每一个类都有他的默认的 `类加载器` 	







## 双亲委派模型

系统中的 `ClassLoader` 在协同工作的时候, 会使用  **双亲委派模型**  

一个类发出加载请求时候, 会首先判断这个类是否已经被加载过, 如果是的, 则直接返回

如果没有, 类的加载器会将该加载请求委派给 `夫类加载器的 loadClass()` 处理, 因此, 所有的类加载

请求都会经过 顶层的类加载器 `BootstrapClassLoader` . 如果 夫类无法处理, 才会分配给子类处理

![ClassLoader](https://camo.githubusercontent.com/4311721b0968c1b9fd63bdc0acf11d7358a52ff6/68747470733a2f2f6d792d626c6f672d746f2d7573652e6f73732d636e2d6265696a696e672e616c6979756e63732e636f6d2f323031392d362f636c6173736c6f616465725f5750532545352539422542452545372538392538372e706e67)



## 双亲委派模型的好处

这种模型可以避免 **类的重复加载** , 也保证了 Java 的核心 API 不被篡改.

比如可以防止 自己定义的 `java.lang.Object` 覆盖掉 核心库里面的 `Object` 包







## 如果我们不想用双亲委派模型怎么办？

为了避免双亲委托机制，我们可以自己定义一个类加载器，然后继承我们的`ClassLoader` 类 ,  然后重载 `loadClass()` 即可。







# 类进入内存重要的三个阶段 (从磁盘进入内存)



![ç±"å è½½è¿ç¨](https://camo.githubusercontent.com/9cb5a35384ed4da10079e3180e608828c7afe3a8/68747470733a2f2f6d792d626c6f672d746f2d7573652e6f73732d636e2d6265696a696e672e616c6979756e63732e636f6d2f323031392d362f2545372542312542422545352538412541302545382542442542442545382542462538372545372541382538422e706e67)



1. 加载 : 查找并加载类的二进制数据, (类的 Class 文件加载到内存)

2. 连接 : 

* 验证 : 确保被加载的类的正确性

* 准备 : 为类的 **静态变量** 分配内存, 并初始化为 **默认值**

  即使 静态变量被初始化过, 但是在这个准备阶段还是被赋为默认值

* 解析 : 符号引用转化为直接引用 

3. 初始化 : 为类的 **静态变量** 赋于 **正确的初始值**







# Java 对类的使用方式

首次主动使用才 **初始化** , 且只会被初始化一次

1. 主动使用

   * 创建类的实例
   * 创建类的一个子类实例
   * 访问类, 接口的静态, 或者对静态变量赋值
   * 调用类的静态方法
   * 反射
   * 包含 Main 方法的类

2. 被动使用 : 上述情况除外

   ~~~java
   /*
   	对象数组
   	此时并没有对 MyTest 类 初始化
   	
   	但是. 会创建一个 数组类型 (并不是 MyTest类型)
   */
   MyTest[] MyTestArr = new MyTest[1];
   
   
   ~~~

   不导致类的初始化 不意味着 类不被加载, 链接



# 类的加载时机

对于静态字段 : **只有直接定义了该字段的类**, 才会被 **初始化**

静态代码块只有, 在 **初始化 !!!!!!!!!!** 的阶段执行





## 多态性质的子类调用夫类, 此时子类不会被加载

~~~java
class parent {
    
	public static String str = "hello word parent";
    
    // 静态代码块
    static {
        System.out.p("p")
    }
    
}

class child extend parent {
    
	public static String str2 = "hello word child";
    
    // 静态代码块
    static {
        System.out.p("c")
    }
    
}

// 访问父类的静态变量
// 此时只会 打印父类的静态代码块
// 此时没有主动使用 子类
S.o.p(child.str)
    
    
// 输出
p
Hello world parent
~~~





## 子类调用子类则都会被加载

~~~java
class parent {
    
	public static String str = "hello word parent";
    
    // 静态代码块
    static {
        System.out.p("p")
    }
    
}

class child extend parent {
    
	public static String str2 = "hello word child";
    
    // 静态代码块
    static {
        System.out.p("c")
    }
    
}

/*
	此时打印子类的静态变量
*/
public static main(String[] args){
    
    S.o.p(child.str2)
        
}
    

/*
	此时父类也被主动使用了
*/
// 输出
p
c
Hello world child
~~~





## 调用 static final 修饰的不会涉及到类加载

~~~java
class parent{
    
    public static final String str = "hello word";
    
    // 静态代码块
    static {
        System.out.p("Hi this is Static block")
    }
    
    
}

main Test(){
    
    /*
	结果 :
	hello world
    */
	S.o.p(parent.str) 
}

/*
	-- 加了 final 之后, 就不执行 static 代码块了
	原因 :
	如果被修饰成一个 常量, 那么在 🌟编译阶段🌟, 常量会被存入到调用这个常量的类的 常量池
	也就是说, 调用这个常量, 不会直接引用调用这个常量的类, 也就是说这个类不会被初始化
	在这个例子,  会被放在 Test 类里面的常量池
	之后与 parent 没有任何关系, 不会被初始化, 甚至不会被加载
*/
~~~





### e.g.4

~~~java
/*
	当 静态 final 变量调用的是一个方法的时候
	
	
	所以, 当一个常量的值, 在编译期可以确定的, 那么就会被放入 调用类的常量池
	当一个常量的值, 在编译期不可以确定的, 那么不会放入常量池, 则此时需要相应类的 初始化工作了
	 
	
	
*/
class parent{
    
    public static final String str = UUID.RandomUUID().toString();
    
    // 静态代码块
    static {
        System.out.p("Hi this is Static block")
    }
    
    
}

main Test(){
    
    /*
	结果 :
	Hi this is Static block
	.. aasjdhgsdyufgdsh // UUID
    */
	S.o.p(parent.str) 
}

~~~





































