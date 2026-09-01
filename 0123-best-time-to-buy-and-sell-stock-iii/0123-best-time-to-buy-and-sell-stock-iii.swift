// Your original solution:
// class Solution {
//    func maxProfit(_ prices: [Int]) -> Int {
//    }
// }
//
// // Thinking
// // at most two tranaction
// // how to maximum the profit
// // for loop price from i = 0
// // choose i as buy date
// // if price[i + 1] > prices[i], the caculate cur profit
// // and keep for loop, if saw larger prices, update the sell day, caculate the profit
// // if saw low prices, even start a new buy day
//
// // then add the total for two parts
// // question this might can't make sure this is the max profit


class Solution {
    func maxProfit(_ prices: [Int]) -> Int {
        guard !prices.isEmpty else {
            return 0
        }

        // Best profit after buying the first stock.
        // Buying costs money, so this starts as a negative profit.
        var firstBuy = -prices[0]

        // Best profit after selling the first stock.
        var firstSell = 0

        // Best profit after buying the second stock.
        // This includes the profit from the first completed transaction.
        var secondBuy = -prices[0]

        // Best profit after selling the second stock.
        var secondSell = 0

        for price in prices {
            // Either keep the earlier first buy,
            // or buy today as the first transaction.
            firstBuy = max(firstBuy, -price)

            // Either keep the earlier first sell,
            // or sell today after the best first buy.
            firstSell = max(firstSell, firstBuy + price)

            // Either keep the earlier second buy,
            // or use firstSell profit to buy again today.
            secondBuy = max(secondBuy, firstSell - price)

            // Either keep the earlier second sell,
            // or sell today after the best second buy.
            secondSell = max(secondSell, secondBuy + price)
        }

        // At most two transactions means we may use zero, one, or two.
        return secondSell
    }
}

/*
 GPT's summary

 Good:
 - You correctly recognized there can be at most two transactions.
 - You also correctly questioned whether greedy local buy/sell choices
   always produce the global maximum. They do not always.

 State meaning:
 - firstBuy:
   best profit after one buy and no sell yet.
 - firstSell:
   best profit after completing one buy + sell transaction.
 - secondBuy:
   best profit after buying again, after possibly completing transaction one.
 - secondSell:
   best profit after completing up to two transactions.

 Example:
 prices = [3, 3, 5, 0, 0, 3, 1, 4]

 After price 5:
 firstBuy = -3
 firstSell = 2

 After price 0:
 firstBuy = 0
 firstSell = 2
 secondBuy = 2

 After price 4:
 secondSell = 6

 The two transactions are:
 buy at 0, sell at 3 = 3
 buy at 1, sell at 4 = 3
 total = 6

 Important formula:
 - Buy:
   current money - price
 - Sell:
   previous buy state + price

 Complexity:
 - Time: O(n)
 - Space: O(1)
*/