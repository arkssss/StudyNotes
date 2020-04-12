[TOC]

# Composer

**Composer是 PHP 世界里用于管理项目依赖的工具**



# 相关命令

## 创建一个项目 - create-project 

~~~shell
# 创建一个 laravel 项目, 本地写入文件夹 larabbs 中.
>$composer create-project laravel/laravel larabbs --prefer-dist "6.*"
~~~



## 设置国内淘宝镜像

~~~shell
$ composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
~~~

