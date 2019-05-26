##  TensorFlow

* tf.Session()
* tf.placeholder()





TensorFlow 使用 numpy 阵列来表示张量值 !!



* 构建图 tf.graph()

~~~python
a = tf.constant(3.0, dtype=tf.float32)
b = tf.constant(4.0) # also tf.float32 implicitly
total = a + b
~~~

这些 [`tf.Tensor`](https://www.tensorflow.org/api_docs/python/tf/Tensor)对象仅代表将要运行的操作的结果, 并不是真实的值。

* 打印之后 

~~~python
Tensor("Const:0", shape=(), dtype=float32)
Tensor("Const_1:0", shape=(), dtype=float32)
Tensor("add:0", shape=(), dtype=float32)
~~~



* 画计算图

  ~~~python
  # begin session
  sess = tf.seesion()
  
  #第一个参数为保存文件的目录 dir
  writer = tf.summary.FileWriter('logs/', sess.graph)
  
  # 在命令行使用 (或者之间利用 python使用command line)
  os.system("tensorboard --logdir=logs")
  
  #至此便可以画出一个计算图
  ~~~





如果说 [`tf.Graph`](https://www.tensorflow.org/api_docs/python/tf/Graph) 像一个 `.py` 文件，那么 [`tf.Session`](https://www.tensorflow.org/api_docs/python/tf/Session) 就像一个 `python` 可执行对象。

当您使用 `Session.run` 请求输出节点时，TensorFlow 会回溯整个图，并流经提供了所请求的输出节点对应的输入值的所有节点。因此此指令会打印预期的值 7.0：

**也就是说, 每一次Session.run()**





目前来讲，这个图不是特别有趣，因为它总是生成一个常量结果。图可以参数化以便接受外部输入，也称为**占位符**。**占位符**表示承诺在稍后提供值，它就像函数参数。

~~~python
x = tf.placeholder(tf.float32)
y = tf.placeholder(tf.float32)
z = x + y
~~~

也就是说, 先定义再复制









