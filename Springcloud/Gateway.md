# Gateway

> [Spring Cloud Gateway](<https://spring.io/projects/spring-cloud-gateway>)
>
> API 网关自身也是一个服务，且是是后端微服务的唯一入口，它封装了内部的架构，为客户端提供一个定制的API接口。同时还可以负责 验证，监控，负载均衡，限流等功能。

Gateway 是 SpringCloud 官方推出的 **服务网关层** , 用于取代 网飞公司的Zuul2.x。

Gateway 是一个 非阻塞异步IO，底层基于 Netty。

