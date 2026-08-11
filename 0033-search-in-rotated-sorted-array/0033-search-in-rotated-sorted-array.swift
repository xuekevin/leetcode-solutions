// Your original solution:
//
// class Solution {
//     func search(_ nums: [Int], _ target: Int) -> Int {
//         var left = 0
//         var right = nums.count - 1
//
//         while left <= right {
//             let middle = left + (right - left) / 2
//
//             if nums[middle] == target {
//                 return middle
//             }
//
//             if nums[left] <= nums[middle] {
//                 if nums[middle] <= nums[right] {
//                    if nums[middle] > target {
//                     right = middle - 1
//                    } else {
//                     left = middle + 1
//                    }
//                 } else {
//
//                 }
//             }
//
//         }
//     }
// }
//
//
// // Pattern: binary search,
// // Card shape: get middle from left and right then compare with target, but because it is roated, we should check current partial sort to decide the order
// // State needed: left, right ,middle
// // Contract:      what is TRUE when one call returns?
// // Recall:         half
// // thinking the contract before I write the code, already 2 mins
// // when we find the middle
// // if middle == target done
// // if middle != target, then we also check the left and right with target, and middle
// // left < middle < right, which means the target is in the partial order part,then is no peak,
// // if left < middle, middle > right, so there is first part is ascending ,second part is decending,
// // if middle < target, then return -1
// // if middle > target, then right = middle - 1
//
// // if left > middle > right,
// // middle < target, left = middle +1
// // middle > target, right = middle - 1
//
// // that's all cases I can think
// // ready to write the code
// // so contract is adjust the middle, based on the partial order
// // I realized I write too many if else check, not the right approach, already 15 mins
// // abort, ask gpt to help


// Fixed version:
class Solution {
    func search(_ nums: [Int], _ target: Int) -> Int {
        var left = 0
        var right = nums.count - 1

        // Contract:
        // If target exists, it remains inside nums[left...right].
        while left <= right {
            let middle = left + (right - left) / 2

            if nums[middle] == target {
                return middle
            }

            // In a rotated sorted array, at least one half is sorted.
            if nums[left] <= nums[middle] {
                // The left half is sorted: [left...middle].

                if nums[left] <= target && target < nums[middle] {
                    // Target is inside the sorted left half.
                    right = middle - 1
                } else {
                    // Target cannot be in the sorted left half.
                    left = middle + 1
                }
            } else {
                // The right half is sorted: [middle...right].

                if nums[middle] < target && target <= nums[right] {
                    // Target is inside the sorted right half.
                    left = middle + 1
                } else {
                    // Target cannot be in the sorted right half.
                    right = middle - 1
                }
            }
        }

        // Wrong: the original function did not return on every path.
        // Correct: return -1 when target does not exist.
        return -1
    }
}


// GPT's summary:
//
// Mistakes you made:
// - You correctly tried to identify the sorted half, but then added
//   another unnecessary check between middle and right.
// - A rotated sorted array contains two ascending sections.
//   The second section is not descending.
// - Comparing only target with nums[middle] is insufficient.
//   First identify a sorted half, then check whether target is in its range.
// - The original function was missing `return -1`.
//
// Key decision:
//
// 1. Is the left half sorted?
//    nums[left] <= nums[middle]
//
// 2. If yes, is target inside its value range?
//    nums[left] <= target && target < nums[middle]
//
// 3. Otherwise, the right half is sorted.
//    Check:
//    nums[middle] < target && target <= nums[right]
//
// Why one half must be sorted:
// - The rotation point can only appear in one half.
// - The other half does not cross the rotation point, so it remains sorted.
//
// Boundary syntax to remember:
// - Closed interval: [left, right]
// - Loop: while left <= right
// - Remove middle and everything after it: right = middle - 1
// - Remove middle and everything before it: left = middle + 1
//
// What you did well:
// - You chose the correct binary-search pattern.
// - Your middle calculation was correct.
// - You recognized that rotation requires an extra sorted-half check.
//
// Complexity:
// - Time: O(log n)
// - Space: O(1)