// Your original solution:
//
// class Solution {
//     var dp = [Int]()
//     func coinChange(_ coins: [Int], _ amount: Int) -> Int {
//         dp = Array(repeating: -1, count: amount + 1)
//         return helper(coins, amount)
//     }
//
//     func helper(_ coins: [Int], _ amount: Int) -> Int {
//         if amount <= 0 {
//             return -1
//         }
//
//         if coins.contains(amount) {
//             dp[amount] = 1
//             return dp[amount]
//         }
//         if dp[amount] != -1 {
//             return dp[amount]
//         }
//
//         for i in 0..<coins.count {
//             let sub = dp[amount - coins[i]]
//             if sub == -1 {
//                 continue
//             }
//             if dp[amount] == -1 {
//                 dp[amount] = sub + 1
//             } else {
//                 dp[amount] = min(dp[amount], sub + 1)
//             }
//         }
//         return dp[amount]
//     }
// }
//
// // Think
// // still can do top down
// // also can use dp array to track the duplicate sub problem
// // 10 mins finish, now checking
// // seems good to me,start to run
// // again got compiler error, silly typo
// // also found some logic mistake fix all the logic again
// // still compile error, another typo, fix
// // still compile error, another typo + 1, fix
// // no compiler error, but wrong answer, which means I didn't check example carefully
// // already 22 mins, ask gpt to fix

// Fixed version: your top-down memoization approach.
class Solution {
    // -2 means "not calculated yet".
    // -1 means "impossible to make this amount".
    var dp = [Int]()

    func coinChange(_ coins: [Int], _ amount: Int) -> Int {
        dp = Array(repeating: -2, count: amount + 1)
        dp[0] = 0

        return helper(coins, amount)
    }

    func helper(_ coins: [Int], _ amount: Int) -> Int {
        // Wrong: `if amount <= 0 { return -1 }`
        // Why: amount 0 needs zero coins, so it is a valid base case.
        if amount < 0 {
            return -1
        }

        if dp[amount] != -2 {
            return dp[amount]
        }

        var minimumCoins = Int.max

        for coin in coins {
            // Wrong: reading `dp[amount - coin]` directly.
            // Why: that smaller subproblem may not be calculated yet,
            // and amount - coin can be negative.
            // Correct: recursively calculate the smaller subproblem.
            let subproblem = helper(coins, amount - coin)

            if subproblem != -1 {
                minimumCoins = min(minimumCoins, subproblem + 1)
            }
        }

        dp[amount] = minimumCoins == Int.max ? -1 : minimumCoins
        return dp[amount]
    }
}

// Upgrade version: rename UpgradeSolution to Solution before submitting.
// Bottom-up DP avoids recursion and is often easier to debug.
class UpgradeSolution {
    func coinChange(_ coins: [Int], _ amount: Int) -> Int {
        if amount == 0 {
            return 0
        }

        // `amount + 1` is impossible because the answer cannot use
        // more than `amount` coins when every coin value is positive.
        let impossible = amount + 1
        var dp = Array(repeating: impossible, count: amount + 1)
        dp[0] = 0

        for currentAmount in 1...amount {
            for coin in coins {
                if coin <= currentAmount {
                    dp[currentAmount] = min(
                        dp[currentAmount],
                        dp[currentAmount - coin] + 1
                    )
                }
            }
        }

        return dp[amount] == impossible ? -1 : dp[amount]
    }
}

// GPT's summary:
// What you did well:
// - Top-down DP is a correct pattern for this problem.
// - You correctly identified repeated subproblems and introduced a dp array.
// - You were trying to minimize over all possible final coins, which is
//   exactly the right recurrence.
//
// Mistakes you made:
// - Amount 0 returns 0, not -1.
// - `-1` cannot represent both “not calculated” and “impossible”.
// - A dp value cannot be used until its smaller subproblem is calculated.
// - `amount - coin` can be negative, so direct array indexing can crash.
//
// Key idea:
// - For each coin, solve the remaining amount: amount - coin.
// - If that smaller amount is possible, add one for the current coin.
// - Choose the smallest valid answer.
//
// Fixed version complexity:
// - Time: O(amount * numberOfCoins).
// - Space: O(amount) for memoization and recursion.
//
// Upgrade version complexity:
// - Time: O(amount * numberOfCoins).
// - Space: O(amount), with no recursion stack.