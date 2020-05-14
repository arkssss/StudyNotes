# Springboot

# 一. 快速开始

### 快速构建一个web应用

springboot 可以快速构建一个 web 应用，步骤如下:

1. 创建一个 `maven` 工程并导入如下依赖:

   ~~~xml
   <parent>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-parent</artifactId>
       <version>1.5.9.RELEASE</version>
   </parent>
   
   <dependencies>
       <!-- https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-web -->
       <dependency>
           <groupId>org.springframework.boot</groupId>
           <artifactId>spring-boot-starter-web</artifactId>
       </dependency>
   </dependencies>
   ~~~

   **spring-boot-start** -==web== 表示启动一个 web应用

   springboot 将所有的功能常见抽取为对应的 start，需要的时候只需要导入对应的启动器即可。

2. 定义一个`Java`主程序

   ~~~java
   package com.ark;
   
   import org.springframework.boot.SpringApplication;
   import org.springframework.boot.autoconfigure.SpringBootApplication;
   
   @SpringBootApplication
   public class HelloWorldApplication {
   
       public static void main(String[] args) {
   		
           /* 
           	启动 springboot 应用
           	需要传入一个 SpringBootApplication
           */
           SpringApplication.run(HelloWorldApplication.class, args);
   
       }
   }
   ~~~

3. 定义相关的 `Controller` 

   ~~~java
   package com.ark.controller;
   
   import org.springframework.stereotype.Controller;
   import org.springframework.web.bind.annotation.RequestMapping;
   import org.springframework.web.bind.annotation.ResponseBody;
   
   @Controller
   public class HelloWorldController {
   
       @ResponseBody
       @RequestMapping("/hello")
       public String hello(){
   
           return "hello world";
           
       }
   
   }
   ~~~

4. 运行主程序即可, 由于 springboot 自带了 tomcat， 所以我们可以直接启动，将比于以前的 SSM 框架极大的简化了我们构建应用的速度

### 快速打包一个web应用



# 二. 基础配置

## 目录结构

~~~
├── pom.xml
├── quick-first-start.iml
└── src
    ├── main
    │   ├── java
    │   └── resources
    │       ├── application.properties # 配置文件
    │       ├── static		# 存在 js, css 等静态资源
    │       └── templates	# 存放模版文件
    └── test
~~~



## 全局配置文件

### 配置文件加载顺序

springboot 加载配置文件的顺序如下:

1. 当前项目根目录下的 config :  `/config`
2. 当前项目根目录 : `/`
3. classpath下的config : `src/resources/config`
4. 🌟 classpath下: `src/resources` 

配置文件加载优先级从 1 到 4， 如果在之前的配置文件已经对数据进行配置，那么只有的文件就会失效。

### 配置文件类型

springboot 中的一般配置文件位于 `src/resources/` 下，可以以下两种方式存在。

* application.properties

  ~~~properties
  # 在 properties 文件中指定端口
  server.port=8888
  
  # 在属性是中文时候，需要在 idea->Preferences->encoding file-> 勾选 Transparent to aciii 防止乱码
  ~~~

* application.yaml

  ~~~yaml
  # 在 yaml 中指定端口
  server:
  	port:8888
  ~~~

可以用于指定整个项目的配置，比如访问端口等.





## 多环境配置文件切换

项目开发是基于不同的环境如 ： 开发环境，生产环境...。springtboot 支持对全局配置文件进行不同的环境配置, 只需要给 application.properties 不同的命令即可 application-{profile}-properties/yaml. 如

* application-dev.properties : 开发环境的配置
* application-prod.properties : 生产环境的配置

启动哪个配置只需要在主文件中指定:

~~~properties
# 启动 application-dev.properties 配置
spring.profiles.active=dev
~~~



# 三. 日志工具

日志系统分为 工具接口 和 工具实现.

==springboot 分别选用先进的 SLF4j 和 logback 作为我们的 接口和实现==

## SLF4j 使用

~~~java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


Logger logger =  LoggerFactory.getLogger(getClass());

/*
日志级别由低到高
可以通过 logger 调整日志输出级别, 从而到只打印高级别的日志信息
*/
logger.trace("trace");
logger.debug("debug");
/*------- 默认级别为 info 级别 ------ */
logger.info("info");
logger.warn("warm");
logger.error("error");
~~~

~~~properties
# 指定 logger 级别
logging.level.com.ark = trace

# logger file 输出文件名
# 默认为当前项目根目录下
logging.file.name=springboot.log
# 指定目录文件path
logging.file.path=

# 指定输出logger格式
logging.pattern.console=
# 指定文件中输出的 logger 格式
logging.pattern.file=
~~~



# 四. 常用注解

## 控制器层

### `@Restcontroller` 注解

~~~java
package com.ark.springcloud.controller;

@RestController
public class PaymentController {

}
~~~

* 如果只是使用 `@RestController` 注解Controller，则Controller中的方法无法返回jsp页面，或者html，配置的视图解析器 InternalResourceViewResolver不起作用，返回的内容就是Return 里的内容 一般即为一个 `Json` 串。

*  `@RestController` = `@Controller` + `@ResponseBody` 

  返回json数据不需要在方法前面加@ResponseBody注解了。

### `@PostMapping` 注解

~~~java
@PostMapping(value = "/payment/create")
public CommonResult create(Payment payment){

}
~~~

即仅处理 `POST` 请求

### `@GetMapping` 注解

~~~java
@GetMapping(value = "/payment/get/{id}")
public CommonResult<Payment> getPaymentById(@PathVariable("id") Long id){

}
~~~

即仅处理 `GET` 请求

### `@RequestBody` 注解

~~~java
/* 
	使用post方式接受值的时候，需要加
	@RequestBodt 注解在传递参数上
*/
@PostMapping(value = "/payment/create")
public CommonResult create(@RequestBody Payment payment){
	// ...
}
~~~



## 组件初始值注入

### `@Value()` 注解

```java
public class Person {
	
    // 在配置文件中寻找 person.name 进行诸如
    @Value("${person.name}")
    private String name;
	
    // 使用表达式注入 110
    @Value("#{11*10}")
    private Integer age;
	
    // bool 值注入
    @Value("false")
    private Boolean boss;

    @Value("2020/01/01")
    private Date birth;

    
    // ....
}
```



### `@ConfigurationProperties()` 在配置文件中批量注入

使用 这个注解需要先倒入 `maven`

```xml
<!-- https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-configuration-processor -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-configuration-processor</artifactId>
</dependency>
```

```java
@Component
@ConfigurationProperties(prefix = "person")
public class Person {
    private String name;
    private Integer age;
    private Boolean boss;
    private Date birth;
    
    //...
}
```

对应配置文件为 :

```properties
person.name=joel
person.age=20
person.birth=1995/11/03
person.boss=true
```



此外， `@ConfigurationProperties()` 还支持如下特性

- 使用 `@ConfigurationProperties()` 方式注入变量的时候，可以同时对变量进行校验: 需要先标示 `@Validated` 注解

  ```java
  @Component
  @Validated
  @ConfigurationProperties(prefix = "person")
  public class Person {
      @Email
      private String name;
      private Integer age;
      private Boolean boss;
      private Date birth;
  
      //...
  }
  ```



### `@PropertySource()` 注解指定配置文件

由于配置数据不可能只写到一个文件中，在大型项目中，我们需要拆分 properties 文件, 而之前的 `@ConfigurationProperties()` 注解默认从 springboot 的主配置上文件中拿值，因此需要指定配置文件

```java
@Component
@ConfigurationProperties(prefix = "person")
@PropertySource(value = {"classpath:person.properties"})
public class Person {
    private String name;
    private Integer age;
    private Boolean boss;
    private Date birth;
    
    
    // ... 
}
```



### `@ImportResource` 导入 Spring 的XML配置文件

像传统的 Spring 方式在 XML 中定义导入一个 bean 进入 IOC 的时候，springboot 并不能识别, 此时我们需要在

主程序中加入该注解使其可以识别 xml 配置文件.

- 第一种方式可以

```java
@SpringBootApplication
@ImportResource(value = {"classpath:"})
public class QuickFirstStartApplication {
    public static void main(String[] args) {
        SpringApplication.run(QuickFirstStartApplication.class, args);
    }
}

```



# 五. 综合话题

## IoC 容器并发安全性

Springboot和传统 Spring一样, 在IoC容器的bean默认都是单例的 包括我们常用的 Controller, Service, Dao 等等。**注意单例的对象同样可以被多线程并发访问**， 因此单例中的成员变量是多线程可访问的，并不是线程安全。

~~~java
/* for example */
@Controller
public class ScopeTestController {

    private int num = 0;

    @RequestMapping("/testScope")
    public void testScope() {
        System.out.println(++num);
    }

    @RequestMapping("/testScope2")
    public void testScope2() {
        System.out.println(++num);
    }

}
~~~

此时同时访问 `/testScope` 和 `/testScope2` 会得到不同的j结果 1, 2 。且和PHP不同，Java 是常驻内存的，对象的成员变量会对所有的请求保存更改，并不会在请求结束后销毁。





















































