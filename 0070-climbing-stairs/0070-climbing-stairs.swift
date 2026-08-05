class Solution {
    var dp = [Int]()
    func climbStairs(_ n: Int) -> Int {
        // forgot how init array with count, check online
        dp = Array(repeating: -1, count: n + 1)
        return helper(n)
    }

    func helper(_ n: Int) -> Int {
        if n == 1 || n == 2 {
            return n
        }
        
        if dp[n] != -1 {
            return dp[n]
        }

        dp[n] = helper(n-1) + helper(n-2)
        return dp[n]
    }
}
// decompose the issue
// from top to down
// start to write
// 6 mins finish
// checking, seems fine
// start run, oops compile error, again, didn't check the issue before I run
// should init var dp: [Int], when declare
// fix, but the issue again, have a typo climbStair, should be climbStairs
// oops another issue, crash
// made a mistake, should create a helper, other will reinit dp every time
// fix, still crash, lol
// now checking again, I should call my new helper method in my new helper method, while I still call climbStairs
// so silly





