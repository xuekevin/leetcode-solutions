// Your original solution:
//
// class Solution {
//     func findPeakElement(_ nums: [Int]) -> Int {
//         if nums.count == 1 {
//             return 0
//         }
//
//         if nums.count == 2 {
//             return nums[0] > nums[1] ? 0 : 1
//         }
//
//         var left = 0
//         var right = nums.count - 1
//
//         while left <= right {
//             let middle = (left + right) / 2
//
//             if middle == 0 {
//                 if nums[middle] > nums[middle+1] {
//                     return middle
//                 } else {
//                     left = middle + 1
//                 }
//             }
//
//             if middle == nums.count - 1 {
//                 if nums[middle-1] < nums[middle] {
//                     return middle
//                 } else {
//                     right = middle  - 1
//                 }
//             }
//
//             if nums[middle-1] < nums[middle] && nums[middle] > nums[middle + 1] {
//                 return middle
//             } else if nums[middle-1] > nums[middle] {
//                 right = middle - 1
//             } else {
//                 left = middle + 1
//             }
//         }
//
//         return left
//     }
// }
//
//
// // Pattern: binary search
// // Card shape: create left and right, get middle, then update middle based on if it is peak value around neighour, consider the corner case
// // State needed: left, right, middle
// // Contract:      one round while get new middle then check if it is peak
// // Recall:         half
// // Thinking
// // the array is not sorted
// // need log n time, so think to use binary search
// // start form middle index,
// // if middle greater than neighor, then return
// // then first case 1 middle < "middle -1" , case 2 middle < "middle + 1"
// // case 1: middle is the new right
// // case 2: middle is the new left
// // when the while loop exit, when left > right
// // corner case, if middle = 0 or middle = n -1 , its one side neighbor is -OO
// // if it is possible there is no peak ?
// // for ordered array, 123, then peak is 3, or 321, peak is 3, index is 0, or n-1
// // for not ordered 132, it must have peak
// // ready to write code
// // 20 mins for the code
// // quick check the example with my code
// // looks good with the example, ready to run, 25 mins, pass
// // I do concern with the final case, about return left is correct or not,
// // but let's submit, got crash, so must some place cause infinite loop
// // time up, will let gpt to fix

// Fixed version: preserves your neighbor-checking approach.
class Solution {
    func findPeakElement(_ nums: [Int]) -> Int {
        if nums.count == 1 {
            return 0
        }

        var left = 0
        var right = nums.count - 1

        while left <= right {
            let middle = (left + right) / 2

            if middle == 0 {
                if nums[middle] > nums[middle + 1] {
                    return middle
                }

                left = middle + 1

                // Wrong: letting this boundary case fall through.
                // Why: the later code reads nums[middle - 1], or nums[-1].
                // Correct: continue after handling the boundary.
                continue
            }

            if middle == nums.count - 1 {
                if nums[middle - 1] < nums[middle] {
                    return middle
                }

                right = middle - 1
                continue
            }

            if nums[middle - 1] < nums[middle]
                && nums[middle] > nums[middle + 1] {
                return middle
            } else if nums[middle - 1] > nums[middle] {
                right = middle - 1
            } else {
                left = middle + 1
            }
        }

        return left
    }
}

// Upgrade version: rename UpgradeSolution to Solution before submitting.
// Compare only middle and middle + 1, so no boundary checks are needed.
class UpgradeSolution {
    func findPeakElement(_ nums: [Int]) -> Int {
        var left = 0
        var right = nums.count - 1

        while left < right {
            let middle = (left + right) / 2

            if nums[middle] > nums[middle + 1] {
                // The slope goes downward, so a peak exists at middle
                // or somewhere to its left.
                right = middle
            } else {
                // The slope goes upward, so a peak exists to the right.
                left = middle + 1
            }
        }

        // left == right, and that index is a peak.
        return left
    }
}

// GPT's summary:
// What you did well:
// - You correctly recognized that O(log n) requires binary search.
// - Your “move toward the higher side” intuition is the key idea.
// - You correctly considered both edge elements as possible peaks.
//
// Mistakes you made:
// - After handling middle == 0 or middle == lastIndex, the code continued
//   and accessed an out-of-bounds neighbor.
// - Use `continue` after a boundary case, or use the upgrade version to
//   avoid boundary cases entirely.
//
// Fixed version:
// - Keeps your explicit left-neighbor and right-neighbor checks.
// - Time: O(log n), space: O(1).
//
// Upgrade version:
// - Checks only `nums[middle]` and `nums[middle + 1]`.
// - `left < right` guarantees middle + 1 is always a valid index.
// - Time: O(log n), space: O(1).