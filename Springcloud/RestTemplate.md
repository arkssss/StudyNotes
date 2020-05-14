# RestTemplate

> 提供多种便捷访问远程 Http 服务的方法
>
> Spring 提供的访问 Rest 服务的 客户端模版工具集



# 一. 依赖注入

由于 RestTemplate 是Spring框架自带功能，因此无需 maven 引入, 在使用的时候，只需要 DI 即可, 具体步骤如下:

新建 com\ark\springcloud\config\ApplicationContextConfig 类, 然后注入 RestTemplate。

~~~java
package com.ark.springcloud.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

/**
 * IoC 容器初始化注入类
 */
@Configuration
public class ApplicationContextConfig {

    /* RestTemplate 注入到容器中 */
    @Bean
    public RestTemplate getRestTemplate(){
        return new RestTemplate();
    }

}
~~~



# 二. 基本用法

## 常用函数 ---ForObject

---ForObject 函数返回对象为响应体中数据转化的对象，**基本上可以理解为 Json**

推荐使用 **---ForObject 方法**

### `postForObject`

~~~java
/* 
	发送一个 post 请求
	分别传入
    1. 请求url 
    2. post 数据 
    3. response 类型
*/
restTemplate.postForObject(PAYMENT_URL + "/payment/create", payment, CommonResult.class);
~~~

### `getForObject`

~~~java
/*
	发送一个 get 请求
	1. 请求 url
	2. response 类型
*/
restTemplate.getForObject(PAYMENT_URL + "/payment/get/" + id, CommonResult.class);
~~~



## 常用函数 ---ForEntity

---ForEntity函数返回的是 ResponseEntity<> 对象。



### `getForEntity`

~~~java
ResponseEntity<CommonResult> entity =
    restTemplate.getForEntity(PAYMENT_URL + "/payment/get/" + id, CommonResult.class);

/*	
	获取请求状态码
    entity.getStatusCode().is2xxSuccessful()
    
    获取内容, 可直接返回
    entity.getBody();
*/
~~~





## 相关注解

###  `@LoadBalanced` 

要成功实现负载均衡调用，需要在 `RestTemplate` 注入的时候加入该注解

```java
/**
 * IoC 容器初始化注入类
 */
@Configuration
public class ApplicationContextConfig {

    /* RestTemplate 注入到容器中 */
    @Bean
    @LoadBalanced	// enable 负载均衡调用
    public RestTemplate getRestTemplate(){
        return new RestTemplate();
    }

}
```













