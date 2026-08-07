// Your original solution:
//
// class Solution {
//     func searchInsert(_ nums: [Int], _ target: Int) -> Int {
//         var left = 0
//         var right = nums.count - 1
//         var middle = (left + right) / 2
//         while left < right && right >= 0 {
//             middle = (left + right) / 2
//             if nums[middle] == target {
//                 return middle
//             } else if nums[middle] < target {
//                 left = middle + 1
//             } else {
//                 right = middle - 1
//             }
//         }
//
//         return left
//     }
// }
// // Pattern: Binary search
// // Card shape: for loop the array, with left right pointers
// // State needed: compare with target, then update
// // Contract:      compare the middle with the target, move left and right after compare, if index's value can't find then it is the place to insert
// // Recall:        half
//
// // start to write in 3 mins
// // write code in 8 mins, now check with example
// // notice there is forever loop
// // should use left = middle + 1, or right = middle - 1
// // spend 16 already, spend more time on what if can't find target
// // ready to ask gpt

class Solution {
    func searchInsert(_ nums: [Int], _ target: Int) -> Int {
        var left = 0
        var right = nums.count - 1

        // Wrong: `while left < right`
        // Why: it exits when left == right, before checking whether the
        // target belongs after the final element.
        // Correct: continue while the search range is not empty.
        while left <= right {
            let middle = (left + right) / 2

            if nums[middle] == target {
                return middle
            } else if nums[middle] < target {
                // Good: target can only be to the right of middle.
                left = middle + 1
            } else {
                // Good: target can only be to the left of middle.
                right = middle - 1
            }
        }

        // Good: when the range becomes empty, left is the insertion index.
        return left
    }
}

// GPT's summary:
// What you did well:
// - You chose the correct binary-search pattern.
// - You fixed the infinite-loop risk by moving middle with +1 or -1.
// - You correctly understood that if the target is not found, the answer
//   is its insertion position.
//
// Mistake you made:
// - `left < right` misses the case where target belongs after every value.
// - Example: nums = [1, 3, 5, 6], target = 7.
//   Your old code returns 3, but the correct insertion index is 4.
//
// Key idea:
// - Search while `left <= right`.
// - When target is greater than nums[middle], move left to middle + 1.
// - When target is smaller, move right to middle - 1.
// - When the loop finishes, `left` is the first valid insertion index.
//
// Complexity:
// - Time: O(log n).
// - Space: O(1).