[TOC]

# Laravel MVC

[Laravel 6 中文文档 ](https://learnku.com/docs/laravel/6.x)

[Laravel项目入门实战](https://learnku.com/courses/laravel-essential-training/6.x)



# Route 层

路由层, 将 http 请求映射到相应的控制器中. 注意处理 http 路由的位于 `routes/web.php` 中

>Laravel 遵从 RESTful 架构的设计原则，将数据看做一个资源，由 URI 来指定资源。对资源进行的获取、创建、修改和删除操作，分别对应 HTTP 协议提供的 GET、POST、PATCH 和 DELETE 方法



## GET 方法映射

在路由映射中, 我们同样利用 RESTful 设计接口, 例如:

~~~php
// 接受 浏览器端发来的 get 请求, 路由为 '/' 映射到  StaticPagesController 控制器下的 home 方法
Route::get('/', 'StaticPagesController@home')->name('home');
Route::get('/help', 'StaticPagesController@help')->name('help');
Route::get('/about', 'StaticPagesController@about')->name('about');
~~~

### 调用 route with get 传参

~~~php
# [$user] 为这个 GET 请求的传参时, 会默认获得这个模型的主键作为传参
route('users.show', [$user])
    
# 等效于 
    
route('users.show', [$user->id])
~~~



## DELETE 方法映射

delete 在 RESTful 设计中表示删除一个资源. 可以用于 **删除用户, 登出** 等功能

~~~php
Route::delete('/logout','SessionsController@delete')->name('logout');
~~~

在 delete 对应的 controller 中, 不直接返回 View, 而是在实现逻辑后采用重定向的功能.

~~~php
public function delete(){
    ...
        
	// 完成逻辑后重定向到 login 路由
	return redirect()->route('login');
}
~~~

注意在前端, 我们浏览器现在还不支持发送 `delete`请求, 所以在前端 from 中我们需要增加隐藏域表示 delete 方法

~~~html
<form action="{{ route('logout') }}" method="POST">
    {{ csrf_field() }}
    {{--   可以模拟出浏览器发出 delete 请求  --}}
    {{ method_field('DELETE') }}
    <button class="btn btn-block btn-danger" type="submit" name="button">退出</button>
</form>
~~~







## RESTful 接口全映射

~~~php
- 1. 定义一个 RESTful 接口

    // users 为资源名, 后一个为控制器名
    Route::resource('users', 'UsersController');

    // 以上代码等同于下面所有操作 

    // 获得所有用户
    Route::get('/users', 'UsersController@index')->name('users.index');
    // 获得 创建一个用户的页面
    Route::get('/users/create', 'UsersController@create')->name('users.create');
    // 根据用户id展现一个用户
    Route::get('/users/{user}', 'UsersController@show')->name('users.show');
    // post 方法创建一个用户
    Route::post('/users', 'UsersController@store')->name('users.store');
    // 获得更新用户信息页面
    Route::get('/users/{user}/edit', 'UsersController@edit')->name('users.edit');
    // 更新用户操作
    Route::patch('/users/{user}', 'UsersController@update')->name('users.update');
    // 删除用户操作
    Route::delete('/users/{user}', 'UsersController@destroy')->name('users.destroy');



- 2. 定义一个 RESTful 接口的同时指定特定操作
    Route::resource('users', 'UsersController', ['only'=>['store', 'destory']]);
~~~



# Controller 控制器层

## 创建一个控制器

~~~shell
# 创建一个 UsersController 的控制器
$php artisan make:controller UsersController
~~~







## 控制器传递参

~~~php
/* ----------- 1. Request 对象获得 ----------- */

/*
	最普通获得前端的数据的方法通过 request
	可以获得 get , post 数据
*/  
Route::get("/show/{id}", "User@show");

public function show(Request $request){
    /* 传递request对象 从而获得id */
    $id = $request->id;
}


/* ----------- 2. 直接封装为 Eloquent 模型 ----------- */
/*
	当传递的 id 为某个模型的 主键的时候, 那么 laravel 在传递的时候
	可以自定根据id封装为 Eloquent 模型
*/  

/* 使用此种方法的时候, {user} 名称必须和 Eloquent模型名相同, 同时首字母小写 */
Route::get("/show/{user}", "User@show");
public function show(User $user){
    /* 直接获得 Eloquent 模型 */

}
~~~





















# 数据库

## 数据库迁移

> [手册中的数据库迁移](https://learnku.com/docs/laravel/6.x/migrations/5173)

数据库迁移在团队开发中很重要, 可以选择直接利用 sql 文件, 或者`Laravel` 中采用 `migrate` 的方式进行数据库迁移 (仅仅迁移表结构)

`Migrate` 文件位于 `\databases\migrations` 下. 初始状态下, `Laravel` 提供了三个表的表结构, 如下:

~~~
database/migrations/2019_08_19_000000_create_users_table.php
database/migrations/2019_08_19_100000_create_password_resets_table.php
database/migrations/2019_08_19_000000_create_failed_jobs_table.php
~~~

`Migrate `相关的命令操作

~~~shell
- 1 . 根据数据库迁移文件完成的数据库创建
> php artisan migrate 

- 2. 修改某些迁移文件后, 重新根据种子去刷新数据库
> php artisan migrate:refresh --seed
~~~



### 添加字段

假设我们需要给已经生成的表 `users` 添加字段 `is_admin`, 步骤如下 :

~~~php
// ------- 1. 生成一个 migrate 文件
> php artisan make:migration add_user_is_admin --table=users

// ------- 2. 编辑该迁移文件的 up, down 函数, 分别对应执行和回滚
    public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->boolean('is_admin')->default(false);
        });	
    }
    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            //
            $table->dropColumn('is_admin');
        });
    }

// ------ 3. 执行该文件
> php artisan migrate
~~~

添加字段的默认选择:

| 操作       | 含义               |
| ---------- | ------------------ |
| default()  | 定义该字段的默认值 |
| nullable() | 表示该字段可以为空 |



### 新增数据表

在数据库层面添加数据表, 例如添加 blogs 步骤如下:

~~~php
# 1. 生成一个 create_table_blogs 的迁移文件
> php artisan make:migration create_table_blogs --create="blogs"


# 2. 在 create_table_blogs 中定义字段
    在默认的create_table_blogs文件中, laravel 会为数据表自动创建如下字段 :
	id | create_at | update_at 三个字段, 对应的以下代码:

	$table->bigIncrements('id');
	$table->timestamps();

# 3. 运行迁移文件
> php artisan:migrate
~~~

### 迁移回滚

~~~shell
# laravel 的回滚有如下方式

# 回滚最近一次迁移命令
>$php artisan migrate:rollback

# 回滚指定次数的迁移
>$php artisan migrate:rollback --setp=5

# 回滚所有的迁移
>$php artisan migrate:reset

# 回滚后再执行所有的迁移
>$php artisan migrate:refresh
~~~



## 数据填充

### 填充初始数据

有一些数据需要在数据表形成的时候，便需要填充一些初始化数据，我们使用 `laravel` 中的迁移文件即可实现.

~~~php
// 例如在初始的时候，便需要给给 postCategories 表插入如下数据

<?php

class SeedPostCategoriesData extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //
        $initCategories = [
            [
                'name'        => '分享',
                'description' => '分享创造，分享发现',
            ],
            [
                'name'        => '教程',
                'description' => '开发技巧、推荐扩展包等',
            ],
            [
                'name'        => '问答',
                'description' => '请保持友善，互帮互助',
            ],
            [
                'name'        => '公告',
                'description' => '站点公告',
            ],
        ];

        DB::table('postCategories')->insert($initCategories);
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        // truncate() 方法为清空 categories 数据表里的所有数据。
        DB::table('postCategories')->truncate();
    }
}

~~~



### 填充测试数据

> [手册中的数据填充](https://learnku.com/docs/laravel/6.x/seeding/5174)

就是利用假数据填充数据库做测试, 我们利用 Faker 库自动数据填充例子如下 :

~~~php
假设需要给 blogs 数据表自动填充数据

| id | user_id  |content | updated_at | created_at |

- 1. 创建一个 factory 工厂 => BlogFactory.php 手动创建或者命令行均可 : 
  > $php artisan make:factory BlogFactory --model="Blog"
    
- 2 . 编辑 工厂文件, 定义 faker 数据生成规则
  $factory->define(Blog::class, function (Faker $faker) {
        $date_time = $faker->date . ' ' . $faker->time;
        return [
            'user_id' => 1,
            'content' => $faker->text(100),
            'created_at' => $date_time,
            'updated_at' => $date_time,
        ];
    });


- 3. 生成一个 seeder , 并且和该工厂对应
    > $ php artisan make:seeder BlogTableSeeder
    
     
- 4. 编辑 BlogTableSeeder.php 文件的 run 方法
	public function run()
    {	
        // 生成 50 条数据
        $blogs = factory(Blog::class)->times(50)->make();
        Blog::insert($blogs->toArray());
    }
	
- 5. 运行 seeder
    
    > $php artisan db:seed --class=BlogTableSeeder
~~~











# View 层

Webapp 中 View 层即传递给前端的 HTML 



## View 层赋值

~~~php
# 返回在 user/edit 的试图
# 给页面传递参数的时候, 必须为数组形式, 也就是说 $data 必须为数组
return View('user.edit', $data)
    
$user;  
# 当传参不为数组的时候, 我们可以用 compact 函数将其转化为数组
return View('user.edit', compact('user'))
~~~



# Model 层

##Eloquent 

Laravel 的 model 层为 ORM 架构, 在框架中叫 : `Eloquent ORM`, 所谓的 ORM 即为 Object Relation Map. 表示数据库中的每一个表都对应一个 Model 对象

表和model对象的对应关系为 : users表 -> App\Models\User

~~~php
/* 继承 Model的User Eloquent */
class User extends Model
{
  // ...   
}
~~~

### `Fillable` 成员变量

在新增记录的时候, 需要注意在 `Model`内部指出, 哪些是可以被更新的. 即规定 fillable 变量. 否则会导致插入失败

```php
class Blog extends Model
{
	
    // 指定模型中 content 字段为 fillable 字段. 从而可以正常插入
    // $fillable 可以保护必要的字段不被更新
    protected $fillable = [
        'content',
    ];
    
}
```

###  `timestamps` 成员变量

有些数据表不需要维护默认的 `timestamps` 字段，此时需要在对应的 model 中将其关闭

~~~php
class PostCategory extends Model
{
    // 不需要维护时间字段
    public $timestamps = false;
}
~~~



## 模型操作 CRUD

> [快速入门](<https://learnku.com/docs/laravel/6.x/eloquent/5176#retrieving-single-models>)

### 查询

~~~php
/* ------------------------ 1. find() ------------------- */
/* 
	find() 函数默认查询的是表中的主键
*/
// 返回表中 id = 1 的记录映射为 Eloquent 对象
$user = User::find(1)


/* -------------------- 2. where() + first() ------------------- */

// 当查找项不在主键时候, 我们便需要使用 where + first 的方法查找第一个满足的记录
// 凡事不利用主键, 那么都有可能返回超过1条记录, 所以要使用 first().
$user = User::where('name', 'fz')->first()

// 返回所有姓名为 fz 的记录, 并且封装为 collection
$user = User::where('name', 'fz')->get();
   
~~~



## 新增模型

在 `Eloquent` 规则中, 数据模型名称对应的单数形式的数据表, 例如新增一个 `Blog` 模型:

~~~shell
> php artisan make:model Models/Blog 
~~~





## Model REPL - tinker

即直接用命令的方式进行数据库操作.

~~~shell
# 进入 tinker 模式
> php artisan tinker

>>> ...
~~~

## 新增记录

~~~shell
# App\Models\User 表示操作的模型
>>>App\Models\User::create(['name'=>'ark','email'=>'ark@example.com','password'=>bcrypt('password')])
~~~



## 模型事件

> [手册中的模型事件](https://learnku.com/docs/laravel/6.x/eloquent/5176#events)

Eloquent 模型事件允许我们在模型的合个生命周期节点上进行自定义操作. 模型的生命周期指的是 **该条记录的生命周期而不是模型实例的生命周期** , 比如 : 

~~~
- retrieved : 当利用该模型从数据库中查找数据时触发
  for example : \App\Models\User::find(1);

- creating  : 当调用模型的 create 方法创建一个记录 **之前**.
  for example : 
  $user = User::create([
        'name' => $request->name,
        'email' => $request->email,
        'password' => bcrypt($request->password),
    ]);

- created  : 当调用模型的 create 方法创建一条记录 **之后**.


- updating : 当调用模型的 update 方法更新一条数据 **之前**

- updated  : 当调用模型的 update 方法更新一条数据 **之后**

- ...
~~~

### 利用 观察者模式为模型制定 event 逻辑

如果我们想为 `User` 模型 制定一个 `creating` 事件逻辑, 步骤如下 :

~~~php
- // ----------- step 1 : 
  利用artisan创建一个UserObserver 
  > php artisan make:observer UserObserver --model=User
  
  
- // ----------- step 2 : 
  在 UserOberver 中制定相应逻辑 
  
  class UserObserver{
      
      public function creating(User $user){
          
          Log::debug("creating event happened");
          
      }
      
  }
  
- // ----------- step 3 : 
  在 \App\Providers\AppServiceProvider 的 boot 方法中将两者绑定
  
    class AppServiceProvider extends ServiceProvider
	{
    
    // ....
        public function boot()
            {
                // 绑定模型和观察者
                User::observe(UserObserver::class);
            }
	}
~~~



## 模型关联

> [手册中的模型关联](https://learnku.com/docs/laravel/5.5/eloquent-relationships/1333)
>
> [模型关联详解](<https://learnku.com/laravel/t/15620/laravel-eloquent-model-associated-quick-lookup-table>)

即可以在 Model 层面对几个模型进行关联操作, 从而简化数据库逻辑.

### 一对多逻辑 hasMany

比如一个用户会发多个微博. 可以如下处理:

~~~php
class User extend Model{
    
    // ... code
    
    
    /* 动态绑定 */
    public function blogs(){
        
        return $this->hasMany(\App\Models\Blog::class);
        
    }
}
~~~

在调用的时候, 便可以直接利用:

~~~php
# 获得该用户的所有博客
>>> \App\Models\User::find(1)->blogs()->get()
~~~



### 多对一逻辑 belongsTo

同样多个微博可以属于一个用户, 那么处理如下:

~~~php
class Blog extend Model{
    
    // ... code
    
    
    /* 动态绑定 */
    public function user(){
        
        # 默认情况下, blogs 表中的外键为 user_id, 如果不是需要在函数的第二个参数指定
        return $this->belongsTo(\App\Models\User::class);
        // return $this->belongsTo(\App\Models\User::class, 'foreignKey');
        
    }
}
~~~

在调用的时候, 便可以直接利用:

~~~php
# 获得该博客的所属用户
>>> \App\Models\Blog::find(1)->user()->get()
~~~



### 多对多逻辑 belongsToMany

比如公交车和司机的关系, 一辆公交车可以有多个司机, 一个司机也可以驾驶多个公交车

<img src='img/car_driver.png' width="300px"/>

此时我们便可以利用 belongsToMany 关系

在模型文件中如下定义 :

~~~php
class Car extend Model{
    
    // ...
    
    public class driver(){
        
       // car_driver 为中间表
       // driver_id, car_id 都是中间表的字段
       return $this->belongsToMany(Driver::class, 'car_driver','driver_id', 'car_id');
        
    }
    
}

class Driver extend Model{
    
    // ...
    
    public class car(){
        
       // car_driver 为中间表
       // driver_id, car_id 都是中间表的字段
       return $this->belongsToMany(Car::class, 'car_driver', 'car_id', 'driver_id');
        
    }
}
~~~

同时我们需要创建一个中间表 `car_driver` 当然也可以自定义其他的名字

~~~php
Schema::create('car_driver', function (Blueprint $table) {
    $table->bigIncrements('id');
    $table->integer('car_id')->index();
    $table->integer('driver_id')->index();
    $table->timestamps();
});
~~~

在定义好如上规则之后, 我们便可如下查值 :

~~~shell
# 获得司机驾驶过的所有车辆信息
> $driver->car()->get()

# 获得车辆的所有司机信息
> $car->driver()->get()
~~~



**Laravel 内置的关于多对多的关联操作 :**

~~~php
/* Laravel 内置了关于中间表(如 car_driver) 的相关关联操作, 所有的操作都是在中间表中进行改变, 而不改变主表*/

- 1. attach 操作 (简单添加)
	/* 将id 为1,2 的车辆标记为当前 driver 的历史驾驶车辆 */
	$driver->car()->attach([1, 2]);
    
    /* 将id 为2,3 的司机标记为当前车辆的 历史驾驶司机 */
	$car->driver()->attach([2, 3]);

- 2. sync 操作 (去重添加)
    /* 
    	使用 attach 可能会出现重复添加的情况 for exmaple :
    	$driver->car()->attach([1, 2, 1])
    	那么 car_id 1 会重复添加到 car_driver 表中
    	此时我们使用 sync 解决这个问题
    */
    $driver->car()->sync([1, 2], false);
    
- 3. detach (删除)
    /* 删除当前司机的 car_id 为 1,2 的中间表记录 */
    $driver->car()->detach([1, 2]);
~~~















