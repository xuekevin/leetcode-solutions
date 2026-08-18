// Your original solution:
//
// class Solution {
//     func spiralOrder(_ matrix: [[Int]]) -> [Int] {
//         let row = matrix.count
//         let col = matrix[0].count
//         var top = 0
//         var bottom = row - 1
//         var left = 0
//         var right = col - 1
//         var x = 0
//         var y = 0
//         var result = [Int]()
//
//         while y >= left && y <= right && x >= top && x <= bottom {
//             // first round
//             while y <= right {
//                 result.append(matrix[x][y])
//                 y += 1
//             }
//             top += 1
//             x = top
//             y = right
//             while x <= bottom {
//                 result.append(matrix[x][y])
//                 x += 1
//             }
//
//             right -= 1
//             y = right
//             x = bottom
//
//             while y >= left {
//                 result.append(matrix[x][y])
//                 y -= 1
//             }
//
//             bottom -= 1
//             x = bottom
//             y = left
//
//             while x >= top {
//                 result.append(matrix[x][y])
//                 x -= 1
//             }
//             left += 1
//             y = left
//             x = top
//         }
//         return result
//     }
// }
//
// // use around 11 mins
// // seem there is some wrong, will let gpt fix


// Fixed version: preserves your x/y while-loop approach.
class Solution {
    func spiralOrder(_ matrix: [[Int]]) -> [Int] {
        guard !matrix.isEmpty, !matrix[0].isEmpty else {
            return []
        }

        var top = 0
        var bottom = matrix.count - 1
        var left = 0
        var right = matrix[0].count - 1
        var result = [Int]()

        // At the beginning of each loop, these boundaries describe
        // the remaining unvisited rectangle.
        while top <= bottom && left <= right {
            var x = top
            var y = left

            // 1. Top row: left to right.
            while y <= right {
                result.append(matrix[x][y])
                y += 1
            }
            top += 1

            // Important: a single-row matrix is now complete.
            if top > bottom {
                break
            }

            // 2. Right column: top to bottom.
            x = top
            y = right

            while x <= bottom {
                result.append(matrix[x][y])
                x += 1
            }
            right -= 1

            // Important: a single-column matrix is now complete.
            if left > right {
                break
            }

            // 3. Bottom row: right to left.
            x = bottom
            y = right

            while y >= left {
                result.append(matrix[x][y])
                y -= 1
            }
            bottom -= 1

            // There may be no remaining row for the left traversal.
            if top > bottom {
                break
            }

            // 4. Left column: bottom to top.
            x = bottom
            y = left

            while x >= top {
                result.append(matrix[x][y])
                x -= 1
            }
            left += 1
        }

        return result
    }
}


// GPT's summary:
//
// Your corrected boundary direction:
// - `top += 1`
// - `right -= 1`
// - `bottom -= 1`
// - `left += 1`
// - These were conceptually correct.
//
// Remaining logic problem:
// - After shrinking a boundary, the opposite side may no longer exist.
// - Your code immediately traversed it anyway.
// - This duplicates elements in a one-row or one-column matrix.
//
// Failing example: [[1, 2, 3]]
// - The top traversal adds 1, 2, 3.
// - top becomes 1 while bottom remains 0.
// - No rows remain.
// - The original code still traverses the bottom row and adds 2, 1 again.
//
// Correct checks:
// - After `top += 1`, stop if `top > bottom`.
// - After `right -= 1`, stop if `left > right`.
// - After `bottom -= 1`, stop if `top > bottom`.
//
// Why x and y should not control the outer loop:
// - x and y are temporary traversal positions.
// - At the end of a side, they intentionally move outside that side.
// - top, bottom, left, and right are the persistent state that determines
//   whether an unvisited rectangle remains.
//
// What you did well:
// - The four traversal directions were correct.
// - All four boundary updates are now correct.
// - Your while-loop implementation works once the boundary checks are added.
//
// Complexity:
// - Time: O(rows * columns)
// - Extra space: O(1), excluding the returned array.