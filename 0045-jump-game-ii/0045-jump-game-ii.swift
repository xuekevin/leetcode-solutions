class Solution {
    func jump(_ nums: [Int]) -> Int {
        var currentEnd = 0
        var farthest = 0
        var jump = 0

        for i in 0..<(nums.count - 1) {
            farthest = max(farthest, i + nums[i])

            if currentEnd == i {
                jump += 1
                currentEnd = farthest
            }
            if currentEnd >= nums.count - 1 {
                return jump
            }
        }
        return jump
    }
}
// I will just write directly
// 3 mins, made mistake got wrong answer for case [2,3,1,1,4]
// first check the example first
// forgot to write the code when to return jump
// fix. now try with the example again
