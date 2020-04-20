[TOC]

# laravel - 综合话题



# 事件系统

[手册中的事件系统](<https://learnku.com/docs/laravel/6.x/events/5162>)

> Laravel 的事件提供了一个简单的观察者实现，允许你在应用中订阅和监听各种发生的事件。事件类通常放在 `app/Events` 目录下，而这些事件类的监听器则放在 `app/Listeners` 目录下。如果在你的应用中你没有看到这些目录，不用担心，它们会在你使用 Artisan 控制台命令生成事件与监听器的时候自动创建。
> 事件系统为应用各个方面的解耦提供了非常棒的方法，因为单个事件可以拥有多个互不依赖的监听器。举个例子，你可能希望每次订单发货时向用户推送一个 Slack 通知。你可以简单地发起一个可以被监听器接收并转化为 Slack 通知的 `OrderShipped` 事件，而不是将订单处理代码和 Slack 通知代码耦合在一起。

简单来说, 事件系统类似于更细粒度的 `Spring AOP`. 可以在某函数的任意位置调用某事件.

## 实现步骤

~~~php
/* ----------------- 1 ------------------ */
一个事件的完成, 需要以下几个类文件
    - event    : 我们自定义的事件类
    - listener : 我们自定义的监听类
    - EventServiceProvider : laravel 自带的, 用于关联 event 和对应的 listener

        
        
        


/*------------------ 2 EventServiceProvider定义 ------------------*/
首先我们在 EventServiceProvider 中定义一个事件及其监听器
        
        
/* 纵然现在还不存在这些 event 和 listener , 我们先 use 进来 */
use App\Events\testEvent;
use App\Listeners\testListener;
class EventServiceProvider extends ServiceProvider
    {
        protected $listen = [
            Registered::class => [
                SendEmailVerificationNotification::class,
            ],

            /* 我们自定义的 event 以及 listener */
            testEvent::class => [
                testListener::class
            ]
        ];

    }






/*------------------ 3 artisan 命令 ------------------*/
在定义好 EventServiceProvider 后,我们便可以利用 artisan 命令去生成对应的 event & listener

  
# 根据 EventServiceProvider 生成 event & listener
>$php artisan event:generate

    
    
    


/*------------------ 4 修改 生成的 enevt ------------------*/


/* enevt 的本质即为某个实例的容器, 所以我们需要在这个类的构造函数注入这个类 */
class testEvent
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $user;


    /**
     * Create a new event instance.
     *
     * @param User $user
     */
    /* enevt 的本质即为某个实例的容器, 所以我们需要在这个类的构造函数注入这个类 */
    public function __construct(User $user)
    {
        //
        $this->user = $user;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return \Illuminate\Broadcasting\Channel|array
     */
    public function broadcastOn()
    {
        return new PrivateChannel('channel-name');
    }
}




/*------------------ 5 修改生的 listener ------------------*/


namespace App\Listeners;
class testListener
{
    /**
     * Create the event listener.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

	/* 这个handle 即为我们的事件处理函数, 传入的参数即为我们定义的 event 实例 */
    /* event 实例包含了 $user 实体 */
    public function handle(LogIned $event)
    {
        //
        Log::debug("test listener : ". $event->user->name);
        
        // handle code
        
    }
}


/*------------------ 6 事件触发 ------------------*/  

要触发这个事件, 我们只需要在任意函数去实例化一个 event 即可

    public function login(User $user){
    	/* 触发事件 */
    	event(new testEvent($user));
	}


~~~





# 安全相关

## 用户认证

> [文档中的用户认证](https://learnku.com/docs/laravel/5.6/authentication/1379#authenticating-users)
>
> [深挖Attempt函数](https://blog.csdn.net/xueba8/article/details/82347270)

`use Illuminate\Support\Facades\Auth;`

简而言之, 用户认证可以理解为用一个 `Auth` 类去保存 **当前登陆用户.**

同时我们可以使用 Auth 去获得当前登陆用户的信息

```php
// 判断当前用户是否已认证（是否已登录）
 Auth::check();
// 获取当前的认证用户
 Auth::user();
// 获取当前的认证用户的 ID（未登录情况下会报错）
 Auth::id();
// 通过给定的信息来尝试对用户进行认证（成功后会自动启动会话）
 Auth::attempt(['email' => $email, 'password' => $password]);
// 通过 Auth::attempt() 传入 true 值来开启 '记住我' 功能
 Auth::attempt($credentials, true);
// 只针对一次的请求来认证用户
 Auth::once($credentials);
// 登录一个指定用户到应用上
 Auth::login(User::find(1));
// 登录指定用户 ID 的用户到应用上
 Auth::loginUsingId(1);
// 使用户退出登录（清除会话）
 Auth::logout();
// 验证用户凭证
 Auth::validate($credentials);
// Attempt to authenticate using HTTP Basic Auth
 // 使用 HTTP 的基本认证方式来认证
 Auth::basic('username');
// Perform a stateless HTTP Basic login attempt
 // 执行「HTTP Basic」登录尝试
 Auth::onceBasic();
// 发送密码重置提示给用户
 Password::remind($credentials, function($message, $user){});
```

也就是说, 一旦一个用户登陆(认证)了 Laravel 应用, 那么我们便可以通过 Auth 去获得其信息.



### 设置当前用户到 Auth

- 用户登陆成功情景
  我们使用 `Auth::attempt()` 去验证 `request` 传递来的登陆信息. for example :

  ```php
  public function store(Request $request){
    $basicValidate = $this->validate($request,[
          'password' => 'required',
          'email'=> 'required|email|max:255'
      ]
  );
      // 检测 basicValidate 是否存在与数据库中
      // 第二个传参为 bool 值，true 表示记住次用户
      if(Auth::attempt($basicValidate, true)){
          // 登陆成功
          
      }else{
          // 登陆失败
  
      }
  }
  ```

  `Auth::attempt()` 在验证的同时, **如果登陆成功也会记录到这个用户**. 底层代码实现如下 :

  ```php
  // in Illuminate\Auth 的文件 SessionGuard.php
      public function attempt(array $credentials = [], $remember = false)
      {
          $this->fireAttemptEvent($credentials, $remember);
          $this->lastAttempted = $user = $this->provider->retrieveByCredentials($credentials);
  
          if ($this->hasValidCredentials($user, $credentials)) {
              
              // 这里就是登陆逻辑, 如果验证成功了, 那么登陆该user
              $this->login($user, $remember);
  
              return true;
          }
          $this->fireFailedEvent($user, $credentials);
  
          return false;
      }
  
  
  public function login(AuthenticatableContract $user, $remember = false)
      {
          $this->updateSession($user->getAuthIdentifier());
  
          if ($remember) {
              $this->ensureRememberTokenIsSet($user);
  
              $this->queueRecallerCookie($user);
          }
          $this->fireLoginEvent($user, $remember);
  		
  		// login 函数的最后即为 set当前的suer
          $this->setUser($user);
      }
  
  
  // setUser 即为赋值给当前的成员函数
  public function setUser(AuthenticatableContract $user)
  {
      $this->user = $user;
  
      $this->loggedOut = false;
  
      $this->fireAuthenticatedEvent($user);
  
      return $this;
  }
  ```

### 注销当前用户

即为 logout 功能, 我们直接调用 Auth 的 logout 即可, 如下 :

```php
Auth::logout();
```



## 用户授权 与 策略授予

> [手册中的用户授权](https://learnku.com/docs/laravel/6.x/authorization/5153#registering-policies)

相比于用户认证(中间件实现) , **用户授予倾向于给当前登陆的用户授予操作某个方法的权限**, 比如 当前登陆用户只能修改自己的个人信息. **策略授予是用户授权的实现**

我们使用命令创建一个 **策略**

```shell
> php artisan make:policy UserPolicy
```

此时在 `\App\Policies\` 下会生成一个 `UserPolicy.php`文件

**基于约定大于配置的原则, 我们的策略名和 model 保持一致, 从而可以省略一些配置操作**

比如我们的用户表对应的 **Eloquent 模型为 User**, 那么我们的策略即为 **UserPilicy** 用来定义一些关于 User 数据操作的权力授予. 

**以更新用户权利为例子, 完整步骤如下 :**

```php
// --- 1. 在 UserPolicy 中定义关于 update 权利验证的方法
class UserPolicy
{
    use HandlesAuthorization;
    
    // 返回一个bool值, 这个逻辑即为当前用户只能修改自己的资料
    public function update(User $currentUser, User $passUser){

            return $currentUser->id === $passUser->id;

    }
}


// --- 2. 在 \App\Provides\AuthServiceProvider 中定义自动注册机制 (也可以手动注册)
public function boot()
{
    $this->registerPolicies();

    // 修改策略自动发现的逻辑
    Gate::guessPolicyNamesUsing(function ($modelClass) {
        //  约定大于配置 也可以如下实现 
        //  $class_name = class_basename($modelClass);
        //  if($class_name == 'User'){
        //   return 'App\Policies\UserPolicy';
        //   }
        // 动态返回模型对应的策略名称，如：// 'App\Models\User' => 'App\Policies\UserPolicy',
        return 'App\Policies\\'.class_basename($modelClass).'Policy';
    });
}


// --- 3. 在 UserController 更新操作中调用该策略
// 控制用户 CRUD 操作
class UsersController extends Controller
{

    public function update(User $user, Request $request){

        // 利用 UserPolicy 策略的 update 方法， 验证此时的user
        $this->authorize('update', $user);

		// code ...
}
```



### 关于策略方法第一个参数的问题

默认情况下, 策略内方法的第一个参数是当前登陆的用户, 可以理解为, **所有的策略方法, 都是针对某一用户权限授予, 默认情况下为当前登陆用户**

```php
class BlogPolicy
{

    /* 删除策略 */
    /* 所有策略的方法第一个传递参数都必须是 User 类型的 !!! */
    public function destroy(User $currentUser, Blog $currentBlog){
        /* 只能删除属于自己的blog */
		return $user->id == $currentBlog->user_id;
    }

}



/* 用这种方式调用的时候, laravel 默认的传递了 Auth::user() 给这个策略变为第一个参数 */
$this->authorize('destroy', $blog);
```

### 关于策略方法第二个参数的问题

```php
/* 值得注意的是, 策略的寻找并不是和对应控制器绑定的, 如下举例解释 */

class BlogController extend controller{
    

    public function destroy(Blog $blog){
        
        /* 这种调用下, 会找对应的 BlogPolicy 中的 destroy 方法去授权当前用户 */
		$this->authorize('destroy', $blog);
        
    }
    
}

/* 

	实际上以上情况会调用 `BlogPolicy` 策略文件, 是应为第二个参数传递的是 Blog 类型
	也就是说, 寻找哪个策略文件取决于 第二个传参数, 而不是所在的控制器
	
	即, 我们没必要为每一个控制器都写一个对应的 策略
	而对于每一个 Eloquent 模型才是需要对应一个 策略文件

*/
```











### 策略方法对非当前登陆用户的权限检测

```php
/* 这种方法检验权限即为 对当前登陆用户的检验*/
$this->authorize('destroy', $blog);


/* 对于非当前登陆用户, 可以如下方式查看 */
User::find(1)->can('destroy', $blog);
```



# CSRF 攻击



# N + 1 问题

N + 1 问题普遍存在于ORM框架中，发生于当模型中存在关联关系的时，我们用 `post(推文)` 表和 `category（推文类别）` 表举例子。

~~~
/* table : category */
id
category_name


/* table : post */
id 
category_id // Foreign key
~~~

当我们将 `Post Model` 和 `Category Model` 使用 `belongsTo` 关联后, 便可以使用 `Post Model` 属性的方式获得其对应的类别

~~~php
# 获得 $post 类别名
$post->category->category_name
~~~

**N+1** 问题发上在从数据库中取出一定量的 posts 同时获取这些 posts 的类别名的时候。

## 不关联的 Sql 查询

~~~php
/* 不获得推文分类信息 */

/* 分页获取 $posts */
$posts = Post::pagenate(30);
~~~

此时 `Query` 查询数量及其语句为以下两个 :

~~~sql
select count(*) as aggregate from `posts`
select * from `posts` limit 30 offset 0
~~~

<img src='img/N1-without-rel.png'>

## 关联的 Sql 查询

~~~php
/* 获得推文分类信息 */

/* 分页获取 $posts */
$posts = Post::pagenate(30);

/* 获取推文类别并加入为推文的属性 */
foreach($posts as &$post){
	$post['cat'] = $post->category->category_name;
}
~~~

此时的 `Query` 数量及其语句为 :

<img src='img/n1-with-rel.png' />

**可以看到 query 数量从 2 个飙升到 32 个**，对于每一个 post 都会查找一遍对应的类别表, 造成了极大的性能损耗.

## `with` 预加载

N + 1 的问题可以使用 `with` 预加载语句解决。

~~~php
# 预加载
$posts = $this->postModel::with('category')->paginate(30);
foreach ($posts as &$post){
    $post['cat'] = $post->category->name;
}
~~~

<img src='img/n1-sql-use-with.png' />

可以看到使用 `with` 预加载可以提前获得所有 `post` 中出现 `category_id` 然后一并查询类别表并缓存下来。从而使得其查询数量将为 3 个。

















