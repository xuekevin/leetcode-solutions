class Solution {
    func maxProfit(_ prices: [Int]) -> Int {
        var buy = 0
        var sell = 1
        var profit = 0

       while sell < prices.count {
            if prices[sell] < prices[buy] {
                // basically final a lower price, then buy in
                buy = sell
            } else {
                // when we have profit,caculate and compare with the max one
                profit = max(profit, (prices[sell] - prices[buy]))
            }
            sell += 1
        }
        return profit
    }
}

// write directly, spend 10 mins
// still check the previous submit for help

