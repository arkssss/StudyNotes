# Spring RPC

[TOC]

# 一. 概述

RPC (Rome Procedure call) 即为远程过程调用, 基于 **客户端 与 服务端** 的通信模式, 可以实现进程间的通信.

通信的协议可以基于多种例如 : **HTTP, RMI ...**  

**利用RPC 的所有的通信机制都是同步的, 也就是BIO的模式, 必须等待远程的过程执行完后才可以继续执行**





在使用 RPC 的时候, 可以以调用本地方法的形式去调用远程的服务, 以 RMI 为例实现 RPC 的过程 : 

1. 服务端发布一个接口的所有功能作为一个 **服务端的服务**
2. **此时将这个接口打为 JAR 包发布到客户端**
3. **然后直接在客户端使用这个接口的方法, 便可以远程调用服务端的这个接口的实现方法**




# 二. RPC 和 Socket 的区别和联系

既然都是基于 C/S 模式的通信,  那么 PRC 和 Socket 编程之间有什么区别呢

* **首先 RPC 是基于 Socket 的一种封装** , 目的是让 C/S 模型开发更加简洁高效, 但是开发高效的同时肯定会减少 Socket 的灵活性. 

* **RPC 的原则是 : 让远程的过程调用就像调用自己本地的方法一样** , RPC 的实现忽略了具体的通信细节, 这就意味着, 不可能每一个应用通信都有最优解.

* RPC 从实现过程来说, 是 **服务端通过接口实现一些特定的服务, 然后将接口打成Jar 包给 C端用, C 端就可以通过这些接口去远程调用 S 端的实现, 就像是自己实现了一样**



# 三. Spring 支持的 RPC

Spring 支持多种 PRC  的实现 :

| RPC 模型           | 场景                                                         |
| ------------------ | ------------------------------------------------------------ |
| RMI (远程方法调用) | 不考虑网络防火墙, C/S 都需要基于 Java 实现, 且两边的 JDK 版本都需要一样 |
| Hessian 或 Burlap  | 通过 HTTP 协议 访问/发布 S端基于 Java 实现, 但是 C 端没有要求 |
| HTTP invoker       |                                                              |
| JAX-RPC 和 JAX-WS  | 基于 SOAP 的 web 服务                                        |





# 四. RMI 发布远程服务

RMI 是最初的一个远程调用技术

Spring 极大的简化了 RMI 的使用, 可以将任意的 Bean 发布为 RMI 服务, 且 Bean 根本不需要关心自己是否为 RMI 服务



## #1. 发布 一个 RMI 服务

使用 Spring 将一个 POJO 类发布为 RMI 服务的过程如下 : 

### RMI 服务端 (S 端)

**1. 在 RMI 服务端需要定义一个 服务的功能接口 :**

~~~java
/*
	注意方法的返回值即为此服务的返回给客户端的数据
*/
public interface IRMITestServer{
    String hello(){}
    
    List<String> hello3();

}
~~~



**2. 然后完成一个接口的实现 : **

~~~java
public class RMITestServerImpl implement IRMITestServer{
    String hello(){
        return "hello wrold";
    }
    
    List<String> hello3(){
        List<String> names = new ArrayList<>();
        names.add("ark");
        names.add("fangzhou");
        return names;
    }
}
~~~



**3. 将这个 POJO 类发布为 RMI 服务, 需要在 JavaConfig 类利用使用手动的方式注册 Bean**

涉及的核心的类即为 **RmiServiceExporter** 

~~~java
    /**
     * 发布 iRMITestServer 为一个 RMI Server, 从而实现进程 RPC 通信
     * @param iRMITestServer
     * @return
     */
    @Bean
    public RmiServiceExporter rmiServiceExporter(IRMITestServer iRMITestServer){
        RmiServiceExporter rmiServiceExporter = new RmiServiceExporter();
        rmiServiceExporter.setService(iRMITestServer);
        // 设置这个 RMI 服务的名称
        rmiServiceExporter.setServiceName("iRMITestServer");
        rmiServiceExporter.setServiceInterface(IRMITestServer.class);
        // 设置这个 RMI 服务的通信端口
        rmiServiceExporter.setRegistryPort(1199);
        return rmiServiceExporter;
    }
~~~



### RMI 客户端 (C 端)

**1. 在 C 端引入 S 端发布的 接口 JAR 包** 

S 端需要将这个服务的接口打为 JAR 包, 其实就是需要告诉 C 端, 服务端提供了哪些掉用的方法



**2. 在 C 端进行 Bean 配置**

~~~java
    @Bean
    public RmiProxyFactoryBean rmiProxyFactoryBean(){

        RmiProxyFactoryBean rmiProxyFactoryBean = new RmiProxyFactoryBean();
        // 注意这里的 端口和服务器名称 和 S 端对应起来
        rmiProxyFactoryBean.setServiceUrl("rmi://localhost:1199/iRMITestServer");
        rmiProxyFactoryBean.setServiceInterface(IHelloWorld.class);

        return rmiProxyFactoryBean;
    }
~~~



**3. 本地掉用远程服务**

~~~java
import ServiceApi.IHelloWorld;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


@Component
public class RmiClient {

    @Autowired
    private IHelloWorld helloWorld;

    public void sayHi(){
	
        // 调用 远程发布的 RPC 服务
        System.out.println(helloWorld.sayHi());

    }


    public void sayYes(){
        System.out.println(helloWorld.sayYes());
    }
}

~~~





















## #2. RMI 特性分析

* RMI 底层基于的是 **BIO** 也就是说,  C 端调用 S 端的过程是阻塞的, C 端必须等待 S 端执行完之后, 才能继续向下执行.




# 五. Hessian 和 Burlap 发布远程服务





















































