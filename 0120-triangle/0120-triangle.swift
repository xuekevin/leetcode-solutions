// ============================================================
// FIX VERSION: Follows your DFS choice-tree approach
// Correct, but may time out because it explores every path.
// ============================================================

class fixSolution {
    var minPathSum = Int.max

    func minimumTotal(_ triangle: [[Int]]) -> Int {
        if triangle.isEmpty {
            return 0
        }

        // Reset global state in case this instance is called again.
        minPathSum = Int.max

        helper(triangle, 0, 0, 0)

        return minPathSum
    }

    // Contract:
    // Explores every path beginning at triangle[level][index],
    // using pathSum as the sum before entering the current cell.
    func helper(
        _ triangle: [[Int]],
        _ level: Int,
        _ index: Int,
        _ pathSum: Int
    ) {
        let currentValue = triangle[level][index]
        let newPathSum = pathSum + currentValue

        // Reaching the final row completes one possible path.
        if level == triangle.count - 1 {
            minPathSum = min(minPathSum, newPathSum)
            return
        }

        // Choice 1: Move to the same index in the next row.
        helper(
            triangle,
            level + 1,
            index,
            newPathSum
        )

        // Choice 2: Move to index + 1 in the next row.
        helper(
            triangle,
            level + 1,
            index + 1,
            newPathSum
        )
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Recommended: bottom-up dynamic programming, O(n²).
// ============================================================

class Solution {
    func minimumTotal(_ triangle: [[Int]]) -> Int {
        guard let lastRow = triangle.last else {
            return 0
        }

        // Start with the minimum path sums for the final row.
        var dp = lastRow

        if triangle.count == 1 {
            return dp[0]
        }

        // Work upward from the second-to-last row.
        for level in stride(
            from: triangle.count - 2,
            through: 0,
            by: -1
        ) {
            for index in 0...level {
                // The current cell can move to:
                // dp[index] or dp[index + 1] in the row below.
                dp[index] = triangle[level][index]
                    + min(dp[index], dp[index + 1])
            }
        }

        return dp[0]
    }
}

// ============================================================
// YOUR ORIGINAL CODE AND THINKING COMMENTS
// ============================================================

/*
class Solution {
    var minPathSum = INT.max
    func minimumTotal(_ triangle: [[Int]]) -> Int {
        helper(triangle, 0, 0, 0)
        return maxPathSum
    }

    func helper(_ triangle: [[Int]], _ level: Int, _ index: Int, _ pathSum: Int) {
        let curArr = triangle[level]
        let curItem = curArr[index]
        let newPathSum =  pathSum + curItem

        if level == triangle.count - 1 {
            minPathSum = min(minPathSum, newPathSum)
            return
        }

        helper(triangle, 1, index, newPathSum)
        // should no overflow, since next level always has extra element compare with current
        helper(triangle, 1, index + 1, newPathSum)
    }
}

// Thinking
// Looks like a tree
// to get the minimum path, we need to go to the bottom
// so it is a DFS
// make the choice

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank

// finish in 11 mins
// quick check the code
// INT.max doesn't exist
// will let gpt fix
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
WHAT YOU GOT RIGHT:

1. The triangle can be viewed as a decision tree.
2. From triangle[level][index], there are exactly two choices:

       triangle[level + 1][index]
       triangle[level + 1][index + 1]

3. Reaching the final row completes a path.
4. The running path sum can be passed into recursive calls.


SWIFT MISTAKE 1:

Swift uses:

    Int.max

not:

    INT.max


NAMING MISTAKE:

You declared:

    var minPathSum = Int.max

but returned:

    return maxPathSum

`maxPathSum` does not exist.

Correct:

    return minPathSum


MAIN RECURSION MISTAKE:

You wrote:

    helper(triangle, 1, index, newPathSum)
    helper(triangle, 1, index + 1, newPathSum)

This always sends level 1.

For a triangle with more than two rows, recursion remains at level 1
and never reaches the bottom. It can continue until an index crashes or
the call stack overflows.

Correct:

    helper(triangle, level + 1, index, newPathSum)
    helper(triangle, level + 1, index + 1, newPathSum)


DFS EXAMPLE:

Triangle:

        2
       3 4
      6 5 7
     4 1 8 3

From 2:

    choose 3 or 4

From 3:

    choose 6 or 5

From 5:

    choose 1 or 8

One minimum path is:

    2 -> 3 -> 5 -> 1

Sum:

    11


WHY PLAIN DFS MAY TIME OUT:

Every non-leaf call creates two recursive calls.

For n rows, the number of complete paths is:

    2^(n - 1)

Therefore, the fixed DFS version has:

    Time: O(2^n)
    Space: O(n) recursion depth


BOTTOM-UP DP IDEA:

Begin at the bottom:

    dp = [4, 1, 8, 3]

Process row [6, 5, 7]:

    dp[0] = 6 + min(4, 1) = 7
    dp[1] = 5 + min(1, 8) = 6
    dp[2] = 7 + min(8, 3) = 10

Now:

    dp = [7, 6, 10, 3]

Process row [3, 4]:

    dp[0] = 3 + min(7, 6) = 9
    dp[1] = 4 + min(6, 10) = 10

Now:

    dp = [9, 10, 10, 3]

Process row [2]:

    dp[0] = 2 + min(9, 10) = 11

Answer:

    11


UPGRADE DP CONTRACT:

Before processing a level:

    dp[index] stores the minimum path sum beginning at the cell directly
    below the current cell.

After processing triangle[level][index]:

    dp[index] stores the minimum path sum beginning at the current cell.


PATTERN:

    Dynamic programming

CARD SHAPE:

    Start from the final row and move upward.

STATE:

    dp[index] = minimum path sum from the current position to the bottom

RECURRENCE:

    dp[index] = triangle[level][index]
        + min(dp[index], dp[index + 1])


UPGRADE COMPLEXITY:

If the triangle contains n rows, it contains O(n²) values.

Time:

    O(n²)

Space:

    O(n)

Only one row of DP values is stored.
*/