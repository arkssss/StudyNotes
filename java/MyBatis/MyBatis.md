

- [Spring 持久层](#spring-%E6%8C%81%E4%B9%85%E5%B1%82)
- [一. 数据库 数据源配置](#%E4%B8%80-%E6%95%B0%E6%8D%AE%E5%BA%93-%E6%95%B0%E6%8D%AE%E6%BA%90%E9%85%8D%E7%BD%AE)
  - [I. 数据库连接池的数据源配置](#i-%E6%95%B0%E6%8D%AE%E5%BA%93%E8%BF%9E%E6%8E%A5%E6%B1%A0%E7%9A%84%E6%95%B0%E6%8D%AE%E6%BA%90%E9%85%8D%E7%BD%AE)
  - [II. 基于 JDBC 驱动的数据源](#ii-%E5%9F%BA%E4%BA%8E-jdbc-%E9%A9%B1%E5%8A%A8%E7%9A%84%E6%95%B0%E6%8D%AE%E6%BA%90)
- [二. Spring 的持久层操作 (JDBC)](#%E4%BA%8C-spring-%E7%9A%84%E6%8C%81%E4%B9%85%E5%B1%82%E6%93%8D%E4%BD%9C-jdbc)
  - [Spring 中使用 模版JDBC](#spring-%E4%B8%AD%E4%BD%BF%E7%94%A8-%E6%A8%A1%E7%89%88jdbc)
  - [利用 JDBC 模版 插入数据](#%E5%88%A9%E7%94%A8-jdbc-%E6%A8%A1%E7%89%88-%E6%8F%92%E5%85%A5%E6%95%B0%E6%8D%AE)
- [MyBatis 框架](#mybatis-%E6%A1%86%E6%9E%B6)
- [一. ORM 思想](#%E4%B8%80-orm-%E6%80%9D%E6%83%B3)
- [二. MyBatis Hello World](#%E4%BA%8C-mybatis-hello-world)
  - [#1. 确定数据表结构和 POJO 类](#1-%E7%A1%AE%E5%AE%9A%E6%95%B0%E6%8D%AE%E8%A1%A8%E7%BB%93%E6%9E%84%E5%92%8C-pojo-%E7%B1%BB)
  - [#2. 确定持久层接口](#2-%E7%A1%AE%E5%AE%9A%E6%8C%81%E4%B9%85%E5%B1%82%E6%8E%A5%E5%8F%A3)
    - [基于 XML](#%E5%9F%BA%E4%BA%8E-xml)
    - [基于注解](#%E5%9F%BA%E4%BA%8E%E6%B3%A8%E8%A7%A3)
  - [#3. MyBatis 主配置文件 || 数据源 || 打印执行Log](#3-mybatis-%E4%B8%BB%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6--%E6%95%B0%E6%8D%AE%E6%BA%90--%E6%89%93%E5%8D%B0%E6%89%A7%E8%A1%8Clog)
  - [#4. Mapper 基于XML配置的定义](#4-mapper-%E5%9F%BA%E4%BA%8Exml%E9%85%8D%E7%BD%AE%E7%9A%84%E5%AE%9A%E4%B9%89)
  - [#5. Get Start !!](#5-get-start-)
- [三. MyBatis CRUD 操作](#%E4%B8%89-mybatis-crud-%E6%93%8D%E4%BD%9C)
  - [#1. 保存操作](#1-%E4%BF%9D%E5%AD%98%E6%93%8D%E4%BD%9C)
  - [#2. 更新操作](#2-%E6%9B%B4%E6%96%B0%E6%93%8D%E4%BD%9C)
  - [#3. 删除操作](#3-%E5%88%A0%E9%99%A4%E6%93%8D%E4%BD%9C)
  - [#4. 根据 ID 查询用户](#4-%E6%A0%B9%E6%8D%AE-id-%E6%9F%A5%E8%AF%A2%E7%94%A8%E6%88%B7)
  - [#5. 根据 Name 模糊查找](#5-%E6%A0%B9%E6%8D%AE-name-%E6%A8%A1%E7%B3%8A%E6%9F%A5%E6%89%BE)
  - [#6. 查询 Count 返回类型](#6-%E6%9F%A5%E8%AF%A2-count-%E8%BF%94%E5%9B%9E%E7%B1%BB%E5%9E%8B)
  - [手动 Commit || 自动 Commit](#%E6%89%8B%E5%8A%A8-commit--%E8%87%AA%E5%8A%A8-commit)
- [四. MyBatis 参数解析](#%E5%9B%9B-mybatis-%E5%8F%82%E6%95%B0%E8%A7%A3%E6%9E%90)
  - [#1. parameterType 输入类型](#1-parametertype-%E8%BE%93%E5%85%A5%E7%B1%BB%E5%9E%8B)
    - [-- POJO 对象传入解析过程 --](#---pojo-%E5%AF%B9%E8%B1%A1%E4%BC%A0%E5%85%A5%E8%A7%A3%E6%9E%90%E8%BF%87%E7%A8%8B---)
    - [-- 多 POJO 包装类 --](#---%E5%A4%9A-pojo-%E5%8C%85%E8%A3%85%E7%B1%BB---)
    - [-- $ 和 # 的区别 --](#----%E5%92%8C--%E7%9A%84%E5%8C%BA%E5%88%AB---)
  - [#2. resultType 结果类型](#2-resulttype-%E7%BB%93%E6%9E%9C%E7%B1%BB%E5%9E%8B)
  - [#3. resultMap 结果类型](#3-resultmap-%E7%BB%93%E6%9E%9C%E7%B1%BB%E5%9E%8B)
- [五. MyBatis 动态SQL](#%E4%BA%94-mybatis-%E5%8A%A8%E6%80%81sql)
  - [#1. IF 标签](#1-if-%E6%A0%87%E7%AD%BE)
  - [#2. WHERE 标签](#2-where-%E6%A0%87%E7%AD%BE)
  - [#3. FOREACH 标签](#3-foreach-%E6%A0%87%E7%AD%BE)
    - [-- 实现 SQL 中的 IN 操作 --](#---%E5%AE%9E%E7%8E%B0-sql-%E4%B8%AD%E7%9A%84-in-%E6%93%8D%E4%BD%9C---)
- [六. Mybatis 高级查询](#%E5%85%AD-mybatis-%E9%AB%98%E7%BA%A7%E6%9F%A5%E8%AF%A2)
  - [#1. 多表联合查询](#1-%E5%A4%9A%E8%A1%A8%E8%81%94%E5%90%88%E6%9F%A5%E8%AF%A2)
    - [-- Implement 1 : 新建一个 domain 查询 POJO --](#---implement-1--%E6%96%B0%E5%BB%BA%E4%B8%80%E4%B8%AA-domain-%E6%9F%A5%E8%AF%A2-pojo---)
    - [-- Implement 2 : 直接在原 POJO 进行封装 --](#---implement-2--%E7%9B%B4%E6%8E%A5%E5%9C%A8%E5%8E%9F-pojo-%E8%BF%9B%E8%A1%8C%E5%B0%81%E8%A3%85---)
- [七. Mybits 注解 消灭 XML](#%E4%B8%83-mybits-%E6%B3%A8%E8%A7%A3-%E6%B6%88%E7%81%AD-xml)
  - [#1. 取代主配置文件](#1-%E5%8F%96%E4%BB%A3%E4%B8%BB%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6)



# Spring 持久层

Spring 在持久层提供多种实现选择, 包括: 

* JDBC
* Hibernate
* Java 持久化 API
* ....

在项目中, 根据自己需求选择即可.

持久层对象一般被称为 : **Data Access Object (DAO)**  同时也被称为 **Repository**

在持久层最好的设计方法即为 : **面向接口的编程**

因为 设计到数据库种类的不同, 我们细节的实现方式也不同, 所以利用接口定义共有的 CRUD 操作. 然后根据不同的 数据库, 做出相应的实现, 最后在使用中进行动态的装配即可.



# 一. 数据库 数据源配置

数据源配置即为需要配置连接的数据库的 **一些参数的配置 (这些基本的连接参数即为数据源配置)**, Spring 提供几种方式去配置数据源

* 数据库连接池的数据源
* JDBC 驱动程序定义的数据源



## I. 数据库连接池的数据源配置

Spring 可以使用现在主流的数据库连接池 作为 数据源的配置, 包括:

* C3P0
* Apache Commons DBCP
* BoneCP



## II. 基于 JDBC 驱动的数据源

通过 JDBC 定义数据源是 Spring 里面只最简单的一种配置方法. 以满足一些基本的持久层需求

Spring 提供三种 数据源类 

* `DriverManagerDataSource` : 在每个连接请求的时候, 都会返回一个新建的连接. **且由其定义的数据源并没有池化的功能**
* `SimpleDriverDataSource` : 与上一种工作方式类似, 直接使用 JDBC 驱动
* `SingleConnectionDataSource` : **每个连接都返回同一个连接, 不是严格意义上的连接池, 但是可以视为只有一个链接的连接池**

**以 `DiverManagerDataSource` 为例子 定义数据源:** 

~~~java
@Bean
public DataSource dataSource(){
    DriverManagerDataSource ds = new DriverManagerDataSource();
    // 注意此时要引入 MySQL 驱动的 JAR 包
    ds.setDriverClassName("com.mysql.jdbc.Driver");

    // 定义数据库
    ds.setUrl("jdbc:mysql://localhost/my_test");

    ds.setUsername("root");
    ds.setPassword("19951103");

    return ds;
}
~~~

**由于不提供链接池的功能, 使用 JDBC 作为数据源, 用于一些小应用或小的开发环境是不错的, 但是一旦放在工业级别的生产环境, 变力不从心了.**

# 二. Spring 的持久层操作 (JDBC)



## Spring 中使用 模版JDBC

在利用 **JDBC** 定义数据源后, 我们可以利用 **JDBC模版** 实现对持久层的操作

**什么是 JDBC 模版 :**

众所周知, 利用 **JDBC** 进行一次 持久层操作, 涉及数据库资源链接关闭等操作等一些重复的代码, **JDBC 模版可以将这些重复的代码抽离出去, 从而可以让持久层更加专注的实现自己的逻辑**

**在使用 JDBC模版的时候, 需要利用 JDBC 数据源 将其初始化为一个 `@bean` ** , 如下 : 

~~~java
/*
	JdbcTemplate 仅是一个接口
	在持久层使用的时候, 需要使用其对应的 实现类 JdbcOperations
*/
@Bean
public JdbcTemplate jdbcTemplate(DataSource dataSource){
    return new JdbcTemplate(dataSource);
}
~~~



在 声明这个 @bean 之后, 我们便可以在 持久层里面使用 **JDBC 模版了** : 

~~~java
private JdbcOperations jdbcOperations;

/*
	jdbcOperations 为 JDBC 模版接口的实现
*/
@Autowired
public StudentRepositoryMySQLImpl(JdbcOperations jdbcOperations) {
    this.jdbcOperations = jdbcOperations;
}
~~~



## 利用 JDBC 模版 插入数据

~~~java
/*
	使用 JDBC 模版后 变可以极大的简化 持久层操作了
	插入一条数据为例
*/
public class StudentSQL {
public final static String INSERT_STUDENT = "insert into studentInfo(id, age, name) values (?,?,?)";
}


@Override
public boolean addStudent(Student student) {
    jdbcOperations.update(StudentSQL.INSERT_STUDENT,
                          student.getStudentID(),
                          student.getAge(),
                          student.getName()
                         );
    return false;
}
~~~





# MyBatis 框架

**持久层框架 : 封装了 JDBC 操作的细节, 且利用 ORM 思想封装返回结果集**











# 一. ORM 思想

Object Relational Mapping 对象关系映射

**可以实现将我们程序中的 POJO实体类 和数据表对应**

1. 所以为了方便, 我们一般将 **实体类中的属性名和数据库的字段名设置为一致**
2. **但是 POJO 类的类名没必要与我们数据表相同**, 因为在实现的时候会指定 POJO 的权限定类名



# 二. MyBatis Hello World

我们以 MyBatis 框架, **执行一个最基本的查询操作来看, 需要以下的几个步骤 :**



## #1. 确定数据表结构和 POJO 类

假设我们表为 StudentInfo 的表结构为 : 

| 字段 | 类型     |
| ---- | -------- |
| name | varcharr |
| age  | varchar  |
| id   | tinyint  |

对应的我们的 POJIO 类定义为 : 

~~~java
package com.arkssss.domain;

public class StudentInfo {
	
    /*
    	这里的字段类型和名称要对应数据表
    */
    private Integer id;
    private String age;
    private String name;
    
    @Override
    public String toString() {
        return "StudentInfo{" +
                "id=" + id +
                ", age='" + age + '\'' +
                ", name='" + name + '\'' +
                '}';
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getAge() {
        return age;
    }

    public void setAge(String age) {
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}

~~~





## #2. 确定持久层接口



### 基于 XML

和以往的架构一样, 我们需要定义一个持久层接口, 然后便于给出不同版本的实现.

然而在 **MyBatis 中我们甚至可以不需要给出 接口的实现, 便可以直接获得查询数据**

~~~java
/*
	持久层接口
*/
public interface IStudentDao{
    // 定义一个查询, 表示获得数据库中所有的 StudentInfo
    List<StudentInfo> getAll();
}
~~~







### 基于注解

和基于 XML 方式不一样的是, 在基于注解的方式上, 我们直接将 **数据库操作语句写在了 持久层接口上 :**

如果使用基于注解的方式, 那么我们便可以不写 **Mapper 的 xml 文件**

~~~java
/*
	持久层接口
*/
public interface IStudentDao{
    // 定义一个查询, 表示获得数据库中所有的 StudentInfo
    
    @Select("select * from StudentInfo")
    List<StudentInfo> getAll();
    
}
~~~







## #3. MyBatis 主配置文件 || 数据源 || 打印执行Log

我们利用 MyBatis 实现持久层操作, 自然要为 MyBatis 配置数据源. 

**一个 MyBatis 有一个总的配置文件, 用于定义 MyBatis 连接数据库的一些参数细节:** 

`SqlMapConfig.xml`

~~~xml

<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    
    <settings>
        <!--配置 MySQL 执行 log -->
        <setting name="logImpl" value="STDOUT_LOGGING" />
    </settings>
    
    
    <environments default="development">
        <!--配置 mysql 环境-->
        <environment id="development">

            <!-- 事务类型           -->
            <transactionManager type="JDBC"/>

            <!--配置数据源-->
            <dataSource type="POOLED">

                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/my_test"/>
                <property name="username" value="root"/>
                <property name="password" value="19951103"/>
            </dataSource>
        </environment>
    </environments>


    <!--指定映射配置文件的位置-->
    <mappers>
        	
        
        <!--基于 XML 方式-->
	    <!--指定一个我们定义的持久层接口mapper的 全类名-->
        <mapper resource="com/arkssss/Resource/mapper/IStudentDao.xml"/>
        
        <!--基于 注解方式-->
	    <!--指定一个我们定义的持久层接口的 全类名-->
        <mapper class="com.arkssss.dao.IStudentDao"/>
        
    </mappers>
</configuration>
~~~



​	

## #4. Mapper 基于XML配置的定义 

最后我们需要将 POJO 和 数据库操作联系起来, 从而定义一个 Mapper 的 XML 文件进行配置

`IStudentDAO.xml`

~~~xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<!--这个Mapper 关联的DAO接口 的全限定类名-->
<mapper namespace="com.arkssss.dao.IStudentDao">

    <!-- 配置查询所有 -->
    <!-- 注意这里的 id 必须对应 持久层接口的 方法名 -->
    <select id="getAll" resultType="com.arkssss.domain.StudentInfo">
        select * from studentinfo
    </select>

</mapper>
~~~





## #5. Get Start !!

在上面四个步骤准备就绪之后, 我们便可以使用 **MyBatis** 框架开始我们的 数据库操作 : 

MyBatis 的使用 主要涉及到的类为 : 

* SqlSessionFactoryBuilder 类 : **用于读取 总的 XML 文件, 且生成对应的 SqlSessionFactory**

* SqlSessionFactory 类 : **用于生成一个 sqlSession 实例**
* sqlSession 类 : **用于 真正的 数据库操作**

~~~java
package com.arkssss.main;

import com.arkssss.dao.IStudentDao;
import com.arkssss.domain.StudentInfo;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public class TestDemo {

    public static void main(String[] args)throws IOException {

        // 读物 Mybatis 总的配置文件
        InputStream in = Resources.getResourceAsStream("com/arkssss/Resource/SqlMapConfig.xml");


        // 创建 SqlSessionFactory 工厂
        SqlSessionFactoryBuilder sqlSessionFactoryBuilder = new SqlSessionFactoryBuilder();
        SqlSessionFactory sqlSessionFactory = sqlSessionFactoryBuilder.build(in);


        // 生产 Session 对象
        SqlSession sqlSession = sqlSessionFactory.openSession();

        // 利用 Session对象基于 Mapper.xml 创建 代理接口实例
        IStudentDao studentDao = sqlSession.getMapper(IStudentDao.class);

        // 执行
        List<StudentInfo> studentInfos = studentDao.getAll();

        for(StudentInfo studentInfo : studentInfos) System.out.println(studentInfo);

    }

}
~~~



# 三. MyBatis CRUD 操作

## #1. 保存操作



**普通的保存操作**

基于 XML 的保存一个POJO到数据库的操作 : 

~~~XML
<!-- 配置插入操作-->
<insert id="saveStudent" parameterType="com.arkssss.domain.StudentInfo">
    insert into StudentInfo(name, age) values (#{name}, #{age})
</insert>
~~~

在对应的 Mapper 文件中使用 **insert** 标签, id 依然对应 接口的方法名称

**parameterType属性 :** 用于指定在 **插入操作的 POJO 类的全限定类名.** 

insert 语句中, **使用 #{} 来指定 POJO 中的字段名称 和 插入语句对应**

<hr>

**保存的同时获取这个记录的 ID**

在 Mybatis 中使用 MySQL的 `last_insert_id()` 函数

~~~xml
<insert id="saveStudent" parameterType="com.arkssss.domain.StudentInfo">
    <selectKey keyColumn="id" keyProperty="id" order="AFTER" resultType="Integer">
        select last_insert_id();
    </selectKey>
    insert into StudentInfo(name, age) values (#{name}, #{age})
</insert>
~~~

**keyColumn 对应实体类的属性名称**



这样在函数的返回时, 会自动的将插入的实例的 ID 值赋为数据库的对应的 ID

~~~java
StudentInfo studentInfo = new StudentInfo();
studentInfo.setName("ark3");
studentInfo.setAge("40");
// id = null
System.out.println(studentInfo);
studentView.saveOne(studentInfo);
// id = 33
System.out.println(studentInfo);
~~~



**在高并发的情况下, `last_insert_id()` 也并没有 安全隐患 !!!** 

> 生成的ID在*每个连接*的服务器中维护 。这意味着函数返回给定客户端的`AUTO_INCREMENT`值*是为该客户端*影响`AUTO_INCREMENT`列*的*最新语句生成的第一个 值 。该值不会受到其他客户端的影响，即使它们生成 `AUTO_INCREMENT`自己的值也是如此。此行为可确保每个客户端都可以检索自己的ID，而不必担心其他客户端的活动，也不需要锁或事务。
>
> [MySQL Reference](<https://dev.mysql.com/doc/refman/8.0/en/information-functions.html#function_last-insert-id>)

也就是说, 这个 ID 的获并不是基于整表的, 而是基于这一个特定的客户端, 所以不存在并发的安全问题







## #2. 更新操作

和 插入操作类似. 更新操作, 也只需要定义 一个 **Update 标签**:

~~~xml
<!-- 更新操作-->
<update id="updateStudent" parameterType="com.arkssss.domain.StudentInfo">
    update StudentInfo set name=#{name}, age=#{age} where id=#{id}
</update>
~~~

同样的, 调用的最后需要手动的 Commit



## #3. 删除操作

和 插入操作类似, 删除操作, 也只需要定义一个 **Delete 标签**:

~~~xml
<!-- 删除操作-->
<delete id="deleteStudent" parameterType="Integer">
    delete from StudentInfo where id=#{id}
</delete>
~~~

注意此时对应的 DAO 接口的方法为 : 

传入的参数为一个 Integer 类型

~~~java
// 删除
void deleteStudent(Integer id);
~~~

注意当传递的操作只有一个基本数据类型的时候, **在 XML 上些占位符的字段名可以任意定义**, 因为只有一个传参, 所以 MyBatis 一定一个找到





## #4. 根据 ID 查询用户

`Select` 标签 :

~~~xml
<!-- 选择一个 -->
<select id="selectOneById" parameterType="Integer" resultType="com.arkssss.domain.StudentInfo">
    select * from StudentInfo where id=#{id}
</select>
~~~



## #5. 根据 Name 模糊查找

**在Mybatis中模糊查找和普通查找在 XML 中的写发差不多, 且模糊查找的 `%` 并不出现在 XML 定义中**

~~~xml
<!-- 根据 Name 模糊查找 -->
<select id="selectOneByName" parameterType="String" resultType="com.arkssss.domain.StudentInfo">
    select * from StudentInfo where name like #{id}
</select>
~~~

为了实现模糊查找, **`%` 需要在参数传递的时候传入**

~~~java
studentDao.selectOneByName("ark%")
~~~



## #6. 查询 Count 返回类型

注意返回值的类型写为。**Integer / int**

~~~xml
<!-- Count 返回值查询-->
<select id="countAll" resultType="Integer">
    select count(*) from StudentInfo
</select>
~~~







## 手动 Commit || 自动 Commit

**在修改操作中, 需要手动的调用 SqlSession 的 Commit 操作, 否则插入的数据会 RollBack**

```java
// 执行 保存一个学生
StudentInfo studentInfo = new StudentInfo();
studentInfo.setAge("100");
studentInfo.setName("RenYiXuan");

// 保存 一个学生
studentDao.saveStudent(studentInfo);

// 如果不手动 commit 则会插入失败, 但是并没报错, 只是 RollBack 了
sqlSession.commit();
```



当然我们在创建 `SqlSession` 对象的时候, 默认的构造函数就可以将 **事务类型设置为自动提交**

~~~java
// 设置自动提提交的 Session 对象
SqlSession sqlSession = sqlSessionFactory.openSession(true);
~~~

从而在修改数据库后, 会自动的进行 Commit









# 四. MyBatis 参数解析

## #1. parameterType 输入类型

定义这个 SQL 的输入参数的类型, 定义的类型可以为如下几种情况

* 简单类型
* POJO 对象
* 多 POJO 对象的包装类



### -- POJO 对象传入解析过程 --


MyBatis 利用 **OGNL 风格的表达式** 

~~~xml
<!-- 配置插入操作-->
<insert id="saveStudent" parameterType="com.arkssss.domain.StudentInfo">
    insert into StudentInfo(name, age) values (#{name}, #{age})
</insert>
~~~

利用的 `#{name}, #{age}` 其实是调用的 : `StudentInfo.getName() , StudentInfo.getAge()`

**在书写的时候, 省略的方法的get, 也就是说 POJO 类里面必须定义 getter, setter 方法**





### -- 多 POJO 包装类 --

**有时候我们的 query 查询条件不止为一个 POJO 对象, 此时需要将多个 POJO 对象放在一个包装类中**

~~~java
public class QueryVo{
    private StudentInfo studentInfo;
    public getter();
    public setter();
}
~~~

如果传入类型为 POJO 包装类, 那么对应的写法为 : 

~~~xml
<!-- 配置插入操作-->
<insert id="saveStudent" parameterType="com.arkssss.domain.QueryVo">
    insert into StudentInfo(name, age) values (#{studentInfo.name}, #{studentInfo.age})
</insert>
~~~



### -- $ 和 # 的区别 -- 

在标签内表示占位变量的时候, 使用 **$ 和 #** 都是可以的, 例如 : 

~~~xml
<!-- 选择一个 -->
<select id="selectOneById" parameterType="Integer" resultType="com.arkssss.domain.StudentInfo">
    select * from StudentInfo where id=#{id}
    <!-- the Same as -->
    select * from StudentInfo where id=${id}
</select>

~~~

两者在结果上是一样的, 但是实现过程有些差别 : 

* **使用 # 的方式 : ** 采用的是占位预处理的方式, 即直接使用 **?** 表示的, **较为安全**
* **使用 $ 的方式 : ** 采用的是字符串拼接的方式, 可能带来 `SQL注入`的风险,  **但是如果使用在order by 中就需要使用 $.**





## #2. resultType 结果类型













## #3. resultMap 结果类型

考虑如下场景, **当 POJO 类的属性名和 数据库 字段名不对应的时候, 此时如果不加处理, 则不能被自动封装数据 : **

~~~java
MySQL 字段名为 : id, name, age
Student POJO 定于的属性名为 : myId, myName, myAge
~~~

**此时如果再使用 resultType 则不会将结果集封装** , 此时我们便需要定义一个 `resultMap` 实现两边的映射

~~~xml
<resultMap id = "StudentMap" type = "com.arkssss.domain.Student">
	<!-- 主键 字段的对应-->
    <id property = "myId" column="id"></id>
	
    <!-- 非主键 字段的对应-->
    <result property="myName" column="name"></result>
    <result property="myAge" column="age"></result>
</resultMap>
~~~

然后在 查询语句的时候 使用 **resultMap参数定义** 即可完成 映射结果集封装

~~~XMl
<!-- 利用 resultMap 封装结果集-->
<select id="selectOneById" paramteType="Integer" resultMap="StudentMap">
	select * from StudentInfo where id = #{id}
</select>
~~~



# 五. MyBatis 动态SQL

## #1. IF 标签

**当 SQL 语句中, 需要定义的 WHERE 条件有不确定性, 即 name, age 可能作为查询条件, 也可以不作为. 此时则需要使用 IF 标签进行判断.**

~~~xml
<!--  根据条件查询   -->
<select id="selectByCondition" resultType="com.arkssss.domain.StudentInfo">
    select * from StudentInfo where 1 = 1
    <if test="name != null">
        and name = #{name}
    </if>
    <if test="age != null">
        and age = #{age}
    </if>
</select>
~~~

此种写法, 最后处理出来的 SQL 语句为, 然后给占位符填充相应的值: 

~~~
 Preparing: select * from StudentInfo where 1 = 1 and name = ? and age = ? 
~~~





## #2. WHERE 标签

WHERE 标签可以让我们 SQL 语句看起来更加清晰, 还可以除去 `where 1 = 1` 这样的语句

实现效果来看, 和不加其实结果一样

~~~java
<!--  根据条件查询   -->
<select id="selectByCondition" resultType="com.arkssss.domain.StudentInfo">
    select * from StudentInfo 
    	<where>
            <if test="name != null">
                and name = #{name}
            </if>
            <if test="age != null">
                and age = #{age}
            </if>
    	</where>
</select>
~~~



## #3. FOREACH 标签

### -- 实现 SQL 中的 IN 操作 -- 

实现类似 : `select * from table where A in (a, b,c)` 的 **in 的操作**

~~~xml
<!--  IN 操作查询  -->
<select id="selectByInId" resultType="com.arkssss.domain.StudentInfo" parameterType="com.arkssss.domain.QueryVo">
    select * from StudentInfo
    <where>
        <if test="ids!=null and ids.size()>0">
            <!-- collection 表示 QueryVo里面容器名 -->
            <!-- separator 表示分隔符 -->
			<!-- item 和下面便利的 #{} 里写的保持一致 -->
            <foreach collection="ids" open="and id in (" close=")" item="id" separator=",">
                #{id}
            </foreach>
        </if>
    </where>
</select>
~~~

此时我们的传入类型用 `QuertVo` 进行封装 : 

~~~java
package com.arkssss.domain;
import java.util.List;
public class QueryVo {

    private List<Integer> ids;

    public List<Integer> getIds() {
        return ids;
    }

    public void setIds(List<Integer> ids) {
        this.ids = ids;
    }
}
~~~



# 六. Mybatis 高级查询



## #1. 多表联合查询



有如下需求 : 存在两个表 User, Account, User 和 Account 字段为一对多的关系. 即一个用户可以有多个 Account 账户, 在需求中, 我们希望实现如下的 SQL 语句 : 

`select si.*, sc.* from StudentInfo si, StudentCard sc where si.id = sc.studentid`

**即, 将所有的 Account 基于相对应的 User 信息打印**



### -- Implement 1 : 新建一个 domain 查询 POJO --

在 MyBatis 中实现要如下的步骤 : 

1. 创建 `User`, `Account` 的实体 POJO 类, 且字段分别对应到数据库的字段

2. 创建一个 联合类 比如 `UserAccount` , 可以继承我们的 `Account`

   ~~~java
   public class UserAccount extends Account{
       // 这两个为需要保存的 User 里面的信息
       private String name;
       private Integer age;
       
       public getter(){};
       public setter(){};
   }
   ~~~

3. 最后我们在 `Mapper` 文件里面定义 `SQL` 语句如下 : 

   ~~~xml
   <select id="getAll" resultType="com.arkssss.domain.UserAccount">
       select u.*, a.* from User u, Account a where u.id = a.uid
   </select>
   ~~~

   **最后可以自动的实现结果集的封装**



### -- Implement 2 : 直接在原 POJO 进行封装 --



# 七. Mybits 注解 消灭 XML

目前来看, Mybits 有如下几个配置文件

* 主配置文件 : Mybits.xml
* 映射配置文件 : Mapper.xml



## #1. 取代主配置文件



**1. 通过 JavaConfig 配置数据源**

<hr>

主配置文件主要定义了 数据源的信息, 所以在 JavaConfig 中, 我们先单独用一个 `Bean` 定义我们的数据源 :

~~~java
    /**
     * 数据源基本信息配置
     * @return
     * @throws PropertyVetoException
     */
    @Bean
    public DataSource dataSource() throws PropertyVetoException {

        ComboPooledDataSource ds = new ComboPooledDataSource();

        // 利用 Properties 配置 数据源基本信息
        ds.setDriverClass(driver);
        ds.setJdbcUrl(url);
        ds.setUser(username);
        ds.setPassword(password);


        // 设置 数据库连接池信息
        ds.setMaxPoolSize(30);
        ds.setMinPoolSize(10);

        // 自动提交
        ds.setAutoCommitOnClose(false);

        ds.setCheckoutTimeout(10000);
        ds.setAcquireRetryAttempts(2);

        return ds;
    }
~~~







**2. 配置 SqlSessionFactoryBean**

<hr>

但后定义我们的 `SqlSessionFactoryBean` : 这个类的在 `Spring-Mybatis` 中可以取代 `SqlSessionBuilder, SqlSessionFactor` 

~~~java
    @Bean
    public SqlSessionFactoryBean sqlSessionFactoryBean(DataSource dataSource){
        SqlSessionFactoryBean bean = new SqlSessionFactoryBean();
        bean.setDataSource(dataSource);
        return bean;
    }
~~~

**SqlSessionFactoryBean** 实现了 FactoryBean 接口, 也就是说最后 SqlSessionFactoryBean 被 Spring 创建的并不是这个本身, 而是通过工厂类返回的结果, 即 **SqlSessionFactory** 对象







**3. 管理 Mapper Bean**

<hr>

~~~java
@Bean
public MapperFactoryBean<TestTableDAO> mapperFactoryBean(SqlSessionFactory sqlSessionFactory){
    MapperFactoryBean<TestTableDAO> bean = new MapperFactoryBean<>(TestTableDAO.class);
    bean.setSqlSessionFactory(sqlSessionFactory);
    return bean;
}
~~~







​																																						





















































