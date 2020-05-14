# OpenFeign

# 一. 概念

> OpenFeign 实现了客户端 Rest 接口的更简易调用，且其聚合了 RestTemplate + Ribbon 的功能，可以在客户端上封装负载均衡的方式调用微服务提供者的 REST 接口。



# 二. 安装

## Maven Jar 包引入

~~~xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
~~~

注意引入 openfeign 便可以不再引入 ribbon 因为其已经自身整合。



# 三. 基本使用

## Quick Start

### `@EnableFeignClients` 注解

首先需要在主程序添加 `@EnableFeignClients` 注解

~~~java
package com.ark.springcloud;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication
@EnableFeignClients
public class FeignMain80 {
    public static void main(String[] args) {
        SpringApplication.run(FeignMain80.class, args);
    }
}
~~~



### `@FeignClient` 注解面向微服务接口

openfeign 最大的特点是自身封装 ribbon 和 Rest 接口调用, 可以讲原本在 contoller 层进行的 rest 调用抽离到单独的service层进行。

~~~java
package com.ark.springcloud.service;

/* @FeignClient 定义了请求的微服务名 */
@Component
@FeignClient(value = "CLOUD-PAYMENT-SERVICE")
public interface PaymentFeignService {
	
    /* 
    	这些定义的方法和微服务提供者保持一致即可
    	注解的地址即为微服务提供者暴露的 REST 风格地址
    */
    
    @PostMapping(value = "/payment/create")
    CommonResult create(@RequestBody Payment payment);
    
    @GetMapping(value = "/payment/get/{id}")
    CommonResult<Payment> getPaymentById(@PathVariable("id") Long id);
    
    @GetMapping(value = "/payment/timeout")
    public String timeOutUnit();
}

~~~



## 服务响应时间

OpenFeign中 ribbon 默认服务响应时间为 1s, 如果超过会自动跳转到超时页面

也是更改如下设置

~~~yaml
ribbon:
#指的是建立连接所用的时间，适用于网络状况正常的情况下,两端连接所用的时间
  ReadTimeout: 5000
      #指的是建立连接后从服务器读取到可用资源所用的时间
  ConnectTimeout: 5000
~~~



## 日志增强

OpenFeign 可以设置日志的等级，详细的日志等级可以记录每一次 HTTP 请求的详细信息, 可以如下设置

首先在 `@Configuration` 类中进行 IoC注入

~~~java
package com.ark.springcloud.config;

import feign.Logger;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ApplicationContext {
    @Bean
    Logger.Level getFeignLoggerLevel(){
        /* 配置openfeign日志增强 */
        return Logger.Level.FULL;
    }
}
~~~

**然后在配置文件中设置 openfeign 的日志输出在slf4j的输出等级**

~~~yaml
logging:
  level:
    # feign日志以什么级别监控哪个接口
    com.ark.springcloud.service.PaymentFeignService: debug
~~~





























