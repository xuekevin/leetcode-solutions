// Your original solution:
// class Solution {
//     func removeDuplicates(_ nums: inout [Int]) -> Int {
//         var i = 0
//         var k = 1
//
//         while i < nums.count {
//             var j = i + 1
//             while nums[j] == nums[i] && j < nums.count {
//                 i += 1
//                 j += 1
//             }
//             nums[k] = nums[j]
//         }
//         return k + 1
//     }
// }
//
// // # Thoughts
//
// // Pattern: two pointers, use index as point tofind the duplicate
// // Card: like if you find a duplicate then you can move the index,something like this,since 
// // State needed: not sure what I need in here
// // Recall: half
//
// // how to check if it is duplicate, since it is ordered
// // so it must be continuious, we can find next not right and keep the loop
// // think need two pointers, one is for the result array index
// // one is for the old index
// // 6 mins so far, write to write code
// // 11 mins write code, then use example to verify
// //  17 mins got exception
// // ready to ask gpt

class Solution {
    func removeDuplicates(_ nums: inout [Int]) -> Int {
        if nums.isEmpty {
            return 0
        }

        // Good: `k` is the write pointer.
        // Why it works: nums[0..<k] stores the unique values found so far.
        var k = 1

        // Wrong: manually searching with `j = i + 1` and then reading `nums[j]`.
        // Why: when `j == nums.count`, `nums[j]` crashes with index out of range.
        // Correct: scan from left to right and compare each number with the last unique value.
        for i in 1..<nums.count {
            if nums[i] != nums[k - 1] {
                nums[k] = nums[i]
                k += 1
            }
        }

        return k
    }
}

// GPT's summary:
// Mistakes you made:
// - Your two-pointer idea was correct.
// - The missing state was: `k` should mean "next position to write a unique number".
// - Your exception came from `while nums[j] == nums[i] && j < nums.count`.
// - In Swift, the left side `nums[j] == nums[i]` is evaluated before `j < nums.count`, so `nums[j]` can crash.
// - Your outer `while i < nums.count` also never moved `i` in some cases, which can create an infinite loop.
// - You wrote `nums[k] = nums[j]` but did not update `k`, so the result position did not move forward.
//
// Key idea:
// - Because the array is sorted, duplicates are next to each other.
// - Keep the first number.
// - Scan from index 1.
// - If `nums[i]` is different from the last written unique value `nums[k - 1]`, write it at `nums[k]`.
// - Return `k`, the count of unique values.
//
// Swift syntax to remember:
// - `inout [Int]` means the function can modify the original array.
// - `nums.isEmpty` checks whether the array has no elements.
// - `for i in 1..<nums.count` loops from 1 up to nums.count - 1.
// - Always check bounds before indexing: `j < nums.count && nums[j] == nums[i]`, not the reverse.
// - `nums[k] = nums[i]` overwrites the value at index `k`.
//
// Complexity:
// - Time: O(n), because each element is scanned once.
// - Space: O(1), because the array is modified in place.