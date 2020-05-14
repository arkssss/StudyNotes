# Ribbon

> Spring cloud Ribbon 是 Netflix 实现的一个 **负载均衡工具**, 通过Spring Cloud的封装，可以让我们轻松地将面向服务的REST模版请求自动转换成客户端负载均衡的服务调用



# 一. 安装

## 通过 Eureka 整合安装 Ribbon

引入了 **eureka-client** 变可以不用再引入 **ribbon**

~~~xml
<!-- 通过 Eureka 的 starter 默认整合的 Ribbin实现 -->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
~~~



## 独立安装 Ribbon

~~~xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-ribbon</artifactId>
</dependency>
~~~





# 二. 基本概念 

## Ribbon vs Nginx

Ribbon 和 Nginx 均为常见的负载均衡工具，但是两者也有所不同。

* Nginx 是服务端负载均衡：

  用于拦截所有的 浏览器 请求, 是整合微服务端架构的大门, 负责将请求转发为所有的 **接入层**。

* Ribbon 即为本地负载均衡:

  即为 **微服务接入层** 和 **微服务持久层** 的负载均衡，属于微服务内部服务之间的负载均衡。



## 负载均衡策略

Ribbin 负载均衡策略可以分为如下几种 :

* 轮询（默认）: `RoundRobinRule`

  ~~~java
  /*
  	实现：
  	请求服务为 当前请求次数的 % 总机器数量
  */
  ~~~

* 随机 : `RandomRule`



## 切换策略

Ribben 额负载均衡策略由 **IRule** 类型的 bean 定义，一般而言在容器中注入实例, 需要在 `ApplicationContext` 配置文件中配置即可。

但是 Ribben 的注入略有不同，Ribben 不能在 `@ComponentScan` 注解下的那个包中放入容器。

因此需要另起一个 包 `com.ark.myrule` 

~~~java
package com.ark.myrule;

import com.netflix.loadbalancer.IRule;
import com.netflix.loadbalancer.RandomRule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MyselfRule {
    @Bean
    public IRule myRule(){
        
        /* 使用随机的负载均衡规则 */
        return new RandomRule();
    }
}
~~~

在主程中添加 `@RibbonClient` 注解

~~~java
package com.ark.springcloud;

import com.ark.myrule.MyselfRule;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.cloud.netflix.ribbon.RibbonClient;

@SpringBootApplication
@EnableEurekaClient
@RibbonClient(name = "CLOUD-PAYMENT-SERVICE", configuration = MyselfRule.class)
public class OrderMain80 {
    public static void main(String[] args) {
        SpringApplication.run(OrderMain80.class, args);
    }
}
~~~

































