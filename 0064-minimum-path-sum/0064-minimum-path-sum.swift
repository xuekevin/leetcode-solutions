class Solution {
    

    func minPathSum(_ grid: [[Int]]) -> Int {
        let m = grid.count
        let n = grid[0].count
        let colArr = Array(repeating: -1, count: n)
        var dp: [[Int]] = Array(repeating: colArr, count: m)
        dp[0][0] = grid[0][0]


        helper(grid, m-1, n-1, &dp)
        return dp[m-1][n-1]
    }

    func helper(_ grid: [[Int]], _ x: Int, _ y: Int, _ dp: inout [[Int]]) {
        if x < 0 || y < 0 {
            return
        }

        if dp[x][y] != -1 {
            return
        }

        helper(grid, x-1, y, &dp)
        helper(grid, x, y-1, &dp)

        var preSum = 0

        if x - 1 < 0 {
            preSum = dp[x][y-1]
        } else if y - 1 < 0 {
            preSum = dp[x-1][y]
        } else {
            preSum = min(dp[x-1][y], dp[x][y-1]) 
        }

        dp[x][y] = preSum + grid[x][y]
    }
}

// Thinking
// first thought 
// kind like backtracking
// make a choice the get an answer
// the unmake the choice to go another choice
// or can I consider dp issue?
// try to define dp
// dp: the current minisum to nums[i][j]
// dp[0][0] = nums[0][0]
// dp[0][1] = dp[0][0] + nums[0][1]
// ....
// dp[1][1] = min(dp[0][1] + nums[1][1], dp[1][0] + nums[1][1])

// Pattern: Backtracking? dp?, decide to use dp 
// Card shape: dp issue, dp[i][j] = min(dp[i-1][j], dp[i][j-1]) + nums[i][j]
// State needed: dp array
// Contract:  for dp issue what should I write in here
// Recall:        landed 

// starting writing at 8

// finish writing in 20 mins
// quick check realize I didn't do recursive call helper 
// now update
// should work
// tc: visit every node so should be O(m*n)
// create a dp array sc also O(m*n) 
// run crash
// should consider the case row 0, or col 0 cases 

