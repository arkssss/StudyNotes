# Maven

> [Maven](<https://maven.apache.org/>)
>
> [Maven repository](<https://mvnrepository.com/>)
>
> Apache Maven is a software project management and comprehension tool. Based on the concept of a project object model (POM), Maven can manage a project's build, reporting and documentation from a central piece of information.

Java 的依赖包下载管理工具



# 标签概念

## Dependency 和 DependencyManagement

DependencyManagement 一般用在父类 pom 文件中如:

~~~xml
<!-- 父类pom文件 -->
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.47</version>
        </dependency>
    </dependencies>
</dependencyManagement>
~~~

此时子项目在依赖 mysql 的时候，可以不指定版本，默认从父类的中读取对应的版本号。

~~~xml
<!-- 子类pom文件 -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>
~~~

* DependencyManagement 只是声明依赖，并不真正引入jar, 类似于 接口。
* 子类的 pom 文件中必须要指定依赖，才会真正的引入 jar 包。
* 如果子类自己规定了版本号，那么子类自定义版本号会覆盖父类































