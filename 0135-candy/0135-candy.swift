// Your key idea was right:
// every child gets at least one candy first.
// Then we must satisfy both left-neighbor and right-neighbor rules.

class Solution {
    func candy(_ ratings: [Int]) -> Int {
        guard ratings.count > 1 else {
            return ratings.count
        }

        // Start by giving every child one candy.
        var candies = Array(repeating: 1, count: ratings.count)

        // Left-to-right:
        // Higher rating than the left neighbor -> more candy.
        for i in 1..<ratings.count {
            if ratings[i] > ratings[i - 1] {
                candies[i] = candies[i - 1] + 1
            }
        }

        // Right-to-left:
        // Higher rating than the right neighbor -> more candy.
        for i in stride(from: ratings.count - 2, through: 0, by: -1) {
            if ratings[i] > ratings[i + 1] {
                // Keep whichever direction requires more candy.
                candies[i] = max(candies[i], candies[i + 1] + 1)
            }
        }

        return candies.reduce(0, +)
    }
}

/*
 GPT's summary

 Your single left-to-right idea fails for a decreasing section:

 ratings = [1, 5, 6, 2, 1]

 The child with rating 6 must have more candy than:
 - rating 5 on the left
 - rating 2 on the right

 Therefore, we need two passes.

 Important syntax/logic correction:
 - Wrong: ratings[i] > ratings[i] + 1
 - Correct: ratings[i] > ratings[i - 1]
            ratings[i] > ratings[i + 1]

 Complexity:
 - Time: O(n)
 - Space: O(n)
*/