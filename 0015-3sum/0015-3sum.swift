// Your original solution:
// class Solution {
//     func threeSum(_ nums: [Int]) -> [[Int]] {
//         var result = [[Int]]()
//         for (i, value) in nums.enumerated() {
//             let answer = twoSum(nums, i+1, -value)
//             if answer.count != 0 {
//                 result.append(answer)
//             }
//         }
//         return result
//     }
//
//     func twoSum(_ nums: [Int], _ startIndex: Int, _ target: Int) -> [Int] {
//         var dict = [Int:Int]()
//         var j = startIndex 
//         while (j < nums.count) {
//             if let _ = dict[target - nums[j]] {
//                 return [-target, target - nums[j], nums[j]]
//             }
//             dict[nums[j] = j
//             j = j + 1
//         }
//         return []
//     }
// }
//
// // #Thoughts
//
// // nums[i] + nums[j] = - nums[k]
//
// // dynamic target, so need a foor loop as a wrapper, inside is the basic two sum sum issume
//
// // 2 mins start to write code
//
// // 10 mins so far, finish writing, now checking the code
//
// // use 3 mins confirmed it is correct, ready to submit
// // got below synatx error
//
// // dict[nums[j] = j
// // 21 |             j+=1
// //    |             `- error: expected ',' separator
// // going to use gpt to check

class Solution {
    func threeSum(_ nums: [Int]) -> [[Int]] {
        // Wrong idea: using normal twoSum directly on the unsorted array.
        // Why: Three Sum needs unique triplets, so duplicates become hard to avoid.
        // Correct: sort first, then use two pointers while skipping duplicates.
        let nums = nums.sorted()
        var result = [[Int]]()

        for i in 0..<nums.count {
            // Good: each loop chooses one fixed number.
            // Why it works: after fixing nums[i], the problem becomes twoSum for target -nums[i].

            // Wrong missing check: not skipping duplicate fixed values.
            // Why: without this, nums like [-1, -1, 0, 1] can produce duplicate triplets.
            // Correct: skip nums[i] if it is the same as nums[i - 1].
            if i > 0 && nums[i] == nums[i - 1] {
                continue
            }

            var left = i + 1
            var right = nums.count - 1

            while left < right {
                let sum = nums[i] + nums[left] + nums[right]

                if sum == 0 {
                    result.append([nums[i], nums[left], nums[right]])

                    left += 1
                    right -= 1

                    // Correct: skip duplicate left values after finding a valid triplet.
                    while left < right && nums[left] == nums[left - 1] {
                        left += 1
                    }

                    // Correct: skip duplicate right values after finding a valid triplet.
                    while left < right && nums[right] == nums[right + 1] {
                        right -= 1
                    }
                } else if sum < 0 {
                    // Good: sorted array lets us move left to make sum bigger.
                    left += 1
                } else {
                    // Good: sorted array lets us move right to make sum smaller.
                    right -= 1
                }
            }
        }

        return result
    }
}

// GPT's summary:
// Mistakes you made:
// - The syntax error is here: `dict[nums[j] = j`.
// - Correct dictionary assignment is `dict[nums[j]] = j`.
// - Your twoSum-wrapper idea is close, but Three Sum also needs duplicate triplets removed.
// - Returning the first twoSum answer for each `i` can miss other valid pairs for the same fixed number.
// - The equation in your comment should be `nums[j] + nums[k] = -nums[i]` after fixing `i`.
//
// Swift syntax to remember:
// - Dictionary write syntax: `dict[key] = value`.
// - Array indexing inside dictionary subscript needs closing brackets: `dict[nums[j]] = j`.
// - `nums.sorted()` returns a sorted copy of the array.
// - `continue` skips the current loop iteration.
//
// Complexity:
// - Time: O(n^2), because each fixed `i` does a two-pointer scan.
// - Space: O(n) if counting the sorted copy; O(1) extra space besides output if sorting in place were allowed.