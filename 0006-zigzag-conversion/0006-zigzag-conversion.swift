/*
YOUR ORIGINAL SOLUTION:

class Solution {
    func convert(_ s: String, _ numRows: Int) -> String {
        let colArr: [Character] = Array(repeating: '', count: s.count)
        var resultArr = Array(repeating: colArr, count: numRows)

        var x = 0
        var y = 0
        let top = 0
        let bottom = numRows - 1
        let isDown = true

        for item in string {
            // assume no out of bound, because we create the resultArr big enough
            if isDown {
                resultArr[x][y] = item
                if y == bottom {
                    x -= 1
                    y += 1
                    isDown = false
                } else {
                    y += 1
                }
            } else {
                resultArr[x][y] = item
                if x == top {
                    x += 1
                    isDown = true
                } else {
                    x -= 1
                    y += 1
                }
            }
        }

        var resultStr = ""

        for i in 0..<resultArr.count {
            for j in 0..<resultArr[0].count {
                let cur = resultArr[i][j]
                if cur != "" {
                    resultStr.append(cur)
                }
            }
        }

        return resultStr
    }
}

// Thinking
// so basically it is about convert the zigzag string to a normal array
// how to do it?
// try to find the pattern
// basically give a index I can caculate its corresponding [x][y]
// so that's what I need
// now figure out the pattern
// numsRows = 3
// so i in 0..<str.count
// use example to figure out the pattern
// frist round y in 0.<numsRow, x didn't change
// second (x + 1)(y-1) continue, until x == top, which is x == 0
// then go down again, until y == bottom, which is nuumsRow - 1
// basically can use this logic to write the code
// 11 mins so far
// start to try write the code
// finish writing in 26 mins
// quick check,lgtm
// try to run
// some swift synatx error, will let gpt fix
*/


// FIX VERSION: preserves your 2D-grid idea.

class fixSolution {
    func convert(_ s: String, _ numRows: Int) -> String {
        // Without this, one row would try to reverse direction forever.
        if numRows == 1 || s.count <= numRows {
            return s
        }

        // Wrong: Character cannot be empty: ''
        // Correct: use Character? so `nil` represents an empty cell.
        let emptyRow = Array<Character?>(
            repeating: nil,
            count: s.count
        )
        var grid = Array(repeating: emptyRow, count: numRows)

        var row = 0
        var column = 0
        var movingDown = true

        for character in s {
            grid[row][column] = character

            if movingDown {
                if row == numRows - 1 {
                    // After the bottom cell, move diagonally up-right.
                    row -= 1
                    column += 1
                    movingDown = false
                } else {
                    row += 1
                }
            } else {
                if row == 0 {
                    // After the top cell, the next cell is directly below.
                    row += 1
                    movingDown = true
                } else {
                    row -= 1
                    column += 1
                }
            }
        }

        var result = ""

        // Read the completed grid row by row.
        for row in grid {
            for character in row {
                if let character = character {
                    result.append(character)
                }
            }
        }

        return result
    }
}


// UPGRADE VERSION:
// Build each output row directly. A grid is not needed.

class Solution {
    func convert(_ s: String, _ numRows: Int) -> String {
        if numRows == 1 || s.count <= numRows {
            return s
        }

        var rows = Array(
            repeating: "",
            count: numRows
        )

        var currentRow = 0
        var movingDown = true

        for character in s {
            // Put the character directly into its final output row.
            rows[currentRow].append(character)

            // Reverse direction only at the first and last row.
            if currentRow == 0 {
                movingDown = true
            } else if currentRow == numRows - 1 {
                movingDown = false
            }

            currentRow += movingDown ? 1 : -1
        }

        return rows.joined()
    }
}


/*
GPT'S SUMMARY

What you did well:
- You correctly identified this as a coordinate-pattern problem.
- Your idea of tracking direction is correct.
- The zigzag path really does alternate between:
  - moving down through the rows
  - moving diagonally up through the rows

Swift mistakes:

1. `''` is not a valid empty Character.

   Wrong:

       let empty: Character = ''

   A Character must contain exactly one character.

   Correct approach for an empty grid cell:

       Character?

   Then use `nil` to mean "this cell has no character."

2. `isDown` must be `var`, not `let`.

   Wrong:

       let isDown = true

   You later need:

       isDown = false

   Correct:

       var movingDown = true

3. The input variable is named `s`.

   Wrong:

       for item in string

   Correct:

       for item in s

4. You cannot compare a Character with an empty String.

   Wrong:

       if cur != ""

   Correct with optional Character:

       if let character = cur {
           result.append(character)
       }

Why the upgrade is simpler:
- We do not need to remember columns.
- We do not need to build empty grid cells.
- Each character already knows its final output row.
- Joining the rows at the end creates the required result.

Example: `s = "PAYPALISHIRING"`, `numRows = 3`

Rows after the traversal:

    row 0: "PAHN"
    row 1: "APLSIIG"
    row 2: "YIR"

Join them:

    "PAHNAPLSIIGYIR"

Pattern:
- Simulation / direction traversal.

State needed:
- `currentRow`: where the next character belongs.
- `movingDown`: whether the traversal is moving down or up.
- `rows`: final characters grouped by their output row.

Loop contract:
- Before processing each character, `currentRow` is its correct final
  zigzag row.
- After processing it, move one row in the current direction.

Complexity:

Fix grid version:
- Time: O(numRows * n), because reading the full grid touches its cells.
- Space: O(numRows * n).

Upgrade version:
- Time: O(n).
- Space: O(n), required for the output.
*/