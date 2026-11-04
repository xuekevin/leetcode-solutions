class Solution {
    func maxProfit(_ prices: [Int]) -> Int {
        guard !prices.isEmpty else {
            return 0
        }


        var firstBuy = -prices[0]

        var firstSell = 0

        var secondBuy = -prices[0]

        var secondSell = 0

        for i in 1..<prices.count {
            // Either keep the earlier first buy,
            // or buy today as the first transaction.
            firstBuy = max(firstBuy, -prices[i])

            // Either keep the earlier first sell,
            // or sell today after the best first buy.
            firstSell = max(firstSell, firstBuy + prices[i])

            // Either keep the earlier second buy,
            // or use firstSell profit to buy again today.
            secondBuy = max(secondBuy, firstSell - prices[i])

            // Either keep the earlier second sell,
            // or sell today after the best second buy.
            secondSell = max(secondSell, secondBuy + prices[i])
        }

        // At most two transactions means we may use zero, one, or two.
        return secondSell
    }
}