# Hystrix

> [官网](<https://github.com/Netflix/Hystrix>), 现在已经停止更新
>
> 服务降级，限流，熔断框架



# 一. 基本概念

## 服务雪崩

多个微服务之间调用的时候，假设 A,B,C,...多个微服务出现链式的调用关系，如果链路上某个微服务响应时间过长，对该服务的调用就会越来越多，从而占用越来越多的系统资源，进而引起系统崩溃-**服务雪崩，服务高可用被破坏**



## Hystrix 引出

Hystrix是一个用于分布式系统 **延迟** 和 **容错** 的开源库，在分布式系统里，许多依赖不可避免会调用失败，Hystrix 可以保证在一个依赖出现问题的情况下，**不会导致整体服务失败，避免级联故障，提高分布式系统的弹性**



## Hystrix 解决思路

**断路器**是一种开关装置，当某个服务单元发生故障的时候，用过断路器监控，想调用方返回一个符合预期 （FallBack），可处理的备选响应，而不是长时间的等待或者抛出异常，从而保证调用方线程的可用性。



# 二. 服务降级

当 **微服务提供者服务不可用时， 服务调用者需要给出一个友好的降级解决方案**

服务降级会在如下的情况下发生

* 程序运行异常
* 超时
* 服务熔断
* 线程池/信号量 打满

一般服务降级推荐在 **服务调用方开启**

基于 **Springcloud Hystrix** 实现的服务熔断如下:

## 主程加入 `@EnableHystrix` 注解

主程加入 `@EnableHystrix` 注解, 开启 hystrix 降级服务机制

~~~java
package com.ark.springcloud;

@SpringBootApplication
@EnableHystrix
/* 确保降级/熔断等机制生效 */
@EnableCircuitBreaker
public class HystrixPaymentMain8005 {
    public static void main(String[] args) {
        SpringApplication.run(HystrixPaymentMain8005.class, args);
    }
}
~~~

## 设置降级方案

~~~java
/* 降级方案与该方法绑定 */
@HystrixCommand(fallbackMethod = "PaymentTimeOutHandler", commandProperties = {
    /* 该方法响应时间超过3s便启动降级方案 */
    @HystrixProperty(name="execution.isolation.thread.timeoutInMilliseconds", value = "3000")
})
public String PaymentInfo_Error(Integer id){
}

/* 服务降级方案 */
public String PaymentTimeOutHandler(Integer id){
    return "Sorry Payment time out, try later";
}
~~~



## 全局降级方案

对于每一个方法都有一个降级方案使得代码膨胀，我们可以设置一个全局的降级方案。

~~~java
@Service
/* 指定全局降级方案 */
@DefaultProperties(defaultFallback = "GlobalHandle")
public class PaymentService {
	
    
    @HystrixCommand
    public String PaymentInfo_Error(Integer id){
        ...
    }
    

    /* 全局降级方案 */
    public String GlobalHandle(){

        return "GlobalHandle";

    }
}
~~~



## 🌟 结合 OpenFeign 解耦降级方案

我们可以结合 openFeign 对服务提供者的服务进行检测，从而在 **客户端进行服务降级**

首先需要在配置文件中对 openfeign 的熔断机制打开

~~~yaml
# 打开 openfeign 熔断机制
feign:
  hystrix:
    enabled: true
~~~

**此时可以不用在主程序中加入  `@EnableHystrix`  ** 注解

然后我们只需要创建一个 降级方案类继承我们 openfeign 的定义调用接口

~~~java
/* OpenFeign 的定义调用接口 */
@Service
@FeignClient(value = "CLOUD-PROVIDER-HYSTRIX-PAYMENT", fallback = PaymentServiceHandler.class)
public interface PaymentService {

    @GetMapping("/payment/hystrix/ok/{id}")
    public String paymentInfo_OK(@PathVariable("id") Integer id);

    @GetMapping("/payment/hystrix/error/{id}")
    public String paymentInfo_Error(@PathVariable("id") Integer id);

}

~~~

~~~java
/* 自定义类继承接口 */
package com.ark.springcloud.hystrix;

import com.ark.springcloud.service.PaymentService;
import org.springframework.stereotype.Component;

/* 这个类里面重写的即为对应方法的降级方案 */
@Component
public class PaymentServiceHandler implements PaymentService {
    @Override
    public String paymentInfo_OK(Integer id) {

        return "in PaymentServiceHandler hystrix paymentInfo_OK";

    }

    @Override
    public String paymentInfo_Error(Integer id) {

        return "in PaymentServiceHandler hystrix paymentInfo_Error";

    }
}
~~~

最后只需要在 `@openFeign` 注解中讲这个类标示出来即可

~~~java
@FeignClient(value = "CLOUD-PROVIDER-HYSTRIX-PAYMENT", fallback = PaymentServiceHandler.class)
~~~



# 三. 服务熔断

**微服务达到最大访问量是的时候**，直接拒绝访问，拉闸限电，然后调用服务降级的方法并给出友好的提示。**同时在检测到该节点微服务调用响应正常后，便可恢复调用链路。**

Springcloud 框架里，熔断机制通过 Hystrix 实现，会监控微服务间的调用情况，当失败的调用达到一定的阈值的时候，（默认 5 秒内 20次调用失败）便会自动启动熔断机制。

**熔断后，无论什么请求，服务都会自动被降级，直到检测到该节点恢复正常，才继续提供服务**



## 服务熔断三状态

* 熔断打开

  请求不再进行调用当前服务，**请求一律被降级**，内部设置时钟一般为(MTTR) 处理故障的平均时间，当超过 MTTR 后，进入半开状态。

* 熔断关闭

  服务正常被提供

* 熔断半开

  部分请求根据规则调用当前服务，如果请求成功且符合规则，则默认当前服务恢复正常，关闭熔断。

基于 **Springcloud Hystrix** 实现的服务熔断如下:

## 主程加入 `@EnableHystrix` 注解

~~~java
package com.ark.springcloud;

@SpringBootApplication
@EnableHystrix
public class HystrixPaymentMain8005 {
    public static void main(String[] args) {
        SpringApplication.run(HystrixPaymentMain8005.class, args);
    }
}
~~~



## 熔断服务加入 `@HystrixCommand` 注解

~~~java
/* ======= 服务熔断 ======= */
@HystrixCommand(fallbackMethod = "PaymentFuseFallback",commandProperties = {
    // 是否开启断路器
    @HystrixProperty(name = "circuitBreaker.enabled",value = "true"),
    // 请求次数
    @HystrixProperty(name = "circuitBreaker.requestVolumeThreshold",value = "10"),
    // 时间窗口期
    @HystrixProperty(name = "circuitBreaker.sleepWindowInMilliseconds",value = "10000"), 
    // 失败率达到多少后跳闸
    @HystrixProperty(name = "circuitBreaker.errorThresholdPercentage",value = "60"),
})
public String PaymentFuse(Integer id){
    	// ...
}


/* PaymentFuse 降级方案 */
public String PaymentFuseFallback(Integer id){
    return "PaymentFuse error"
}
~~~

熔断  `@HystrixCommand`  注解重要参数说明:

1. `circuitBreaker.requestVolumeThreshold` : 请求阈值，表示在时间窗口内，请求的总次数必须大于等于该阈值，才有熔点的资格，否则，就算所有请求失败，都不会熔断
2. `circuitBreaker.sleepWindowInMilliseconds` : 请求时间窗口，表示统计的时间窗口，默认为最近的10s
3. `circuitBreaker.errorThresholdPercentage` ：失败率阈值，如果舍得时间窗口内超过请求次数超过阈值，且失败率也超过阈值，那么执行熔断，默认失败率为 50%。





# 四. 服务限流

秒杀高并发等操作，对请求进行限流





# 五. Hystrix 仪表盘界面

































