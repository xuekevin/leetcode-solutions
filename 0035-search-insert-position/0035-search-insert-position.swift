// Your original solution:
//
// class Solution {
//     func searchInsert(_ nums: [Int], _ target: Int) -> Int {
//         var left = 0
//         var right = nums.count - 1
//
//         while left < right {
//             var middle = (left + right) / 2
//             if nums[middle] == target {
//                 return middle
//             } else if nums[middle] < target {
//                 left = middle + 1
//             } else {
//                 right = middle - 1
//             }
//         }
//         return left + 1
//     }
// }
//
// // Pattern: Binary search
// // Card shape: caculate the middle
// // State needed: update left and right
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed
//
// // start to write 1 mins, since I know what I want to do
// // finish writing in 3 mins
// // but I still not sure whether should be while left <= right, or just left < right
// // or should left = middle, or left = middle + 1, same question for updating right
// // now using example to figure out
// // you can tell me the real approach
// // fix the final return be return left + 1 instead of return left
// // now try to submit
// // got wrong answer whith example 1
// // which should't
// // fix it, but still got wrong answer for case [1,3,5,6] target 0,
// // ask gpt to fix, since this is a retry


// Fixed version: closed interval [left, right]
class Solution {
    func searchInsert(_ nums: [Int], _ target: Int) -> Int {
        var left = 0
        var right = nums.count - 1

        // Correct: both left and right are valid candidates,
        // so continue while left <= right.
        while left <= right {
            // Good: middle is not changed, so use let.
            let middle = left + (right - left) / 2

            if nums[middle] == target {
                return middle
            } else if nums[middle] < target {
                // middle is too small, so remove it.
                left = middle + 1
            } else {
                // middle is too large, so remove it.
                right = middle - 1
            }
        }

        // When the loop finishes:
        // right < left
        // Everything before left is smaller than target.
        // Everything from left onward is larger than target.
        return left
    }
}


// Upgrade version: lower-bound binary search
// This directly searches for the first index whose value is >= target.
// Rename UpgradeSolution to Solution before submitting.
class UpgradeSolution {
    func searchInsert(_ nums: [Int], _ target: Int) -> Int {
        var left = 0
        var right = nums.count // Exclusive boundary

        while left < right {
            let middle = left + (right - left) / 2

            if nums[middle] < target {
                left = middle + 1
            } else {
                // middle might be the answer, so keep it.
                right = middle
            }
        }

        return left
    }
}


// GPT's summary:
//
// Mistakes you made:
// - You mixed two binary-search templates.
// - With right = nums.count - 1 and right = middle - 1,
//   the loop should use left <= right.
// - return left + 1 is incorrect because insertion may be at index 0.
// - For [1, 3, 5, 6] and target 0, the answer is 0, not 1.
//
// Binary-search templates to remember:
//
// 1. Closed interval [left, right]:
//    - right = nums.count - 1
//    - while left <= right
//    - left = middle + 1
//    - right = middle - 1
//    - return left
//
// 2. Half-open interval [left, right):
//    - right = nums.count
//    - while left < right
//    - left = middle + 1
//    - right = middle
//    - return left
//
// Important rule:
// - Do not choose each line independently.
// - Pick one interval contract, then use all rules belonging to it.
//
// What you did well:
// - You correctly recognized the binary-search pattern.
// - left = middle + 1 was correct when nums[middle] < target.
//
// Complexity:
// - Fixed version: O(log n) time and O(1) space.
// - Upgrade version: O(log n) time and O(1) space.