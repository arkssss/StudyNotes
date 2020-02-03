# 动态规划题目整理

[TOC]

# 一. 背包问题

背包问题可以归结为 以下三总形式

- 01 背包问题 : 每个物品只有或者不选两种形式
- 完全背包问题 : 每个物品可以选择无限多次
- 多重背包问题 : 每个物品的选择有次数的限制
- 混合背包问题
- 二维费用问题
- 分组背包问题
- 背包问题求方案数
- 最优物品选择方案
- 有依赖的背包物品 : 选的物品有相互间的依赖



## 0-1背包

```
有 N 件物品和一个容量是 V 的背包。每件物品只能使用一次。

第 i 件物品的体积是 vi，价值是 wi。

求解将哪些物品装入背包，可使这些物品的总体积不超过背包容量，且总价值最大。
输出最大价值。

e.g.
4 5
1 2
2 4
3 4
4 5

out:
8
```



## 原始解法, 二维数组表示

**定义表达式 :**

`d[i][j]` 表示在前 `i` 个物品, 背包剩余 `j kg` 容量下的 : 最大价值.

然后二层的循环下, 每一层都算出 一个 `i` 的 `0-v` 种情况并对数组进行赋值

从而对于我们的结果来说, `res = max(d[n][0~v])` ; 即最后的结果是这个一维数组的最大值



**分析状态转移 :**

对于状态 `d[i][j]` 我们计算方法无非有以下两种情况:

1. 选取 第 `i` 个物品 : `d[i][j] = d[i-1][j - vi] + wi`
2. 不选取 第 `i` 个物品 :  `d[i][j] = d[i-1][j]`



**初始化分析 :**

当 `i=0` 的时候 `d[0][0-v] = 0` 



```c++
#include <iostream>
#include <algorithm>

using namespace std;
const int N = 1010;
int d[N][N];

// 重量数组
int v[N];
// 价值数组
int w[N];
int main (){
    int n,m;
    cin >> n >> m;
    
    for(int i=1; i<=n ;i++) cin >> v[i] >> w[i];
    
    for(int i=1; i<=n ;i++)
        for(int j=0; j<=m;j++){
            
            // 不选的情况
            d[i][j] = d[i-1][j];
            
            if(j>= v[i]){
                // 可以有选择的可能
                d[i][j] = max(d[i][j], d[i-1][j-v[i]] + w[i]);
            }
        }
        
    int res = 0;
    // 获得结果
    for(int i=0; i<= m;i++) res = max(res, d[n][i]);
    cout << res;   
}
```







# 二. 零钱兑换

> [零钱兑换](https://leetcode-cn.com/problems/coin-change/)

~~~
给定不同面额的硬币 coins 和一个总金额 amount。编写一个函数来计算可以凑成总金额所需的最少的硬币个数。如果没有任何一种硬币组合能组成总金额，返回 -1。

输入: coins = [1, 2, 5], amount = 11
输出: 3 
解释: 11 = 5 + 5 + 1

输入: coins = [2], amount = 3
输出: -1

你可以认为每种硬币的数量是无限的。
~~~

这一题可以看为 每个价值都相同的 `完全背包问题`

我们给出 **递推式子** 的形式 :

`F(S) 表示当总量为 S的时候, 所需要的最小的硬币总数`

从而我们的结果可以表示为 :

`res = F(amount)`

我们的 **递推关系式** 可以表现为 :

`F[S] = min(F[S - coins[0], F[S - coins[1]], ... , F[S - coins[len-1]]]) + 1`

也就是说, 当额剩为 S 的时候, 我们假设每个硬币都选取, 然后得出这样选取的话, 所需要的硬币最小值

**然后选出一个 最小的选法即可**

我们的初始关系为:

`F[0] = 0`

`F[amount < min_coin] = -1`  : 这种情况即不存在该选法, 赋值为 -1



**代码如下**

~~~c++
/*  
    F[S] 构成 S 的最少硬币数量
    e.g. F[11] = min(F[10], F[9], F[5]) + 1
    从而形成了重叠字结构的问题, 我们采用动态规划的思想
    
    递推公式 : 
    可以看到, 我们d的取值就是 假设 取 各个硬币的最小值
    F[d] = min(F[d-coins[0], F[d-conins[1], ... , F[d-coins[n-1]]]] + 1
    
    出口 : 
    从 F[0] 开始计算
    
    1. F[0] = 0
    
    // 说明 不存在这样的硬币
    2. F[S-conis[i]]  = 0 
    
*/
#include <algorithm>

class Solution {
public:
    int coinChange(vector<int>& coins, int amount) {
        // dp array
        vector<int> dp(amount+1);

        
        int len = coins.size();
        int min_coins = INT_MAX;
        int init_value = -1;
            
        // init 
        dp[0] = 0;
        
        for(int i = 0; i<len ;i++) {min_coins = min(coins[i], min_coins); }
        
        for(int i=1; i<=amount ;i++){
            if(i < min_coins){
                dp[i] = init_value;
            }else{
                dp[i] = INT_MAX;
                for(int j=0; j<len ;j++){
                    // 可以看到, 我们d的取值就是 假设 取 各个硬币的最小值
                    // F[d] = min(F[d-coins[0], F[d-conins[1], ... , F[d-coins[n-1]]]] + 1         
                    int this_coin = coins[j];
                    // 排除两种可能
                    if(this_coin > i) continue;
                    if(dp[i - this_coin] == -1) continue;
                    
                    // 最后的方案
                    dp[i] = min(dp[i], dp[i - this_coin]);
                }
                // 如果当前没有选法, 则命为 -1 ;
                if(dp[i] == INT_MAX) dp[i] = -1;
                else dp[i] ++;
            }
        }
    
        return dp[amount];        
    }

};
~~~







#  三. 最大上升子序列长度

[最长上升子序列](https://leetcode-cn.com/problems/longest-increasing-subsequence/)

~~~
给定一个无序的整数数组，找到其中最长上升子序列的长度。

示例:

输入: [10,9,2,5,3,7,101,18]
输出: 4 
解释: 最长的上升子序列是 [2,3,7,101]，它的长度是 4。
~~~



对于这题, 我们的 `dp` 的公式定义为 :

`dp[S] : 以 nums[S] 结尾的序列的最大上升子序列长度 `

从而, 我们的结果可以取为

`res = dp[0-N]` 

也就是说, 我们的结果, 是以 `0-N` 元素结尾的子序列长度最大值的 最大值

我们的递推关系如下 :

`dp[i] = max(dp[0~(i-1)])+1 subject to nums[i] > nums[0~i-1]` 

即我们的 `dp[i]` 依赖于之前的 `0~i-1` 个元素的 `dp` 值, 然后取一个小于该元素, 且长度最大的即可

否则 `dp[i] = 1` 

初始值为 :

`dp[0] = 1`



代码如下:

~~~c++
/*
    考虑 F[i] 表示到 nums[i] 为止的最大上升序列的长度
    
    递推式为 :
    F[i] = MAX(F[0-V]) subject to nums[i] > nums[0-V];
    否则 F[i] = 1
    
    初始条件为 :
    F[0] = 1
    
    最后的结果为 :
    res = F[len-1]
    
*/

#include<algorithm>

class Solution {
public:
    int lengthOfLIS(vector<int>& nums) {
        int len = nums.size();
        
        vector<int> dp(len);
        if(!len) return 0;
        // init
        dp[0] = 1;
        
        for(int i=1; i<len ;i++){
            int curtItem = nums[i];
            dp[i] = INT_MIN;
            for(int j=0; j<i; j++){
                int compItem = nums[j];
                if(compItem >= curtItem) continue;
                dp[i] = max(dp[i], dp[j]);
            }
            if(dp[i] == INT_MIN) dp[i] =1;
            else dp[i] ++;
        }
        
        int res = 0;
        for(int i=0; i<len;i++) res = max(res, dp[i]);
        return res;
        
        }
};
~~~



# 四. 最佳买股票时机 (含冷冻期)

[最佳买卖股票时机含冷冻期](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-with-cooldown/)

~~~
给定一个整数数组，其中第 i 个元素代表了第 i 天的股票价格 。

设计一个算法计算出最大利润。在满足以下约束条件下，你可以尽可能地完成更多的交易（多次买卖一支股票）:

你不能同时参与多笔交易（你必须在再次购买前出售掉之前的股票）。
卖出股票后，你无法在第二天买入股票 (即冷冻期为 1 天)。
示例:

输入: [1,2,3,0,2]
输出: 3 
解释: 对应的交易状态为: [买入, 卖出, 冷冻期, 买入, 卖出]
~~~



这个动态的题目, 要分为当前的 `五个状态`

定义 : `dp[i][1-5]` 为 第 i 天的最大利润, `1-5` 代表此时 的 `五个状态`

    * 1代表当前状态为买入时候的最大值
    * 2代表当前为冷冻状态下的最大值
    * 3代表当前为卖出的最大值
    * 4代表当前为 买入后什么都不做的最大值
    * 5代表当前为 冻结后什么都不做的最大值
从而我们的结果可以表示为 , 这五个状态之间的最大值

`res = max(dp[len-1][1-5])`



我们可以整理出递推关系 :

~~~
// 买入
// 上一个冻结才能买, 上一个卖出后
d[i][1] = max(d[i-1][2] - prices[i], d[i-1][5] - prices[i])

// 冻结
// 上一个为卖出 这一个冻结
d[i][2] = dp[i-1][3]

// 卖出
// 上一个为买入, 或者买入后什么都不做
d[i][3] = max(d[i-1][1] + prices[i], d[i-1][4] + prices[i])

// 买入后什么都不做
// 上一个为买入, 或者也没买入后什么都不做
d[i][4] = max(d[i-1][1], d[i-1][4])

// 冻结后什么都不做
// 上一个为冻结, 或者冻结够什么都不做
d[i][5] = max(d[i-1][2], d[i-1][5])
~~~





代码如下:

~~~c++
/*
    动态规划
    定义 : dp[i][1-4] 为 第 i 天的最大利润, 1-4 代表此时
    
    dp[i][1-4] 
    * 1代表当前状态为买入时候的最大值
    * 2代表当前为冷冻状态下的最大值
    * 3代表当前为卖出的最大值
    * 4代表当前为 买入后什么都不做的最大值
    * 5代表当前为 冻结后什么都不做的最大值
    
    
    // 买入
    // 上一个冻结才能买, 上一个卖出后
    d[i][1] = max(d[i-1][2] - prices[i], d[i-1][5] - prices[i])
    
    // 冻结
    // 上一个为卖出 这一个冻结
    d[i][2] = dp[i-1][3]
    
    // 卖出
    // 上一个为买入, 或者买入后什么都不做
    d[i][3] = max(d[i-1][1] + prices[i], d[i-1][4] + prices[i])
    
    // 买入后什么都不做
    // 上一个为买入, 或者也没买入后什么都不做
    d[i][4] = max(d[i-1][1], d[i-1][4])
    
    // 冻结后什么都不做
    // 上一个为冻结, 或者冻结够什么都不做
    d[i][5] = max(d[i-1][2], d[i-1][5])
    
    
    // 结果 
    res = d[len-1][1-5]
    
    // init
    dp[0][1] = -valuse
    dp[0][5] = 0;
    
    
*/

#include<algorithm>

const int N = 1024*1024;
const int M = 6;
int dp[N][M];


class Solution {
public:
    int maxProfit(vector<int>& prices) {
        
        int len = prices.size();
        if(!len) return 0;
        
        
        // init
        dp[0][1] = -prices[0];
        dp[0][5] = 0;
        dp[0][2] = dp[0][3] = dp[0][4] = SHRT_MIN;
        
        // loop
        for(int i=1; i<len; i++){
            
            dp[i][1] = max(dp[i-1][2]-prices[i], dp[i-1][5]-prices[i]);
            dp[i][2] = dp[i-1][3];
            dp[i][3] = max(dp[i-1][1]+prices[i], dp[i-1][4]+prices[i]);
            dp[i][4] = max(dp[i-1][1], dp[i-1][4]);
            dp[i][5] = max(dp[i-1][2], dp[i-1][5]);
        }
        
        int pro = INT_MIN;
        for(int i=1; i<=5;i++) pro = max(pro, dp[len-1][i]);
        
        return pro;
    }
};

~~~







# 四. 不同路径 (美团) (二维动态规划)

[LeetCode 62](https://leetcode-cn.com/problems/unique-paths)

~~~
一个机器人位于一个 m x n 网格的左上角 （起始点在下图中标记为“Start” ）。

机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为“Finish”）。

问总共有多少条不同的路径？
~~~

<img src='image/robot_maze.png'/>



~~~
例如，上图是一个7 x 3 的网格。有多少可能的路径？

说明：m 和 n 的值均不超过 100。

示例 1:

输入: m = 3, n = 2
输出: 3
解释:
从左上角开始，总共有 3 条路径可以到达右下角。
1. 向右 -> 向右 -> 向下
2. 向右 -> 向下 -> 向右
3. 向下 -> 向右 -> 向右
~~~

思路 : 

~~~c++
/*
    dp[i][j] = 到点 (i, j) 的路径个数
    
    // dp[i][j] = 
    // 如果 dp[i-1][j] 存在 one = dp[i-1][j];
    // 如果 dp[i][j+1] 存在 two = dp[i][j+1];
    // dp[i][j] = one + two
    
    // init
    dp[0][0] = 1;
    
    // return
    dp[len-1][len-1]
    */
class Solution {
public:
    int uniquePaths(int m, int n) {
        int dp[105][105];
        
        // init
        dp[0][0] = 1;
        
        for(int i=0; i<m; i++){
            for(int j=0; j<n; j++){
                if(!i && !j) continue;
                int one = 0;
                int two = 0;
                if(i) {one = dp[i-1][j];}
                if(j) {two = dp[i][j-1];}
                dp[i][j] = one + two;
            }
        }
        
        return dp[m-1][n-1];
    }
};
~~~





# 六. 不同路径II (美团) (二维动态规划)

[不同路径 II](https://leetcode-cn.com/problems/unique-paths-ii)

~~~
一个机器人位于一个 m x n 网格的左上角 （起始点在下图中标记为“Start” ）。

机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为“Finish”）。

现在考虑网格中有障碍物。那么从左上角到右下角将会有多少条不同的路径？
~~~

<img src='image/robot_maze.png'/>

~~~
网格中的障碍物和空位置分别用 1 和 0 来表示。

说明：m 和 n 的值均不超过 100。

示例 1:

输入:
[
  [0,0,0],
  [0,1,0],
  [0,0,0]
]
输出: 2
解释:
3x3 网格的正中间有一个障碍物。
从左上角到右下角一共有 2 条不同的路径：
1. 向右 -> 向右 -> 向下 -> 向下
2. 向下 -> 向下 -> 向右 -> 向右
~~~



~~~c++
/*
	和第一题一样的思路
	不同的是, 如果碰到了障碍
	dp[i][j] 置为0 即可
*/


class Solution {
public:
    int uniquePathsWithObstacles(vector<vector<int>>& obstacleGrid) {
        int row_num = obstacleGrid.size();
        if(!row_num) return 0;
        int col_num = obstacleGrid[0].size();
        if(!col_num) return 0;
        if(obstacleGrid[0][0] == 1) return 0;
        long dp[105][105];
        
        // init
        dp[0][0] = 1;
        
        // 迭代
        for(int i=0; i<row_num; i++){
            for(int j=0; j<col_num; j++){
                if(!i && !j) continue;
                if(obstacleGrid[i][j] == 1) {
                    dp[i][j] = 0;
                    continue;
                }
                long one = 0;
                long two = 0;
                if(i) one = dp[i-1][j];
                if(j) two = dp[i][j-1];
                dp[i][j] = one + two;
            }
        }
        return dp[row_num-1][col_num-1];
    }
};
~~~





# 七. 输出所有组合方式

> [组合总和](https://leetcode-cn.com/problems/combination-sum)

~~~
给定一个无重复元素的数组 candidates 和一个目标数 target ，找出 candidates 中所有可以使数字和为 target 的组合。

candidates 中的数字可以无限制重复被选取。

说明：

所有数字（包括 target）都是正整数。
解集不能包含重复的组合。 
示例 1:

输入: candidates = [2,3,6,7], target = 7,
所求解集为:
[
  [7],
  [2,2,3]
]
示例 2:

输入: candidates = [2,3,5], target = 8,
所求解集为:
[
  [2,2,2,2],
  [2,3,3],
  [3,5]
]

~~~



~~~c++
/*
    还是动态规划
    
    map<i, vector<vector<int> >> dp 表示 target 为 i 的时候, 可以包含的数组类型
        
	// 迭代式子
    dp[i] = 
        for(i : candidates){
            if(target - i >0){
                if(dp[target-i]) 不为空
                dp[i].add(every elm in dp[target-i]  + i)
            }
        }
    
    init :
    dp[0] = 空;
    
    结果 :
    dp[target]
    

*/
#include <map>
#include <algorithm>
class Solution {
public:
    vector<vector<int>> combinationSum(vector<int>& candidates, int target) {
        map<int, vector<vector<int>> > dp;
        int len = candidates.size();
        
        for(int curtTarget=1; curtTarget<=target; curtTarget++){
            
            vector<vector<int> > tmp2value;
            
            for(int i=0; i<len; i++){
                
                vector<int> tmp1value;
                
                int curtElem = candidates[i];
                
                if(curtTarget - curtElem  == 0){
                    tmp1value.push_back(curtElem);
                    tmp2value.push_back(tmp1value);
                    continue;
                }
                if(curtTarget - curtElem > 0){
                    if(dp.count(curtTarget - curtElem)){
                        // copy
                        int len2 = dp[curtTarget - curtElem].size();
                        for(int k=0; k<len2; k++){
                            vector<int> tmp;
                            tmp = dp[curtTarget - curtElem][k];
                            tmp.push_back(curtElem);
                            tmp2value.push_back(tmp);
                        }
                    }
                }
            }
            if(!tmp2value.empty()) dp[curtTarget] = tmp2value;
        }
        vector<vector<int>> ans;
        int finalSize = dp[target].size();
        for(int i=0; i<finalSize; i++){
            vector<int> tmp = dp[target][i];
            sort(tmp.begin(), tmp.end());
            if(find(ans.begin(), ans.end(), tmp) == ans.end()){
                ans.push_back(tmp);
            }
        }
        return ans;
        
        
    }
};
~~~







