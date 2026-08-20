// ============================================================
// FIX VERSION: Follows your top-down recursive DP approach
// ============================================================

class fixSolution {
    func minPathSum(_ grid: [[Int]]) -> Int {
        if grid.isEmpty || grid[0].isEmpty {
            return 0
        }

        let rowCount = grid.count
        let columnCount = grid[0].count

        // -1 means this cell has not been calculated yet.
        var dp = Array(
            repeating: Array(repeating: -1, count: columnCount),
            count: rowCount
        )

        // Base case: the path starts at grid[0][0].
        dp[0][0] = grid[0][0]

        helper(
            grid,
            rowCount - 1,
            columnCount - 1,
            &dp
        )

        return dp[rowCount - 1][columnCount - 1]
    }

    // Contract:
    // After helper(row, column) returns for a valid cell,
    // dp[row][column] contains the minimum path sum from
    // grid[0][0] to grid[row][column].
    func helper(
        _ grid: [[Int]],
        _ row: Int,
        _ column: Int,
        _ dp: inout [[Int]]
    ) {
        // This position is outside the grid.
        if row < 0 || column < 0 {
            return
        }

        // This cell was already calculated.
        if dp[row][column] != -1 {
            return
        }

        // Calculate the cells that can lead to this cell.
        helper(grid, row - 1, column, &dp)
        helper(grid, row, column - 1, &dp)

        let previousSum: Int

        if row == 0 {
            // First row: we can only arrive from the left.
            previousSum = dp[row][column - 1]
        } else if column == 0 {
            // First column: we can only arrive from above.
            previousSum = dp[row - 1][column]
        } else {
            // Other cells can be reached from above or from the left.
            previousSum = min(
                dp[row - 1][column],
                dp[row][column - 1]
            )
        }

        dp[row][column] = previousSum + grid[row][column]
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Bottom-up DP using only one row of extra storage.
// ============================================================

class Solution {
    func minPathSum(_ grid: [[Int]]) -> Int {
        if grid.isEmpty || grid[0].isEmpty {
            return 0
        }

        let rowCount = grid.count
        let columnCount = grid[0].count

        // dp[column] stores the minimum path sum for the current cell
        // in this column.
        var dp = Array(repeating: Int.max, count: columnCount)

        // Allows the first cell to become 0 + grid[0][0].
        dp[0] = 0

        for row in 0..<rowCount {
            for column in 0..<columnCount {
                if column == 0 {
                    // First column can only come from above.
                    dp[column] += grid[row][column]
                } else {
                    // Before the update:
                    // dp[column]     = value from above
                    // dp[column - 1] = updated value from the left
                    dp[column] = min(
                        dp[column],
                        dp[column - 1]
                    ) + grid[row][column]
                }
            }
        }

        return dp[columnCount - 1]
    }
}

// ============================================================
// YOUR ORIGINAL CODE AND THINKING COMMENTS
// ============================================================

/*
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
// Card shape: dp issue,
//             dp[i][j] = min(dp[i-1][j], dp[i][j-1]) + nums[i][j]
// State needed: dp array
// Contract: for dp issue what should I write in here
// Recall: landed

// starting writing at 8

// finish writing in 20 mins
// quick check realize I didn't do recursive call helper
// now update
// should work
// tc: visit every node so should be O(m*n)
// create a dp array sc also O(m*n)
// run crash
// should consider the case row 0, or col 0 cases
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
YOUR MAIN DP IDEA WAS CORRECT:

Define:

    dp[row][column]

as the minimum path sum from the top-left cell to that cell.

Because movement is allowed only right or down, a cell can be reached
only from:

    the cell above: dp[row - 1][column]
    the cell left:  dp[row][column - 1]

Therefore:

    dp[row][column] =
        min(dp[row - 1][column], dp[row][column - 1])
        + grid[row][column]


THIS IS DP, NOT BACKTRACKING:

Backtracking normally:

1. Makes a choice.
2. Recursively explores it.
3. Undoes the choice.
4. Tries another choice.

Your solution does not undo changes.

Instead, it calculates each subproblem once and stores the result in dp.
That is top-down dynamic programming with memoization.


YOUR HELPER CONTRACT:

A stronger contract is:

    After helper(row, column) returns for a valid cell,
    dp[row][column] contains the minimum path sum from
    grid[0][0] to grid[row][column].

That contract explains why the function first calls:

    helper(row - 1, column)
    helper(row, column - 1)

It needs those smaller answers before calculating the current answer.


BOUNDARY CASES:

For the first row:

    dp[0][column] = dp[0][column - 1] + grid[0][column]

There is no cell above it.

For the first column:

    dp[row][0] = dp[row - 1][0] + grid[row][0]

There is no cell to its left.

For the first cell:

    dp[0][0] = grid[0][0]


WHY YOUR ORIGINAL CODE SHOULD OTHERWISE WORK:

Your original base value:

    dp[0][0] = grid[0][0]

causes helper(0, 0) to return before trying to access a negative index.

Your first-row and first-column checks also choose the only valid
previous cell.

The empty-grid guard is defensive; LeetCode's normal constraints provide
a non-empty grid.


WHY -1 WORKS AS A SENTINEL:

The problem's grid values are nonnegative, so a real minimum path sum
cannot be -1.

Therefore:

    dp[row][column] == -1

safely means "not calculated."


UPGRADE EXAMPLE:

Grid:

    1 3 1
    1 5 1
    4 2 1

Start:

    dp = [0, max, max]

After row 0:

    dp = [1, 4, 5]

After row 1:

    dp = [2, 7, 6]

After row 2:

    dp = [6, 8, 7]

Answer:

    7


UPGRADE LOOP CONTRACT:

Before updating dp[column]:

    dp[column] is the minimum path sum from the cell above.

After updating dp[column - 1]:

    dp[column - 1] is the minimum path sum from the cell to the left.

Therefore:

    min(dp[column], dp[column - 1])

selects the better previous path.


COMPLEXITY:

Top-down fix:

    Time:  O(m * n)
    Space: O(m * n) for dp
           plus O(m + n) recursion depth

Bottom-up upgrade:

    Time:  O(m * n)
    Space: O(n)

where n is the number of columns.
*/