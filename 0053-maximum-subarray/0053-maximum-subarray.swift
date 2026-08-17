// Your original solution:
//
// class Solution {
//     func maxSubArray(_ nums: [Int]) -> Int {
//         if nums.count == 1 {
//             return nums[0]
//         }
//
//         var currentSum = nums[0]
//         var maxSum = currentSum
//
//         for item in nums.dropFirst() {
//             if currentSum < 0 {
//                 currentSum = item
//             } else {
//                 currentSum += item
//             }
//             maxSum = max(maxSum, currentSum)
//         }
//         return maxSum
//     }
// }
//
// // Pattern: Array
// // Card shape: check my describe below
// // State needed: currentSum, maxSum
// // Contract:      update the maxSum or keep growing currentSum, or reset currentSum
// // Recall:        landed / half / blank
// // Thinking
// // how to get the maximum
// // if current num[i] < 0, update current maxSum with current num, also update currentSum with nums[i]
// // if currentSum < 0, can reset currentSum and start from nums[i], as the new start, also update maxSum
// // think I can start to write, 5 mins
// // finish writing in 13 mins
// // use example to verify, looks good
// // run, find a compile error, should call dropFirst() method, not dropFirst
// // submit pass


// Reviewed version:
class Solution {
    func maxSubArray(_ nums: [Int]) -> Int {
        // The problem guarantees that nums is nonempty.
        var currentSum = nums[0]
        var maxSum = nums[0]

        for item in nums.dropFirst() {
            // Good: a negative previous sum can only make the next
            // subarray worse, so discard it and restart at item.
            if currentSum < 0 {
                currentSum = item
            } else {
                currentSum += item
            }

            // Keep the best subarray found anywhere so far.
            maxSum = max(maxSum, currentSum)
        }

        return maxSum
    }
}


// GPT's summary:
//
// What you did well:
// - Your solution is correct and passed.
// - This is Kadane's algorithm.
// - You correctly tracked both currentSum and maxSum.
// - You correctly restarted the subarray when currentSum became negative.
// - You initialized both values with nums[0], which correctly handles
//   arrays containing only negative numbers.
//
// Why resetting works:
// - Suppose currentSum is -3 and the next item is 5.
// - Extending gives -3 + 5 = 2.
// - Restarting at 5 gives 5.
// - Therefore, a negative prefix can never improve a future subarray.
//
// Why currentSum and maxSum are different:
// - `currentSum` is the best sum of a subarray ending at the current item.
// - `maxSum` is the best sum found at any position so far.
//
// Loop contract:
// - At the top of each iteration, currentSum is the maximum subarray sum
//   ending at the previously processed item.
// - maxSum is the maximum subarray sum among all processed items.
//
// Equivalent compact expression:
// - `currentSum = max(item, currentSum + item)`
// - This chooses between starting a new subarray and extending the old one.
//
// Swift syntax to remember:
// - `dropFirst()` is a method, so parentheses are required.
// - `nums.dropFirst()` returns every element except the first.
// - The special `nums.count == 1` case is unnecessary because the normal
//   initialization and loop already handle it.
//
// Complexity:
// - Time: O(n)
// - Space: O(1)