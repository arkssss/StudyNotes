## 岭回归 (Ridge)

加入了**正规化项(Regularization terms)**的回归, 好处是可以消弱输入数据的某些属性对结果的影响.

现在的损失函数就可以写为 :

MIN$_W$ F(W)  = $\lambda$|W|$^2$  + |X$^T$ W - Y|$^2$ (加入了正规化项的损失函数) 

**即为MSE 加上了 L2正规化项**



#### 利用微分求得W

此时我们要求得满足这个的最小值时候 W 的值. 

一般的可以利用**公式法** , 对这个公式进行求导, 然后置为0. 从而可以确定出: 

**W = (XX$^T$ + $\lambda$I)$^{-1}​$XY**  其中第一项是可逆的(Always invertible)



#### Ridge回归的一些特性

- 加入正规化项可以帮助我们的约束模型面临的输入属性过多带来的Overfitting问题
- 正规化参数$\lambda$可以帮助我们调控 'bias-variance' trade-off. 在模型的训练中, 我们明显是希望拥有 Low Bias 和 Low Variance . **$\lambda$ 越大带来的bias越大Variacne越小**
- Ridge加入的L2正规化项的作用可以帮助减少W Toward 0 但是, 不能将W置为0 (这点就是有区别于L1正规化项, **L1正规化可以讲某个参数置为0, 而L2只能无限趋近于0**) 

