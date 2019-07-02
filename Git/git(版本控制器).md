## git(版本控制器)

###1.概念

####可以管理什么格式的文件

* 文本文件 (.txt) 等
* 脚本文件 (.py) 等
* 各种基于文本信息的文件

#### 不能管理什么格式的文件

* 图片(.jpg) 等
* MS word (.doc) 等



### 创建一个git仓库

* Step 1: 创建一个文件夹
* Step 2: 利用bash进入该文件夹

先配置全局的用户信息(用于标示日后提交的author记录)

**注意这个是全局有效的, 不只局限于这个仓库**

~~~shell
$git config --global user.name ark
$git config --global user.email 522500442@qq.com
~~~

* Step 3: git仓库初始化

  此时, 在target_dir_name的文件夹下便创建了一个git仓库

~~~shell
target_dir_name $git init
~~~

* Step 4: 创建文件并加入版本库

~~~shell
//在本文件下添加的文件, 默认是没有加入这个代码仓库的, 处于unstaged状态
$touch demo1.py
target_dit_name $git add demo1.py
//一次性添加所有未存储文件
$git add .
~~~

* Step 5: 开始这个仓库的使用 每一次提交都是一个版本

~~~shell
//提交这一次的修改, 然后用description描述
$git commit -m "description"
~~~







### git相关状态

![status](status.png)

* 修改 & 添加文件 操作都会使文件进入Modified 状态, 而此状态是不能进行commit操作

* 从Modified & Untracked -> staged 使用 git add file_name(保存单个文件的改变) & git add . (保存所有改变的文件)
* 只有在staged 状态下才能进行commit 操作!



### git命令

* git log (显示所有的提交(commit)信息)

* git status (显示当前仓库的文件状态(在Modified & staged & untracked 状态下的文件))

* git diff (显示当前修改(Modified状态下)和最近一次commit的不同之处)

  ​	--cached(显示当前staged状态下) 和最近一次的commit的不同之处



### Gitignore 文件失效

.gitignore 只能忽略**不是staged态**的文件, 即untrack的文件

解决办法:

~~~shell
// 先删除 cached态文件
$git rm -r --cached .

// 重新add
$git add .
~~~









