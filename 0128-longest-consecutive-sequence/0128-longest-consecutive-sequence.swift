class Solution {
    func longestConsecutive(_ nums: [Int]) -> Int {
        if nums.count <= 1 {
            return nums.count
        }
        
        // remove duplicate
        let numsSet = Set(nums)
        var maxStreak = 0

        for num in numsSet {
            // Always start for the smallest
            if !numsSet.contains(num-1) {
                var currentNum = num
                var streak = 1
                
                while numsSet.contains(currentNum+1) {
                    currentNum = currentNum + 1
                    streak+=1
                }

                maxStreak = max(streak, maxStreak)
            }
        }
        return maxStreak
    }
}

// #Thoughts
// because it is O(n) so I can't sort it,
// can only do one for loop
// thinking...
// 6 mins have no idea. going to check the discussion below, no help
// going to check my previous submit

// 11 mins, going to write the code. although I don't know why TC is O(n) seems there is a nest loop


