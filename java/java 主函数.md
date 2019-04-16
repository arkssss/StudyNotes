## java 一些基本问题



### 1. 程序的主函数定义

~~~java
    // 主函数的格式一定 !!! 
	public static void main(String[] args) {
        
        System.out.println("Hello World!");
        // args[0] , args[1] , ....
        
    }
~~~



* 主函数的传参是用于在利用命令行执行时调用

  ~~~shell
  # 以这种方式启用程序
  java test 1 2 3
  # 则 args[0] = 1 args[1] = 2 args[2] = 3 
  ~~~


* **一个.java 源文件可以定义多个主函数** 

  ~~~java
  class Demo{
  
      public static void main(String[] args) {
  
          System.out.println("Hello World demo!");
  
      }
  
  
  }
  
  class Test{
  
      public static void main(String[] args) {
  
          System.out.println("Hello World test!");
  
      }
  
  
  }
  ~~~

  这样在编译的时候, 就生成两个 .class文件 : Demo.class  &&  Test.class

  但是, **同一个类里面只能写一个主函数**