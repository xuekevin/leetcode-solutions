/*
YOUR ORIGINAL SOLUTION:

class Solution {
    func maximalSquare(_ matrix: [[Character]]) -> Int {
    }
}

// Thinking
// define the square
// dp[0][0] define the x = 0, y = 0, the square with 1 only,
// if matrix[0][0] == 0, then dp[0][0] = 1 area = 1
// dp[0][1] = max( dp[0][0] matrix[0][1])
// dp[0][2] = max(dp[0][1], matrix[0][2])
// dp[1][1] = dp[1][0] + dp[]
// spend 10 mins, still didn't figure out the convert function
// will ask gpt to help

// thinking what's the convert functionn

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/


// FIX VERSION: 2D DP.
// `dp[row][column]` stores a square SIDE LENGTH, not an area.

class fixSolution {
    func maximalSquare(_ matrix: [[Character]]) -> Int {
        guard !matrix.isEmpty, !matrix[0].isEmpty else {
            return 0
        }

        let rows = matrix.count
        let columns = matrix[0].count

        // The extra top row and left column remain zero.
        // They eliminate boundary checks.
        var dp = Array(
            repeating: Array(repeating: 0, count: columns + 1),
            count: rows + 1
        )

        var maxSide = 0

        for row in 1...rows {
            for column in 1...columns {
                if matrix[row - 1][column - 1] == "1" {
                    // A square ending here can grow only as far as its
                    // smallest neighbor permits.
                    dp[row][column] = min(
                        dp[row - 1][column],     // above
                        dp[row][column - 1],     // left
                        dp[row - 1][column - 1]  // diagonal
                    ) + 1

                    maxSide = max(maxSide, dp[row][column])
                }
            }
        }

        // The problem asks for area, not side length.
        return maxSide * maxSide
    }
}


// UPGRADE VERSION: 1D DP.
// Same recurrence, but one array replaces the full table.

class Solution {
    func maximalSquare(_ matrix: [[Character]]) -> Int {
        guard !matrix.isEmpty, !matrix[0].isEmpty else {
            return 0
        }

        let rows = matrix.count
        let columns = matrix[0].count

        var dp = Array(repeating: 0, count: columns + 1)
        var maxSide = 0

        for row in 1...rows {
            // This represents the previous row's previous column:
            // dp[row - 1][column - 1].
            var previousDiagonal = 0

            for column in 1...columns {
                // Before updating, dp[column] is the value above:
                // dp[row - 1][column].
                let previousRowValue = dp[column]

                if matrix[row - 1][column - 1] == "1" {
                    dp[column] = min(
                        dp[column],          // above
                        dp[column - 1],      // left, already updated
                        previousDiagonal     // diagonal
                    ) + 1

                    maxSide = max(maxSide, dp[column])
                } else {
                    // A square ending at a "0" cannot exist.
                    dp[column] = 0
                }

                // Save the old above value for the next column.
                previousDiagonal = previousRowValue
            }
        }

        return maxSide * maxSide
    }
}


/*
GPT'S SUMMARY

The correct DP state is:

    dp[row][column]

= the largest square SIDE LENGTH containing only "1"s whose bottom-right
corner is at this matrix cell.

For example, if:

    dp[3][4] = 2

then there is a 2-by-2 all-"1" square ending at matrix[2][3].

The area is:

    2 * 2 = 4


THE RECURRENCE

If the current matrix value is "0":

    dp[row][column] = 0

A square of 1s cannot end at a zero.

If the current matrix value is "1":

    dp[row][column] = min(
        above,
        left,
        diagonal
    ) + 1


WHY USE min?

To create a larger square, all three neighboring directions must support
that square size.

Example:

    1 1 1
    1 1 1
    1 1 ?

At `?`, a 3-by-3 square is possible only if:

- the square above supports side 2,
- the square left supports side 2,
- the diagonal supports side 2.

If one neighbor only supports side 1, the new square can grow only to:

    1 + 1 = 2

The smallest neighbor is the limiting side.


YOUR MAIN MISCONCEPTIONS

1. If the matrix cell is "0", the DP value is zero.

   Wrong idea:

       matrix[0][0] == 0 -> dp[0][0] = 1

   Correct:

       matrix[row][column] == "0" -> dp[row][column] = 0

2. Do not use `max` to create the current square.

   `max` finds the best answer seen anywhere.

   The current DP cell needs `min`, because every neighboring direction
   must support the new square.

3. The DP value is side length, not the final area.

   Track:

       maxSide

   Then return:

       maxSide * maxSide


EXAMPLE

Matrix:

    1 1 1
    1 1 1
    1 1 1

At the bottom-right cell:

    above    = 2
    left     = 2
    diagonal = 2

Therefore:

    dp = min(2, 2, 2) + 1
       = 3

The largest square has:

    side = 3
    area = 3 * 3 = 9


WHY THE EXTRA DP BORDER HELPS

The matrix uses zero-based indexes:

    matrix[row - 1][column - 1]

The DP array starts at index 1:

    dp[row][column]

So the first real matrix cell can safely look at:

    dp[0][1]
    dp[1][0]
    dp[0][0]

All are zero. No special boundary logic is needed.


PATTERN:
- 2D dynamic programming
- Largest square ending at the current cell

STATE NEEDED:
- `dp[row][column]`: largest valid square side ending at this cell
- `maxSide`: largest side found anywhere

CONTRACT:
- After calculating a cell, `dp[row][column]` accurately represents
  the largest all-"1" square ending exactly at that cell.

COMPLEXITY:

Fix 2D version:
- Time: O(rows * columns)
- Space: O(rows * columns)

Upgrade 1D version:
- Time: O(rows * columns)
- Space: O(columns)
*/