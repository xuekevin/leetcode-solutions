// Your original solution:
//
// class Solution {
//     var dp = [Int]()
//     func climbStairs(_ n: Int) -> Int {
//         // forgot how init array with count, check online
//         dp = Array(repeating: -1, count: n + 1)
//         return helper(n)
//     }
//
//     func helper(_ n: Int) -> Int {
//         if n == 1 || n == 2 {
//             return n
//         }
//
//         if dp[n] != -1 {
//             return dp[n]
//         }
//
//         dp[n] = helper(n-1) + helper(n-2)
//         return dp[n]
//     }
// }
// // decompose the issue
// // from top to down
// // start to write
// // 6 mins finish
// // checking, seems fine
// // start run, oops compile error, again, didn't check the issue before I run
// // should init var dp: [Int], when declare
// // fix, but the issue again, have a typo climbStair, should be climbStairs
// // oops another issue, crash
// // made a mistake, should create a helper, other will reinit dp every time
// // fix, still crash, lol
// // now checking again, I should call my new helper method in my new helper method, while I still call climbStairs
// // so silly
// // pass and submit

// Fixed version: your top-down memoization approach.
class Solution {
    var dp = [Int]()

    func climbStairs(_ n: Int) -> Int {
        // Good: create one memo array before starting recursion.
        dp = Array(repeating: -1, count: n + 1)
        return helper(n)
    }

    func helper(_ n: Int) -> Int {
        // Good: base cases.
        // One step has 1 way; two steps have 2 ways.
        if n == 1 || n == 2 {
            return n
        }

        // Good: return the saved answer instead of recalculating it.
        if dp[n] != -1 {
            return dp[n]
        }

        // To reach step n, the final move came from n - 1 or n - 2.
        dp[n] = helper(n - 1) + helper(n - 2)
        return dp[n]
    }
}

// Upgrade version: rename UpgradeSolution to Solution before submitting.
// Bottom-up DP needs no recursion and no dp array.
class UpgradeSolution {
    func climbStairs(_ n: Int) -> Int {
        if n <= 2 {
            return n
        }

        var twoStepsBefore = 1 // Ways to reach step 1.
        var oneStepBefore = 2  // Ways to reach step 2.

        for _ in 3...n {
            let current = twoStepsBefore + oneStepBefore
            twoStepsBefore = oneStepBefore
            oneStepBefore = current
        }

        return oneStepBefore
    }
}

// GPT's summary:
// What you did well:
// - You recognized the top-down recursive structure.
// - You correctly created a separate helper so dp is initialized only once.
// - You correctly used memoization to avoid repeated recursive work.
//
// Key idea:
// - Ways(n) = Ways(n - 1) + Ways(n - 2).
// - The final move is either one step or two steps.
//
// Swift syntax to remember:
// - Initialize a fixed-size array with:
//   `Array(repeating: -1, count: n + 1)`.
// - `dp[n] != -1` means the answer for n is already calculated.
//
// Fixed version complexity:
// - Time: O(n).
// - Space: O(n) for dp and the recursion stack.
//
// Upgrade version complexity:
// - Time: O(n).
// - Space: O(1).