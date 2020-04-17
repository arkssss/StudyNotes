<img src='image/redux-logo.png' width="300px"/>



> Redux = Reducer + Flux
>
> Redux 作为 React 生态的重要组成部分，是前端数据层框架，用于负责大型项目中各个组件之中的传值。在引入Redux之后便可以使用一个全局的数据层 Store, 给各个组件传值, 避免各个组件自身传值过于复杂。



<img src='image/redux-diff.png' width="500px"/>





# 安装

## 使用 `yarn` 

~~~shell
cd your-app

$yarn add redux
~~~



# 核心概念

## Redux 工作流程

<img src='image/redux-flow.png' width="500px"/>

* React Component 即为各个 React 组件
* Store 为全局公共数据存储池
* Action Creator 负责为组件的数据操作创建一个 `action` (动作)，用于描述组件需要什么数据
* Reducers 负责处理 `action` 对应的 数据处理更新，然后更新 `stroe` 中的对应数据



## Store 定义

Store 可以看作为整个 web 前端的数据库类似 `MySQL` 之于后台的存在，它一般被定义于 `\store\index.js` 中

且它可以给 View (React component) 端 和 Reducer 端提供借口

~~~javascript
// 公共存储仓库
import {createStore} from  'redux'
import reducer from './reducer'


/* 使用 createStore 函数创建一个 store */
const store = createStore(
    reducer,
    
    /* 插件相关 */
    window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
)

export default store;
~~~



## Reducer 定义

Reducer 可以看为后端逻辑中的 `controller` 层的存在，它可以接受 从 `React component` 中传递过来的 `action` 然后对 `action` 进行解析，最后更改当前 `store` 中的值

~~~javascript
// init 数据
const defaultState = {

    'inputValue' : '',

    'list' : [
        'Racing car sprays burning fuel into crowd.',
        'Japanese princess to wed commoner.',
        'Australian walks 100km after outback crash.',
        'Man charged over missing wedding girl.',
        'Los Angeles battles huge wildfires.',
    ]

}

// reducer 
export default (state = defaultState, action) => {

    // handle the input value change
    if(action.type === 'input_value_change'){
        // deep copy
        const newState = JSON.parse(JSON.stringify(state))

        // assign
        newState.inputValue = action.value

        return newState
    }

    if(action.type === 'button_click'){
        // deep copy
        const newState = JSON.parse(JSON.stringify(state))

        newState.list = [...newState.list, action.value]

        return newState 
    }

    return state;
}
~~~

主要的逻辑处理在中定义

~~~javascript
// 这里的 state 即为上一个状态下的数据状态 , action 即为 React component 传递过来的具体动作
/* 	
	action 一般包含两个字段
    {
    	type : 操作的类型由React component定义.
    	value: 状态的新值
    }
*/
export default (state = defaultState, action) => {
    
    // code ...
    
}
~~~

值得注意的是 `Reducer` 中不允许直接对上一个`state` 进行操作，因此需先对其 `deep copy` ，然后再返回相应的 `newState`.

~~~javascript
// deep copy
const newState = JSON.parse(JSON.stringify(state))

// assign
newState.inputValue = action.value

return newState
~~~

## React component 定义

`React component` 只能操作 `store`  而不能操作 `reducer`

### 通过 store 初始化 state

在 component 的构造函数中，可以对 state 进行初始化

~~~javascript
import store from './store/index'

class App extends Component{
  constructor(props){
    super(props)
    // init state
    this.state = store.getState()
  }
}
~~~





### 修改 store

React component 通过定义 `action` 向 store 使用 `dispatch` 函数修改 store。这里是利用 

`store.dispatch(action)` ，但是 `store` 并不直接接受这个 `action` 而是传递给 `reduce` 处理。

~~~javascript
import store from './store/index'

class App extends Component{
  constructor(props){
	// code ...
  }

  render(){
     // code ...
  }

   /* 以input 框输入事件举例 */
  inputHandleChange(e){
    /* 定义action */
    const action = {
      'type' : "input_value_change",
      'value': e.target.value
    }
    /* 分发action, store 提供的接口，但是处理者为 reducer */
    store.dispatch(action)
  }
}
~~~

### 通过 store 更新 state

React component 通过对 `store` 更新事件的 **订阅事件** 来对其自身的 state 进行更新

~~~javascript
import store from './store/index'

class App extends Component{
  constructor(props){
	// code ...
      
    this.handlerStoreChange = this.handlerStoreChange.bind(this)
    /* 当 store 更新时 ，自动执行这个订阅的函数 */
    store.subscribe(this.handlerStoreChange)
  }

  render(){
     // ...
  }
	
  /* 通过更新后的 store 来更新组件的 state */
  handlerStoreChange(){
    this.setState(
      store.getState()
    )
  }
}
~~~



### actionType 拆分

~~~javascript
/* 以input 框输入事件举例 */
inputHandleChange(e){
    /* 定义action */
    const action = {
        'type' : "input_value_change",
        'value': e.target.value
    }
    /* 分发action, store 提供的接口，但是处理者为 reducer */
    store.dispatch(action)
}

// 这样的 action.type 的方式会造成死数据，不利于维护.
~~~

抽离 actionType 

~~~javascript
/* actionType.js */

// 定义 ActionTypes 
export const INPUT_VALUE_CHANGE = "1"
export const BUTTON_CLICK = "2"
export const ITEM_CLICK = "3"
~~~



### actionCreator 拆分

同样我们讲 action 的定义抽离

~~~javascript
/* actionCreator.js */

// 文件统一创建 action
import {INPUT_VALUE_CHANGE, BUTTON_CLICK, ITEM_CLICK} from './actionTypes'


/* 框输入动作 */
export const inputHandleChangeAction = (value) => {
    return {
        'type' : INPUT_VALUE_CHANGE,
        'value': value
      }
}

/* 按钮点击动作 */
export const buttonHandlerClickAction = (value) => {
    return {
        'type' : BUTTON_CLICK,
        'value': value
    }
}

/* 按钮点击动作 */
export const itemHandlerClickAction = (value) => {
    return {
        'type' : ITEM_CLICK,
        'value': value
    }
}
~~~

在调用的时候，便可以直接

~~~javascript
import { inputHandleChangeAction } from './store/actionCreator'


/* input 框输入事件 */
inputHandleChange(e){

    const inputValue = e.target.value

    store.dispatch(inputHandleChangeAction(inputValue))

}
~~~

# 中间件

## 中间件定义

`redux` 中间件的定义在 `action` 和 `store` 中间, 是对 `dispathch` 方法的升级

<img src='image/redux-middleware.png' />





## Redux-thunk

> With a plain basic Redux store, you can only do simple synchronous updates by dispatching an action. Middleware extend the store's abilities, and let you write async logic that interacts with the store.
>
> [redux-thunx-github](<https://github.com/reduxjs/redux-thunk>)



### 安装

~~~shell
$yarn add redux-thunk
~~~



### 引入

项目只有一个中间件的时候，可以如下引入

~~~javascript
/* 引入 thunk 部分在 stroe 的创建文件中，即 store/index.js */

// 公共存储仓库, 全局唯一
/* applyMiddleware 可以使用中间件(redux-thunk) */
import {createStore, applyMiddleware} from  'redux'
import reducer from './reducer'
/* 使用 redux-thunk 中间件进行AJAX */
import thunk from 'redux-thunk'

const store = createStore(
    reducer,
    /* redux 中间件定义 */
    applyMiddleware(thunk)
)

export default store;
~~~

项目有多个中间件的时候，需要如下引入

~~~javascript
// 公共存储仓库, 全局唯一
/* applyMiddleware 可以使用中间件(redux-thunk) */
import {createStore, applyMiddleware, compose} from  'redux'
import reducer from './reducer'
/* 使用 redux-thunk 中间件进行AJAX */
import thunk from 'redux-thunk'

/* 
    这种写法让 redux 同时支持
    redux-devtools,
    thunk
    两个中间件
*/
const composeEnhancer = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__?
window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__({}) : compose

/* redux 中间件定义 */
const enhancer = composeEnhancer(
    applyMiddleware(thunk)
)

// window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
const store = createStore(
    reducer,
    enhancer
)

export default store;
~~~



### Redux-thunk 中间件 实现 AJAX

如果不使用 redux-thunk 那么我们的 actionCreator 只能返回一个对象

~~~javascript
/* 框输入动作 */
export const inputHandleChangeAction = (value) => {
    return {
        'type' : INPUT_VALUE_CHANGE,
        'value': value
      }
}
~~~

redux-thunk 可以使得我们的 actionCreator 返回一个函数, 从而在这个函数中进行一步 Ajax

~~~javascript
/* 不使用 redux-thunk 则action只能返回一个对象 */
/* redux-thunk 可以使得 action creator 返回一个函数 */
export const getTodoList = ()=>{
    return (dispatch)=>{
        axios.get('/api/getInit').then((res)=>{
            // success
            dispatch(todoListInitData(res.data))      
          }).catch(()=>{
            // error
            console.log('error')
          })
    }
}
~~~

调用，从而实现将 Ajax 操作封装到 `actionCreator` 中

~~~javascript
/* 组件挂载后 */
componentDidMount(){
    /* 利用 redux-thunk 返回一个异步 action */
    const action = getTodoList()
    
    store.dispatch(action)
}
~~~



















