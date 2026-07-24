// Your original solution:
// class Solution {
//     func minSubArrayLen(_ target: Int, _ nums: [Int]) -> Int {
//         
//         var left = 0
//         var right = 0
//         
//         var minLength = nums.count + 1
//         var curSum = 0
//
//         for item in nums {
//             curSum += item 
//             right += 1
//             if curSum >= target {
//                 minLength = min(minLength, right - left + 1)
//                 // Think to shirk the window
//                 curSum -= nums[left]
//                 left += 1
//             }
//         }        
//
//         while curSum >= target {
//             minLength = min(minLength, right - left + 1)
//             
//             curSum -= nums[left]
//             left += 1
//         }
//
//         if minLength == nums.count + 1 {
//             return 0
//         }
//         
//         return minLength 
//     }
// }
//
// //# Thoughts
// // first thought is this subarray, so I should be able to use window
// // all we need a length
// // so basica logic is for loop the nums, then add the item into the window
// // if it meets the condition, which is sum >= target, then we found one
// // update the length, also think to shirk the window
// // so window length we use left and right to maintain
// // what we need to store in window? 
// // 5 mins so far, think we can write code
//
// // 10 mins so far
//
// // now using exmaple to verify
//
// // 19 mins so far, ready to complier the code
// // some compile error 
// // should no need to use Interger.MAX as the minLength's inital value
// // change to nums.count + 1
// // got wrong answer
// // means I didn't check the example very careful
// // already spend 28 mins, going to ask gpt to fix the issue

class Solution {
    func minSubArrayLen(_ target: Int, _ nums: [Int]) -> Int {
        var left = 0
        var curSum = 0
        var minLength = nums.count + 1

        for right in 0..<nums.count {
            // Good: expand the window by adding the right-side number.
            curSum += nums[right]

            // Wrong: using `if curSum >= target`.
            // Why: after finding a valid window, you may be able to shrink multiple times.
            // Correct: use `while curSum >= target` to keep shrinking until the window becomes invalid.
            while curSum >= target {
                // Wrong: right - left + 1 in your code used a manually incremented `right`.
                // Why: your `right` represented count/end-after-index, so `+ 1` made the length too large.
                // Correct: here `right` is the actual index, so length is `right - left + 1`.
                minLength = min(minLength, right - left + 1)

                // Good: shrink from the left after recording the valid length.
                curSum -= nums[left]
                left += 1
            }
        }

        return minLength == nums.count + 1 ? 0 : minLength
    }
}

// GPT's summary:
// Mistakes you made:
// - Your sliding window idea was correct.
// - The main bug was using `if curSum >= target`; it should be `while curSum >= target`.
// - You put another `while curSum >= target` after the for loop, but shrinking must happen immediately after each expansion.
// - Your manual `right += 1` made length calculation confusing.
// - With your `right` style, `right - left + 1` was off by one because `right` was already one past the current index.
//
// Key idea:
// - Expand the window by moving `right`.
// - Once `curSum >= target`, the window is valid.
// - Then shrink from `left` as much as possible while it stays valid.
// - This finds the shortest valid window ending at each `right`.
//
// Swift syntax to remember:
// - `for right in 0..<nums.count` gives you the actual index.
// - `right - left + 1` is the length when both `left` and `right` are real indices.
// - `while condition { ... }` repeats shrinking until the condition is false.
// - `condition ? a : b` is Swift's ternary expression.
//
// Complexity:
// - Time: O(n), because each element is added once by `right` and removed once by `left`.
// - Space: O(1), because we only store pointers, sum, and min length.