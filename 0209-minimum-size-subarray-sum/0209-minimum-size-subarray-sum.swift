// Your original solution:
//
// class Solution {
//     func minSubArrayLen(_ target: Int, _ nums: [Int]) -> Int {
//
//         var left = 0
//         var right = 1
//         var length = nums.count + 1
//
//         var curSum = nums[left]
//
//         while right <= nums.count {
//             while curSum >= target && left < right {
//                 length = min(length, right - left)
//                 curSum -= nums[left]
//                 left += 1
//             }
//             if right < nums.count {
//                 curSum += nums[right]
//             }
//             right += 1
//         }
//
//         if length > nums.count {
//             return 0
//         }
//         return length
//     }
// }
// // Pattern: slide window
// // Card shape: minimum lengght
// // State needed:
// // Recall: half
// // basically will track a window,  increase right, until we find the subarray
// // then shrink to get the minimal length
// // then move right again
// // finish code in 10 mins
// // now use example to verify
// // seems fine
// // ready to run
// // compiler error, no Integer.max, use nums.count + 1
// // no compiler, but wrong answer
// // means I didn't use example to verify carefully
// // fix the issue
// // now submit, pass in 22 mins

class Solution {
    func minSubArrayLen(_ target: Int, _ nums: [Int]) -> Int {
        // Correct: protects `nums[left]` when the input is empty.
        guard !nums.isEmpty else {
            return 0
        }

        var left = 0
        var right = 1
        var minLength = nums.count + 1
        var currentSum = nums[left]

        // Good: right is an exclusive boundary.
        // The current window is nums[left..<right].
        while right <= nums.count {
            // Good: shrink repeatedly, not just once, to find the minimum
            // valid window ending at this right boundary.
            while currentSum >= target && left < right {
                minLength = min(minLength, right - left)
                currentSum -= nums[left]
                left += 1
            }

            if right < nums.count {
                currentSum += nums[right]
            }
            right += 1
        }

        return minLength > nums.count ? 0 : minLength
    }
}

// GPT's summary:
// What you did well:
// - Your sliding-window solution is correct and passed.
// - You correctly expand the window until the sum reaches target.
// - You correctly use a nested while loop to keep shrinking and find
//   the shortest valid window.
// - `nums.count + 1` is a good sentinel value because no valid answer
//   can be longer than nums.count.
//
// Key idea:
// - `left` and `right` describe a window: nums[left..<right].
// - Add values by moving right.
// - Once currentSum >= target, remove values by moving left until the
//   window is no longer valid.
//
// Swift syntax to remember:
// - `nums[left..<right]` uses a half-open range: left is included,
//   right is excluded.
// - For that range, length is `right - left`.
// - A ternary expression has the form:
//   `condition ? valueIfTrue : valueIfFalse`.
//
// Complexity:
// - Time: O(n). Even with nested loops, each pointer only moves forward
//   across the array at most n times.
// - Space: O(1).