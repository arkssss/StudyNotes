# HDFS 设计原理

[TOC]



## 一、介绍

**HDFS** （**Hadoop Distributed File System**）是Hadoop下的分布式文件系统，具有高容错、高吞吐量等特性，可以部署在低成本的硬件上

![img](https://github.com/heibaiying/BigData-Notes/raw/master/pictures/hdfsarchitecture.png)



## 二. HDFS 设计原理



### 2.1 HDFS 架构

HDFS 遵循 **主/从架构**，由单个NameNode(NN)和多个DataNode(DN)组成：

- **NameNode** : 负责执行有关`文件系统命名空间`的操作，例如打开，关闭、重命名文件和目录等。它同时还负责集群元数据的存储，记录着文件中各个数据块的位置信息。
- **DataNode**：负责提供来自文件系统客户端的 **读写请求**，执行块的创建，删除等操作。





### 2.2 文件系统命名空间







### 2.3 数据容错机制

HDFS 提供一定的 数据容错机制 :

* HDFS 将每一个文件存储为一系列**块**
* 每个块由 **多个副本** 来保证容错

文件的块的大小 和 副本的复制因子 可以自己设定, 默认为:

块 : 128 M , 复制因子 : 3



### 2.4 架构的稳定性



#### 确定设备的存在性

**心跳机制和重新复制机制: **

**每个DataNode定期向NameNode发送心跳消息**，如果超过指定时间没有收到心跳消息，则将DataNode标记为死亡, 当一个 DataNode 被标记为死亡的时候, NameNode 采取以下的措施 : 

1. NameNode不会将任何新的IO请求转发给标记为死亡的DataNode，
2. 也不会再使用这些DataNode上的数据。 

由于数据不再可用，可能会导致某些块的复制因子小于其指定值，NameNode会跟踪这些块，并在必要的时候进行重新复制



#### 保证数据的完整性

通过 `检验和` 来检测 DataNode 上面的数据有没有损坏















































