// Your original solution:
//
// class Solution {
//     func findMin(_ nums: [Int]) -> Int {
//         var left = 0
//         var right = nums.count - 1
//
//         while left < right {
//             let middle = (left + right) / 2
//             if nums[middle] < nums[middle + 1] {
//                 // peak is in right side, so move left to middle + 1
//                 left = middle + 1
//             } else {
//                 // peak is in left side, so move right be middle
//                 right = middle
//             }
//         }
//
//         if left + 1 == nums.count {
//             return nums[0]
//         } else {
//             return nums[left + 1]
//         }
//     }
// }
//
// // Pattern: about find middle can use binary search, especially it used to be sorted array, also it need log(n)
// // Card shape:
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank
// // Thinking:
// // Seems like the peak value we just addressed, find the peak value, because it sorted, so it can only have one peak number,  the peak number's next is the minimum.
// // 5 mins ready to write code
// // 11 mins to finish, got a compiler error, made a silly mistake
// // let index = (left + 1) % nums.count, return nums[index]
// // seems can't return correct answer
// // change the code to above,still not correct
// // ask gpt to fix


// Fixed version:
class Solution {
    func findMin(_ nums: [Int]) -> Int {
        var left = 0
        var right = nums.count - 1

        // Contract:
        // The minimum always remains inside nums[left...right].
        while left < right {
            let middle = left + (right - left) / 2

            // Compare middle with the right boundary.
            if nums[middle] > nums[right] {
                // The rotation point and minimum must be after middle.
                // middle cannot be the minimum because nums[right] is smaller.
                left = middle + 1
            } else {
                // nums[middle] <= nums[right] means middle...right is sorted.
                // The minimum is middle itself or somewhere to its left.
                right = middle
            }
        }

        // left == right, so only the minimum candidate remains.
        return nums[left]
    }
}

// GPT's summary:
//
// Mistakes you made:
// - The main issue was not Swift syntax; it was the binary-search comparison.
// - Comparing nums[middle] with nums[middle + 1] only detects a local slope.
// - An increasing slope can appear both before and after the rotation point.
// - Therefore, an increasing slope does not prove that the minimum is on the right.
//
// Failing example:
// - nums = [5, 6, 7, 0, 1, 2, 3, 4]
// - middle points to 0, and 0 < 1.
// - Your code moves left to the right, throwing away the real minimum, 0.
//
// Key idea:
// - Compare nums[middle] with nums[right].
// - nums[middle] > nums[right]:
//   middle is in the larger, left section, so minimum is to its right.
// - nums[middle] <= nums[right]:
//   middle is in the sorted right section, so minimum is at middle or to its left.
// - Use right = middle because middle could itself be the minimum.
//
// What you did well:
// - Binary search is the correct pattern.
// - while left < right is correct.
// - You correctly targeted O(log n) time.
//
// Complexity:
// - Time: O(log n)
// - Space: O(1)