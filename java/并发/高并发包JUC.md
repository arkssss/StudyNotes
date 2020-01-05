[TOC]

# 锁的类型

## 互斥锁 mutex

任意一个时刻, 都只能有一个现象访问该对象

常见的互斥锁有 :

* synchronized 底层的互斥信号量
* ReentrantLock



## 读写锁 rwlock

* 分为读锁和写锁。处于读操作时，可以允许多个线程
* 同时获得读操作。但是同一时刻只能有一个线程可以获得写锁, 写锁的存在会阻塞其他获取读锁的线程.







# J.U.C

**J.U.C** 即为 `java.util.concurrent`  , 由于这个包的引入, 大大提高了并发的性能

在这个包的帮助下, 我们便可以实现一些自己的锁, 只需要继承 `lock` 接口

```java
public class MLock implements Lock{
	// ...
}
```

`J.U.C` 已经包下实现了很多功能的锁如 :

* ReentrantLock
* Semaphore
* CountDownLatch
* ...





# synchronized 和 J.U.C 效率区别

> [synchronized 和 AQS 效率问题](http://www.lwyyyyyy.cn/getArticleDetailInfo?articleId=77)

因为 `synchronized` 在编译过后会生成`monitorenter`, `monitorexit` 指令, 这都是直接利用了 

`os` 的互斥量机制, 是直接和 `os` 打交道, **所以如果线程没有获得资源会立即阻塞** 涉及到 用户态

和核心态之间的切换, 这个切换会非常耗时. 

所以我们直接引入 `J.U.C` , 实现 `JDK` 层面的加锁, 在使用上,会先 **尝试自旋** 取锁, **如果失败才会被阻塞**, 从而一定

程度上提高了同步的效率

从而实现了 基于 `JDK` 实现高并发的 第二派系  ( 区别于 `synchronized` `JVM` 实现了的第一派系 )

**在两种的效率上, 并发数不高的情况下,  两者耗时差不多, 但是如果 并发量很高, 则 `JUC` 效率很高**





# J.U.C - AQS 

>  [一步步讲解 tryAcquire 实现过程](https://www.jianshu.com/p/e4301229f59e)

**AQS 是这个 `J.U.C` 的核心内容**

`AQS = AbstractQueuedSynchronizer ` , 位于 `java.util.concurrent.locks` 包下

AQS是一个用来 **构建锁和同步器的框架** , **是锁的实现框架!!**

`ReentrantLock` , `Semaphore` , `CountDownLatch`  等等一些基本的锁, 在

核心实现上都是利用了 **A.Q.S**  实现的 (**A.Q.S** 为这些 **锁的内部接口类** ) , 我们自己实现 **lock** 的时候也

需要在 **lock内部** 定义一个 **Syn 实现 A.Q.S 接口**





**AQS核心思想是 :**  如果此时请求的 **资源空闲**, 则将当前请求的线程设置为 工作线程, 并且将共享资源设定为 

**锁定状态** , 如果被请求的资源 **被锁定**,  **那么就需要一套线程阻塞等待以及被唤醒时锁分配的机制** 这个分配机

制就是利用 **CLH(一个双向队列)** 实现的, 即 将暂时没有获取到锁的线程加入到这个队列

> CLH 就是一个 负责维护 线程阻塞等待以及被唤醒时锁分配的机制 的一个双向队列



![enter image description here](https://camo.githubusercontent.com/55090fdc22963d41a3e56d5dadb17dfa7ad6379f/68747470733a2f2f6d792d626c6f672d746f2d7573652e6f73732d636e2d6265696a696e672e616c6979756e63732e636f6d2f4a6176612532302545372541382538422545352542412538462545352539312539382545352542462538352545352541342538372545462542432539412545352542392542362545352538462539312545372539462541352545382541462538362545372542332542422545372542422539462545362538302542422545372542422539332f434c482e706e67)

对于共享资源的争取方式, 不同的同步器实现也不一样, 比如 :

* **Exclusive (独占)** : 只有一个线程能执行，如ReentrantLock
* **Share (共享)** : 多个线程可同时执行，如Semaphore/CountDownLatch。Semaphore、CountDownLatCh、 CyclicBarrier、ReadWriteLock ...

我们只需要去实现 共享资源额争取方式 ,至于 **线程阻塞等待以及被唤醒时锁分配的机制 已经由 A.Q.S 实现好了**



**AQS使用了模板方法模式，自定义同步器时需要重写下面几个AQS提供的模板方法：**

~~~java
isHeldExclusively()//该线程是否正在独占资源。只有用到condition才需要去实现它。
tryAcquire(int)//独占方式。尝试获取资源，成功则返回true，失败则返回false。
tryRelease(int)//独占方式。尝试释放资源，成功则返回true，失败则返回false。
tryAcquireShared(int)//共享方式。尝试获取资源。负数表示失败；0表示成功，但没有剩余可用资源；正数表示成功，且有剩余资源。
tryReleaseShared(int)//共享方式。尝试释放资源，成功则返回true，失败则返回false。
~~~

一般来说，自定义同步器要么是独占方法，要么是共享方式，他们也只需实现`tryAcquire-tryRelease`、`tryAcquireShared-tryReleaseShared`中的一种即可。但AQS也支持自定义同步器同时实现独占和共享两种方式，如`ReentrantReadWriteLock`。





# Semaphore 信号量 允许多个线程同时访问















#ReentrantLock 可重入锁 (互斥锁)





















































 