# Git 版本控制器
[TOC]

# 1I.概念

**可以管理什么格式的文件**

* 文本文件 (.txt) 等
* 脚本文件 (.py) 等
* 各种基于文本信息的文件



**不能管理什么格式的文件**

* 图片(.jpg) 等
* MS word (.doc) 等



**git相关状态**

![status](/Users/ark/%E6%96%87%E6%A1%A3%E7%AC%94%E8%AE%B0/%E5%90%8E%E7%AB%AF%E6%8A%80%E6%9C%AF%E6%96%87%E6%A1%A3%E7%AC%94%E8%AE%B0/Git/status.png)

- 修改 & 添加文件 操作都会使文件进入Modified 状态, 而此状态是不能进行commit操作
- 从Modified & Untracked -> staged 使用 git add file_name(保存单个文件的改变) & git add . (保存所有改变的文件)
- 只有在staged 状态下才能进行commit 操作!



# II. 相关命令



## 1. 创建一个git仓库

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
# 在本文件下添加的文件, 默认是没有加入这个代码仓库的, 处于unstaged状态
$touch demo1.py
target_dit_name $git add demo1.py
# 一次性添加所有未存储文件
$git add .
~~~

* Step 5: 开始这个仓库的使用 每一次提交都是一个版本

~~~shell
# 提交这一次的修改, 然后用description描述
$git commit -m "description"
~~~



## 2. 新建分支

~~~shell
# 将当前分支却换到我们的主分支 master, 其他的均为衍生分支
$git checkout master

# 表示根据 master 克隆一个新分支 dev
# -b 即为新增分支的意思
$git checkout -b dev
~~~



## 3. 删除分支

~~~shell
# 删除 test 分支
# 注意在删除的时候, 要先将分支切换到其他
$git branch -d test
~~~



## 4. 抛弃此次修改

~~~shell
# 此次修改后, 想撤销此次的所有修改

# 先 add
$git add -A

# 再撤销
# 回到最近 commit 的内容
$git checkout -f
~~~



## 5. 删除 Git 仓库

要删除 git 仓库, 只需要删除项目目录下的 `.git/`下的所有文件即可

~~~shell
$rm -rf .git/
~~~














# III. 问题与解决
## 1. gitignore 文件失效

.gitignore 只能忽略**不是staged态**的文件, 即untrack的文件

解决办法:

~~~shell
// 先删除 cached态文件
$git rm -r --cached .

// 重新add
$git add .
~~~



## 2. 分支文件可见性问题

假设此时有两个分支

~~~
- master
- dev
~~~

我们在 dev 分支下改变的文件(**修改, 新增, 删除**) 在没有 commit 的情况下, 此时其实是对所有的分支可见的.

for example  :

~~~
# in branch dev
新增文件 hello.py

# switch to master 
此时也可以看到 hello.py 文件
~~~

而各个分支互不影响的意思是, **在某一分支下进行 commit 操作后, 那么此次改变对其他的分支变为不可见**

for exmple :

~~~
# in branch dev
新增文件 hello.py
add && commit hello.py

# switch to master
此时便看不到 hello.py 文件
~~~



## 3. git checkout 报错 : (error: pathspec 'master' did not match any file(s) known to ）

> [CSND](http://www.itboth.com/d/NjMvYz/error-git-file)

主要原因是在 `Master`分支还没有任何提交的情况下, 便切换到了其他分支并提交, 此时再切回到`master` 分支. 便会报此 erro

解决方法 :

**在切换到其他分支的时候, 先给 master 分支提交一些文件**



## 4. 修改以往提交的 Author 和 Emial

如下脚本, 可以修改之前所有 `old_email` 到新的 `author` 和 `emial`

~~~shell
#!/bin/sh
git filter-branch --env-filter '
OLD_EMAIL="vagrant@homestead"
CORRECT_NAME="arkssss"
CORRECT_EMAIL="522500442@qq.com"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
~~~

























