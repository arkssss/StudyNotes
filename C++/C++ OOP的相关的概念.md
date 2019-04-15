# C++ OOP的相关的概念

### 1. 类访问的修饰符

* public (C默认情况下)
* Private (C++默认情况下)
* protected (保护类型的成员, 只能被类内部的函数和友元函数访问)

### 2.类的系统函数

* 构造函数 : 无返回值, 也不返回void, 创建新的对象class 时自动调用

~~~c++
//初始化列表的方式给成员赋值
Class_name::Class_name(int the_age): age(the_age){
    
}
~~~

* 析构函数 : 无返回值, 无传递的参数 ,在删除所创建的对象时执行(对象的生命周期结束时)

* 拷贝构造函数: 利用一个类之前创建的一个对象, 来初始化一个新对象

~~~c++
Class_name::Class_name(const Class_name& obj){
	code...
}
//e.g. 以下两种情况, 都会调用拷贝构造函数
Class_name new_Class = old_Class 
//or
Class_name new_Class(old_Class)   
~~~

* 赋值运符重载 : 利用赋值运算符 = , 将一个对象赋值给 另一个对象, 注意 , 这两个对象都不是新创建的

~~~c++
Class_name & Class_name::operator = (const Class_name& obj){
    code ...
}
//e.g.
Class_Name C1 = new Class_Name();
C1 = old_one;
~~~

 

### 3.类的继承

* 派生类可以访问基类中的所有非 private 成员 
* 一个派生类继承了所有的基类的方法, 除了, 基类的构造函数, 析构函数, 拷贝构造函数,运算符号重载函数, 友元函数



### 3. 函数重载

* 重载声明是指一个与之前已经在该作用域内声明过的函数或方法具有相同名称的声明，但是它们的参数列表和定义（实现）不相同。

  当您调用一个**重载函数**或**重载运算符**时，编译器通过把您所使用的参数类型与定义中的参数类型进行比较，决定选用最合适的定义。选择最合适的重载函数或重载运算符的过程，称为**重载决策**。



### 4. C++多态



* C++ 的对象调用成员函数的时候, 会根据调用该成员函数的对象的不同来执行不同的函数.

* 一般的运用场合是在, 两个派生类继承了同一个基类

  ~~~c++
  class audi : public car{
      ...
          public virtual space(){
          	code ...
      }
  }
  class bwm  : public car{
      ...
          public virtual space(){
  			code ...
      }
  }
  
  //指向基类的指针, 亦可以指向派生类
  //此时一个指针 my_car, 根据指向对象的不同, 导致行为不同
  car *my_car;
  my_car = &audi;
  my_car -> space();
  my_car = &bwm;
  my_car -> space();
  ~~~

  注意在需实现多态的函数加入 virtual (虚函数)关键字 : 告诉编译器**不要静态连接**该函数, 从而实现的动态连接

  **纯虚函数** : 在基类里面便定义某个函数, 基类不去实现它, 而是留给子类去实现. 















