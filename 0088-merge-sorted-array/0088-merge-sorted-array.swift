// Your original solution:
// class Solution {
//     func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
//         var i = m - 1
//         var j = n - 1
//         var k = m + n - 1
//
//         while i >= 0 && j >= 0 {
//             if nums1[i] <= nums2[j] {
//                 nums1[k] = nums2[j]
//                 j -= 1
//             } else {
//                 nums1[k] = nums1[i]
//                 i -= 1
//             }
//             k -= 1
//         }
//
//         while i >= 0 {
//             nums1[k] = nums1[i]
//             i -= 1
//             k -= 1
//         }
//
//         while j >= 0 {
//             nums1[k] = nums2[j]
//             j -= 1
//             k -= 1
//         }
//     }
// }
//
// // # Thoughts
// // basically nums1.length > nums.length
// // Pattern: Two pointers
// // Card shape: do for loop for both nums, compare and update nums1 and move both two pointers
// // State needed: nothing special, two variable represent the index 
// // Recall: landed
// // 2.30 mins start to write code
// // start too early before I fully figure out the solution, will spend more time to think how to write code
// // still think need a temp array, but I think they want me to do the change in nums1 directly
// // I guess it is hard to do without temp array
// // will use a temp array
// // actually I can think from back to get the answer
// // then it is no overlap issue
// // 16 mins finish writing, now using example to verify
//
// // Example 1: nums1 = [1,2,3,0,0,0], m = 3, nums2 = [2,5,6], n = 3
// // i = 2, j = 2, k = 5
// // ... seems good to me 
// // check exmaple 2 and 3 seems correct,
// // now check if there is any synatx error
// // 20 mins ready to run, pass
// // submit, pass

class Solution {
    func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        // Good: start from the real last values, not from index 0.
        // Why it works: nums1 has empty space at the end, so writing from the back avoids overwriting useful values.
        var i = m - 1
        var j = n - 1
        var k = m + n - 1

        while i >= 0 && j >= 0 {
            // Good: compare the largest remaining values.
            // Why it works: the bigger value belongs at nums1[k], the current last open position.
            if nums1[i] <= nums2[j] {
                nums1[k] = nums2[j]
                j -= 1
            } else {
                nums1[k] = nums1[i]
                i -= 1
            }

            k -= 1
        }

        // This loop is optional.
        // Why: if nums1 has leftover values, they are already in the correct place.
        while i >= 0 {
            nums1[k] = nums1[i]
            i -= 1
            k -= 1
        }

        // Good: this loop is necessary.
        // Why it works: if nums2 has leftover values, they must be copied into the front of nums1.
        while j >= 0 {
            nums1[k] = nums2[j]
            j -= 1
            k -= 1
        }
    }
}

// GPT's summary:
// What you did well:
// - Your final algorithm is correct.
// - The key breakthrough was "think from back".
// - You correctly used three pointers: `i` for nums1, `j` for nums2, and `k` for write position.
// - You avoided a temp array, so the merge is in-place.
//
// Key idea:
// - If you merge from the front, you may overwrite nums1 values you still need.
// - If you merge from the back, nums1's extra zero slots give you safe write space.
// - Always place the larger remaining number at `nums1[k]`.
// - Move the pointer for whichever array provided that number.
//
// Swift syntax to remember:
// - `inout [Int]` means the function modifies the original `nums1` array.
// - `var i = m - 1` starts at the last real nums1 element.
// - `while i >= 0 && j >= 0` works here because `i` and `j` are Int, not UInt.
// - `nums1[k] = nums2[j]` overwrites nums1 at index `k`.
//
// Complexity:
// - Time: O(m + n), because each element is processed once.
// - Space: O(1), because the merge happens inside nums1 without another array.