// Your original solution:
// class Solution {
//     func longestConsecutive(_ nums: [Int]) -> Int {
//         if nums.count <= 1 {
//             return nums.count
//         }
//         
//         // remove duplicate
//         let numsSet = Set(nums)
//         var maxStreak = 0
//
//         for num in numsSet {
//             // Always start for the smallest
//             if !numsSet.contains(num-1) {
//                 var currentNum = num
//                 var streak = 1
//                 
//                 while numsSet.contains(currentNum+1) {
//                     currentNum = currentNum + 1
//                     streak+=1
//                 }
//
//                 maxStreak = max(streak, maxStreak)
//             }
//         }
//         return maxStreak
//     }
// }
//
// // #Thoughts
// // because it is O(n) so I can't sort it,
// // can only do one for loop
// // thinking...
// // 6 mins have no idea. going to check the discussion below, no help
// // going to check my previous submit
//
// // 11 mins, going to write the code. although I don't know why TC is O(n) seems there is a nest loop

class Solution {
    func longestConsecutive(_ nums: [Int]) -> Int {
        if nums.count <= 1 {
            return nums.count
        }

        // Good: Set removes duplicates and gives average O(1) lookup.
        // Why it works: we need to quickly ask "does num + 1 exist?"
        let numsSet = Set(nums)
        var maxStreak = 0

        for num in numsSet {
            // Good: only start counting when `num` is the beginning of a sequence.
            // Why it works: if `num - 1` exists, then `num` is not the start,
            // so counting from it would duplicate work.
            if !numsSet.contains(num - 1) {
                var currentNum = num
                var streak = 1

                // Good: this nested loop is still O(n) overall.
                // Why it works: each number is only walked as part of one sequence,
                // because we only enter this loop from the smallest number in that sequence.
                while numsSet.contains(currentNum + 1) {
                    currentNum += 1
                    streak += 1
                }

                maxStreak = max(maxStreak, streak)
            }
        }

        return maxStreak
    }
}

// GPT's summary:
// What you did well:
// - Your solution is correct.
// - You correctly avoided sorting because sorting would be O(n log n).
// - You used a Set to remove duplicates and make lookup fast.
// - The key insight is checking `!numsSet.contains(num - 1)` so you only start from sequence beginnings.
//
// Key idea:
// - Even though there is a nested `while` loop, the total work is still O(n).
// - Example: for [1, 2, 3, 4], only 1 starts the while loop.
// - 2, 3, and 4 are skipped as starting points because each has a previous number.
// - So each number participates in sequence expansion only once overall.
//
// Swift syntax to remember:
// - `Set(nums)` creates a Set from an Array.
// - `numsSet.contains(x)` checks membership in average O(1).
// - `currentNum += 1` is shorthand for `currentNum = currentNum + 1`.
// - `max(a, b)` returns the larger value.
//
// Complexity:
// - Time: O(n), where n is `nums.count`.
// - Space: O(n), because the Set can store all unique numbers.