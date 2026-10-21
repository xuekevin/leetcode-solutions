class Solution {
    func rob(_ nums: [Int]) -> Int {
        if nums.count == 1 {
            return nums[0]
        }

        // Circle rule:
        // Cannot rob both first and last houses.
        return max(
            rob(nums, 0, nums.count - 2), // Do not use last house.
            rob(nums, 1, nums.count - 1)  // Do not use first house.
        )
    }

    func rob(_ nums: [Int], _ start: Int, _ end: Int) -> Int {
        var previousOne = 0 // Best answer through the previous house.
        var previousTwo = 0 // Best answer through the house before that.

        for i in start...end {
            // Either skip current house, or rob it plus previousTwo.
            let current = max(previousOne, previousTwo + nums[i])

            previousTwo = previousOne
            previousOne = current
        }

        return previousOne
    }
}

/*
GPT's summary

Your main logic is correct.

- Because houses are in a circle, house 0 and the final house cannot
  both be robbed.
- Split the problem into two normal House Robber problems:
    1. Houses 0...(n - 2)
    2. Houses 1...(n - 1)
- Return the larger answer.

DP meaning during each loop:
- previousOne: best money through i - 1
- previousTwo: best money through i - 2

At house i:
    max(previousOne, previousTwo + nums[i])

Time Complexity: O(n)
Space Complexity: O(1)
*/