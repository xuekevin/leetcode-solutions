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

    func helper(_ board: [[Int]], _ x: Int, _ y: Int, _ newBoard: inout [[Int]]) {
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
        
        let sum = top + leftTop + rightTop + left + right + bottom + leftBottom + rightBottom

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
// ready submit 

// Pattern: 2D array, traverse
// Card shape: N/A
// State needed: just update array[i][j] with above 4 rules
// Contract: for index i,j go around its eight neighbors then decide it's value is 1 or 0

// Recall:        blank