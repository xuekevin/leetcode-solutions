class Solution {
    func maxSubArray(_ nums: [Int]) -> Int {
        if nums.count == 1 {
            return nums[0]
        }

        var currentSum = nums[0]
        var maxSum = currentSum

        for item in nums.dropFirst() {
            if currentSum < 0 {
                currentSum = item
            } else {
                currentSum += item
            }
            maxSum = max(maxSum, currentSum)
        }
        return maxSum
    }
}

// Pattern: Array
// Card shape: check my describe below
// State needed: currentSum, maxSum
// Contract:      update the maxSum or keep growing currentSum, or reset currentSum
// Recall:        landed / half / blank
// Thinking
// how to get the maximum
// if current num[i] < 0, update current maxSum with current num, also update currentSum with nums[i]
// if currentSum < 0, can reset currentSum and start from nums[i], as the new start, also update maxSum
// think I can start to write, 5 mins
// finish writing in 13 mins
// use example to verify, looks good
// run, find a compile error, should call dropFirst() method, not dropFirst




