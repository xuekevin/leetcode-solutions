// Your original solution:
//
// class Solution {
//     func maxProfit(_ prices: [Int]) -> Int {
//         var buy = 0
//         var profit = 0
//         
//         for i in 1..<prices.count {
//             if prices[i] > prices[buy] {
//                 profit += prices[i] - prices[buy]
//             }
//             buy = i
//         }
//         return profit
//     }
// }
//
//
// // Pattern: Greedy
// // Card shape: do the for loop, update the profit is price[i] > prices[buy]
// // State needed: buy index
// // Contract:      update the buy index for every time loop, and profit if we have profit
//
// // Thinking
// // to get max profit
// //core buy low and sell high
// // also we don't want to do brute force
// // first find a low price to buy
// // for next price, if it is high.
// // then we can sell, get part profit
// // and keep the new sell price as t he buy price
// // then we got a lower price, then we update to the new buy price
// // use examles to verify
// // ready to write
// // 10 mins for most code
// // use example to verify
// // seems ok
// // ready to run, made a silly mistake, fix it
// // ready to submit


// Reviewed version:
class Solution {
    func maxProfit(_ prices: [Int]) -> Int {
        guard prices.count > 1 else {
            return 0
        }

        var previousDay = 0
        var totalProfit = 0

        for currentDay in 1..<prices.count {
            // Good: collect every positive day-to-day increase.
            if prices[currentDay] > prices[previousDay] {
                totalProfit += prices[currentDay] - prices[previousDay]
            }

            // The next comparison should use the current day.
            previousDay = currentDay
        }

        return totalProfit
    }
}


// GPT's summary:
//
// What you did well:
// - Your original solution is correct.
// - You identified the correct greedy pattern.
// - You correctly ignored every price decrease.
// - You correctly added every positive consecutive difference.
// - You achieved the optimal time and space complexity.
//
// Small naming improvement:
// - `buy` works, but the variable actually represents the previous day.
// - `previousDay` makes the loop's behavior more explicit.
//
// Why adding daily profits gives the maximum:
// - Suppose prices rise from 1 to 3 to 5.
// - One transaction gives: 5 - 1 = 4.
// - Your method gives:
//   (3 - 1) + (5 - 3) = 2 + 2 = 4.
// - The intermediate price cancels, so both methods produce the same profit.
//
// General identity:
// - For an increasing section:
//   (b - a) + (c - b) + (d - c) = d - a
// - Therefore, collecting every positive daily increase is equivalent to
//   buying at the valley and selling at the peak.
//
// Why decreases are ignored:
// - Example: [5, 3]
// - Buying at 5 and selling at 3 loses money.
// - Since transactions are optional, the best contribution is 0.
//
// Loop contract:
// - At the top of each iteration, `totalProfit` contains every profitable
//   increase before `currentDay`.
// - `previousDay` is the day immediately before `currentDay`.
//
// Important difference from Best Time to Buy and Sell Stock I:
// - Stock I allows only one transaction, so track the cheapest earlier buy.
// - Stock II allows unlimited transactions, so collect every positive
//   consecutive increase.
//
// Complexity:
// - Time: O(n)
// - Space: O(1)