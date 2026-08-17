// Your original solution:
//
// class Solution {
//     var selectedArr = [Bool]()
//     var maxMoney = 0
//     func rob(_ nums: [Int]) -> Int {
//         if nums.count == 1 {
//             return nums[0]
//         }
//         selectedArr = Array(repeating: false, count: nums.count)
//         helper(nums, 0, 0)
//         return maxMoney
//     }
//
//     func helper(_ nums: [Int], _ cur: Int, _ curAmount: Int) {
//         if cur == nums.count - 1 {
//             if selectedArr[cur - 1] == false {
//                 selectedArr[cur] = true
//                 maxMoney = max(maxMoney, curAmount + nums[cur])
//             } else {
//                maxMoney =  max(maxMoney, curAmount)
//             }
//             return
//         }
//
//         if selectedArr[cur - 1] == false || cur == 0 {
//             // select current
//             selectedArr[cur] = true
//             helper(nums, cur + 1, curAmount + nums[cur])
//             selectedArr[cur] = false
//             helper(nums, cur + 1, curAmount)
//         } else if selectedArr[cur - 1] == true {
//             // can only unselect
//             selectedArr[cur] = false
//             helper(nums, cur + 1, curAmount)
//         }
//     }
// }
//
// // Pattern: greedy
// // Card shape: recursive, for every index, I can decide select or unselect, and pass down the amount I get so far, once I get end of the foor loop, then I will know the maxAmount I can get so far
// // State needed: maxAount, curAmount, selectedArr, or I can just change it to previousSelect to a variable,
// // Contract:      every choose, I got a new curAmount, and whether I choose cur item or not. and move to next item along with these info.
// // Recall:         half
//
// // Thinking
// // feels like the greedy, since we want to get maxMoney
// // definitely doesn't want to do brute force
// // every node, has 2 option, choose or not
// // when exit?
// // choice i, then can't choose i+1
// // but can choose i+2, but which means can't choose i+3
// // seems like a greedy problem
// // make a choice the upgrage the choice result
// // then unmake choice
// // kind like a tree, make a choose, then go to next one
// // finish writing in 24 mins
// // got a crash, related to index


// Fixed version: preserves your recursive choose/unchoose approach.
// will cause time limit exceeded. so use the below gpt's solution 
class OriginSolution {
    var selectedArr = [Bool]()
    var maxMoney = 0

    func rob(_ nums: [Int]) -> Int {
        selectedArr = Array(repeating: false, count: nums.count)

        // Reset global state in case the same Solution instance is reused.
        maxMoney = 0

        helper(nums, 0, 0)
        return maxMoney
    }

    func helper(_ nums: [Int], _ cur: Int, _ curAmount: Int) {
        // A simpler base case: all houses have been considered.
        if cur == nums.count {
            maxMoney = max(maxMoney, curAmount)
            return
        }

        // Wrong:
        // selectedArr[cur - 1] == false || cur == 0
        //
        // Why:
        // Swift evaluates the left side first, so cur == 0 attempts
        // to access selectedArr[-1] and crashes.
        //
        // Correct:
        // Check cur == 0 first so short-circuit evaluation prevents
        // the invalid index access.
        if cur == 0 || selectedArr[cur - 1] == false {
            // Choose the current house.
            selectedArr[cur] = true
            helper(nums, cur + 1, curAmount + nums[cur])

            // Unmake the choice.
            selectedArr[cur] = false
        }

        // Do not choose the current house.
        selectedArr[cur] = false
        helper(nums, cur + 1, curAmount)
    }
}


// Upgrade version: dynamic programming with O(1) space.
class Solution {
    func rob(_ nums: [Int]) -> Int {
        // Best result through the house two positions behind.
        var previousTwo = 0

        // Best result through the previous house.
        var previousOne = 0

        for money in nums {
            // Choice 1: skip this house and keep previousOne.
            // Choice 2: rob this house and add it to previousTwo.
            let current = max(
                previousOne,
                previousTwo + money
            )

            previousTwo = previousOne
            previousOne = current
        }

        return previousOne
    }
}


// GPT's summary:
//
// Main crash:
// - When cur == 0, `selectedArr[cur - 1]` accesses index -1.
// - Swift evaluates `||` from left to right.
// - Put the safe condition first:
//   `cur == 0 || selectedArr[cur - 1] == false`
//
// Algorithm classification:
// - Your recursive solution is backtracking/brute force, not greedy.
// - It explores both choices: rob the current house or skip it.
// - The upgraded solution is dynamic programming because the best answer
//   through house i depends on answers to smaller overlapping subproblems.
//
// Dynamic-programming formula:
// - best[i] = max(best[i - 1], best[i - 2] + nums[i])
//
// Meaning:
// - Skip house i: keep best[i - 1].
// - Rob house i: add nums[i] to best[i - 2] because i - 1 cannot be robbed.
// - Choose whichever option gives more money.
//
// Example: [2, 7, 9, 3, 1]
// - House 2: max(0, 0 + 2) = 2
// - House 7: max(2, 0 + 7) = 7
// - House 9: max(7, 2 + 9) = 11
// - House 3: max(11, 7 + 3) = 11
// - House 1: max(11, 11 + 1) = 12
//
// What you did well:
// - You correctly identified the choose/unchoose decision tree.
// - You correctly knew that choosing one house prevents choosing the next.
// - You correctly passed the accumulated amount through recursion.
// - You also noticed that a Boolean `previousSelected` could replace the
//   entire selectedArr; that observation was correct.
//
// Swift syntax to remember:
// - `||` uses left-to-right short-circuit evaluation.
// - Put the condition that prevents unsafe access first.
// - Reset mutable class properties at the start of a public method when a
//   Solution instance might be reused.
//
// Complexity:
// - Fixed backtracking version: O(2^n) time and O(n) space.
// - Dynamic-programming version: O(n) time and O(1) space.