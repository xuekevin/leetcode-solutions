// Your original solution:
//
// class Solution {
//     func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
//         var mLeft = 0
//         var mRight = matrix.count - 1
//         var nLeft = 0
//         var nRight = matrix[0].count - 1
//
//         while mLeft <= mRight && nLeft <= nRight {
//             var mMiddle = (mLeft + mRight) / 2
//             var nMiddle = (nLeft + nRight) / 2
//
//             var cur = matrix[mMiddle][nMiddle]
//
//             if cur == target {
//                 return true
//             }
//
//             if cur < target {
//                 if matrix[mMiddle][nRight] == target {
//                    return true
//                 }
//
//                 if matrix[mMiddle][nRight] > target {
//                     // convert to 1 level
//                 } else {
//                     mLeft = mMiddle + 1
//                 }
//             } else {
//                 if matrix[mMiddle][nLeft] == target {
//                    return true
//                 }
//
//                 if matrix[mMiddle][nLeft] < target {
//                     // convert to 1 level
//                 } else {
//                     mLeft = mMiddle - 1
//                     if m
//                 }
//             }
//         }
//
//     }
//
//     func helper ()
// }
//
// // Thinking
// // it looks in order search in o(log(m*n))
// // should in binary search
// // so thing is can we covert this m x n to a 1 level array
// // or when do binary search, or I can know how to move between 2D
// // think it is not left right, also a level of the array, so that's the 2D
//
// // Pattern: Binary Search
// // Card shape:
// // check if two pointers, x, use x to compare m
// // use y to compare n
// // still compare middle, but we can also compare with the matrix[middle][0] and matrix[middle][n-1] before change middle
// // State needed:
// // Contract: compare with the matrix[middleM][middleN] with target
// // Recall:        half
// // 6 mins start to write code
// // times is up, already 23 mins,
// // ready to ask gpt
// // couple thoughts, maybe it also worth to convert 2D to 1 D array first
// // then do binary search, since we only need to check if it is exist, we don't need to return index

class Solution {
    func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
        guard !matrix.isEmpty, !matrix[0].isEmpty else {
            return false
        }

        let rowCount = matrix.count
        let columnCount = matrix[0].count

        // Treat the matrix as one virtual sorted array:
        // [matrix[0][0], matrix[0][1], ..., matrix[1][0], ...]
        var left = 0
        var right = rowCount * columnCount - 1

        while left <= right {
            let middle = (left + right) / 2

            // Convert virtual 1D index back into matrix coordinates.
            let row = middle / columnCount
            let column = middle % columnCount
            let current = matrix[row][column]

            if current == target {
                return true
            } else if current < target {
                left = middle + 1
            } else {
                right = middle - 1
            }
        }

        return false
    }
}

// GPT's summary:
// What you did well:
// - You correctly recognized that the matrix can be searched in O(log(m * n)).
// - You correctly considered converting the 2D matrix into a 1D view.
// - You do not need to physically create a new 1D array.
//
// Key idea:
// - Use one binary-search range from 0 through m * n - 1.
// - Convert a virtual 1D index to 2D coordinates:
//   row = index / columnCount
//   column = index % columnCount
//
// Example for 3 columns:
// - Virtual index 0 -> row 0, column 0.
// - Virtual index 4 -> row 1, column 1.
// - Virtual index 8 -> row 2, column 2.
//
// Mistakes you made:
// - Separate row and column pointers do not represent one continuous
//   binary-search range.
// - The matrix ordering is globally sorted, so one virtual index is simpler
//   and avoids complex row-boundary cases.
//
// Swift syntax to remember:
// - `/` gives the row number.
// - `%` gives the column number.
// - `guard !matrix.isEmpty, !matrix[0].isEmpty` prevents index crashes.
//
// Complexity:
// - Time: O(log(m * n)).
// - Space: O(1).