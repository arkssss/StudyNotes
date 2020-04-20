# PHP语言基础

## 数组

### 遍历

~~~php
/* foreach 遍历 php 数组 */
$arr = [];

/* key + value 形式 */
foreach($arr as $key => $value){
    // code ...
}

/* value 形式 */
foreach($arr as $value){
    // code ...
}
~~~



### `in_array` 判断数组有无某元素

> [in_array](<https://www.php.net/manual/en/function.in-array.php>)

~~~php
<?php
    $os = array("Mac", "NT", "Irix", "Linux");
    if (in_array("Irix", $os)) {
        echo "Got Irix";
    }
    if (in_array("mac", $os)) {
        echo "Got mac";
    }
?>
~~~



### `unset` 销毁数组中元素

> [unset](<https://www.php.net/manual/zh/function.unset.php>)

~~~php
/* 可以使用 unset 销毁某数组元素 */
$arr = ['title' => 'hello', 'age' : '18', ...];

/* 销毁，同时销毁 title 及其对应的 value 值 */
unset($arr['title']);
~~~











## 其他

### 如何子类函数调用基类方法, 在这个方法中显示子类的类名 ?



* 1. 首先想到的是PHP的魔术常量 \__CLASS__

   但是, 如果在基类中使用\__CLASS__ 代表的是这个基类的类名, 而非调用它的子类的类名

  ~~~php
  <?php
  class Base{
      public test(){
          echo __CLASS__;
      }
  }
  class myTest extends Base{
      public my_test(){
          $this->test(); 	// 此时输出的为 Base 而非 myTest
      }
  }
  ~~~

* 2. 利用PHP 自带的函数 **get_called_class()**  后者 **get_class()** 既可以解决	

  ~~~php
  <?php
  class A
  {
      function __construct()
      {
          echo get_class($this);	# 注意用get_class 需要传入$this
      }
   
      static function name()
      {
          echo get_called_class();
      }
  }
   
  class B extends A
  {
  }
   
  $objB = new B(); // 输出 B
  B::name();       // 输出 B
  ~~~







