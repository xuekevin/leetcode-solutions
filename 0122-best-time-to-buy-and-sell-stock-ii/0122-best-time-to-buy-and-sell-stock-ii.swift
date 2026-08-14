class Solution {
    func maxProfit(_ prices: [Int]) -> Int {
        var buy = 0
        var profit = 0
        
        for i in 1..<prices.count {
            if prices[i] > prices[buy] {
                profit += prices[i] - prices[buy]
            }
            buy = i
        }
        return profit
    }
}


// Pattern: Greedy
// Card shape: do the for loop, update the profit is price[i] > prices[buy]
// State needed: buy index
// Contract:      update the buy index for every time loop, and profit if we have profit

// Thinking
// to get max profit
//core buy low and sell high
// also we don't want to do brute force
// first find a low price to buy
// for next price, if it is high.
// then we can sell, get part profit 
// and keep the new sell price as t he buy price
// then we got a lower price, then we update to the new buy price
// use examles to verify
// ready to write
// 10 mins for most code
// use example to verify
// seems ok
// ready to run, made a silly mistake, fix it
// ready to submit


