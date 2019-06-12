## Intro to regression

- 回归是常见的**监督学习**的算法

一般**回归的问题描述**:

给定一个假定映射方程(a hypothesis set) *H*集合 可以完成 输入变量 *X* 到 *Y*  的映射. 回归问题就是用labelled sample *S*(有标签数据的集合) S = {(x$_1$, y$_1$), ..., (x$_m$, y$_m$)} $\in$ (*X*, *Y*) . 找到一个 h $\in$ *H* 有期望的最小损失值(Small expected loss) 或者小的泛化误差 Generalization error.

一般的loss方程为 : R(h) = $\frac{1}{m}\sum_{i=1}^{m}L(h(x_i, y_i))$ , 这里的L又一般是的取 square error

