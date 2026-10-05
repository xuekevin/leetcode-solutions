class Solution {
    func minSubArrayLen(_ target: Int, _ nums: [Int]) -> Int {
        // slide window
        var left = 0
        var right = 0
        var sum = 0
        var result = Int.max

        // increase right if sum < target
        // once >= target
        // store the right - left
        // then shirnk the window, move left until it is no longer >= target
        // then move right again
        // the exit condition is we go the end of the nums array
        
        

        while right < nums.count {
            sum += nums[right]
            while sum >= target {
                result = min(result, right - left + 1)
                sum -= nums[left]
                left += 1
                // ? is it possible left > right?, not sure
            }
            right += 1
        }
        
        if result == Int.max {
            return 0
        } else {
            return result
        }
    }
}