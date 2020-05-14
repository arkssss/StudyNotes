# RESTful 风格



[TOC]



# 一. RESTful API 概述

RESTful API 其实就可以看作为 基于 HTTP 的 web 服务接口

Spring 中 RESTful 接口的返回值可以有多种 : 

* `application/html` : 最普通的 HTML 类型的返回类型, 这种类型需要经过 Spring 试图类进行解析
* `application/json` : 对 JS 友好, 不需要被视图类解析, 可以直接通过 控制器返回
* `application/xml` : 返回为 xml 类型, 同样不需要配视图类解析

**RESTful 客户端一般是 JavaScript (就是当下最流行的前后端分离的形式), 但也可以是移动端, 甚至是 Spring程序** 





# 二. JSON 返回形式

这种形式的返回需要客户端的请求头支持 Json 返回, 即 : `Accept : applcation/json`

在实现上, 我们需要先将 **Jackson Json Precessor** 导入我们的类库中, **但是它的转换器是自动注册的, 也就是说不需要再通过 JavaConfig 或者 XML 方式去注册**, 这个处理类负责自动的将我们的 Java对象 转化为 JSON 格式从而输出:

例如 : 

~~~java
/**
* 将 Map 变为 Json 格式返回
* @return : {"name":"ark","age":"20"}
*/

@RequestMapping(value = "/map", produces = "application/json")
public @ResponseBody Map testMap(){
    Map<String, String> map = new HashMap<>();
    map.put("name", "ark");
    map.put("age", "20");
    return map;
}
~~~



## @RequestMapping 注解

里面的 **produces** 参数说明了, 返回的媒体类型为 Json 类型.



## @ResponseBody 注解

通常用于修饰一个方法, 这个注解表示了, 这个控制器的结果可以直接作为我们返回给客户端的结果. 而不需要在被视图解析器解析

~~~java
// For Example : 表示直接通过这个控制器, 返回一个 Map类型
public @ResponseBody Map testMap(){
    Map<String, String> map = new HashMap<>();
    map.put("name", "ark");
    map.put("age", "20");
    return map;
}
~~~







# 三. XML 返回形式

需要先导入如下的 Maven 工程 : 

~~~xml
 <!-- java2XML -->
    <dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-databind</artifactId>
      <version>2.5.0</version>
    </dependency>

    <dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-core</artifactId>
      <version>2.5.0</version>
    </dependency>

    <dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-annotations</artifactId>
      <version>2.5.0</version>
    </dependency>

    <dependency>
      <groupId>com.fasterxml.jackson.dataformat</groupId>
      <artifactId>jackson-dataformat-xml</artifactId>
      <version>2.5.0</version>
    </dependency>
  <!-- java2XML -->
~~~



然后更改我们的 produces 即可完成 XML 形式的返回

~~~java

@RequestMapping(value = "/map", produces = "application/xml;charset=utf-8")
public Map testMap(){

    Map<String, String> map = new HashMap<>();
    map.put("name", "ark");
    map.put("age", "20");

    return map;
}
~~~

注意这个方法没有添加 **@Response 注解** 是因为我们直接在类上添加了**@RestController** 注解, 从而表示这个类的方法都不需要被视图解析器解析





# 四. 健壮的 RESTful 接口



## #1. @ExceptionHandle 注解 || 处理异常

考虑如下形式的接口, 接受一个用户的 id, 然后查找该 id 且以 Json 的形式返回给 Client, 最初的写法如下 : 

~~~java
/*
	采用 ResponseEntity<> 的数据类型封装结果
	ResponseEntity<> Spring为自带的封装结果集对象, 可以自定义此次请求的返回消息和状态码
*/
@RequestMapping(value = "/OneEntity/{id}", method = RequestMethod.GET, produces = "application/json")
    public
    ResponseEntity<User> getUserByID(@PathVariable Integer id){

        User user = UserDAO.getOneById(id);

        if(user == null){
            // 没有结果便传递 404的状态码
	        return new ResponseEntity<>(user, HttpStatus.NOT_FOUND);
        }
		
		/// 有结果便传递 200状态码
        return new ResponseEntity<>(user, HttpStatus.OK);
    }
~~~



查看以上代码, **我们可以做如下形式的改进** : 

* 当没有找到对象的时候, 返回一个 **Errror对象** , 而不是 TestTable 对象

* **自定义运行时异常类 UserNotFoundException**, 然后添加一个 **ExceptionHandler** 去捕获本控制器所有异常并进行后续处理
* 最后在这个处理类里面只需要抛出这个异常即可



新增一个 **Entity** `ResponseError.java` :

~~~java
package com.arkssss.entity;
/**
 * 处理错误情况的返回实体
 */
public class ResponseError {

    private int code;

    private String message;

    public ResponseError(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
~~~



新增一个 **UserNotFoundException 异常类 :**

~~~java
package com.arkssss.exception;

public class UserNotFoundException extends RuntimeException{

    private Integer UserId;

    public UserIdNotFoundException(Integer UserId) {
        this.UserId = testTableId;
    }

    public Integer getUserId() {
        return UserId;
    }

    public void setUserId(Integer UserId) {
        this.UserId = UserId;
    }
}
~~~



**使用  @ExceptionHandle 拦截器**

**值得注意的是, @ExceptionHandle 只对相同控制器下的 异常抛出有作用 !!**

~~~java
/**
     * UserNotFoundException 的拦截处理器
     * 可以拦截 本控制器范围内的 UserNotFoundException 异常， 并加以处理
     * @param e
     * @return
     */
@ExceptionHandler(UserNotFoundException.class)
public ResponseEntity<ResponseError> TestTableNotFound(UserNotFoundException e){

    Integer id = e.getTestTableId();
    ResponseError responseError = new ResponseError(id, "the entity : "+ id + " is not found");
    return new ResponseEntity<>(responseError, HttpStatus.NOT_FOUND);
}

~~~

**最后在为空的错误的时候, 直接抛出这个自定义异常即可**



## #2. @ResponseStatus 注解 || ResponseEntity<>

* **ResponseEntity<> (要封装对象, 返回 (HTTP Header), 状态码(HTTP Status), ...):**

  我们使用 **ResponseEntity<>** 封装结果的一个原因就是, 可以通过 **ResponseEntity<>** 封装返回状态码 eg. 404...

  且 **ResponseEntity<>** 为返回值的时候, 可以不用加 **@ResponseBoby注解**

* **@ResponseStatus :** 

  注解可以加在方法之前, 从而可以实现和 ResponseEntity 一样的话返回状态码的效果




# 五. CURL 命令



## #1. 访问 restful 接口

实际上 HTTP 客户端有很多种 : **浏览器**, **curl** 等, 所以只要可以发送 http 请求的就可以称为 http 客户端

**实际上很多爬虫就是通过 curl 命令然后进行网页的抓取和解析的**

在定义 RESTful 接口的时候, 可以很方便的通过 CURL 测试定义的 RESTful 接口, 例如 : 

~~~shell
curl http://localhost:8888/RecommendSystem_war_exploded/JsonApi/EntityList
~~~

**实际上, curl 理论上可以完全模仿 浏览器**, 所以如何防止恶意的 curl 爬虫也是 我们接口需要考虑的问题

> [RESTful 接口安全设计理念](https://www.v2ex.com/t/579256)



## #2. CURL 没有跨域问题

所谓的跨域问题, 就是在 **浏览器** 中, 如果服务器没有开放跨域限制, 那么 **当前脚本只能给当前同域名的服务器发送 HTTP 请求**

CURL命令并不是浏览器客户端, 它可以给 **没有开放跨域限制的服务器发送 HTTP请求**



























