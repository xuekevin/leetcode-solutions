// Your original solution:
//
// class Solution {
//     func productExceptSelf(_ nums: [Int]) -> [Int] {
//         var results = Array(repeating: 1, count: nums.count)
//
//         i = nums.count - 1
//         var product = 1
//         j = 0
//
//         while i > 0 {
//             let item = nums[i]
//
//             if j != i {
//                 nums[j] = nums[j] * item * product
//             }
//             product = nums[j]
//             i -= 1
//             j += 1
//
//
//         }
//     }
// }
//
// // Pattern: Array, two pointers
// // Card shape: do foor loop and on nums, create same size result array,
// // when do foor loop, also modify corresponding result's value
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank
//
// // thinking
// // need to do without division
// // so how can you know
// // also follow is O(1)
// // need for O(n) which means we can only do one loop
// // let's first try can have more extra space
// // 7 mins so far, have a general thoughts
// // already 15 mins
// // give up
// // will let gpt help


// Fixed version:
class Solution {
    func productExceptSelf(_ nums: [Int]) -> [Int] {
        guard !nums.isEmpty else {
            return []
        }

        var results = Array(repeating: 1, count: nums.count)

        // First pass:
        // results[i] becomes the product of everything LEFT of i.
        for i in 1..<nums.count {
            results[i] = results[i - 1] * nums[i - 1]
        }

        // Stores the product of everything RIGHT of the current index.
        var rightProduct = 1

        // Second pass: move from right to left.
        for i in stride(from: nums.count - 1, through: 0, by: -1) {
            // Left product is already in results[i].
            // Multiply it by the right product.
            results[i] *= rightProduct

            // Add nums[i] to the right product for the next index.
            rightProduct *= nums[i]
        }

        return results
    }
}


// GPT's summary:
//
// Mistakes you made:
// - `i` and `j` were used without being declared with `var` or `let`.
// - `nums` is not declared `inout`, so you cannot write `nums[j] = ...`.
// - The function returns `[Int]` but the original code did not return a value.
// - `(i + k) / count` belonged to the previous rotation problem and is not
//   useful for this product problem.
// - Two pointers moving toward each other do not naturally provide the full
//   left product and right product for every index.
//
// Main misunderstanding:
// - O(n) does not mean that only one loop is allowed.
// - Two separate loops of n iterations are:
//   O(n) + O(n) = O(2n) = O(n).
// - Nested loops may produce O(n²), but sequential loops remain O(n).
//
// Key formula:
// - answer[i] = product of values left of i
//             * product of values right of i
//
// Example: [1, 2, 3, 4]
//
// After the left-product pass:
// - results = [1, 1, 2, 6]
// - Index 0 has nothing on its left, so its left product is 1.
// - Index 1: 1
// - Index 2: 1 * 2 = 2
// - Index 3: 1 * 2 * 3 = 6
//
// During the right-product pass:
// - Start rightProduct = 1
// - i = 3: results[3] = 6 * 1  = 6
// - i = 2: results[2] = 2 * 4  = 8
// - i = 1: results[1] = 1 * 12 = 12
// - i = 0: results[0] = 1 * 24 = 24
//
// Final result:
// - [24, 12, 8, 6]
//
// Why 1 is the starting value:
// - 1 is the multiplication identity.
// - Multiplying by 1 does not change the product.
// - When no values exist on one side, that side's product is treated as 1.
//
// Swift syntax to remember:
// - Initialize an array:
//   `Array(repeating: 1, count: nums.count)`
// - Traverse backward:
//   `stride(from: nums.count - 1, through: 0, by: -1)`
// - `through: 0` includes index 0.
// - `to: 0` would exclude index 0.
//
// Space requirement:
// - The returned `results` array normally does not count as extra space.
// - Only `rightProduct` is additional working storage.
//
// Complexity:
// - Time: O(n)
// - Extra space: O(1), excluding the returned array.