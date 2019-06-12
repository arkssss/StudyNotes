## Intro to 判别模型 (Discrimitive Model)

判别模型中, 不用去考虑联合概率分布, 条件概率分布 等等.  而仅仅是依靠了**判别式(Discirmitive function)去根据我们输入的特征向量去引导一个判别规则**

即 :**判别式技术依赖于判别方程而不是数据本身的分布**, 且判别式(主要参数)的形成依赖于training procedure

### 利用判别模型的例子

#### 二分类

假如应对一个二分类的问题 **two-class problem**, 我们的判别方程为(Discirmitive function)

假定 x 是我们输入数据的特征向量.

给定一个判别方程 h(x) :

h(x) > k => x $\in$ c$_1$  

h(x) < k => x $\in c_2$

(k 是一个常数)

#### 多分类

如果是**多分类的问题**, 我们可以将*x*归于类$c_i$当:

g$_i$ (x) > g$_j$(x) => x $\in c_i$ j = 1,...,C; j$\neq$ i	(即给予判别式算出来的值是最大了便可以归为这一类)



### 线性判别式 (Linear discriminant function)

判别式是线性模型的可以称为线性判别式 , 例如输入属性为 *x* = [x1, x2, ... , x$_n$] 

g(x) = $w^t$*X*  + $w_0$ 

利用线性判别式的分类器可以称为 *Linear machines*





### 分段线性判别式 (Piece-wise linear discriminant function)

- 线性机器很简单, 但是有一个问题就是他们形成的决策界有一个问题就是, **决策界是凸的 convex**

  从而解决不了一些复杂的分类问题 (如下图的问题用简单的线性机器就解决不了)

  ![Piece-wise](/Users/ark/%E8%AF%BE%E7%A8%8B%E8%B5%84%E6%96%99/%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0/%E5%88%86%E7%B1%BB/image/Piece-wise.png)

对于分段的线性判别式, 我们的思想就是对于: **每一个类, 我们可以安排多个Prototype**

- Suppose there are n$_i$ prototypes in class $w_i$  which is $p_i^1, p_i^2, ... , p_i^{n_i}$	

- 然后我们将 *X* 归位类 $w_i$ 当且仅当:

  g$_i$(x) = max$_{j=1,...,n_i}$ $g_i^j$ (x)