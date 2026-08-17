// Your original solution:
//
// class Solution {
//     func spiralOrder(_ matrix: [[Int]]) -> [Int] {
//         var m = matrix.count
//         var n = matrix[0].count
//
//         var count = 0
//
//         var x = 0
//         var y = 0
//
//         var resultArr = [Int]()
//
//         while count < m * n {
//             // first round
//             var startX = x
//             var endX = m - 1
//             var startY = y
//             var endY = n - 1
//             // first round
//             for j in startY...endY {
//                 resultArr.append(matrix[startX][j])
//                 count += 1
//             }
//             // second
//             startX = startX + 1
//             for i in startX...endX {
//                 resultArr.append(matrix[i][endY])
//                 count += 1
//             }
//             // third
//
//
//
//
//         }
//     }
// }
//
// // Pattern: Array
// // Card shape:
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank
// // Thinking
// // check the example to figure out the pattern
// // basically the logic do the traverse
// // but change the x or y with the "spiral" order, until meet the last
// // how to know the end, maybe we can have a counter
// // first: x = 0, y start from 0 to t he n - 1
// // second: y = n -1, now x change from 1 to m - 1 (increase from previous x)
// // third: x = m - 1, y start from n -2 (or decrease from previous y)
// // fourth: x = m - 1 -1 (decrease from previous x), y start from 0 until n - 2, because n - 1 already checked
// // think can start writing in 6 mins
//
// // already 16 mins
// // I think I spend a lot of time t o figure out how in change the x and y
// // but seems spend too long, ready ask gpt to figure


// Fixed version:
class Solution {
    func spiralOrder(_ matrix: [[Int]]) -> [Int] {
        guard !matrix.isEmpty, !matrix[0].isEmpty else {
            return []
        }

        var result = [Int]()

        // These four boundaries describe the unvisited rectangle.
        var top = 0
        var bottom = matrix.count - 1
        var left = 0
        var right = matrix[0].count - 1

        while top <= bottom && left <= right {
            // 1. Traverse the top edge from left to right.
            for column in left...right {
                result.append(matrix[top][column])
            }
            top += 1

            // 2. Traverse the right edge from top to bottom.
            if top <= bottom {
                for row in top...bottom {
                    result.append(matrix[row][right])
                }
            }
            right -= 1

            // 3. Traverse the bottom edge from right to left.
            // Check both boundaries to avoid visiting a row twice.
            if top <= bottom && left <= right {
                for column in stride(from: right, through: left, by: -1) {
                    result.append(matrix[bottom][column])
                }
            }
            bottom -= 1

            // 4. Traverse the left edge from bottom to top.
            // Check both boundaries to avoid visiting a column twice.
            if top <= bottom && left <= right {
                for row in stride(from: bottom, through: top, by: -1) {
                    result.append(matrix[row][left])
                }
            }
            left += 1
        }

        return result
    }
}


// GPT's summary:
//
// Mistakes you made:
// - Your function did not return resultArr.
// - The outer-loop state was not updated, so count could stop changing and
//   the loop could run forever.
// - Recreating startX, endX, startY, and endY inside every iteration loses
//   the smaller inner rectangle.
// - A counter can detect completion, but four boundaries more directly
//   represent which cells remain unvisited.
// - `m` and `n` never change, so they should be declared with `let` if used.
//
// State needed:
// - `top`: first unvisited row.
// - `bottom`: last unvisited row.
// - `left`: first unvisited column.
// - `right`: last unvisited column.
//
// Movement order:
// - Top edge: left to right, then `top += 1`.
// - Right edge: top to bottom, then `right -= 1`.
// - Bottom edge: right to left, then `bottom -= 1`.
// - Left edge: bottom to top, then `left += 1`.
//
// Why the extra boundary checks matter:
// - In a single remaining row, the top traversal consumes the whole row.
// - In a single remaining column, the right traversal may consume the rest.
// - Without checking the boundaries again, those cells could be appended
//   twice or a closed range such as `3...2` could crash.
//
// Loop contract:
// - At the top of every iteration, the rectangle bounded by
//   top...bottom and left...right contains exactly the unvisited cells.
// - One iteration consumes its outer layer and shrinks the boundaries.
//
// Swift syntax to remember:
// - Forward closed range: `left...right`
// - Backward traversal:
//   `stride(from: right, through: left, by: -1)`
// - `through:` includes the ending value.
//
// What you did well:
// - You correctly identified all four traversal directions.
// - You correctly avoided repeating the corner when starting the right edge.
// - Your idea of shrinking toward the center was the correct foundation.
//
// Complexity:
// - Let m be the row count and n be the column count.
// - Time: O(m * n), because every cell is visited once.
// - Extra space: O(1), excluding the returned array.