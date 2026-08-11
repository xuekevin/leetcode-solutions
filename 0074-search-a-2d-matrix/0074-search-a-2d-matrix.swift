// Your original solution:
//
// class Solution {
//     func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
//         var left = 0
//         var row = matrix.count
//         var column = matrix[0].count
//         var right = row * column - 1
//
//         // close interval
//         while left <= right {
//             let middle = (left + right) / 2
//             // convert middle back to the matrix row and column
//             let x = middle / row
//             let y = middle % row - 1
//
//             let cur = matrix[x][y]
//
//             if cur == target {
//                 return true
//             } else if cur > target {
//                 right = middle - 1
//             } else {
//                 left = middle + 1
//             }
//         }
//         return false
//     }
// }
//
// // Pattern: Binary search
// // Card shape: left, and right, get middle ,then compare with target
// // State needed: need to maintain the left and right
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed
// // 1mins start to write
// // use 7 mins to finish
// // use example to quick verify
// // Example 1
// // round 1: 11 / 2 = 5, x: 5 / 3 = 1, y: 5 % 3 - 1= 1
// // right = 4
// // round 2: middle = 2, x: 0, y: 1
// // found it ,seems right
// // ready to run
// // got crash, assume in the place I caculate matrix[x][y]
// // ask gpt to fix


// Fixed version:
class Solution {
    func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
        // Prevent matrix[0] from crashing for an empty matrix.
        guard !matrix.isEmpty, !matrix[0].isEmpty else {
            return false
        }

        let rows = matrix.count
        let columns = matrix[0].count

        var left = 0
        var right = rows * columns - 1

        // Good: this is a correct closed-interval binary search.
        while left <= right {
            let middle = left + (right - left) / 2

            // Wrong:
            // let x = middle / rows
            // let y = middle % rows - 1
            //
            // Why:
            // Every matrix row contains `columns` elements.
            // Therefore, division and remainder must use `columns`.
            // Array indices are already zero-based, so do not subtract 1.
            let x = middle / columns
            let y = middle % columns

            let current = matrix[x][y]

            if current == target {
                return true
            } else if current > target {
                right = middle - 1
            } else {
                left = middle + 1
            }
        }

        return false
    }
}


// GPT's summary:
//
// Mistakes you made:
// - You divided by the number of rows instead of the number of columns.
// - You calculated the column using `% rows` instead of `% columns`.
// - You subtracted 1 from the column, which can create index -1 and crash.
// - `rows` and `columns` do not change, so they should use `let`, not `var`.
//
// Index conversion to remember:
// - rowIndex = flatIndex / numberOfColumns
// - columnIndex = flatIndex % numberOfColumns
//
// Example with 3 rows and 4 columns:
// - Flat index 5
// - rowIndex = 5 / 4 = 1
// - columnIndex = 5 % 4 = 1
// - Therefore, index 5 maps to matrix[1][1].
//
// Why your manual test looked correct:
// - You used 3 for both calculations and then subtracted 1.
// - For flat index 5, that accidentally produced [1][1].
// - Other indices, especially 0, reveal the problem:
//   0 % 3 - 1 = -1, which crashes.
//
// What you did well:
// - Treating the matrix as a virtual one-dimensional sorted array is correct.
// - Your closed-interval binary search is correct.
// - You do not need to create a real flattened array.
//
// Complexity:
// - Time: O(log(rows * columns))
// - Space: O(1)