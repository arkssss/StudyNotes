[TOC]

# Shell

## 一. Shell 编程

###环境

* Shell为用户和系统交互的桥梁
* 完成Shell编程也只需要 **一个文本编辑器** && **一个脚本解释器** (常用的为BASH)
* 不用的解释器, 可能对应的命令不同

### 编程Tips

* Shell文件的扩展名并不影响程序的运行 e.g. test.sh (常用) , test.php , test.ryx 都可以在bash上跑出来

* 在脚本的第一行 , 需要加上此shell 脚本运行的解释器的类型 e.g. 使用bash解释shell脚本

  ~~~shell
  #!/bin/bash
  echo "hello world !"
  ~~~

* 运行shell脚本的两种方法

  * 直接在终端输入shell脚本的路径进行执行即可e.g.

    **注意在执行前需要给这个文件加入一个执行权限!**

    ~~~shell
    # 文件加入执行权限
    chmod +x ./example_1.ryx
    ~~~

  * ~~~shell
    # 绝对路径
     /Users/ark/code_file/shell/example_1.ryx 
    # 相对路径
    ./example_1.ryx
    ~~~

    注意, 如果使用相对路径的方式, 则一定要在文件名前面加 ./ , 否则bash会自定到PATH环境里面去找文件example_1.ryx, 且会把此当作命令而不是一个二进制脚本. 

    **在其他二进制的执行时, 也需要加./**

  * 利用sh命令执行

    **此种方式下, 便不需要先给脚本先加入执行权限, 也不需要在文件名前面加入路径./**

    ~~~shell
    # 当前目录为example_1.ryx的存放目录
    sh example_1.ryx 	#即使没有执行的权限, 都可以去运行这个shell 脚本
    ~~~



### Shell变量 

Shell变量一般都用**大写字母**来命名



##### Shell 变量类型

* 临时变量 : 在Shell 脚本的内部用户自己定义的变量, 只在当前的shell脚本里面起作用

* 永久变量 : 系统的环境变量, 不随着Shell 脚本的改变而消失. 

  ~~~shell
  # 在终端中输入, 则可以显示当前系统的环境变量的值
  echo $PATH  
  # $PATH 变量表示的是系统会在那些目录去寻找可执行程序的环境变量
  # 可就说, 当在shell上面敲命令的时候, 系统会默认的去这些路径下去寻找这个命令的解释
  # 如果在所有的路径中都没有这个命令, 则显示 "command not found"
  # e.g 在我的MAC的环境变量为 
  #/Library/Frameworks/Python.framework/Versions/3.7/bin:/usr/local/bin:/u# sr/bin:/bin:/usr/sbin:/sbin:/Library/TeX/texbin:/usr/local/go/bin
  # 注意 : 分号:表示两个路径的分隔符, 即此时就有8个系统的默认路径
  # 1. /Library/Frameworks/Python.framework/Versions/3.7/bin
  # 2. /usr/local/bin
  # 3. /usr/bin
  # 4. /bin
  # 5. /usr/sbin
  # 6. /sbin
  # 7. /Library/TeX/texbin
  # 8. /usr/local/go/bin
  ~~~





##### Shell 变量定义

~~~shell
# 注意等号的两端是没有空格的
NUM=100
# 定义的时候不加$, 输出的时候加$符号
echo $NUM

# 以命令的运行的结果为变量的值 (注意要加 $ ,() ) 
TIME=$(date)
TIME=$(date +%Y-%m-%d)
echo $TIME

# 变量的赋值为另一个变量的中 (此时加 $ 而不加())
TIME=$(date)
DATE=$TIME
# 此时将TIME的结果赋予DATE

# 字符串内部要解析变量时必须用双引号
ABC="time is $TIME"
# 此时$TIME会被解析成为之前定义的变量

# 字符串用单引号的时候不会被解析赋值
ABC='time is $TIME'
~~~



* Set 命令可以查看到所有的定义的变量的值
  * unset $TIME 可以注销变量







##### Shell 位置变量 & 特殊变量

例如 test.sh 脚本

~~~shell
#!/bin/sh
# $(0-9)
echo $0
echo $1
echo $2
~~~

执行这个脚本的时候:

**sh test.sh /etc /User**



* 在一个脚本里面有一些表示**位置的变量** : 
  * $0 对应的就是 test.sh 这个文件的路径
  * $1-9 对应的就是执行这个文件的时候后面追加的这些参数 , 一般可以是一些目录, 从而使得脚本更加的灵活 (注意在这种方法只能表示到9个参数, 如果有更多的需要用其他的方法)

* 在一个脚本里面还有**特殊的变量** : 

  * $* : 表示这个程序的所有参数 : "/etc /User"
  * $# : 表示这个程序的参数的个数 : 2
  * $$ : 表示这个程序的PID 
  * $!  : 表示执行上一个后台命令的PID
  * $? : 表示执行**上一个命令**的返回值   (0表示成功, 非0表示失败) 一般可以用来IF 条件的判断语句 







##### Shell 命令

* read命令 : 

  ~~~shell
  # 表示从用户的键盘输入一个参数并且赋值给parameter1
  read parameter1
  
  # 输入多个参数
  read parameter1 parameter2 ...
  ~~~

* expr命令 : 

  对**整数型**变进行算术的运算

  ~~~shell
  # 注意两数中间有空格
  expr 3 + 5
  expr $VAR1 - 5 
  ...
  ~~~


* test 命令 : 

  **一般是结合 条件 或者 循环语句进行**

  * 一般的用法 : 

    关于数值

    ~~~shell
    test int1 -eq int2 
    
    -eq # ==
    -ge # >=
    -gt # >
    -le # <=
    -lt # <
    -ne # !=
    ~~~



    关于文件
    
    ~~~shell
    test -d file
    
    -d # 是否为目录
    -f # 是否为常规文件
    -x # 知否可执行
    -r # 是否可读
    -x # 是否可执行
    -w # 是否可写
    -a # 是否存在
    -s # 文件大小是否非0
    ~~~



    结合到if 语句中
    
    ~~~shell
    if test -d $1 then
    	...
    fi
    ~~~
    
    **在if中 可以对test语句进行简化**
    
    ~~~shell
    if [-d $1] then
    	...
    fi
    ~~~


* exit 命令 : 

  **结束程序** 语句 : exit 0 , 返回0表示了正常的退出

 



## 二. shell命令技巧

- shell就是一个命令解释器
- 有很多版本的shell , bash为比较常用的一个



### 1.命令快捷键

- 「tab」键可以自动补全
- Ctrl + l 请屏 = clear
- Ctrl + u 删除此时光标前面所有字符
- ⬆️⬇️可以查看历史命令



### 2.命令别名

```shell
#将rm -rf命令的别名设置为drm
$alias drm="rm -rf"
```

```shell
#接触别名
$unalias drm
```



### 3.输入/输出重定向

- Shell 对与每个程序预定义了3个文件描述字(0,1,2)对应于:

  0 (STDIN) 标准输入 : 键盘

  1 (STDOUT) 标准输出 : 显示屏

  2 (STDERR) 标准错误输出 : 显示屏

- 重定向可以控制输入/输出 不为标准, 既可以从文本或其他渠道进行I/O操作

```shell
# > 或 >> 输出重定向
# 将ls -l /tmp 输出的结果不显示在显示屏上 而是重定向到tmp.msg中
# 注意如果tmp.msg不存在, 则会先创建tmp.msg 再执行改命令
# > 但是第二次重定向会覆盖前一次的tmp.msg的结果
# >> 则为追加结果而不是覆盖
$ls -l /tmp > /tmp.msg
```



```shell
# < 输入重定向
# 将该msg的内容作为广播内容发送
$wall < /etc/tmp.msg
```



```shell
#错误输出重定向
#只有在该条命令出错的时候才会执行, 且把出错的提醒保存在msg中
#此时为 2> 而不是 > 即为第三种错误输出重定向
$cp -R /usr/backup/usr.bak 2> /bak.error
$ls -l /asd 2> msg
...
```





### 4.管道

- 将一个命令的**输出**传给另一个命令作为该命令的**输入**
- 理论上管道可以使用n次

```shell
#将$ls -l /etc 的输出的结果传送给 more命令作为输入
$ls -l /etc | more
#可以用多管道
#wc -l [文件] 可以统计该文件的行数
#多管道的使用
#对 $ls -l /etc 的 结果进行 init关键字抓取 再统计行数
#效果 : 统计/etc目录下包含关键字init的文件或目录的个数
$ls -l /etc | grep init | wc -l
```





### 5.分号 ; , && , ||

- 分号“;” , 顺序的执行各个命令, 前面命令的正确与否不影响后面命令的执行

  ```shell
  #以依次的输出当前的工作目录 , 当前的时间, 当地目录下的文件和目录
  $pwd ; date ;ls -l
  ```

- && , 并列多条命令, 当且仅当前面命令执行成功, 才会执行后面的命令

  ```shell
  #此时会执行 date , ls -l 而不会执行 pwd
  $date && ls -l && sss && pwd
  ```

- || , 当且仅当前面命令执行失败的时候, 才能执行后面的命令, 

  ```shell
  #此时不会执行 pwd
  $date || pwd
  #此时会执行 pwd
  $asd || pwd
  ```



### 6.``号 (1左边的并不是单引号)

- 命令替换: 将一个命令的输出最为另一个命令的 **参数** (注意并不是输入, 和管道还是有区别)

- 格式为 : 命令1 \`命令2\`

- ```shell
  #找到touch命令所在的路径作为ls命令的第三个参数
  $ls -l `which touch`
  ```

