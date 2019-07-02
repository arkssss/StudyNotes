## Intro to regression

- 回归是常见的**监督学习**的算法

一般**回归的问题描述**:

给定一个假定映射方程(a hypothesis set) *H*集合 可以完成 输入变量 *X* 到 *Y*  的映射. 回归问题就是用labelled sample *S*(有标签数据的集合) S = {(x$_1$, y$_1$), ..., (x$_m$, y$_m$)} $\in$ (*X*, *Y*) . 找到一个 h $\in$ *H* 有期望的最小损失值(Small expected loss) 或者小的泛化误差 Generalization error.

一般的loss方程为 : R(h) = $\frac{1}{m}\sum_{i=1}^{m}L(h(x_i, y_i))$ , 这里的L又一般是的取 square error



常见的线性回归方法:

* 一般线性回归
* Ridge
* Lasso



### 一般线性回归

一般的线性回归可以理解为下面目标函数的优化上 :

MIN$_W$ F(W)  = |X$^T$ W - Y|$^2$  

其中 : 

X = $$ \left[  \begin{matrix}   x1,...,xm\\ 1,..., 1   \end{matrix}  \right] $$  融合了偏置项(Bais)



W = $$ \left[  \begin{matrix}   w1 \\ w2 \\ w3 \\w4  \\  ... \\wn \\ 1  \end{matrix}  \right] $$   

**即在给定的train数据集下, 找到最小的Loss时对应的W向量**

由于这个公式是可以求导的, 则可以直接利用公式推导的方法: 

**W = ( XX$^T$ )$^{-1}$XY if it is invertible**



#### 一般的线性回归的特性:

- 通常是**没有很好的泛化(generalization)能力**, 求出来的模型一般拥有**低Bias 和高方差**
- 没有正规化项 (Regularization terms)



### 岭回归 (Ridge)

损失函数加入了**正规化项(Regularization terms)**的回归, 注意预测的线性模型并没有变, 好处是可以**消弱输入数据的某些属性对结果的影响**.

现在的**损失函数**就可以写为 :

MIN$_W$ F(W)  = $\lambda$|W|$^2$  + |X$^T$ W - Y|$^2$ (加入了正规化项的损失函数) 

**即为MSE 加上了 L2正规化项**



#### 利用微分求得W

此时我们要求得满足这个的最小值时候 W 的值. 

一般的可以利用**公式法** , 对这个公式进行求导, 然后置为0. 从而可以确定出: 

**W = (XX$^T$ + $\lambda$I)$^{-1}$XY**  其中第一项是可逆的(Always invertible)



#### Ridge回归的一些特性

- 加入正规化项可以帮助我们的**约束模型面临的输入属性过多带来的Overfitting问题**
- 正规化参数$\lambda$可以帮助我们调控 'bias-variance' trade-off. 在模型的训练中, 我们明显是希望拥有 Low Bias 和 Low Variance . **$\lambda$越大带来的bias越大Variacne越小**
- Ridge加入的L2正规化项的作用可以帮助减少W Toward 0 但是, 不能将W置为0 (这点就是有区别于L1正规化项, **L1正规化可以讲某个参数置为0, 而L2只能无限趋近于0**) 





### 套索回归 (Lasso)

Lasso 回归可以实现自动化的重要特征值筛选, 从而可以当特征值非常多的时候筛**选掉对结果几乎没有影响的特征.**

Lasso 回归的目标函数 :

MIN$_W$ F(W)  = $\lambda$|W|$_1$  + |X$^T$ W - Y|$^2$ 

相比于Ridge回归**大部分类似**, Lasso最大的不同就是其是使用的**正规化参数L1.** 这样Lasso 可以达到直接丢弃无关特征的目的(直接系数置为0), 而Ridge只能无限接近于0







### 正规化项分类(惩罚项)

例如  :W = [w1, w2, ... , wn]

- L0 : 表示所有非0元素的个数
- L1 (Lasso) : |W|$_1$ 表示所有元素的绝对值和即为 $\sum_{i=1}^n |w_i|$
- L2 (ridge) :  |W|$_2$ 表示所有元素的平方和  $ \sum_{i=1}^n w_i^2$



**Q : 为什么L1 惩罚项可以将某个元素置0, 而L2不可以?**

首先我们公式的形式写出加上了正规化项的目标函数:

MIN$_w$(y - wx)$^2$  + L = RSS + L

- **对于Lasso** : 优化式写为 min$_{w, b}${$\sum_{i=1}^n (y_i - wx_1 +b)^2$ } , $\sum_{i=1}^n |w_i|$ <= s 
- **对于Ridge** : 优化式写为 min$_{w,b}${$\sum_{i=1}^n (y_i - wx_1 +b)^2$ } , $\sum_{i=1}^n w_i^2$  <= s

 以二维的向量举例, 最优点表现为圆环(最小二乘法的最优值) 和 绿色阴影的 **交点**: 

![L1:L2](/Users/ark/%E8%AF%BE%E7%A8%8B%E8%B5%84%E6%96%99/%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0/%E5%9B%9E%E5%BD%92/image/L1:L2.png)

<center>左L1(Lasso), 右L2(Ridge)

**当某一个惩罚元素置为0的时候, 意味着该最优点必须在坐标轴上** , 由于L2图为原形, **椭圆和圆的交点不可能落在坐标轴上**, 而合正方形的交点有可能在坐标轴. 所以这就意味着. **L1的惩罚项元素可能为0,但是L2最多只能无限接近0**

因此推广到更高维的空间也是一样.