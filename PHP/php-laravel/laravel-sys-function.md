# Laravel 系统函数手册

[TOC]

记录一些常用的 `laravel` 系统函数



## 1. 获取 `.env` 文件定义的值 - `getenv('key')` 

`.env` 文件位于我们系统根目录下, 用于定义系统运行的 **私密设置** , 如数据库密码等

~~~
/* for example */
APP_NAME=LaraBBS
APP_ENV=local
APP_KEY=your_app_key
APP_DEBUG=true
APP_URL=http://larabbs.test
...
~~~

我们使用 `getenv('key')` 获得在 `env` 中定义的值 :

~~~php
/* local */
getenv('APP_ENV')
~~~

**一般在项目初始化的时候, 建议修改如下几个配置信息:**

~~~php
# your app's name
APP_NAME=LaraBBS 
    
# 访问的 url
APP_URL=http://larabbs.test

# 以及数据库的 username passworld 等
~~~









## 2. 获取配置目录下各个配置文件的值 - `config('file.key')`

一般的设置文件位于 `/config/*` 目录下. 包括以下几个文件 :

| 文件名称         | 配置类型                             |
| ---------------- | ------------------------------------ |
| app.php          | 应用相关，如项目名称、时区、语言等   |
| auth.php         | 用户授权，如用户登录、密码重置等     |
| broadcasting.php | 事件广播系统相关配置                 |
| cache.php        | 缓存相关配置                         |
| database.php     | 数据库相关配置，包括 MySQL、Redis 等 |
| filesystems.php  | 文件存储相关配置                     |
| hashing.php      | 加密算法相关设置                     |
| logging.php      | 日志记录相关的配置                   |
| mail.php         | 邮箱发送相关的配置                   |
| queue.php        | 队列系统相关配置                     |
| services.php     | 放置第三方服务配置                   |
| session.php      | 用户会话相关配置                     |
| view.php         | 视图存储路径相关配置                 |

我们可以利用 `config('file.key')` 的方式获得当前的配置值. 且这个函数是应用的全局函数

~~~php
/* 获得当前时区信息 */
config('app.timezone')
~~~



**一般在项目初始化的时候, 建议修改如下结果配置信息**

~~~php
/* in app.php */

/* 设置为上海时区 */
'timezone' => 'Asia/Shanghai',

/* 默认语言设置为中文 */
'locale' => 'zh-CN',
~~~





















