/*
YOUR ORIGINAL SOLUTION:

class Solution {
    func gameOfLife(_ board: inout [[Int]]) {
        let m = board.count
        let n = board[0].count
        var newBoard = board

        for i in 0..<m {
            for j in 0..<n {
                helper(board, i, j, &newBoard)
            }
        }
        board = newBoard
    }

    func helper(
        _ board: [[Int]],
        _ x: Int,
        _ y: Int,
        _ newBoard: inout [[Int]]
    ) {
        let m = board.count
        let n = board[0].count
        let oldVal = board[x][y]

        //check eight neightbors
        let top = x - 1 >= 0 ? board[x-1][y]: 0
        let leftTop = x - 1 >= 0 && y - 1 >= 0 ? board[x-1][y-1]: 0
        let rightTop = x - 1 >= 0 && y + 1 < n ? board[x-1][y+1]: 0
        let left = y - 1 >= 0 ? board[x][y-1]: 0
        let right = y + 1 < n ? board[x][y+1]: 0
        let bottom = x + 1 < m ? board[x+1][y]: 0
        let leftBottom = x + 1 < m && y - 1 >= 0 ? board[x+1][y-1]: 0
        let rightBottom = x + 1 < m && y + 1 < n ? board[x+1][y+1]: 0

        let sum = top + leftTop + rightTop + left + right +
                  bottom + leftBottom + rightBottom

        if oldVal == 1 && sum < 2 {
            newBoard[x][y] = 0
        }

        if oldVal == 1 && (sum == 2 || sum == 3) {
            newBoard[x][y] = 1
        }

        if oldVal == 1 && sum > 3 {
            newBoard[x][y] = 0
        }

        if oldVal == 0 && sum == 3 {
            newBoard[x][y] = 1
        }
    }
}

// Thinking
// update all the cell simultaneously with current status
// saw there is a follow up
// will try to solve first with out in-place
// go through every cell
// then check all 4 rules to decide whether to update or not
// so need to create a copy size board
// finish writing in 22 mins
// lgtm. ready to run, pas
// ready submit, pass

// Pattern: 2D array, traverse
// Card shape: N/A
// State needed: just update array[i][j] with above 4 rules
// Contract: for index i,j go around its eight neighbors then decide
// it's value is 1 or 0

// Recall: blank
*/


// FIX/REVIEW VERSION:
// Your solution passed and is correct.
// This version preserves your copied-board approach while reducing
// the repeated neighbor and rule logic.

class fixSolution {
    func gameOfLife(_ board: inout [[Int]]) {
        let rows = board.count
        let columns = board[0].count
        var nextBoard = board

        for row in 0..<rows {
            for column in 0..<columns {
                let liveNeighbors = countLiveNeighbors(
                    board,
                    row,
                    column
                )

                if board[row][column] == 1 {
                    // A live cell survives only with 2 or 3 live neighbors.
                    nextBoard[row][column] =
                        liveNeighbors == 2 || liveNeighbors == 3 ? 1 : 0
                } else {
                    // A dead cell becomes alive only with exactly 3.
                    nextBoard[row][column] =
                        liveNeighbors == 3 ? 1 : 0
                }
            }
        }

        board = nextBoard
    }

    private func countLiveNeighbors(
        _ board: [[Int]],
        _ row: Int,
        _ column: Int
    ) -> Int {
        var count = 0

        // Check row - 1, row, and row + 1.
        for rowOffset in -1...1 {
            // Check column - 1, column, and column + 1.
            for columnOffset in -1...1 {
                // Do not count the current cell itself.
                if rowOffset == 0 && columnOffset == 0 {
                    continue
                }

                let neighborRow = row + rowOffset
                let neighborColumn = column + columnOffset

                // Skip positions outside the board.
                if neighborRow < 0 ||
                   neighborRow >= board.count ||
                   neighborColumn < 0 ||
                   neighborColumn >= board[0].count {
                    continue
                }

                count += board[neighborRow][neighborColumn]
            }
        }

        return count
    }
}


// GPT'S UPGRADE VERSION:
// Update the board in place using temporary states.
//
// 0 = originally dead, remains dead
// 1 = originally alive, remains alive
// 2 = originally alive, becomes dead
// 3 = originally dead, becomes alive

class Solution {
    func gameOfLife(_ board: inout [[Int]]) {
        let rows = board.count
        let columns = board[0].count

        // First pass:
        // Calculate the next state while preserving the original state.
        for row in 0..<rows {
            for column in 0..<columns {
                var liveNeighbors = 0

                for rowOffset in -1...1 {
                    for columnOffset in -1...1 {
                        if rowOffset == 0 && columnOffset == 0 {
                            continue
                        }

                        let neighborRow = row + rowOffset
                        let neighborColumn = column + columnOffset

                        if neighborRow < 0 ||
                           neighborRow >= rows ||
                           neighborColumn < 0 ||
                           neighborColumn >= columns {
                            continue
                        }

                        let neighbor = board[neighborRow][neighborColumn]

                        // Both 1 and 2 were alive in the original board.
                        if neighbor == 1 || neighbor == 2 {
                            liveNeighbors += 1
                        }
                    }
                }

                if board[row][column] == 1 {
                    if liveNeighbors < 2 || liveNeighbors > 3 {
                        // Originally alive, next state is dead.
                        board[row][column] = 2
                    }
                } else if liveNeighbors == 3 {
                    // Originally dead, next state is alive.
                    board[row][column] = 3
                }
            }
        }

        // Second pass:
        // Convert temporary states into final 0/1 states.
        for row in 0..<rows {
            for column in 0..<columns {
                board[row][column] %= 2
            }
        }
    }
}


/*
GPT'S EXPLANATION OF THE IN-PLACE VERSION

The challenge:
- Every cell must update simultaneously.
- While examining a cell, its neighbors must still appear to have
  their original values.
- Updating 1 directly to 0 would erase information needed by later
  cells.

Temporary states preserve both pieces of information:

    State   Original    Next
      0       dead      dead
      1       alive     alive
      2       alive     dead
      3       dead      alive

When counting neighbors, check the original state:

    1 and 2 were originally alive.
    0 and 3 were originally dead.

Therefore:

    if neighbor == 1 || neighbor == 2 {
        liveNeighbors += 1
    }

After every cell has been examined, convert temporary states:

    0 % 2 = 0
    1 % 2 = 1
    2 % 2 = 0
    3 % 2 = 1

So this single expression produces every final state:

    board[row][column] %= 2


EXAMPLE

Suppose an originally alive cell must die:

    Original value: 1
    Temporary value: 2

Later cells still see state 2 as originally alive.

After the first pass:

    2 % 2 = 0

So its final state becomes dead.

Suppose an originally dead cell becomes alive:

    Original value: 0
    Temporary value: 3

Later cells see state 3 as originally dead.

After the first pass:

    3 % 2 = 1

So its final state becomes alive.


GPT'S SUMMARY

What you did well:
- Your solution is correct and passed.
- You correctly understood that updates must happen simultaneously.
- Copying the original board is a reliable way to preserve old states.
- You correctly checked all eight neighbors.
- Your boundary checks were correct.
- You implemented all four Game of Life rules correctly.

Small improvements:
- The eight neighbor checks can be generated using two offset loops.
- The three live-cell conditions can be combined:
  
      liveNeighbors == 2 || liveNeighbors == 3

- `newBoard` is clearer as `nextBoard` because it stores the next
  generation.

Upgrade insight:
- A copied board is not required.
- Encode both old and new states inside the same integer temporarily.
- Count neighbors using the old-state part.
- Convert all cells to their final state in a second pass.

Pattern:
- 2D grid traversal / state encoding.

Fix-version state:
- Original `board`.
- Copied `nextBoard`.
- Number of live neighbors.

Upgrade-version state:
- Temporary values 0, 1, 2, and 3 inside the original board.
- Number of originally live neighbors.

Contract:
- During the first pass, every cell always retains enough information
  to determine its original state.
- After the second pass, every cell contains only its final 0 or 1.

Complexity:

Fix version:
- Time: O(m * n).
- Space: O(m * n) for the copied board.

Upgrade version:
- Time: O(m * n).
- Auxiliary space: O(1).
*/