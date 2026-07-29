// Your original solution:
// class Solution {
//     func removeDuplicates(_ nums: inout [Int]) -> Int {
//         var k = 0
//         var offset = 0
//         
//
//         while k < result {
//             var count = 1
//             while k + 1 < result {
//                 if offset != 0 && offset <= k {
//                     // update nums because the offset
//                     nums[k-offset] = nums[k]
//                 }
//
//                 if nums[k] == nums[k+1]
//
//                 count += 1
//                 k += 1
//                 if count == 3 {
//                     offset += 1
//                     count -= 1
//                 }  
//             }
//
//             if offset != 0 && offset <= k {
//                 // update nums because the offset
//                 nums[k-offset] = nums[k]
//             }
//         }
//         return nums.count - offset
//     }
// }
//
// // # Thoughts
// // Pattern: go from back to avoid overlap, since it is inplace change
// // Card shape: compare current with previous in while also and if it is more than 2 equal, start to update the "index" of final result,
// // State needed: the current last index
// // Recall: half 
// // 5 mins so far
// // ready to write base on what I have
// // 13 mins to finish the code writing, now use examle to verify
// // example 1 nums = [1,1,1,2,2,3]
// // k = 5, result = 6
// // do while loop
// // after finish verify
// // 18 mins to think can run
// // didn't pass the test case, means I didn't check careful
// // I just do the count, but I forgot to modify the nums
// // working on it now
// // since this is deletion, so think the index should start from left
// // update the code logic
//
// // /*
// // first failed version
// // func removeDuplicates(_ nums: inout [Int]) -> Int {
// //         var k = nums.count - 1
// //         var j = k
// //         var result = nums.count
// //         
//
// //         while k >= 0 {
// //             var count = 1
// //             while k >= 1 && nums[k] == nums[k-1] {
// //                 count += 1
// //                 k -= 1
// //                 if count == 3 {
// //                     result -= 1
// //                     count -= 1
// //                 }  
// //             }
// //             
// //             j = k
// //             k -= 1
// //         }
// //         return result
// //     }
// // */
//
// // 33 mins,write with new solution
// // now check example again
//
// // spend too long time, abort
// // already 39 mins, ready to ask gpt

class Solution {
    func removeDuplicates(_ nums: inout [Int]) -> Int {
        // Good: for arrays of size 0, 1, or 2, all elements are allowed.
        if nums.count <= 2 {
            return nums.count
        }

        // Correct: `k` is the next write position.
        // Why it works: nums[0..<k] is always the valid result so far.
        var k = 2

        for i in 2..<nums.count {
            // Wrong idea: tracking `offset` and manually shifting many elements.
            // Why: it makes the state complicated and easy to break.
            // Correct: compare nums[i] with nums[k - 2].
            //
            // If nums[i] == nums[k - 2], then writing nums[i] would create 3 copies.
            // If nums[i] != nums[k - 2], then nums[i] is safe to keep.
            if nums[i] != nums[k - 2] {
                nums[k] = nums[i]
                k += 1
            }
        }

        return k
    }
}

// GPT's summary:
// Mistakes you made:
// - You made the state too complicated with `offset`, `result`, nested loops, and manual shifting.
// - `result` was used but not defined in your latest version.
// - `if nums[k] == nums[k+1]` was incomplete; Swift needs a body after `if`.
// - Starting from the back is not needed here because writing from the front is safe.
// - The important state is not "how many deleted"; it is "where should I write the next kept value?"
//
// Key idea:
// - The array is sorted.
// - We are allowed to keep at most 2 copies of each value.
// - Keep the first two values automatically.
// - For every next value `nums[i]`, compare it with `nums[k - 2]`.
// - If they are equal, keeping `nums[i]` would create a third duplicate, so skip it.
// - If they are different, write `nums[i]` at `nums[k]` and move `k`.
//
// Example:
// - nums = [1,1,1,2,2,3]
// - Start k = 2, valid part is [1,1]
// - i = 2, nums[i] = 1, nums[k - 2] = nums[0] = 1, skip
// - i = 3, nums[i] = 2, nums[k - 2] = nums[0] = 1, keep -> [1,1,2]
// - i = 4, nums[i] = 2, nums[k - 2] = nums[1] = 1, keep -> [1,1,2,2]
// - i = 5, nums[i] = 3, nums[k - 2] = nums[2] = 2, keep -> [1,1,2,2,3]
//
// Swift syntax to remember:
// - `nums.count <= 2` handles small arrays directly.
// - `for i in 2..<nums.count` starts scanning from index 2.
// - `nums[0..<k]` means the valid prefix conceptually, though LeetCode only needs return `k`.
// - `nums[k] = nums[i]` writes the next kept value in-place.
//
// Complexity:
// - Time: O(n), because each element is checked once.
// - Space: O(1), because the array is modified in place.