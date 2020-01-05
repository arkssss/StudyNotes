## 关于java 运行

###1.  .java 和 .class 文件

* .java   是自己(开发者)编写的源文件
* .class 是通过编译 .java 文件之后生成的文件 



Tips :

**java 程序的运行依赖于虚拟机(JVM),这也是java可以做到跨平台的一个保证 **

**任何一个java程序的运行都需要先 将 .java文件  编译成为 .class 文件, 然后在JVM上运行 .class 文件 , JVM 只认识.class 文件**



### 2. 如何在 MAC 终端 (command line) 运行 java 程序

假设有一个.java 文件 test.java

要在shell 上编译且执行它 : 

~~~shell
# 先用javac 命令 编译 .java 文件
javac test.java

# 编译了之后可以发现目录下多了一个 .class 文件

# 再用 java 命令直接运行test文件即可
# 注意 java 后面不要加 .class
java test
~~~



tips : 

**安装java配置的环境变量 $PATH 添加 \$JAVA_HOME 就是可以让我们在任何的路径下都能直接使用 java javac 命令进行编译和执行java文件 **



**另一个环境变量 $CLASS_PATH 的作用 就是可在任何路径下都可以去执行 java class_file 这个可执行程序, 当然这个类文件必须在\$CLASS_PATH 的路径下**





### 3. JVM

* JVM作为.class文件和操作系统的中间层 ,因此一个java程序才可以实现跨平台运行, 因为一个java程序不直接又操作系统去解释, 而是又虚拟机去解释, 在虚拟机的层面上去做到操作系统兼容即可
* JVM 也是使得java不同于其他的编译型语言(c++)的一个重要原因, 其他的编译型语言, 可执行程序的下一层便直接是操作系统




