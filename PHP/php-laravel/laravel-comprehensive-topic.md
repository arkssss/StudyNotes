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

