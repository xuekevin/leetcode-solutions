class Solution {
    func minSubArrayLen(_ target: Int, _ nums: [Int]) -> Int {
        
        var left = 0
        var right = 1
        var length = nums.count + 1

        var curSum = nums[left]

        while right <= nums.count {
            while curSum >= target && left < right {
                length = min(length, right - left)
                curSum -= nums[left]
                left += 1
            }
            if right < nums.count {
                curSum += nums[right]
            }
            right += 1
        }

        if length > nums.count {
            return 0
        }
        return length
    }
}
// Pattern: slide window
// Card shape: minimum lengght
// State needed: 
// Recall: half
// basically will track a window,  increase right, until we find the subarray
// then shrink to get the minimal length
// then move right again
// finish code in 10 mins
// now use example to verify
// seems fine
// ready to run
// compiler error, no Integer.max, use nums.count + 1
// no compiler, but wrong answer 
// means I didn't use example to verify carefully
// fix the issue
// now submit



