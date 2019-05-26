## Pandas & Numpy



## Pandas

###1. Pandas 数据类型

* Dataframe

  ~~~python
  d = pd.Dataframe(np.random.randn(6, 4), index = [], columns = list('abcd'))
  # 创建一个6 *4 的Dataframe类型数据
  # index(行名), columns(列名) 默认为从0开始递增的integer
  # 当然可以通过传参进行定义
  ~~~

* Series

  ~~~python
  s = pd.Series([1,2,3,np.nan,'ad'])
  
  # Series数据格式没有列名, 可以看为多数据类型的list(数组)
  
  >> 
  0      1
  1      2
  2    NaN
  3      3
  4      a
  ~~~


###2. 利用Pandas 读取csv数据, 默认返回DataFrame的数据类型

```python

datas = pd.read_csv('url')

# datas 的列index称即为 csv数据的一行 
# datas 的行index为0,1.. 以此递增

```



### 3. 查看数据的属性

* pandas 数据的**类型**

  ~~~python
  # 返回类型为Series
  print(data.dtypes)
  
  >>
  Id                 int64
  MSSubClass         int64
  MSZoning          object
  LotFrontage      float64
  LotArea            int64
  Street            object
  Alley             object
  ...
  ~~~

  注意

  *  整型 : **默认 int64, 也有int32 .. ** 
  *  小数 : **默认 float64 **
  *  对象(object) : 一般值得就是str类型的





  Tips : **查看dataframs中所有数字类型的列的索引**

  ~~~python
  numeric_feats = all_data.dtypes[all_data.dtypes != 'object']
  
  >> # 此时numeric_feats还是一个Series形式
  GarageArea         int64
  WoodDeckSF         int64
  OpenPorchSF        int64
  EnclosedPorch      int64
  3SsnPorch          int64
  ScreenPorch        int64
  PoolArea           int64
  MiscVal            int64
  MoSold             int64
  YrSold             int64
  SalePrice          int64
  
  # 提取Series的行索引
  numeric_feats = numeric_feats.index
  ~~~







* pandas **Dataframe的数据属性** : 

    ~~~python
    # 返回数据的维度
    print(all_data.shape)

    # 返回数据集前几行(尾)的数据 (默认为前5行)
    print(all_data.head())
    print(all_data.tail())

    # 返回数据集的一些数学特征
    print(all_data.describe())

    ~~~



### 4. 数据行, 列操作

* 删除一行, 列

  * 直接以索引删除

  ~~~python
  # axis = 1 means drop the col (0 means the row)
  # inplace means the new_data replace the old one
  all_data.drop('Name', axis=1, inplace=True)
  ~~~

  * 按筛选条件删除

    删除数据集中 GrLivArea > 4000 且 SalePrice<300000 的点

  ~~~python
  # Deleting outliers
  train = train.drop(train[(train['GrLivArea']>4000) & (train['SalePrice']<300000)].index)
  ~~~

### 5. 画图

* 和matplotlib配合画直方图

  **数据类型是Series 或者 Dataframe 都可以直接画图**

  * Series : 

    ~~~python
    # 随机生成1000个数据
    data = pd.Series(np.random.randn(1000), index=np.arrange(1000))
    
    # 直接观看可视化的形式
    data.plot()
    
    # 显示图片
    plt.show()
    ~~~

    一般来说, 用plot()画图需要给 plt.plot(x=, y=) 传入等维数据才能画图

    而, data本身就是这样一个二维的数据, 所以可以直接调用 plot()方法

  * Dataframe:

    ~~~python
    data = pd.DataFrame(
        # 1000 * 4 的二维随机数矩阵
    	np.random.randn(1000, 4),
    	# 规定行的索引(也可以不写)
        index = np.arrange(1000)
    	# 规定列的索引
        columns = list("ABCD")
    )
    
    # 后一项为前一项的叠加
    data.cumsum()
    
    # 画图
    data.plot
    
    # 出图
    plt.show()
    
    ~~~


### 5. 数据元素操作

* apply 函数











## numpy

* 关于数据的创建

  ~~~python
  # 创建一个 4*1 的 (0, 1) 的随机矩阵
  data = np.random.random(4)
  
  # 创建一个 6*4 的 (-1, 1) 的随机数矩阵
  data = np.random.randn(6, 4)
  
  
  ~~~
