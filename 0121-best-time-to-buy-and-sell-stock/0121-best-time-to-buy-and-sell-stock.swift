// Your original solution:
//
// class Solution {
//     func maxProfit(_ prices: [Int]) -> Int {
//         if prices.count == 1 {
//             return 0
//         }
//         var left = 0
//         var right = prices.count - 1
//         var buy = left
//         var sell = right
//         var profit = prices[sell] - prices[buy]
//
//         while left < right {
//             if prices[buy + 1] < prices[buy] {
//                 buy += 1
//             }
//             
//             if prices[sell - 1] > prices[sell] {
//                 sell -= 1
//             }
//
//             if buy < sell {
//                 profit = max(profit, prices[sell] - prices[buy])
//             }
//             left += 1
//             right -= 1
//         }
//
//         return max(profit,0)
//     }
// }
//
// // Pattern: two pointer
// // Card shape: l
// // State needed:
// // Contract:      recursive → what's TRUE when a call returns
// //                iterative → what's TRUE at the top of every loop iteration
// // Recall:
//
// // maximum the profit, just get the diff
// // how to get the max profit
// // simulate the trun scenario
// // day 1 7 , day 2, 1, move to next,,
// // this is brute force way, not what I prefer
// // in order to get max, also need to buy first and sell later
// // so can maintain two pointers
// // left pointer fin the lowest buy price,
// // right pointer find the highest sell price
// // 16 mins, got wrong answer
// // ask gpt to fix


// Fixed version:
class Solution {
    func maxProfit(_ prices: [Int]) -> Int {
        guard prices.count > 1 else {
            return 0
        }

        // `buy` is the cheapest earlier day found so far.
        var buy = 0
        var sell = 1
        var maxProfit = 0

        while sell < prices.count {
            if prices[sell] < prices[buy] {
                // A cheaper price becomes the best buying opportunity
                // for all future selling days.
                buy = sell
            } else {
                // Good: buy is before sell, so the time order is valid.
                let currentProfit = prices[sell] - prices[buy]
                maxProfit = max(maxProfit, currentProfit)
            }

            sell += 1
        }

        return maxProfit
    }
}


// GPT's summary:
//
// Mistakes you made:
// - Finding a low price from the left and a high price from the right
//   independently does not guarantee they form the best transaction.
// - A local comparison such as prices[buy + 1] < prices[buy] does not find
//   the cheapest price seen across all earlier days.
// - Similarly, prices[sell - 1] > prices[sell] only detects a local change.
// - `left` and `right` changed, but they did not control which buy and sell
//   positions were examined, so they did not help the algorithm.
// - Spaces around `0` are preferred: `max(profit, 0)`.
//
// Key idea:
// - Treat every index as a possible selling day.
// - For each selling day, remember the cheapest buying price before it.
// - This guarantees that buying always happens before selling.
//
// Why two forward pointers work:
// - `buy` remembers the cheapest day seen so far.
// - `sell` examines every later day.
// - If sell finds a cheaper price, it becomes the new buy.
// - Otherwise, calculate the profit from buy to sell.
//
// Loop contract:
// - At the top of each iteration, `buy` is the index of the minimum price
//   among all days before or at `sell`.
// - `maxProfit` is the best valid profit found before the current sell day.
//
// What you did well:
// - You recognized that buying must happen before selling.
// - You recognized that only a few variables are needed.
// - A two-pointer greedy approach is appropriate; both pointers simply need
//   to move forward instead of starting at opposite ends.
//
// Complexity:
// - Time: O(n)
// - Space: O(1)