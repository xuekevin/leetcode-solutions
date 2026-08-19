// ============================================================
// FIXED VERSION: Follows your box + row + column approach
// ============================================================

class Solution {
    func isValidSudoku(_ board: [[Character]]) -> Bool {
        // Check every row.
        for row in 0..<9 {
            var seen = Set<Character>()

            for column in 0..<9 {
                let digit = board[row][column]

                if digit == "." {
                    continue
                }

                if seen.contains(digit) {
                    return false
                }

                seen.insert(digit)
            }
        }

        // Check every column.
        for column in 0..<9 {
            var seen = Set<Character>()

            for row in 0..<9 {
                let digit = board[row][column]

                if digit == "." {
                    continue
                }

                if seen.contains(digit) {
                    return false
                }

                seen.insert(digit)
            }
        }

        // Check every 3 x 3 box.
        for box in 0..<9 {
            let startRow = (box / 3) * 3
            let startColumn = (box % 3) * 3
            var seen = Set<Character>()

            for row in startRow..<(startRow + 3) {
                for column in startColumn..<(startColumn + 3) {
                    let digit = board[row][column]

                    if digit == "." {
                        continue
                    }

                    if seen.contains(digit) {
                        return false
                    }

                    seen.insert(digit)
                }
            }
        }

        return true
    }
}

// ============================================================
// UPGRADE VERSION: Validate everything in one traversal
// ============================================================

/*
class Solution {
    func isValidSudoku(_ board: [[Character]]) -> Bool {
        var rows = Array(repeating: Set<Character>(), count: 9)
        var columns = Array(repeating: Set<Character>(), count: 9)
        var boxes = Array(repeating: Set<Character>(), count: 9)

        for row in 0..<9 {
            for column in 0..<9 {
                let digit = board[row][column]

                if digit == "." {
                    continue
                }

                let box = (row / 3) * 3 + column / 3

                if rows[row].contains(digit)
                    || columns[column].contains(digit)
                    || boxes[box].contains(digit) {
                    return false
                }

                rows[row].insert(digit)
                columns[column].insert(digit)
                boxes[box].insert(digit)
            }
        }

        return true
    }
}
*/

// ============================================================
// ORIGINAL THINKING
// ============================================================

/*
Thinking:
- The board is 9 x 9.
- Validate all nine 3 x 3 boxes.
- Validate every row and every column.
- Empty cells should be skipped.

Pattern: Matrix, Set
Card shape: Visit each filled cell and detect duplicates.
State needed: Previously seen digits for each row, column, and box.
Contract: Before checking a cell, each Set contains the digits already
          visited in that row, column, or box.
Recall: half
*/

// ============================================================
// GPT'S SUMMARY
// ============================================================

/*
MAIN LOGIC MISUNDERSTANDING:

You started trying to determine which numbers could fill empty cells.
This problem does not ask you to solve the Sudoku. It only asks whether
the digits currently on the board violate any rules.

MISTAKES:

1. An empty Sudoku cell is ".", not "".

2. `count` was undefined. For the box number, use `box`:
       let startRow = (box / 3) * 3
       let startColumn = (box % 3) * 3

3. Array subscripting uses square brackets:
       checkArray[index] = true
   not:
       checkArray(index) = true

4. Converting Character to Int requires:
       Int(String(digit))
   and the result is optional.

5. `mutedBoard` and `order` were unused.

6. The function must return Bool on every path.

BOX FORMULA:

For a cell at (row, column):

    let box = (row / 3) * 3 + column / 3

This produces box indexes 0 through 8.

COMPLEXITY:

Time: O(81), treated as O(1) because the board is always 9 x 9.
Space: O(81), also treated as O(1).
*/