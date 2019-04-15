# WeiPHP(PHP)学习笔记

## 1.变量的传递 => 实参 和 形参

### 1.函数场景

~~~php
$data = 10
test($data)
function virture($data){...}  //形参形式
function truth(&$data){...}	  //实参形式
~~~

### 2.遍历场景

~~~php
foreach($array as $key => $val){...} //形参形式
foreach($array as &$key => &$val){...} //实参形式
~~~



## 2.变量的作用域

### 1.代码块内部声明的变量可以用于代码块外部

~~~php
if(true){
    $inner = 10
}
echo $inner ;  //output 10 
~~~



## 2.字符串拼接

~~~php
$count = 10
$msg = "123"+$count // output 133
$msg = "123".$count // output 12310
$msg = "123"+string($count) // error!!!
$msg = "123".string($count) // error!!!
~~~



## 3.关于weiphp中的插件

* 

~~~php
	'type' => [
		'title' => '学生类型',
		'type' => 'dynamic_select',
        		//在系统自带的表单中为下拉框显示
		'field' => 'varchar(10) NOT NULL',
		'extra' => 'table=ccnu_usertype&value_field=id&title_field=type_name',
        		// 该字段会关联ccnu_usertype表,且该字段的value值为ccnu_usertype表中的token查找
        		// 出来的相应记录的id值, 且显示字段为type_name
		'remark' => '学生类型',
		'is_show' => 1,
		'is_must' => 1
	]
~~~

* 对插件可以调用系统自带的add等方法,显示是根据data的表单,即使控制器没有定义它



## 4.关于数据库

* 批量更新数据 , 更新数据库中所有记录的某一字段

  ~~~php
  $map['id'] = array('gt',0)			//key值对应数据库中的字段名, gt,0 => id>0 
  $data['token'] = "AVSDFF"			//如果给出一个不存在的key值, 则也会默认更新全部
  M('model_name') -> where($map) -> Save($data)	//此时会一次行操作所有满足where的记录
  ~~~



## 二 . PHP基础语法特性

#### 1. 全局变量

两种方法调用全局变量

* 在需要用的时候 用global关键字定义 e.g.

~~~php
$a = 10;

function test(){
    global $a = 10;
}

~~~

如果不用global 则默认为局部变量

* 使用PHP的全局变数组

~~~php
$a = 10;

function test(){
    $GLOBALS['a'] = 100;
}
~~~

$GLOBALS为保存了php的所有的全局变量的数组



#### 2. PHP常量

~~~php
//constant在脚本的任何地方, 都不能被改变 , 为全局变量
//true 表示不区分大小写 即 CONSTANT = constant
define ('constant', 'www.baidu.com', true);
//www.baidu.com
echo constant;
~~~



#### 3.PHP比较运算符

~~~php
//绝对等于, 需要x==y, 而且x,y的类型也相同
x === y ;
//绝对不等于
x !== y ;
    
x != y is the same as x <> y
~~~



#### 4. PHP逻辑运算符

~~~php
x and y == x && y
x or  y == x || y
~~~



#### 5. PHP数组运算符

~~~php
$array_one = array('a'=>'red',  ...)
$array_two = array('b'=>'blue', ...)
//两个数组取并集
$array_one + $array_two     
//相同的键值对 true
$array_one == $array_two    
//键值对相同, 且顺序同类型同, 则返回true
$array_one === $array_two    
    
~~~



#### 6.PHP数组

* 数值数组 :  array("fangzhou", "REn", ...) 没有指定 key 值默认为数值数组. 
* 关联数组 :  array("name" => "fz", "age" => '12, ...)





































