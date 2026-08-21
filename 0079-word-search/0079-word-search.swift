// ============================================================
// FIX VERSION: Follows your DFS + visited-state approach
// ============================================================

class fixSolution {
    func exist(_ board: [[Character]], _ word: String) -> Bool {
        if board.isEmpty || board[0].isEmpty || word.isEmpty {
            return false
        }

        let wordCharacters = Array(word)
        let rowCount = board.count
        let columnCount = board[0].count

        var visited = Array(
            repeating: Array(repeating: false, count: columnCount),
            count: rowCount
        )

        // Every matching cell could be the beginning of the word.
        for row in 0..<rowCount {
            for column in 0..<columnCount {
                if helper(
                    board,
                    wordCharacters,
                    row,
                    column,
                    0,
                    &visited
                ) {
                    return true
                }
            }
        }

        return false
    }

    // Contract:
    // Returns true if word[index...] can be found starting exactly
    // at board[row][column] without reusing a visited cell.
    func helper(
        _ board: [[Character]],
        _ word: [Character],
        _ row: Int,
        _ column: Int,
        _ index: Int,
        _ visited: inout [[Bool]]
    ) -> Bool {
        // Check boundaries before accessing the matrix.
        if row < 0 || row >= board.count
            || column < 0 || column >= board[0].count {
            return false
        }

        // A cell cannot be used twice in the same path.
        if visited[row][column] {
            return false
        }

        // This cell must match the current word character.
        if board[row][column] != word[index] {
            return false
        }

        // The final character matched, so the word was found.
        if index == word.count - 1 {
            return true
        }

        // Make the choice.
        visited[row][column] = true

        // Explore all four neighboring cells.
        let found = helper(
            board, word, row + 1, column, index + 1, &visited
        ) || helper(
            board, word, row - 1, column, index + 1, &visited
        ) || helper(
            board, word, row, column + 1, index + 1, &visited
        ) || helper(
            board, word, row, column - 1, index + 1, &visited
        )

        // Unmake the choice so another path may use this cell.
        visited[row][column] = false

        return found
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Mark visited cells directly in a temporary board.
// ============================================================

class Solution {
    func exist(_ board: [[Character]], _ word: String) -> Bool {
        if board.isEmpty || board[0].isEmpty || word.isEmpty {
            return false
        }

        var mutableBoard = board
        let wordCharacters = Array(word)

        for row in 0..<mutableBoard.count {
            for column in 0..<mutableBoard[0].count {
                if search(
                    &mutableBoard,
                    wordCharacters,
                    row,
                    column,
                    0
                ) {
                    return true
                }
            }
        }

        return false
    }

    func search(
        _ board: inout [[Character]],
        _ word: [Character],
        _ row: Int,
        _ column: Int,
        _ index: Int
    ) -> Bool {
        if row < 0 || row >= board.count
            || column < 0 || column >= board[0].count {
            return false
        }

        if board[row][column] != word[index] {
            return false
        }

        if index == word.count - 1 {
            return true
        }

        // Temporarily mark this cell as unavailable.
        let originalCharacter = board[row][column]
        board[row][column] = "#"

        let found = search(
            &board, word, row + 1, column, index + 1
        ) || search(
            &board, word, row - 1, column, index + 1
        ) || search(
            &board, word, row, column + 1, index + 1
        ) || search(
            &board, word, row, column - 1, index + 1
        )

        // Backtrack by restoring the original character.
        board[row][column] = originalCharacter

        return found
    }
}

// ============================================================
// YOUR ORIGINAL CODE AND THINKING COMMENTS
// ============================================================

/*
class Solution {
    var hasFound = false

    func exist(_ board: [[Character]], _ word: String) -> Bool {
        let start = Array(word)[0]
        let startPoint = getStartPoint(board, start)
        if startPoint.x == -1 {
            return false
        } else if word.count == 1 {
            return true
        }

        var visited = [(x:Int,y:Int)]()
        visited.append(startPoint)

        helper(board, startPoint.x + 1 sartPoint.y, word, 1, &visited)
        helper(board, startPoint.x - 1 sartPoint.y, word, 1, &visited)
        helper(board, startPoint.x sartPoint.y + 1, word, 1, &visited)
        helper(board, startPoint.x sartPoint.y - 1, word, 1, &visited)
        
        return hasFound
    }

    func getStartPoint(_ board: [[Character]], _ start: Character)
        -> (x:Int, y:Int) {
        let m = board.count 
        let n = board[0].count
        let start = Array(word)[0]
        let startX = -1
        let startY = -1

        for i in 0..<m {
            for j in 0..<n {
                if board[i][j] == start {
                    return (x:i, y:j)
                }
            }
        }
        return (-1, -1)
    }

    func helper(
        _ board: [[Character]],
        _ startX: Int,
        _ endY: Int,
        _ word: [Character],
        _ curIndex: Int,
        _ visited: inout [(x:Int, y:Int)]
    ) -> Bool {
        if hasFound || curIndex == word.count {
            return true
        }

        // don't go to the point you are from
        if visited.contains((startX, startY)) {
            return false
        }

        if startX < 0 || startX >= board.count {
            return false
        }

        if startY < 0 || startY >= board[0].count {
            return false
        }

        if board[startX][startY] == word[curIndex] {
            if curIndex == word.count - 1 {
                hasFound = true
                return true
            }

            visited.append((x:startX, y:startY))
            let right = helper(
                board, startX + 1, startY,
                word, curIndex: curIndex + 1, visited
            )
            let left = helper(
                board, startX - 1, startY,
                word, curIndex: curIndex + 1, visited
            )
            let top = helper(
                board, startX, startY + 1,
                word, curIndex: curIndex + 1, visited
            )
            let down = helper(
                board, startX, startY - 1,
                word, curIndex: curIndex + 1, visited
            )

            // need swift syntax
            visited.remove(x:startX, y:startY)
            return left || right || top || down
        } else {
            return false
        }
    }
}

// Thinking
// first think can do backtacking
// about make a choice
// if one choose can't do deeper, then go back to previous chooice,
// and un make chooice
// or this is more like a DFS
// think can 

// Pattern:backtrack or DFS
// Card shape: try to find current index char in the board,
// if found then move to neighbor to see if can find next index
// of the word
// if can go further, return to previous choice, kind like recursive
// State needed: current char need to find,
// current index need to be find in the word
// Contract: call every helper can know if we find the current index
// of the word, if not, we can return
// Recall: half
// 7 mins ready to write

// already use 38 mins
// but I think I already figure out the basic solution,
// but need more time to consider the detail
// will let gpt to help
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
YOUR HIGH-LEVEL IDEA WAS CORRECT:

1. Choose a cell matching the current character.
2. Mark the cell as visited.
3. Search its four neighbors for the next character.
4. If that path fails, unmark the cell.
5. Try another path.

This is both DFS and backtracking:

    DFS describes how the board is explored.
    Backtracking describes making and undoing each visited choice.


MAIN LOGIC MISTAKE: ONLY ONE STARTING POINT

You used getStartPoint(), which returns the first matching cell.

But the first occurrence may lead to failure while another occurrence
may form the word.

Therefore, every board cell must be tried as a possible starting point:

    for row in 0..<rowCount {
        for column in 0..<columnCount {
            if helper(..., row, column, 0, ...) {
                return true
            }
        }
    }


WHY A GLOBAL hasFound IS UNNECESSARY:

Each recursive call already returns Bool.

Use:

    return top || bottom || left || right

A global variable can also retain its old value if the same Solution
instance is used for another call.


SWIFT AND CODE MISTAKES:

1. Missing commas:

       startPoint.x + 1 sartPoint.y

   Correct:

       startPoint.x + 1, startPoint.y


2. Typo:

       sartPoint

   Correct:

       startPoint


3. getStartPoint() uses `word`, but word is not a parameter.

4. The parameter is named endY, but the body uses startY.

5. exist() passes String, but helper expects [Character].

   Correct:

       let wordCharacters = Array(word)


6. External parameter labels did not match the helper declaration.

7. An inout argument requires &:

       helper(..., &visited)


8. Array has no remove(x:y:) method.

   A Boolean visited matrix is easier:

       visited[row][column] = true
       visited[row][column] = false


9. Bounds must be checked before accessing board[row][column].


BACKTRACKING EXAMPLE:

Board:

    A B C E
    S F C S
    A D E E

Word:

    "ABCCED"

Start at A:

    A -> B -> C -> C -> E -> D

At every step:

    visited[row][column] = true

When returning:

    visited[row][column] = false

That restoration allows the same cell to participate in a different
candidate path, while preventing reuse inside the current path.


CORRECT HELPER CONTRACT:

    helper(row, column, index) returns true if word[index...] can be
    formed starting exactly at board[row][column], without reusing any
    cell already selected in the current path.


PATTERN:

    Matrix DFS + backtracking

STATE:

    row
    column
    word index
    visited cells


COMPLEXITY:

Let:

    m = number of rows
    n = number of columns
    L = word length

Every cell can be a starting point. From each cell, the search explores
up to four directions.

A common upper bound is:

    Time: O(m * n * 4^L)

A tighter bound is approximately:

    O(m * n * 3^(L - 1))

because after the first move, the search cannot immediately reuse the
previous cell.

Fix-version space:

    O(m * n) for visited
    plus O(L) recursion depth

Upgrade-version space:

    O(m * n) for Swift's mutable board copy
    plus O(L) recursion depth

The marking technique itself avoids a separate visited matrix.
*/