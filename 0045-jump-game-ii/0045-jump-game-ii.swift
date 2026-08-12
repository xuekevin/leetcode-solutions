// Your original solution:
//
// class Solution {
//     func jump(_ nums: [Int]) -> Int {
//         var result = nums.count
//         var furtherest = 0
//         var count = 0
//
//         for i in 0..<nums.count {
//             // need to figure out when we update the jump count
//
//             count += 1
//             
//             // current furthest can make less jump from index i
//             furtherest = max(furtherest, i + nums[i])
//             
//             if furthest == nums.count - 1 {
//                 return count
//             }
//
//             // guaranteed that I can always reach nums[n-1]
//         }
//     }
// }
//
// // Pattern: Greedy
// // Card shape:
// // State needed:
// // Contract:      recursive → what's TRUE when a call returns
// //                iterative → what's TRUE at the top of every loop iteration
// // Recall:
//
// // so this is for the minimum to reach the last index
// // how to define minimum
// // the brute force is to traverse all the path go to the n -1, then compare them
// // vaguely recall, we can do in recursive way ?
// // jump to n-1, just need to track the minimum jump for each index
// // how to track the jump I had made so far ?
// // kind of sleepy when read today's doc
// // so try to figure out by myself, in 20 mins
// // how to record the jump I made so far
// // for index i, I just record the minmum jump to current index
// // so i = 0, the mini is 0
// // for i = 1, the mini jump, who can reach index 1, the jump count
// // or we don't care the jump count for each index
// // since we only care the n - 1
// // so need a path to record the furthest along with the jump count to here
//
// // time up
// // ask gpt to help


// Fixed version:
class Solution {
    func jump(_ nums: [Int]) -> Int {
        if nums.count <= 1 {
            return 0
        }

        var jumps = 0

        // The end of the range reachable using `jumps` jumps.
        var currentEnd = 0

        // The farthest position reachable from every index
        // examined inside the current range.
        var furthest = 0

        // We do not need to jump from the final index.
        for i in 0..<(nums.count - 1) {
            // Good: keep the best destination available from this range.
            furthest = max(furthest, i + nums[i])

            if i == currentEnd {
                // We have examined every position reachable with
                // the current number of jumps, so another jump is required.
                jumps += 1

                // Greedily choose the range that reaches farthest.
                currentEnd = furthest

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
// Mistakes you made:
// - You increased `count` at every index, but visiting an index in the loop
//   does not mean that we made another jump.
// - `furtherest` and `furthest` are different variable names, causing a
//   compile error.
// - The original function did not return an Int on every path.
// - `result` was declared but never used.
// - Use `>= nums.count - 1`, because the farthest jump may pass the last index.
//
// State needed:
// - `furthest`: farthest index reachable while examining the current range.
// - `currentEnd`: boundary reachable with the current number of jumps.
// - `jumps`: number of jumps used to reach `currentEnd`.
//
// Loop contract:
// - At the top of each iteration, every index through `currentEnd` is
//   reachable using `jumps` jumps.
// - While examining that range, `furthest` records the boundary reachable
//   with one additional jump.
//
// When to increase the jump count:
// - Do not increase it for every index.
// - Increase it only when `i == currentEnd`.
// - This means we finished examining every choice available from the
//   current jump and must commit to the next jump.
//
// Example: [2, 3, 1, 1, 4]
// - Start: jumps = 0, currentEnd = 0
// - i = 0: furthest = 2
//   Reached currentEnd, so jumps = 1 and currentEnd = 2
// - i = 1: furthest = 4
// - i = 2: reached currentEnd, so jumps = 2 and currentEnd = 4
// - The last index is reachable, so return 2.
//
// What you did well:
// - You recognized this as a greedy problem.
// - You correctly identified `furthest` as necessary state.
// - Your thought that we need the farthest position together with its
//   jump count was heading toward the correct solution.
//
// Complexity:
// - Time: O(n)
// - Space: O(1)