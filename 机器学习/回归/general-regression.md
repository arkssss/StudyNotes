## 一般线性回归

一般的线性回归可以理解为下面目标函数的优化上 :

MIN$_W$ F(W)  = |X$^T$ W - Y|$^2$  

其中 : 

X = $$ \left[  \begin{matrix}   x1,...,xm\\ 1,..., 1   \end{matrix}  \right] $$  融合了偏置项(Bais)



W = $$ \left[  \begin{matrix}   w1 \\ w2 \\ w3 \\w4  \\  ... \\wn \\ 1  \end{matrix}  \right] $$   

**即在给定的train数据集下, 找到最小的Loss时对应的W向量**

由于这个公式是可以求导的, 则可以直接利用公式推导的方法: 

**W = ( XX$^T$ )$^{-1}$XY if it is invertible**



#### 一般的线性回归的特性:

- 通常是**没有很好的泛化(generalization)能力**, 求出来的模型一般拥有低Bias 和高方差





