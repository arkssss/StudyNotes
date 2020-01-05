[TOC]

# SpringMVC 详解

# 一. 构建 SpringMVC

## 利用 JavaConifg 类代替 XML 文件

利用 SpringMVC 构建的 WEB 项目中, 一般有三个 XML 文件位于 WEB-INF下 : `web.xml` , `dispatcher-servlet.xml` , `applicationContext.xml`,  但是在 `Servlet3.0` 规范中, 我们使用 JavaConfig 替代所有的 XML 文件配置, 让程序变得可读性高. 同样的三个XML对应了三个JavacConfig类

## Web.xml <=> AppNameWebApplicationInitializer

~~~java
package spitter.config;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

// 这个配置文件类的名字可以自己定义, 但是需要继承 AbstractAnnotationConfigDispatcherServletInitializer类
public class SpitterWebApplicationInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {


    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class<?>[] {RootConfig.class}; // Important !!
    }
	
    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class<?>[] {WebConfig.class}; // Important !!
    }
	
    // 这个方法定义 分发器所需要拦截的 URL 地址
    // 如果为 '/' 则表示都拦截
    @Override
    protected String[] getServletMappings() {
        return new String[]{"/"};
    }
}

~~~



在 `AbstractAnnotationConfigDispatcherServletInitializer` 启动的时候,  会同时创建 **两个应用上下文.** 

* 由 `WebConfig` 定义的 web 组件 bean : 一般就是 **控制器, 视图解析器, 处理映射器** 
* 由 `RootConfig` 定义的其他 bean : 通常为 **驱动应用后端的中间层, 数据层组件**

通过 `getServletConfigClasses` 方法返回的带有 `@Configuration` 注解类用来定义 `DispatcherServlet` 应用上下文的beans

通过 `getRootConfigClasses` 方法返回的 带有 `@Configuration` 注解类用来定义用来定义 `ContextLoaderListener` 创建的上下文中的 `bean`

**注意如果项目中, 同时存在 web.xml 和 `AbstractAnnotationConfigDispatcherServletInitializer`, 那么可能会报错 (初始化错误)**





## WebConfig 类

`WebConfig` 用于定义 **一些控制器, 试图解析器, 处理映射器的信息**

一个简单的 `WebConfig`  定义

~~~java
package spitter.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.InternalResourceViewResolver;


@Configuration
@EnableWebMvc	// 这个注解表示开启的 MVC, 很重要
@ComponentScan("spitter.web")
public class WebConfig extends WebMvcConfigurerAdapter {
	
    /*
	  给 Spring 容器加入一个 视图解析的 bean
	  且解析的时候 给 view 定义前缀和后缀
	  注意 SpringMVC 项目的 '/' 默认是存放web静态资源的, 所以 ’/‘ 即为 整个项目的 '/web/' 目录
    */ 
    @Bean
    public ViewResolver viewResolver(){

        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        resolver.setExposeContextBeansAsAttributes(true);

        return resolver;
    }	

    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
       configurer.enable();
    }
}

~~~



# 二. 基本的控制器

## 一个小例子

控制器及为 MVC 中的 C 层, 在 Spring MVC 中, 用于接受 `Dispatcher` 转发的请求

一个简单的 控制器, 表示的含义如下 : 

* **表示该 web 项目的 URL 为 '/hello' 的 GET 请求会被定为到 HomeController 下的 home 方法**
* **返回的 字符串 "Home" 被 SpringMVC 的视图解析器解析为 : /WEB-INF/views/home.jsp 并返回**

~~~java
package spitter.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HomeController {
	
    /*
    	注意此时返回的是, 交给视图解析器的 jsp文件 名称
    */
    @RequestMapping(value = "/hello", method = RequestMethod.GET)
    public String home(){
        return "home";
    }

}

~~~



## @Controller 注解

`@Controller` 是一个基于 `@Component` 的注解, 其实这里写为 `@Component`, 也是一样的效果

只不过使用 `@Controller` 表意上更加友好

被 `@Controller` 修饰的 POJO 类则会被 `webConfig` 扫描的时候, 加入 Spring应用上下文



## @RequestMapping 注解

`@RequestMapping` 控制器修饰方法的时候, 表示这个控制器映射的 `URL` 名称

同时, 也可以修饰类, 表示这个类的所有方法映射 URL 的公共前缀 比如: 

~~~java
@Controller
@RequestMapping("/student")
public class StudentController {

    @Resource(description = "studentRepository")
    private StudentRepository studentRepository;
	
    // 此时 getStudents 方法的 URL 映射为 /student/get
    @RequestMapping("/get")
    public String getStudents(Model model){
        model.addAllAttributes(studentRepository.findStudent(3));
        return "get";
    }

}
~~~



`@RequestMapping` 可以定义多于一个的映射 URL 例如 : 

~~~java
@RequestMapping({"/", "/homepages"})
~~~



## 控制器给 jsp视图 注入数据

可以通过 `Model` 类型的函数传参, 实现给 我们返回的视图渲染数据

~~~java
@RequestMapping("/get")
public String getStudents(Model model){
    model.addAllAttributes(studentRepository.findStudent(3));
    return "get";
}
~~~

Model 其实是一个 Map ("key" => "Value") 形式的封装数据. 它可以被传递给视图, 这样 Jsp 就可以获得渲染数据了, Model 类有如下几种规律

* **当调用 `addAllAttributes` 但是不指定 key 的时候 : **  那么 key 会自动的根据装配的对象确定, 以此为例 value 为 `List<Student>` 类型, 那么key 即为 studentList.

* **当然我们也可以显示的指定 key :** 

* ~~~java
  model.addAllAttributes("students", studentRepository.findStudent(3));
  ~~~

* 如果不想使用 Spring 封装的 Model, **我们亦可以只使用map : ** 

  ~~~java
  @RequestMapping("/get")
  public String getStudents(Map model){
      model.put("students", studentRepository.findStudent(3));
      return "get";
  }
  ~~~



# 三. 控制器接受请求输入

SpringMVC 接受前端浏览器发送的数据有多种方式 : 

* 查询参数 : 一般就是 `GET` 形式拼接在 `URL` 后面的方式
* 表单参数 : 一般就是 `POST` 形式非明文形式发送数据给服务端
* 路径变量 : 一定程度上也 `GET` 数据请求



## 接受 GET 形式数据 (@RequestParam)

一般的形式, 可以在相应的方法传参中, 使用 `@RequestParam` 注解表示接受的 `GET` 数据 : 

~~~java
    @RequestMapping("/find")
    public String getStudentByID(
            @RequestParam(value = "StudentID", defaultValue = "10") long studentID,
            Model model){
        System.out.println(studentID);
        return "find";
    }
~~~

如果以这种形式, 那么接受的可访问的 `URL` 便为 :  `/student/find?StudentID=20`

显然这种访问形式是不理想的, 直接通过 `URL` 的形式标示比通过 问号连接的形式更加友好

**@RequestParam 注解 : **

表示该方法接受前端的 `GET` 数据. 常用的 参数有 :

- Value : 表示接受 `GET` 的数据 `KEY` 名
- defaultValue : 表示如果不传递的默认值





## 接受 GET 形式数据 (@PathVariable)

在原始的 `GET` 传递数据的时候, 我们的 `URL` 表现为  :

`/student/find?StudentID=20` 

此时我们通过 **占位符 + `@PathVariable`** 的形式将其变为 :

`/student/find/20`

~~~java
@RequestMapping(value = "findAD/{StudentID}", method = RequestMethod.GET)
public String getStudentByIDAd(
    // 使用 PathVariable 注解
    @PathVariable(value = "StudentID") long studentID,
    Model model){

    System.out.println(studentID);
    return "findAD";

}
~~~

通过 **`@RequestMapping()`占位符** 的形式实现 : 

在 `value` 参数中利用 `{MyParma}` 进行标注占位符. 此时占位符标注的值要和 `@PathVariable` 相同, 即为 : 

`@PathVariable(name = "MyParma")` , 这样可以直接对 `URL` 进行解析, 并且赋予变量.

**值得注意的是, 通过这种形式是没有默认值的**



## 接受 POST 数据 (普通变量为传参)

`SpringMVC` 接受 `POST` 形式的数据非常简单, **只需要在接受函数的传递参数里面声明即可(变量名和表单的 name 一致)**

例如我们的表单如下 : 

~~~html
   <form method="post">
        <label> studentID :<input type="text" name="studentID" /> </label> <br/>
        <label> name :<input type="text" name="name" /> </label> <br/>
        <label> age :<input type="text" name="age" /> </label> <br/>
        <input type="submit" value="register"/>
    </form>
~~~



则接受的方法可以写为 : 

~~~java
/*
	函数的传递参数顺序不需要和表单一一对应
	只需要变量名一致即可
*/
@RequestMapping(value = "/register", method = RequestMethod.POST)
public String saveStudent(String studentID, String name, String age){
	Student student = new Student(studentID, name, age);
    System.out.println(student);
    return "Register";
}
~~~



## 接受 POST 数据 (实体类为传参)

我们也可以直接在传递参数的时候, 将实体类作为传递参数 :

~~~java
@RequestMapping(value = "/register", method = RequestMethod.POST)
public String saveStudent(Student student){

    System.out.println(student);
    return "Register";
}
~~~

**此种方式有一个值得注意的点 : 实体类通过 无参构造函数 + setter函数 去构造实例**

**因此, 如果通过这种方式, 必须让实体类有 无参构造函数 且定义 setter 方法**



## POST 表单验证 (@valid)

**当以实体类作为 POST 接受传参的时候, 我们可以利用 `@valid` 对实体类相应字段进行验证**

在验证规则上, 我们需要直接定义在实体类的成员变量中 : 

~~~java
// 实体类 Student
public class Student {

    @NotNull
    @Size(min=5, max=16)
    private String studentID;

    @NotNull
    private String name;

    @NotNull
    private String age;

	...
~~~

然后在接受方法控制器中 加入 `@valid` 注解: 

~~~java
@RequestMapping(value = "/register", method = RequestMethod.POST)
public String saveStudent(@valid Student student, Errors errors){
    if(errors.hasErrors()){
        // 验证不通过
        // do somethings ...
    }
    System.out.println(student);
    return "Register";
}	
~~~





# 四. 在 JSP 使用 JSTL 标签步骤

1. 首先在 `web/WEB-INF/lib` 下面倒入两个 `JAR` 包 : `jstl.jar, standard.jar` 

2. 在 `Project Structure` 的 `Modules` 里面添加刚加入的两个 `Jar` 包

3. 在 `Project Structure` 的 `Artifacts` 里面将 刚加入的 `jar` 包  `Put into output root`

4. 在使用相关头文件标签的时候, 引入即可, 例如 : s

   ```jsp
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
   <c:out value="{$ID}">
   ```































































