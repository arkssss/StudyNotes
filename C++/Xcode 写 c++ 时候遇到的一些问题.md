## 	Xcode 写 c++ 时候遇到的一些问题

### 1. 读取文件(txt)的路径问题

一直显示读取文件失败 (**file not found**) , 文件和代码都放在一个文件夹下面, 这时需要改工作目录的默认文件读取路径 : 

~~~
Put your .txt files in the same directory where your main.cpp file is (or anywhere you like).

In Xcode go to Product > Scheme > Edit Scheme > Run test (on the right) > Options (middle top)

Down under Options check “Use custom working directory” and set it to the directory where you .txt files are located.

To work with the files, you will have to specify just file names, e.g. 
in_file.open("inputFile.txt"); no path is necessary.
~~~



