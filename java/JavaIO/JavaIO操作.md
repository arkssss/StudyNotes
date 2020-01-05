[TOC]

# Java I/O 操作

Java.io 包里面的都是阻塞的 IO. 即为 BIO 

也就说, 利用这个包读取的时候 **线程为阻塞的**

## 按流数据结构划分

* 字节流 : InputStream, outputStream
* 字符流 : Read , Write

对于 **Java.io** 的操作里面来说, **输入流 和 输出流 式分开的**.



## 按流类型划分 

* 节点流 : 从一个特定的文件进行读取
* 过滤流 : 使用节点流作为 输入或输出, 过滤流是使用一个已经存在的 输入, 输出流创建的 **e.g. StringBuffer 其实就是利用了装饰者模式**





# Java IO 按读写结构划分

* 字节流 : InputStream, outputStream
* 字符流 : Read , Write

字节流 + 编码表 = 字符流

及 **字节流是不涉及编码表的**, 将字节对应到对应的码表中, 便成了字符流

![img](https://www.runoob.com/wp-content/uploads/2013/12/iostream2xx.png)







# 字符流



# 一. 基本读写类

* FileWriter
* FileReader



## FileWrite 类

**FileWrite 对象写入字符的步骤**

~~~java
/*
	创建一个写文件对象
	如果不存在该文件, 那么该方法会创建一个 test.txt文件
	注意, Java读写类 不仅可以读写 .txt 文件
	还可以读写 .csv 文件 操作和 .txt 文件一致
*/
String dir = "test.txt";
FileWriter fw = new FileWriter(dir);


/*
	写入文件对象
	注意此时只是写入文件的缓冲区, 
	并没有真正的写入文件中
*/
fw.write("hello world");
fw.write();
...
    
/*
	刷新缓冲区, 数据被写入磁盘
*/
fw.flush();


/*
	关闭 I/O 资源
*/
fw.close()
~~~



<hr>
**写入文件的相关细节**

~~~java
/*
	1. 关于换行符
	   在 Linux 下, 系统换行为 \n
	   在 Win 下, 换行为 \r\n
	   所以为了可移植性, 我们采取 : 
	   new_line 可以根据不同的系统, 返回不同的换行符
*/
private static final String new_line = System.getProperty("line.separator");


/*
	2. 文件 追加模式
	   否则覆盖 文件的原来的内容
	   在文件后面加一个 true 即可
*/
FileWrite fw = new FileWrite(dir, true);
~~~





## 写文件 I/O 异常机制

几乎所有的 I/O 操作都有异常机制

~~~java
/*
	读文件 try-catch 格式
*/
FileWriter fw = null;

try{
    fw = new FileWriter(dir);
    fw.wirte();
    ...
}catch(IOException e){
    
    // 文件不存在 ...
    
}finally{
    if(fw != null){
        try{
            fw.close();
        }catch(IOException e){
            //  文件资源关闭失败 ...
        }   
    }
}

~~~



## FileReader 类

FileReader 是一个 文件读取类



**按字符读取**

~~~java
/*
	创建一个读文件对象
*/
String url = "test.txt";
FileReader fr = new FileReader(url)
    
/*
	int read();
	注意 read() 返回值为int 类型的
*/
int ch = fr.read();

/*
	fr.read() 读取一次以后
	文件读取指针 自动 指向下一个字符
	所以我们连续读就行了, 不需要手动移动 读取指针
*/
int ch2 = fr.read();

/*
	当文件到结尾的时候, read() 返回 -1
	所以我们可以利用while读取
*/
int ch;
while((ch = fr.read())!= -1){
    System.out.println(ch)
}
~~~



<hr>
**按 char 数组的形式读取**

~~~java
FileReader fr = new FileReader(url);

/*
	1. 先创建一个 char[] 数组
*/
char[] buffer = new char[100];

/*
	2. 将数组存储于 buffer 数组
	   int read(buffer); 
	   注意的返回值也是 int 类型的, 但是表示的是 读取的有效字符的长度
*/
fr.read(buffer);

/*
	3. 且读取一次之后, 文件的指针也会移动 char[].length() 个单位
	   🌟 如果此次 一个有效字符都没有读取到, 那么返回 -1
	   也就是说, 假设数组长度为 100, 那么 文件即使有一个数据, 那么返回值为 1
*/

/*
	4. 将 char[] 数组 转化为 String 输出
*/
System.out.println(new String(buffer));
~~~



**利用 While 的方式读取**

~~~java
int len = 1024;
char[] ch = new char[len];

int read_len = 0;
FileReader fr = new FileReader(url);

// -1 仍然是文件尾的判断标志
while ((read_len = fr.read(ch)) != -1){
    System.out.println(new String(ch, 0, read_len));
}
~~~





# 二. 缓冲读写类

加入读写 缓冲区 可以 **大大的提高效率**, 先把 读/写 的内容放在缓冲区里面, 再集中的进行 I/O 操作, 可以检查 I/O 操作次数, 提高效率

缓冲区的两个类, 利用了 **装饰者** 的设计模式

缓冲区类 分为以下几类 : 

* BufferedReader
* BufferedWriter



##BufferedWriter 类 

实际上 , BufferedWriter 并没有调用系统资源.

本质上还是 **利用 BufferedWriter 操作了 FileWriter 对象**

所以 在构造时, 需要将 FileWriter 传入

结束时, 就是关闭的 FileWriter 对象

~~~java
/*
	加入 字符流缓冲区
	提高写文件效率
	
	
	还是要先创建一个 FileWriter 对象 !!!
*/
FileWriter fw = new FileWriter(url);

/*
	利用 FileWriter 作为 BufferedWriter 构造函数传参, 构造出 BufferedWriter
	创建一个字符流的缓冲区的对象, 并和指定的缓冲区流对象关联
*/
BufferedWriter bw = new BufferedWriter(fw);

/*
	下面直接用 缓冲区对象的方法 进行写入操作
	从而替代 FileWriter 了所有操作
*/
bw.write("hello buffer");

/*
	BufferedWriter 对象 封装了 平台无关的 换行符对象
	bw.newline();
*/
bw.wirte("hello" + bw.newline())

/*
	刷新 缓冲区
*/
bw.flush();

/*
	缓冲区关了之后, fw 便不需要执行 close() 了
	其实 缓冲区关闭 就是 流对象关闭
*/
bw.close();
~~~



## BufferedReader 类

利用缓冲区 读区数据

~~~java
FileReader fr = new FileRead(url)

/*
	缓冲区 构造函数还是要先传入 FileReader 对象
*/
BufferedReader bf = new BufferedReader(fr);
    

/*
	缓冲优化的特有文本读取方法
	读取文本的一行
	String readLine();
	如果到达文本的地步, 那么返回 null 🌟
*/
String line;
while((line = bf.readLine()) != null){
    Sys.o.p (line);
}

fr.close();
~~~





# 字节流

* 基本操作和字符流相同
* 可以操作各种对象, 不仅字符对象, 包括各种媒体资源, 等等

# 一. 基本读写类


## FileOutputStream 对象

~~~java
/*
	字节流写入的时候, 不需要进行 编解码
	不需要对进行 flush
*/
FileOutputStream fos = new FileOutputStream(url);

// 将字符串妆换为 字节码
fos.write("hello world".getBytes());

// 关闭资源
fos.close()
~~~







## FileInputStream 对象

~~~java
FileInputStream fis = new FileInputStream(url);

// 一个 字节 一个字节的 读取
int len = fis.red()

// 关闭资源
fis.close()
~~~



























