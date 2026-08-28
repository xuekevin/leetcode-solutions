// Your original solution:
// class Solution {
//    func solve(_ board: inout [[Character]]) {
//
//        let m = board.count
//        var colArr = Array<Bool>(repeating: false, count: m)
//        var visitedArr = Array(repeating: colArr, count: m)
//
//        // check the edge
//        // top and bottom
//        while j in 0..<m {
//            let item =  board[0][j]
//            let visit = visitedArr[0][j]
//            if item == 'O' && visit == false {
//                visitedArr[0][j] = true
//                helper(board, 0, j, &visitedArr)
//            }
//        }
//    }
//
//    func helper(_ board: [[Character]], _ x: Int, _ y : Int, _ visitedArr: inout [[Bool]]) {
//        var startX = x
//        var startY = y
//
//        ....
//    }
// }
//
// // Thinking
// // basiclly this is about find a surround region, then replace all 0 to X
// // so first is how to find a surround region
// // check surround region define
// // cell is 0, and also no connect 0 is not on the edge
// // so where to start the find, DPS, assume
// // start from 0,0
// // if item is X, continue,
// // saw an 0, if it
// // think use isVisted Array to track
// // and in the isVisited Array also track it is  surround or not
//
// // rethinking
//
// // should start from the 0 in the edge to do dfs
// // mark it as isvisted and also mark it is not surrounded
// // find next connect 0
// // then go to next not visited 0, until there is nothing left
// // then all we need to do is to for loop m-1 x n-1 array
// // to see if there is any suround 0 left, if it is just change it to X
// // 10 mins so far
// // ready to write code
// // already 30 mins, take to long to write down
// // will ask gpt to follow my logic
//
// // Pattern: DFS
// // Card shape:
// // State needed:
// // Contract: what is TRUE when one call returns?
// // Recall: landed / half / blank


// Fix version: follows your visited-array DFS idea.
class Solution {
    func solve(_ board: inout [[Character]]) {
        guard !board.isEmpty, !board[0].isEmpty else {
            return
        }

        let m = board.count
        let n = board[0].count

        // Wrong: your visited array used m for both dimensions.
        // Why: a board can have m rows and n columns.
        // Correct: create m rows, each containing n Boolean values.
        var visitedArr = Array(
            repeating: Array(repeating: false, count: n),
            count: m
        )

        // Good: start DFS from edge 'O' cells.
        // Any 'O' connected to an edge cannot be surrounded.

        // Check the top and bottom edges.
        for column in 0..<n {
            helper(board, 0, column, &visitedArr)
            helper(board, m - 1, column, &visitedArr)
        }

        // Check the left and right edges.
        for row in 0..<m {
            helper(board, row, 0, &visitedArr)
            helper(board, row, n - 1, &visitedArr)
        }

        // Every 'O' not reached from an edge is surrounded.
        for row in 0..<m {
            for column in 0..<n {
                if board[row][column] == "O" && !visitedArr[row][column] {
                    board[row][column] = "X"
                }
            }
        }
    }

    // Marks every edge-connected 'O' as visited.
    func helper(
        _ board: [[Character]],
        _ row: Int,
        _ column: Int,
        _ visitedArr: inout [[Bool]]
    ) {
        // Stop if this coordinate is outside the board.
        if row < 0 || row >= board.count ||
            column < 0 || column >= board[0].count {
            return
        }

        // Stop at an 'X' or at a cell DFS already visited.
        if board[row][column] == "X" || visitedArr[row][column] {
            return
        }

        // This cell is an edge-connected 'O', so it is safe.
        visitedArr[row][column] = true

        // DFS into the four neighboring cells.
        helper(board, row - 1, column, &visitedArr)
        helper(board, row + 1, column, &visitedArr)
        helper(board, row, column - 1, &visitedArr)
        helper(board, row, column + 1, &visitedArr)
    }
}

/*
 GPT's summary

 Good:
 - Your revised idea is correct: start from edge 'O' cells.
 - Mark all connected edge 'O' cells as safe.
 - Any remaining 'O' must be surrounded, so change it to 'X'.

 Mistakes you made:
 - `while j in 0..<m` is not valid Swift.
 - `j` was not declared.
 - The top/bottom edge needs the number of columns, `n`, not `m`.
 - Swift Character values use double quotes: `"O"`, not `'O'`.
 - You also need to check all four edges, not only the top edge.

 Swift syntax to remember:
 - Loop through a range:
   `for j in 0..<n { }`
 - Create a 2D Boolean array:
   `Array(repeating: Array(repeating: false, count: n), count: m)`
 - Character comparison:
   `board[row][column] == "O"`

 Complexity:
 - Time: O(m * n)
 - Space: O(m * n) for `visitedArr`, plus the DFS call stack.
*/