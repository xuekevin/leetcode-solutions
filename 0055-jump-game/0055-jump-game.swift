class Solution {
    func canJump(_ nums: [Int]) -> Bool {
        var furthest = 0

        for i in 0..<nums.count {
            furthest = max(furthest, i + nums[i])

            if furthest >= nums.count - 1 {
                return true
            }

            if furthest <= i {
                // means can't go further than i index
                return false
            }
        }
        
        return false     
    }
}

// Pattern: Greedy
// Card shape: get the furthest of each index, then after the loop to check if it bigger than last index
// State needed: furthest
// Contract:      recursive → what's TRUE when a call returns
//                iterative → what's TRUE at the top of every loop iteration
// Recall:        (leave blank until you're done)
// start to write, since I just rend the doc
// for each step
// current furthest length for index i is 
// i + j
//  0 <= j <= nums[i]
// so for index i, the step it go is i + 0, i + 1, .. i + nums[j]
// all we need to find for current index i, then furthest length, as long as it bigger than n, means you can reach the end
// wo, we do this check furthest = max(furthest, i + nums[i]), which is the furthest for current index j
// verify my logic with example
// i = 0, furtherest: 2
// 1, 1 + 3 = 4 
// 2, 2 + 1 = 3, 3 < 4
// 3, 3 + 1 = 4, 4 = 4
// 4, 4 + 4 = 8,  max is 8

// example 2
// 0, 3
// 1. 1+2
// 2, 2+1 3
// 3, 3+0 3 
// 
// 16 mins so far, check synatx
// ready to submit, still got synatx, error 
//  for i in 0..< nums.count {
    // |                       `- error: expected '{' to start the body of for-each loop


// fix it
// run pass, ready to submit
// got wrong answer for case [0], should return [true]
