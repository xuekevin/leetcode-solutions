class Solution {
    func maxProfit(_ k: Int, _ prices: [Int]) -> Int {
        guard k > 0, prices.count > 1 else {
            return 0
        }

        // If k is large enough, the transaction limit does not matter.
        // We can take every positive price increase.
        if k >= prices.count / 2 {
            var profit = 0

            for i in 1..<prices.count {
                if prices[i] > prices[i - 1] {
                    profit += prices[i] - prices[i - 1]
                }
            }

            return profit
        }

        // buy[t]:
        // Best profit after buying a stock, using at most t transactions.
        var buy = Array(repeating: Int.min / 2, count: k + 1)

        // sell[t]:
        // Best profit after selling a stock, using at most t transactions.
        var sell = Array(repeating: 0, count: k + 1)

        for price in prices {
            // Keep yesterday's states.
            // This makes the transitions explicitly use prior-day information.
            let previousBuy = buy
            let previousSell = sell

            for transaction in 1...k {
                // Either keep holding from before,
                // or buy today after finishing up to transaction - 1 sales.
                buy[transaction] = max(
                    previousBuy[transaction],
                    previousSell[transaction - 1] - price
                )

                // Either keep the earlier sold profit,
                // or sell today after holding this transaction's stock.
                sell[transaction] = max(
                    previousSell[transaction],
                    previousBuy[transaction] + price
                )
            }
        }

        // At most k transactions: sell[k] is the best final profit.
        return sell[k]
    }
}

/*
 GPT's summary

 This is the general version of the at-most-two-transactions problem.

 For k = 2:
 buy[1]  = firstBuy
 sell[1] = firstSell
 buy[2]  = secondBuy
 sell[2] = secondSell

 State transitions:
 buy[t] = max(
     keep the old holding state,
     sell[t - 1] - current price
 )

 sell[t] = max(
     keep the old sold state,
     buy[t] + current price
 )

 Why the order is safe:
 - buy[t] can only come from sell[t - 1].
 - Therefore, transaction t - 1 must be sold before transaction t is bought.
 - `previousBuy` and `previousSell` make every transition use
   the prior day's state.

 Example:
 k = 2
 prices = [3, 2, 6, 5, 0, 3]

 Best transactions:
 buy at 2, sell at 6 = 4
 buy at 0, sell at 3 = 3
 total = 7

 Large-k optimization:
 - You cannot complete more than prices.count / 2 transactions.
 - If k is at least that large, use unlimited transactions:
   add every positive price increase.

 Complexity:
 - Time: O(k * n)
 - Space: O(k)
*/