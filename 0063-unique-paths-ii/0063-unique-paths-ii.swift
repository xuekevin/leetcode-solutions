/*
YOUR ORIGINAL SOLUTION:

class Solution {
    var dp = [[Int]]()

    func uniquePathsWithObstacles(_ obstacleGrid: [[Int]]) -> Int {
        let m = obstacleGrid.count
        let n = obstacleGrid[0].count
        let rowArr = Array(repeating: -1, count: obstacleGrid.count)
        dp = Array(repeating: rowArr, count: obstacleGrid[0].count)

        for i in 0..<m {
            dp[i][0] = 1
        }

        for j in 0..<n {
            dp[0][j] = 1
        }

        return helper(obstacleGrid, m - 1, n - 1)
    }

    func helper(
        _ obstacleGrid: [[Int]],
        _ x: Int,
        _ y: Int
    ) -> Int {
        if obstacleGrid[x][y] == 1 {
            dp[x][y] = 0
            return 0
        }

        if dp[x][y] != -1 {
            return dp[x][y]
        }

        dp[x][y] =
            helper(obstacleGrid, x - 1, y) +
            helper(obstacleGrid, x, y - 1)

        return dp[x][y]
    }
}

// Thinking
// dp issue first thought
// need to figure out the defination for this dp
// func dp(_ obstacleGrid: [[Int], _ x: Int, _ y: Int) -> Int
// dp [i][j] is the path count to i,j
// so since can only move eith down or right
// can get the row = 0, col = 0 's dp
// one more condition, is grid[i][j] == 1, then dp[i][j] should be 0,
// means there is no way can get dp[][]

// 5 mins so far

// ready to write
// Pattern: DP
// Card shape: func dp(_ obstacleGrid: [[Int], _ x: Int, _ y: Int) -> Int
// State needed: dp array, also think to create a memory array,
// which I will get later
// Contract: can get path count to get [i][j]
// Recall: half (not quite sure how to write memory)

// 21 mins finish writing
// quick check. lgtm
// ready to run, fix some basic synatx error
// ready to sumbit, oops got crash
// will let gpt fix
*/


// FIX VERSION: preserves your top-down DP idea.

class fixSolution {
    var dp = [[Int]]()

    func uniquePathsWithObstacles(
        _ obstacleGrid: [[Int]]
    ) -> Int {
        let m = obstacleGrid.count
        let n = obstacleGrid[0].count

        // Wrong:
        // Each row had `m` elements and there were `n` rows.
        //
        // Correct:
        // A grid with m rows and n columns needs:
        // Array(repeating: [n columns], count: m rows)
        let row = Array(repeating: -1, count: n)
        dp = Array(repeating: row, count: m)

        return helper(obstacleGrid, m - 1, n - 1)
    }

    func helper(
        _ obstacleGrid: [[Int]],
        _ row: Int,
        _ column: Int
    ) -> Int {
        // Wrong:
        // The original code accessed obstacleGrid[row][column]
        // before checking whether either index was negative.
        //
        // Example:
        // helper(grid, 0, 1) eventually calls helper(grid, -1, 1).
        // Accessing grid[-1][1] crashes.
        if row < 0 || column < 0 {
            return 0
        }

        // An obstacle contributes zero paths.
        if obstacleGrid[row][column] == 1 {
            return 0
        }

        // The unobstructed starting cell has exactly one path:
        // start there without making any moves.
        if row == 0 && column == 0 {
            return 1
        }

        // Return the saved answer when already calculated.
        if dp[row][column] != -1 {
            return dp[row][column]
        }

        // Good: your recurrence was correct.
        //
        // A cell can only be reached from:
        // 1. the cell above it
        // 2. the cell to its left
        let fromAbove = helper(
            obstacleGrid,
            row - 1,
            column
        )
        let fromLeft = helper(
            obstacleGrid,
            row,
            column - 1
        )

        dp[row][column] = fromAbove + fromLeft
        return dp[row][column]
    }
}


// GPT'S UPGRADE VERSION:
// Bottom-up DP with only one row of memory.

class Solution {
    func uniquePathsWithObstacles(
        _ obstacleGrid: [[Int]]
    ) -> Int {
        let rows = obstacleGrid.count
        let columns = obstacleGrid[0].count

        // dp[column] is the number of paths to the current cell
        // in this column.
        var dp = Array(repeating: 0, count: columns)

        // There is initially one way to stand at the starting position.
        dp[0] = 1

        for row in 0..<rows {
            for column in 0..<columns {
                if obstacleGrid[row][column] == 1 {
                    // An obstacle cannot be reached.
                    dp[column] = 0
                } else if column > 0 {
                    // Before updating:
                    // dp[column]     = paths from above
                    // dp[column - 1] = paths from the left
                    dp[column] += dp[column - 1]
                }
            }
        }

        return dp[columns - 1]
    }
}


/*
GPT'S SUMMARY

What you did well:
- Your DP definition was correct:
  dp[row][column] represents the number of paths to that cell.
- Your recurrence was correct:
  dp[row][column] = paths from above + paths from the left.
- You correctly understood that an obstacle contributes zero paths.

Mistakes you made:

1. The DP dimensions were reversed.

   Wrong:
   let rowArr = Array(repeating: -1, count: obstacleGrid.count)
   dp = Array(repeating: rowArr, count: obstacleGrid[0].count)

   Correct:
   let rowArr = Array(repeating: -1, count: n)
   dp = Array(repeating: rowArr, count: m)

   `m` is the number of rows.
   `n` is the number of columns.

2. The recursion did not check its boundaries.

   Calling helper(row - 1, column) eventually produces row == -1.
   The original code then accessed obstacleGrid[-1][column], causing a crash.

3. Initializing the entire first row and column to 1 is incorrect when
   obstacles exist.

   Example:

       [0, 1, 0]

   The cell after the obstacle must have zero paths, not one path.

4. The starting cell is the real base case:

       if row == 0 && column == 0 {
           return 1
       }

   However, the obstacle check must happen first because the starting
   cell itself could contain an obstacle.

Why the upgrade version works:

For every cell:

    paths to current cell
    = paths from above + paths from left

A one-dimensional array is sufficient because:

    dp[column]     holds the previous row's value, meaning "above"
    dp[column - 1] holds the updated current-row value, meaning "left"

When an obstacle is encountered, dp[column] becomes zero. This also
prevents later cells from receiving paths through that obstacle.

Complexity:

Fix version:
- Time: O(m * n), because each state is calculated once.
- Space: O(m * n) for DP, plus O(m + n) recursion depth.

Upgrade version:
- Time: O(m * n).
- Space: O(n), where n is the number of columns.
*/