# Laravel 前端知识

[TOC]

# Laravel 安装前端库

## bootstrap 安装

1. `bootstrap` 安装可以利用 `composer` , 库的名称叫 `laravel/ui` 实际上这个包收录了`bootstrap, vue, react` 三个框架. 我们直接下载即可 : 

    ~~~shell
    $composer require laravel/ui --dev
    ~~~

    这个命令会自动将库安装在 `vendor/laravel/ui` 下.

2. 安装完成后, 我们便可以通过 `artisan` 安装

    ~~~shell
    $php artisan ui bootstrap
    ~~~

    1. 在 npm 依赖配置文件 `package.json` 中引入 `bootstrap`、`jquery`、`popper.js` 作为依赖；

       **npm 为我们项目前端的包管理工具, 所以我们的依赖需要添加到这个管理中**

    2. 修改 `resources/js/bootstrap.js` ，在此文件中初始化 Bootstrap UI 框架的 JS 部分；

    3. 修改 `resources/sass/app.scss` 以加载 Bootstrap 的样式文件；

    4. 新增 `resources/sass/_variables.scss` 样式配置文件。

3. 写入到 **npm 的json文件之后**, 我们需要利用 npm 安装

   ~~~shell
   $npm install
   # npm 和 yarn 是一样的, 但是 npm 速度较慢, 我们一般用 yarn
   $yarn install
   ~~~

4. 最后编译即可 :

   ~~~shell
   # 注意在修改 scss 文件后, 我们都需要执行该命令
   $npm run watch-poll
   ~~~


## fortawesome 安装

[fortawesome](<https://fontawesome.com/>) 安装直接利用 `yarn` 即可

~~~shell
$ yarn add @fortawesome/fontawesome-free
~~~

不像 `bootstrap` 可以自动导入 `app.scss`. 引入 `fontawesome` 的时候, 我们需要手动导入

~~~css
// Bootstrap
@import '~bootstrap/scss/bootstrap';

// Fontawesome
@import '~@fortawesome/fontawesome-free/scss/fontawesome';
@import '~@fortawesome/fontawesome-free/scss/regular';
@import '~@fortawesome/fontawesome-free/scss/solid';
@import '~@fortawesome/fontawesome-free/scss/brands';
~~~

最后编译 :

~~~shell
$npm run watch-poll
~~~





# Laravel Mix









# Blade 模版



## overview

> Blade 是 Laravel 提供的一个简单而又强大的模板引擎。和其他流行的 PHP 模板引擎不同，Blade 并不限制你在视图中使用原生 PHP 代码。所有 Blade 视图文件都将被编译成原生的 PHP 代码并缓存起来，除非它被修改，否则不会重新编译，这就意味着 Blade 基本上不会给你的应用增加任何负担。Blade 视图文件使用 `.blade.php` 作为文件扩展名，被存放在 `resources/views` 目录。
>
> [Blade 模版引擎](<https://learnku.com/docs/laravel/6.x/blade/5147#introduction>)

## 模版继承

一般来说, 我们将整个页面的布局(骨架) 先定义好, 然后再向布局中按照各个部分填充值, 这个时候便利用到了 **模版继承**

整个页面的布局一般定义于 `\view\layouts\` 下. 一个页面包含三个方面 :

* `_header.blade.php`
* `app.blade.php` : 实际上是整个页面的骨架, header 和 footer 也是包含在 app 这个文件中
* `_footer.blade.php`

### `@include` 包含

我们利用 `@include()` 模版函数, 可以将 `_header, _footer` 包含到 `app` 中. 例如:

~~~html
<!DOCTYPE html>
<html>
    <titile> @yield('titile', 'larabbs') - laras 论坛 </titile>
<body>
<div id="app" class="{{ route_class() }}-page">
  <!--  通过 include 将其他定义的文件包含到这个文件 -->
    
  <!-- 包含 _header 即导航条 -->
  @include('layouts._header')
  <div class="container">
    
    <!-- 包含 消息显示模块 -->
    @include('shared._messages')
      
    @yield('content')
  </div>
    
  <!-- 包含 _footer -->
  @include('layouts._footer')
</div>
</body>
</html>

<!-- 我们包含的这三个文件, 加上 app, 形成了整个页面的骨架 -->
~~~

### `@yield()` 占位

`@yield()` 的功能便是一个占位的作用, 由于一个 web 可能存在很多页面, 每个页面内容都不同, 但是骨架都需要

引用 `app.blade.php` , 所以我们定义 `@yield()` 给以后很多页面的内容提供占位的功能.

同时我们可以给 `@yield()` 指定默认值. 例如 :

~~~html
<!-- 如果子类模版没有重新定义这个字段, 那么便使用默认值 larabbs -->
<titile> @yield('titile', 'larabbs') - laras 论坛 </titile>
~~~

### `@section` 替换基类模版的占位

对于主页 `root.balde.php`

~~~html
<!-- @extends 表示我们继承的是 app.blade.php, 便可以替换这个文件中的占位符 -->
@extends('layouts.app')
@section('title', '首页')

<!-- 将这个部分替换了 app.blade.php 中的 @yield('content')-->
@section('content')
  <h1>这里是首页</h1>
@stop
~~~



## 权限认证

我们可以在 `blade` 模版中直接使用权限认证的特殊字段去判断当前用户的权限



### `@guest` 判断用户是否登陆

~~~html
<!-- guest 为laravel自带的权限中间件, 判断当前是否有用户登陆. -->
@guest
	<h1> 用户未登录 </h1>
@endguest
~~~

















# 问题记录

## 浏览器缓存问题

> 现代化的浏览器，会对静态文件进行缓存，静态文件在本课程的范畴内，指的是 `.css` 、`.js` 后缀的文件。这是一个浏览器的优化功能，极大地加快了网页的加载速度，但是在我们日常开发和维护中，有时候会造成混淆。
>
> 开发时，你明明修改了样式，但是刷新浏览器却看不见变化，然后你就来回不断地修改你的样式文件、重新编译、做各种测试，浏览器页面仍然一成不变。直到你重新刷新好多次，或者修改样式文件名称时，才恍然大悟，原来是浏览器缓存了。

我们只需要修改 `webpack.mix.js` 的代码

~~~javascript
const mix = require('laravel-mix');

# .version()
mix.js('resources/js/app.js', 'public/js')
   .sass('resources/sass/app.scss', 'public/css').version();
~~~

这个会在我们每次改变代码后, 计算出其哈希值, 改变后哈希值必然会变. 从而保证浏览器端会重新加载我们的文件





## 语言包切换问题

前端页面的 `{{__('key')}}` 字段, 调用的便为系统的翻译函数.

### 默认为自带的翻译提供者 `TranslationServiceProvider`

我们在 `/config/app.php` 文件设置的本地语言包为 `zh-CN` 代表的是中文语言包. 

那么这个函数变会去 `resouces/lang/zh-CN.json` 去寻找对应于 'key' 的翻译, 并显示给前端.

比如 :

~~~json
/* zh-CN.json */

{
    "Login": "登录",
    "Password": "密码",
    "Remember Me": "记住我"
}
~~~

那么在 view 中 `{{__('Login')}}` 会被自动翻译成 `登陆`



### 使用翻译提供者 `Overtrue` 

> 会有很多人会遇到翻译 Laravel 自带模板的问题，所以我们无需自己一个个去翻译，这种通用的问题找找扩展包来处理即可。
>
> 我们将使用 [Laravel Lang](https://github.com/overtrue/laravel-lang) 项目来实现，此项目支持了 52 个国家的语言，使用以下命令安装：

使用时我们需要先利用 `composer` 引入:

~~~shell
$composer require "overtrue/laravel-lang:~3.0"
~~~

然后将系统默认的翻译服务替换为 overtrue

具体做法为在文件 `config/app.php` 中的 :

~~~php
# 系统自带的翻译服务
// Illuminate\Translation\TranslationServiceProvider::class,
# 替换为 Overtrue 翻译服务提供者
Overtrue\LaravelLang\TranslationServiceProvider::class,
~~~

此时便不在需要 `resources/lang/zh-CN.json` 文件

但是 **此时翻译配置文件还不在本地**, 如果需要修改某些翻译, 我们将翻译文本下载修改对应即可 :

~~~shell
# 下载中文源文件 位于 resource/lang/zh-CN 文件夹下
$php artisan lang:publish zh-CN
~~~







































