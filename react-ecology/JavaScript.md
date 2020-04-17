

# JavaScript-basic

## 数组

### 数组基本操作

```javascript
// CRUD 
var arr = ['hello', 'world', 'React']


// ---------------------- 新增元素

// 写法1
arr.push('Java')

// 写法2 ...为扩展运算符
[...arr, 'Java']


// 删除元素
// index 为需要删除的元素的下标，1为删除一个
// 此时 arr 元素已经被删除而不是返回值
arr.splice(index, 1)
```



### 遍历数组

```javascript
arr = ['js', 'php', 'java']


arr.map((item, index) => {
    console.log(item)
})
```





