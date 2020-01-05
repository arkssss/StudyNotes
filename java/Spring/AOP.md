# 	AOP 面向切面编程

[TOC]



# 一 概述

`面向切面编程` 只是一种编程范式

它是 `oop` 的补充, 可是实现 `关注点` 分离 , 一般有如下的用途 : 	

* 权限控制
* 缓存控制
* 事务控制
* 日志
* 性能监控



## AOP 解决的问题

考虑如下的权限控制问题, 对于某一方法中要去进行一个权限验证

~~~java
public void deleteItem(Item i){
    // auth access check
    // 可以看到, 我们如果要在一个这个函数进行权限验证, 那么需要调用这个 checkAccess方法
    // 有很严重的代码入侵. 且后期不好维护
    Auth.checkAccess();
    
    // delete process
}
~~~

`AOP` 的编程风格可以实现, 将 ` Auth.checkAccess(); ` 这一行代码从 `deleteItem` 里面分离出来. 







## AOP 的实现原理

**动态代理 :**

* 基于接口的代理 : `JDK`
* 基于继承的代理 : `Cglib`



<hr>

**基于 JDK** 的代理 **只能基于接口**

需要调用 : `java.lang.reflect.Proxy` 包

然后 代理类需要继承  `InvocationHandle` 接口并且实现 `invoke` 方法

~~~java
package Proxy;

import Subject.ISubject;
import Subject.Impl.ISubjectImpl;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;

// Subject 动态代理
public class SubjectProxy implements InvocationHandler {

    private ISubject is;

    public SubjectProxy(ISubjectImpl is){
        this.is = is;
    }
	
    // jdk动态代理 实现 invoke 接口
    // 从而成为 ISubject 对象的代理
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("before ======= ");

        method.invoke(is, args);

        System.out.println("after ======= ");

        return null;
    }
}

~~~

然后在调用的地方通过 `Proxy.newProxyInstance()	`调用即可

~~~java
package domain;
import Subject.ISubject;
import Subject.Impl.ISubjectImpl;
import Proxy.SubjectProxy;

import java.lang.reflect.Proxy;

public class Client {

    public static void main(String[] args) {
	
        // 完成 subject 的动态代理
        ISubject subject = (ISubject) Proxy.newProxyInstance(Client.class.getClassLoader(),
                new Class[]{ISubject.class},
                new SubjectProxy(new ISubjectImpl())
                );

        subject.request();
    }

}

~~~





# 二 Spring AOP 使用

在 Spring 中, `AOP` 主要有两种使用方式

* `XML` 配置的方式
* 🌟 `注解` 方式



## 2.1 Pointcut Expression
































