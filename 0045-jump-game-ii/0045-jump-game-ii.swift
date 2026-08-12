// Your original solution:
//
// class Solution {
//     func jump(_ nums: [Int]) -> Int {
//         var currentEnd = 0
//         var farthest = 0
//         var jump = 0
//
//         for i in 0..<(nums.count - 1) {
//             farthest = max(farthest, i + nums[i])
//
//             if currentEnd == i {
//                 jump += 1
//                 currentEnd = farthest
//             }
//             if currentEnd >= nums.count - 1 {
//                 return jump
//             }
//         }
//         return jump
//     }
// }
// // I will just write directly
// // 3 mins, made mistake got wrong answer for case [2,3,1,1,4]
// // first check the example first
// // forgot to write the code when to return jump
// // fix. now try with the example again
// // the error I made is I use to write
// /**
// -
//
// if farthest >= nums.count - 1 {
//                 return jump
//             }
// */
// // should compare with currentEnd


// Reviewed version:
class Solution {
    func jump(_ nums: [Int]) -> Int {
        var currentEnd = 0
        var farthest = 0
        var jumps = 0

        // Good: no jump needs to start from the final index.
        for i in 0..<(nums.count - 1) {
            // This is the best boundary we could reach with one more jump
            // after examining indices through i.
            farthest = max(farthest, i + nums[i])

            if i == currentEnd {
                // We have finished examining all positions reachable
                // using the current number of jumps.
                jumps += 1

                // Commit the next jump.
                currentEnd = farthest

                // Correct: check currentEnd only after committing the jump.
                if currentEnd >= nums.count - 1 {
                    return jumps
                }
            }
        }

        return jumps
    }
}


// GPT's summary:
//
// What you did well:
// - Your retry is correct.
// - You remembered all three pieces of greedy state.
// - You correctly increment `jumps` only at the current range boundary.
// - You correctly identified why checking `farthest` too early is wrong.
//
// Key distinction:
// - `farthest` means:
//   "I have discovered that the next jump could reach this far."
//
// - `currentEnd` means:
//   "My counted jumps currently guarantee I can reach this far."
//
// Why checking `farthest` was wrong:
// - Example: [2, 3, 1, 1, 4]
// - After the first jump, currentEnd = 2 and jumps = 1.
// - At i = 1, farthest becomes 4.
// - This only discovers that the second jump can reach index 4.
// - The second jump has not been counted yet.
// - Returning `jumps` at that point would incorrectly return 1.
//
// Why checking `currentEnd` works:
// - `currentEnd` is updated only when i reaches the previous boundary.
// - At that moment, `jumps` is incremented.
// - Therefore, currentEnd and jumps always describe the same committed state.
//
// Loop contract:
// - At the top of each iteration, `currentEnd` is the farthest index
//   guaranteed reachable using `jumps` jumps.
// - `farthest` tracks how far one additional jump could reach.
//
// Small style improvement:
// - `jumps` is slightly clearer than `jump` because it stores a count.
//
// Complexity:
// - Time: O(n)
// - Space: O(1)