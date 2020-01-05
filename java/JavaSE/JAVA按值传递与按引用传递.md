[TOC]

# JAVA 按值传递 与 按引用传递

## 基本数据类型





## 数组

```java
/*
	String[] myString 可以直接在函数修改值
*/

```



## ArrayList 容器

java 允许通过函数 来改变 ArrayList容器的值

说明 此时 `Title` 为 `ArrayList<String>` 的一个引用

函数虽然是 **按值传递**

但是传递过去的为 `ArrayList<String>` 引用的 Copy

所以在函数中仍然可以直接操作 `ArrayList<String>` 对象

~~~java
public static void main(String[] args){

    ArrayList<String> Title = new ArrayList<>();
    Read(Title);

    // 打印 [Movie_id] 
    // 说明更改成功
    System.out.println(Title);
}

public static void Read(ArrayList<String> Title){

    String S = "Movie_id";
    Title.add(S);
}
~~~

















