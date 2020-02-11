[TOC]

# laravel - 基础功能

## 表单验证

> [表单验证](https://learnku.com/docs/laravel/6.x/validation/5144)

表单验证是一个接受表单数据的常用功能, 一般在 `Controller`层进行验证. 在 Laravel 中, 验证表单的方法如下 :

```php
public function signin(Request $request){
    // Request 即为 HTTP 请求封装类, 调用其 validate 方法便可以完成验证
    $this->validate($request, [
        'name' => 'required|max:50',
        'email' => 'required|email|unique:users|max:255',
        'password' => 'required|confirmed|min:6'
    ]);
}
```

- 验证成功 : Controller 继续正确执行
- 验证失败 : HTTP Get 请求则进行一个重定向响应, 如果为 AJAX 则返回错误的 Json 信息



## 中间件

> [手册中的中间件](https://learnku.com/docs/laravel/5.6/middleware/1364)

Laravel 中的中间件 MiddleWare 有很多用法, 比较广泛的是用来过滤 HTTP请求.

中间可以分为 **全局中间件** 和 **局部中间件**

~~~php
/* --------------- 全局中间件 --------------- */
/*
	全局中间件会在交付给 controller 之前拦截所有的 Htpp 请求进行逻辑处理
	我们可以在 kernel.php 的 $middleware 数组中定义注册全局中间件
*/

/* 位于 kernel.php 中, 这个数据用于定义所有的全局中间件 */
protected $middleware = [
    \App\Http\Middleware\TrustProxies::class,
    \App\Http\Middleware\CheckForMaintenanceMode::class,
    \Illuminate\Foundation\Http\Middleware\ValidatePostSize::class,
    \App\Http\Middleware\TrimStrings::class,
    \Illuminate\Foundation\Http\Middleware\ConvertEmptyStringsToNull::class,
];



/* --------------- 局部中间件 --------------- */
/*	
	局部中间件只作用于特定的路由请求.  
	定于 kernel.php 的 $routeMiddleware 数组中
*/
protected $routeMiddleware = [
    'auth' => \App\Http\Middleware\Authenticate::class,
    'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
    'bindings' => \Illuminate\Routing\Middleware\SubstituteBindings::class,
    'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
    'can' => \Illuminate\Auth\Middleware\Authorize::class,
    'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
    'password.confirm' => \Illuminate\Auth\Middleware\RequirePassword::class,
    'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
    'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
    'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
];
~~~





### 自定义中间件

我们以一个自定义的中间件为例子

1. 首先, 使用 `artisan` 命令创建一个中间件 `EnsureEmailIsVerify`  :

   ~~~shell
   $php artisan make:middleware EnsureEmailIsVerify
   ~~~

2. 我们将 `EnsureEmailIsVerify` 定义为一个全局中间件, 在所有请求过来的时候判断是否验证了邮箱

   ~~~php
   protected $middleware = [
       \App\Http\Middleware\TrustProxies::class,
       \App\Http\Middleware\CheckForMaintenanceMode::class,
       \Illuminate\Foundation\Http\Middleware\ValidatePostSize::class,
       \App\Http\Middleware\TrimStrings::class,
       \Illuminate\Foundation\Http\Middleware\ConvertEmptyStringsToNull::class,
       
       /* 加入我们自定义的 中间件*/
       \App\Http\Middleware\EnsureEmailIsVerified::class
   ];
   ~~~

   其实在验证邮箱方面, `laravel` 为我们 **自动提供了验证中间件** => `verified`.

   这个中间件默认是注册在 **局部中间件中** , 要实现和上面相同的功能, 我们将这个移动到 **全局中间件**即可





### Auth 中间件自动验证是否登陆

`Auth` 类的中间件同样为我们提供非常方面的验证是否登陆机制, 我们使用的时候, 只需要:

```php
class UsersController extends Controller
{

    public function __construct()
    {
        // 表示除了这三个方法， 其他在执行前都需要调用中间件 auth
        $this->middleware('auth', [
            'except' => ['create', 'store', 'show']
        ]);
        
        // Or
        
        // only 为 except 的反方法
        $this->middleware('auth', [
            'only' => ['create', 'store', 'show']
        ]);
        
    }
    
    // ...
    
}
```

我们怎么知道 auth对应的是哪个中间件呢.

位于 `\App\Http\Kernel.php`中给予了配置 :

```php
    protected $routeMiddleware = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'bindings' => \Illuminate\Routing\Middleware\SubstituteBindings::class,
        // ...
    ];
```

我们看到 `auth` 对应的是 `\App\Http\Middleware\Authenticate::class`

而这个类并没有给出具体的逻辑 (中间件逻辑必须时间在 `handle` 方法🀄实现): 

```php
namespace App\Http\Middleware;

use Illuminate\Auth\Middleware\Authenticate as Middleware;

class Authenticate extends Middleware
{
    /**
     * Get the path the user should be redirected to when they are not authenticated.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return string|null
     */
    protected function redirectTo($request)
    {
        if (! $request->expectsJson()) {
            return route('login');
        }
    }
}
```

真正的验证逻辑在基类 `Illuminate\Auth\Middleware\Authenticate`中实现

```php
class Authenticate
{
    // ...
    
    // 验证是否登陆
    public function handle($request, Closure $next, ...$guards)
    {
        $this->authenticate($request, $guards);

        return $next($request);
    }
    
    // ...
}
```



### Guest 中间件自动验证只对游客开发的操作

有些操作只会对游客开发, 比如登陆功能. 和 auth 类似, guest 也是 laravel提供的一个中间件, 对于游客才授权, 用法如下:

```php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;


class SessionsController extends Controller
{

    public function __construct()
    {
        // 表示 只有未登录的用户才能访问 login 页面
        $this->middleware('guest',
            ['only' => ['create']]
        );

    }
	
    
    // ...
}
```



### verified 中间件验证用户邮箱是否被验证

~~~php
Route::get('/home', 'HomeController@index')->name('home')->middleware('verified');
~~~





## 记录日志

> [手册中日志功能](https://learnku.com/docs/laravel/5.6/logging/1374)

```php
### 写入日志信息

// 记录的日志一般位于 /storage/logs 下

// 你可以使用 `Log` [门面](http://laravelacademy.org/post/8708.html)记录日志信息，如上所述，日志系统提供了定义在 [RFC 5424 规范](https://tools.ietf.org/html/rfc5424)中的八种日志级别：**emergency**、**alert**、**critical**、**error**、**warning**、 **notice**、**info** 和 **debug**：

Log::emergency($error);
Log::alert($error);
Log::critical($error);
Log::error($error);
Log::warning($error);
Log::notice($error);
Log::info($error);
Log::debug($error);

// 上下文信息

// 上下文数据也会以数组形式传递给日志方法，然后和日志信息一起被格式化和显示：

Log::info('User failed to login.', ['id' => $user->id]);
// 写入指定频道
// 有时候你可能希望将日志信息记录到某个频道而不是应用的默认频道。要实现这个目的，你可以使用 Log 门面上的 // channel 方法来获取配置文件定义的频道并将日志写入进去：

Log::channel('slack')->info('Something happened!');
// 如果你想要创建一个由多个频道组成的按需日志堆栈，可以使用 stack 方法：

Log::stack(['single', 'slack'])->info('Something happened!');
```



## 手动发送用户验证邮件

实现邮件的发送, 我们首先需要配置 `.env` 文件

```
// 使用 qq 邮箱的服务发送邮件
MAIL_DRIVER=smtp
MAIL_HOST=smtp.qq.com
MAIL_PORT=25
MAIL_USERNAME=522500442@qq.com
MAIL_PASSWORD=nkgrxqznbounbidd			// 通过 qq 邮箱生成的验证码
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=522500442@qq.com
MAIL_FROM_NAME=WeiboApp


// log 的形式发送邮件 (for debug)
MAIL_DRIVER=log 
```

**调用 Mail::send() 发送邮件**

```php
$view = 'emails.confirm';
$data = compact('user');
$to = $user->email;
$subject = "感谢注册 Weibo 应用！请确认你的邮箱。";

Mail::send($view, $data, function ($message) use ($to, $subject) {
$message->to($to)->subject($subject);
});
```

**编辑视图文件 :**

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>注册确认链接</title>
</head>
<body>
<h1>感谢您在 Weibo App 网站进行注册！</h1>

<p>
  请点击下面的链接完成注册：
  <a href="{{ route('confirm_email', $user->activation_token) }}">
    {{ route('confirm_email', $user->activation_token) }}
  </a>
</p>

<p>
  如果这不是您本人的操作，请忽略此邮件。
</p>
</body>
</html>
```



## 自动发送用户验证邮件

`Larval` 为我们提供了很方便的邮件发送功能. 主要是用来, 做用户邮件认证, 主要的逻辑是, 在用户注册之后, 便给用户发送一封邮件, 由用户点开后从而认证成功. 用户便可以正常使用. 否侧属于未认证账号.

数据库层面 `Laravel` 自带的 users 数据表存在字段 `email_verified_at`. 便是该用户是否被验证

```php
使用方法 :

use Illuminate\Contracts\Auth\MustVerifyEmail as MustVerifyEmailContracts;
use Illuminate\Auth\MustVerifyEmail as MustVerifyEmailTrait;

---- 1. User 类实现接口 Illuminate\Contracts\Auth\MustVerifyEmail 即可
		
class User extends Authenticatable implements MustVerifyEmailContracts
{
    
    
}


---- 2. 
    
    - 如果在老版本, 那么 User 类还需要 use Illuminate\Auth\MustVerifyEmail 这个 trail
    
class User extends Authenticatable implements MustVerifyEmailContracts
{
    use Notifiable, MustVerifyEmailTrait
    
        ...
}


	- 新版本中, MustVerifyEmailTrait 已经被默认移植到 Authenticatable 基类中. 可以不用自己使用了
```

### 实现原理

* 首先 `User` 类实现了 `MustVerifyEmailContracts` 这个接口, 这个接口包括 4 个方法 :

  ~~~php
      /**
       * Determine if the user has verified their email address.
       *
       * @return bool
       */
      public function hasVerifiedEmail();
  
      /**
       * Mark the given user's email as verified.
       *
       * @return bool
       */
      public function markEmailAsVerified();
  
      /**
       * Send the email verification notification.
       *
       * @return void
       */
      public function sendEmailVerificationNotification();
  
      /**
       * Get the email address that should be used for verification.
       *
       * @return string
       */
      public function getEmailForVerification();
  ~~~

* 然后 `use MustVerifyEmailTrait` 分别实现了这四个接口

* 在处理用户注册的 `register` 方法中, 我们可以看到逻辑如下 :

  ~~~php
  /* 用户注册的处理控制器 */
  public function register(Request $request)
  {
      $this->validator($request->all())->validate();
  	
      /* 表示 register 会出发一个事件系统 */
      /* 该事件即为 Registered 我们可以在 EventServiceProvider 里面找到它的监听器 */
      event(new Registered($user = $this->create($request->all())));
  
      $this->guard()->login($user);
  
      return $this->registered($request, $user)
          ?: redirect($this->redirectPath());
  }
  ~~~

* `laravel` 在 `EventServiceProvider` 中已经定义了 `Registered` 的监听器 :

  ~~~php
  /**
       * The event listener mappings for the application.
       *
       * @var array
       */
  protected $listen = [
      Registered::class => [
          
          /* 定义了 event Register 的监听器为 SendEmailVerificationNotification */
          SendEmailVerificationNotification::class,
      ],
  ];
  ~~~


* 进入 `SendEmailVerificationNotification` 后, 我们便可以看到 邮件的发送逻辑了 

  ~~~php
  /**
       * Handle the event.
       *
       * @param  \Illuminate\Auth\Events\Registered  $event
       * @return void
       */
  public function handle(Registered $event)
  {	
      /* 如果传入的 user 实现了MustVerifyEmail接口, 且还没有被验证邮件 */
      if ($event->user instanceof MustVerifyEmail && ! $event->user->hasVerifiedEmail()) {	
          /* 那么发送邮件验证 */
          $event->user->sendEmailVerificationNotification();
      }
  }
  ~~~






## 密码重置

`Laravel` 自动提供了关于密码重置的控制器和数据表

- 关于密码重置的数据表 : password_resets 位于原始的迁移文件中字段如下

  email | token | created_at 

  分别记录了收取 token 令牌的邮箱, token令牌, 以及时间

- 关于密码重置的控制器都是自带的位于 `\App\Http\Controller\Auth` 下

  忘记密码控制器 : `ForgotPasswordController `

  重置密码控制器 : `ResetPasswordController`

- 关于 laravel 自带的密码重置步骤如下 :

  1. 用户对密码忘记页面发起GET请求, 对应的路由为 :

     ```php
     Route::get('/password/reset', 'Auth\ForgotPasswordController@showLinkRequestForm')->name('password.request');
     ```

     **但是我们需要自定义视图** : `\Auth\Passwords\email.blade.php`

  2. 用户通过 POST 请求给 Laravel 发送接收 token 的邮箱

     我们接受这个 POST 请求的路由为 :

     ```php
     Route::post('password/email', 'Auth\ForgotPasswordController@sendResetLinkEmail')->name('password.email');
     ```

  3. Laravel 发送 token 到制定的邮箱

  4. 用户到邮箱中点击相应带 Token 的链接到我们的重置页面

     这个 Get 请求对应的路由为:

     ```php
     Route::get('password/reset/{token}', 'Auth\ResetPasswordController@showResetForm')->name('password.reset');
     ```

  5. 最后即为我们的重置页面 

     对应的 POST 路由为 :

     ```php
     pRoute::post('password/reset', 'Auth\ResetPasswordController@reset')->name('password.update');
     ```

     我们也需要自定义视图 : `Auth\Passwords\reset.blade.php`



## 分页

数据分页是一个很常用的功能 `Laravel` 中的分页功能实现如下:

```php
// 分页功能读取数据, 一页10条数据
$users = User::paginate(10);

return view('users.index', compact('users'));
```

前端用 :

```html
{!! $users->render() !!}
```

便可以算是页码, 如下效果 :

<img src="/Users/ark/%E6%96%87%E6%A1%A3%E7%AC%94%E8%AE%B0/%E5%90%8E%E7%AB%AF%E6%8A%80%E6%9C%AF%E6%96%87%E6%A1%A3%E7%AC%94%E8%AE%B0/PHP/php-laravel/img/pages.png" width="400px">

对应的访问 url 为 : `/users?page=2`



## 注册登陆脚手架(自动生成代码)

`Laravel` 为我们自动集成了用户的 `登陆, 注册, 密码修改, 邮件激活等功能`. 且自动添加了视图等.

使用 `artisan` 生成

```shell
# 生成包括 登陆, 注册, 密码修改, 函数激活等功能的代码
$php artisan ui:auth
```

生成修改的文件如下 :

`route/web.app` , `resources/view/auth/(定义了所有逻辑有关的视图)` , `resource/views/home.blade.php(可删除)`

- 对于 `web.app` 文件

```php
/* 对于文件 web.app, 生成如下 :*/
Route::get('/', "PagesController@root");

/* 包含了注册, 登陆, 密码修改, 邮件激活的所有路由 */
Auth::routes();

/* 这个一般没什么用, 因为我们已经有主页路由了 */
Route::get('/home', 'HomeController@index')->name('home');
```

```php
/*
	我们将 Auth::routes(); 替换为如下功能是一样的
*/
// 用户身份验证相关的路由
Route::get('login', 'Auth\LoginController@showLoginForm')->name('login');
Route::post('login', 'Auth\LoginController@login');
Route::post('logout', 'Auth\LoginController@logout')->name('logout');

// 用户注册相关路由
Route::get('register', 'Auth\RegisterController@showRegistrationForm')->name('register');
Route::post('register', 'Auth\RegisterController@register');

// 密码重置相关路由
Route::get('password/reset', 'Auth\ForgotPasswordController@showLinkRequestForm')->name('password.request');
Route::post('password/email', 'Auth\ForgotPasswordController@sendResetLinkEmail')->name('password.email');
Route::get('password/reset/{token}', 'Auth\ResetPasswordController@showResetForm')->name('password.reset');
Route::post('password/reset', 'Auth\ResetPasswordController@reset')->name('password.update');

// Email 认证相关路由
Route::get('email/verify', 'Auth\VerificationController@show')->name('verification.notice');
Route::get('email/verify/{id}/{hash}', 'Auth\VerificationController@verify')->name('verification.verify');
Route::post('email/resend', 'Auth\VerificationController@resend')->name('verification.resend');

```



