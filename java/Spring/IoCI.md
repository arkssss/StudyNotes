# IoC 装配 与 DI

[TOC]

# 一. IoC 和 DI

IoC 即为 **控制反转**, 各个对象将创建对象的能力交给 IoC 容器去完成, 需要的时候, 直接从容器里面取即可.

我们将容器里面的对象叫做 **组件 (Bean)**

DI 即为 **依赖注入** , 容器里面的各个组件不可能没有依赖关系, 所谓的依赖关系即为 一个组件包含其他组件作为成

员变量. 我们将组件的相互注入的过程叫做 **依赖注入**



## Why IoC & DI

* **动态的装配** 的优势是非常明显的, 比如对于一个数据库访问接口, 可以由 `MySQL` , `SQL Server` , `ORCLAR` 等一些数据库实现, 如果不使用 IoC 和 DI, 那么我们在切换数据库的时候, 会变的异常的麻烦, 应为我们需要改变代码中所有的 `New` 了数据库实现类的代码. **相反的, 如果使用动态装配, 那么我们只需要将不同的 实现放入 IoC 容器即可, 代码不需要修改, 极大的提高了程序的灵活性**







# Spring 装配

Spring 提供三种方式的装配如下 : 

* 自动装配
* Java 代码显示装配
* XML 文件显示装配

在实际场景中, 我们可以选择三种方式配合使用.





# 二. Spring 自动装配

## 自动装配概述 (注解 + Config 类的场景)

一般来说, 自动装配包含以下两个步骤

1. 组件扫描 (Component Scanning) : 使得Spring可以发现我们在上下文定义的 Bean, 且放入我们的 Spring 容器中
2. 自定装配 (autowiring) : 进行依赖注入

也就是说, 自动装配一般的实现为 : **先给需要装备的 POJO 类添加 @Component 注解, 如果 POJO 中有相互依赖的情况, 可以使用 @Autowired 进行 DI , 然后引入一个配置类, 进行包扫描. 最后我们便可以在 应用上下文中 获得 Spring 里面相应的 Bean** 





我们使用 Config 类代替 XML 文件, 可以实现完全的去 XML 化. 先看一个例子

`e.g.`

~~~java
@Component
class CD{
    @Value("上学嗨")
    private String Title;
    
    @Value("法老")
    private String Author;
    
    public void play(){
        sout(Author + Title);
    }
}
             
@Component
class CDPlayer{
    
    // DI
    @Autowired
    private CD myCd;
    
    public void play(){
        myCd.play();
    }
}

@Configuration
@ComponentScan
/*
	注意在 自动装配中. Congfig类可以什么都不定义, 交给 Spring去实现
*/
class CDPlayerConfig{
    
}


public class main{
        public static void main(String[] args) {
        
        	// get IoC container
            // 通过注解的方式获得 IoC 容器
            // 传入注解的类对象
            ApplicationContext applicationContext = new 		 AnnotationConfigApplicationContext(CDPlayerConfig.class);
            
            // 在容器中获得 CDPlayer 组件
			CDPlayer cdplayer = (cdplayer) applicationContext.getBean("CDPlayer");
                        
            // use
			cdplayer.play();
        }
}
~~~

接下来一一解释各个注解的作用 : 

### @Component 

注解 **@Component** 可以告诉 **Spring**, 这个类为一个 Java Bean, 需要放入 IoC 容器

`@Component("rename")` : 可以通过传入参数给该 BeanID 重新命名.

注意如果对 `Bean` 进行了重命名, 在利用 `Factory` 获得的时候, 要进行名称对应

**在包扫描的过程中, 如果扫描到了这个 Component, 则会将实例化这个类切放入应用上下文容器中 , 如何进行实例化又分为如下几个情况 : **

* **如果这个类没有定义构造函数 : ** 则直接利用默认的构造函数去构造, 然后相应的依赖通过 setter 函数注入

* **如果这个类有构造函数, 且没有 DI : ** 则利用这个没有 DI 的构造函数进行实例化

* **如果这个类有构造函数, 且存在DI 的情况, 但是没有加 `@Autowired` 注解 : ** 

  ~~~java
  class Room{
      private Person RoomMate;
      
      // 有 DI, 但是没有加 Autowired 注解
      public Room(Person RoomMate){
          this.RoomMate = RoomMate;
      }
      
  }
  ~~~

  这种情况下, Spring 还是 **不会用这个构造函数进行实例化** , 而是会调用默认的构造函数

* **如果这个类有多个构造函数切都有DI的情况 :**  调用有 `@Autowired` 的构造函数进行实例化

* **如果这个类有多个构造函数, 且都有DI, 都有 `@Autowird` 注解 : **  编译错误 !!!!, 因为构造函数最多只能有一个 `@Autowird` 注解







### @Autowired / @Injection

`@Autowired` 表示自动装配 可以修饰 **属性, 方法, 构造函数**

自动装配可以从 **应用上下文 (ApplicationContext)** 中,这三种装配方式实现的效果是一样的.  **取出和该类型所匹配的 **Bean, **赋值到相应的属性中**. 



* 修饰属性方法即为 : **Field Injection**

  ~~~java
  // DI
  @Autowired
  private CD myCd;
  ~~~

  > [为什么不推荐使用属性注入的方法](<https://www.cnblogs.com/javanoob/p/field_injection_drawbacks.html>)

  直接通过属性注入的方式并不推荐



* 通过 `setter` 方法装配

  ~~~java
  private CD myCd;
  
  @Autowired
  public void setterCD(CD cd){
      this.myCd = cd;
  }
  ~~~

  将 `CD Bean` 装配到 `CDPlayer`



* 通过 构造函数的方法装配

  ~~~java
  class CDPlayer{
      
      private CD myCd;
      
      @Autowired
      public CDPlayer(CD cd){
          this.myCd = cd;
      }
  }
  ~~~



* 通过任意函数实现 DI 的效果 (类似于 Setter 函数), **可以发挥和 setter 完全一样的作用**

  ~~~java
  class CDPlayer{
      
      private CD myCd;
      
      @Autowired
      public MyInjection(CD cd){
          this.myCd = cd;
      }
  }
  ~~~



**@Injection** 在大部分情况下, 和 `@Autowired` 作用一样



### 使用 @Autowired 注入一个接口的实现

当使用 **@Autowired** 注入一个接口 例如: 我们有一个 dataBase 接口, 有 mysql, Orcal 两个实现类

由于并不能对接口进行实例化, 所以 : 

* 当这个接口只有一个实现类的时候, **默认使用这个实现类进行注入**
* 当这个接口有不只一个实现类, **那么会某人注入这个注解修饰变量名相同的实现类**. 如果没有则抛出错误

也就是说, 先利用 byType, 如果有一样再利用 byName.

### @Resouece

`@Resouece` 和 `@Autowired` 作用一样, 都是用于依赖注入.

`@Resouece` 即为根据 BeanID 进行装配, 所以可以根据 BeanID 直接定位一个精确的 Bean

~~~
@Resouece(name = "BeanID")
~~~







### @Configuration

用于修饰一个 **配置类**

**配置类 功能即为 原有的 XML 文件的功能** , 可以让我们代码更加的美观易读, 没有冗长的 XML 文件. 

配置类的作用和 XML 相同, 用来定义 各个Bean 的属性 ...



### @ComponentScan (包扫描)

`@ComponentScan` 一般配合 `@Configuration` 一起使用, 可以在定义配置类的基础上, 去进行包扫描.

如果用注解的方式去定义 `Bean` 那么, 我们需要告诉 `Spring` 去发现哪些组件是我们的 `Java Bean`.

对于 **包扫描** 我们可以有下面三种情况 : 



**默认情况的单包扫描 : **

默认情况下. `@ComponentScan` 会扫描与 **配置类同包的所有文件**. 如果发现了一个带有 `@Component` 的类, 从而为

为其创建一个 `Bean`



**自定义多包扫描 : **

如果需要进行多个包的扫描, 我们可以为 `@ComponentScan` 指定相应的参数 : 

`@ComponentScan(basePackage = {"package1", "package2", ...})`



**自定义类扫描 : **

如果不想整个整个的包进行扫描, 我们还可以指定哪些类需要进行扫描, 而不需要指定相应的包 

`@ComponentScan(basePackageClasses={CDPlayer.class, Person.class, ...})`



## 自动装配特点

相比于其他两种装配方式, **自动装配有如下特点 : **

* 配置类 `Config` 可以什么都不定义, 只需要定义包扫描的地方, Spring就可以获得所有的 `Bean `且加入到 应用上下文.

* 在使用 `ApplicationContext` 获得相应的 `Bean` 的时候, 要注意 `Bean` 的名字是否正确:  

  ~~~java
              ApplicationContext applicationContext = new 		 AnnotationConfigApplicationContext(CDPlayerConfig.class);
  
  
  // 在容器中获得 CDPlayer 组件
  
  // 1. 如果类名为全部都是大写字母(或者首单词为大写), 那么 Bean 名字和类名一样
  CDPlayer cdplayer = (cdplayer) applicationContext.getBean("CDPlayer");
  
  // 2. 如果类名为驼峰, 那么 Bean 名字为类名首字母小写
  CDPlayer cdplayer = (cdplayer) applicationContext.getBean("compactDiscImpl");
  ~~~



# 三. Spring 通过 Java 代码进行 显示装配

## JavaConfig 显示装配

在大多是情况下,  **自动装配是我们更好的选择** , 但是在有些无法进行自动装配, 比如 : 引用第三方 jar 包的时候, 我们不可能

去给源代码添加 @Component 获得 @Autowired 注解, 这种时候, 我们则需要进行显示的装配. 

利用JavaConfig类 显示装配的步骤 : **在普通的 POJO 对象中, 我们便没有必要去添加 @Component 注解, 而是改为在 Config 文件中添加一个以 POJO 类为方法名字的 成员方法. 在 POJO 对象内部的依赖中, 我们也不需要使用 @Autowired 注解, 而是在 Config 类相应的方法内部去传递相应的依赖. 最后便可以通过 ApplicationContext 去获得相应的 Java Bean**

代码实例如下 : 

~~~java

/*
	1
	此时便没必要去添加 ComponentScan注解
	此时我们在 Config 类里面定义了所有的 Java Bean
*/
@Configuration
public class SchoolConfig {

    /*
    	显示装配传入 构造器 DI
    */
    @Bean
    public School school(Student student){
        return new School(student);
    }

    @Bean
    public Student student(){
        return new Student();
    }

}


/*
	2
*/
public interface Person {
    void walk();
}


/*
	3
	POJO 类不需要添加 @Component
*/
public class Student implements Person{

    @Value("fz")
    String name;

    @Override
    public void walk() {
        System.out.println("Im " + name + " Im walking");
    }
}




/*
	4	
    POJO 类不需要添加 @Component
*/
class School {

    private Student student;
	
    /*
    	不再使用 @Autowired 去实现 DI
    	而是在 Config 里面传入相应的 类
    */
    School(Student student) {
        this.student = student;
    }

    void walk(){
        student.walk();
    }

}

/*
	View 层
*/

public class ViewSchool {

    public static void main(String[] args) {


        ApplicationContext applicationContext = new AnnotationConfigApplicationContext(SchoolConfig.class);

        School school = (School) applicationContext.getBean("school");

        school.walk();
    }

}
~~~



## JavaConfig 类里面实现 DI

在 **不能使用 @Autowired 的情景下**, 我们可在 `JavaConfig` 类里面进行 DI 

这种方式下, 我们可以采用

* 构造函数 DI
* setter 函数 (或者其他自定义函数) DI

~~~java
/*
	Config DI 演示
*/

@Configuration
class MyConfig{
    
    /*
    	当 Home 通过构造函数注入 homeMember 的时候
    	我们在 Config 类里 对应的写法如下
    */
    @Bean
    public Home home(HomeMember homeMember){
        return new Home(homeMember);
    }
    
    /*
    	当 School 通过 setter 函数注入 Student 的时候
    	在 Config 类对应的写法如下
    */
    @Bean
    public School school(Student student){
        School school = new School();
        school.setStudent(student);
        return school;
    }
}
~~~



## JavaConfig 类里面实现 DI 关键点

* 在利用 构造函数, setter函数 DI 的时候, 当 Spring 遇到我们方法的传递参数的时候, 会自动的调用去容器寻找 相应的 Bean   到方法中, **但是注意, 这里的 Bean 不一定是通过这个配置文件定义的, 也可以是其他的配置文件, 或者其他的装配方法 (XML, 自动装配) 都可以.**
* 利用 JavaConfig **可以使用任意的方式去创建一个 Bean 实例**. 方法就在于 Config 文件里面返回一个对象的时候, 我们可以加入自己的代码

# 四. Spring 通过 XML 文件实现装配

通过 `XML` 的方式实现 ID 和 装配, 算是 Spring 旧期的一个机制, **在不使用 XML 的情况下, 尽量不要使用 XML 的方式**

**XML 的功能和 Config 类相似**, 因此如果使用 XML 的装配方法, 则可以不使用 Config 类. 亦可以不使用注解

## 利用 XML 定义 Bean

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- 利用 XML 文件的装配 -->
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

<!-- XML文件一般就就是要写 全限定类名 -->
<bean id="jeep" class="com.arkssss.DI.XmlDI.Jeep" />
<bean id="road" class="com.arkssss.DI.XmlDI.Road" >
    <!--构造器注入, 注意Road类里面需要有 这个参数匹配的构造函数-->
    <constructor-arg ref="jeep" />
</bean>
</beans>
~~~



## 利用 XML 构造器 DI

**注意利用 XML 构造器 DI 的时候, 需要相应的 Bean 里有相应的构造函数**

* **构造器注入标签 : ** `<constructor-arg />`  为 `<bean>` 标签的一个子标签, 用于构造函数的 DI
* **注入其他 Bean : ** `ref` 属性用于注入其他的 Bean
* **注入基本数据类型 + String :** `value`  属性用于注入 **基本数据类型 + String**

~~~XML
<!-- XML文件一般就就是要写 全限定类名 -->
<bean id="jeep" class="com.arkssss.DI.XmlDI.Jeep">
    <!--构造器注入    -->
    <constructor-arg value="Jeep"/>
    <constructor-arg value="10 km/s" />
</bean>
<bean id="road" class="com.arkssss.DI.XmlDI.Road" >
    <!--构造器注入    -->
    <constructor-arg ref="jeep" />
</bean>
~~~

* **注入 List\<basicType> / Set\<basicType> 容器 : ** `<list> <value> </value> </list>` 为 `<constructor-arg/>` 的子属性 用于注入 `List` 类型的容器初始值

~~~xml
<bean id="jeep" class="com.arkssss.DI.XmlDI.Jeep">
    <!--构造器注入    -->
    
    <!--注入String    -->
    <constructor-arg value="Jeep"/>
    <constructor-arg value="10 km/s" />

    <!--注入List    -->
    <constructor-arg>
        <list>
            <value>fangzhou</value>
            <value>ark</value>
            <value>Bill</value>
        </list>
    </constructor-arg>
</bean>
~~~

* **注入 List\<bean> / Set\<set> 容器 : ** 当容器的值为 其他Bean 的情况: `<List> <ref bean="a"/> <ref bean="b"/> </List>`





## 利用 XML setter 函数 DI

**通过 构造器注入的都是 强依赖的属性 (即没有这些属性, 就不能去实例化这个类)** , 但是碰到一些 **非强依赖属性的时候** , 我们便可以通过 **setter 函数后续注入**

* **`<property/>` 标签执行 setter DI 其他类型的 bean :**  `name` 属性 表示 set函数的后面的值, ref 表示通过 set 函数注入的 `bean`

  ~~~xml
  <bean id="road" class="com.arkssss.DI.XmlDI.Road" >
      <!--void setCar(Car car){...} 注入-->
      <property name="car" ref="jeep" />
  </bean>
  ~~~

* **`<property/>` 标签执行 setter DI 八种基本类型 + string :**  

  ~~~xml
  <bean id="road" class="com.arkssss.DI.XmlDI.Road" >
  	<!--void setCar(String car){...} 注入-->
      <property name="car" value="jeep" />
  </bean>
  ~~~

* **同 `<constructor-arg>` 一样, `<property>` 也可以包含 `<List>` 标签**  去定义 `List` 类型的初始值





# 五. 混合装配

在现实生产中, 三种装配的方式, 都会存在. 所以需要保证在其他的文件中可以相互引用对方已经装配的 `Bean`

## @Import 组合不同的 JavaConfig

有时候 `JavaConfig` 可能定义在多个文件中, 每一个文件定义自己的 `Bean`, 那么我们最后可以利用 **`@Import()`** 注解在一个 `JavaConfig` 中引入另一个 `JavaConfig`

```java
/*
	Config 1
*/
@Configuration
public class SchoolConfig{
 	   
}

/*
	Config 2
*/
@Configuration
public class HomeConfig{
 	   
}

/*
	CombineConfig
*/
@Configuration
@Import({SchoolConfig.class, HomeConfig.class})
public class CombineConfig{
   	
}
```



## @ImportReource JavaConfig 类中引用 XML 文件

**在 JavaConfig 类中去引用 XML 文件里面定义的 Bean**

~~~java
/*
	CombineConfig
*/
@Configuration
@Import({SchoolConfig.class, HomeConfig.class})
@ImportResource("XMLDI.xml")
public class CombineConfig{
   	
}
~~~



## XML 文件引用其他 XML

使用 `<improt resouce="path">` 标签, 可以实现 XML 引用其他 XML



## XML 文件引用 JavaConfig

~~~XML
<bean class="arksss.HomeConfig"/>
~~~




















