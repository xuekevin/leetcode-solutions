// Your original solution:
//
// class Solution {
//     func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
//         var i = 0
//         var j = nums.count - 1
//         while i <= j {
//             if nums[i] == val {
//                 while j != i && nums[j] == val {
//                     j -= 1
//                 }
//                 if j != i {
//                     nums[i] = nums[j]
//                     j -= 1
//
//                 } else {
//                     return i
//                 }
//             }
//             i += 1
//         }
//         return i
//     }
// }
//
// // time complexity is O(n2)
//
//
// // nums size is 0, -> return 0
// // nums doesn't contains val -> ruturn 0
// // do we need to sort the nums first k? -> my takeaway is we don't need to
// // in place, we can't create new array? -> yes
//
//
//
// // thoughts
// // for loop the array from beginning
// // if current index's value is not val, do nothing
// // if it is val, then move right to left?
// // abort
// // restart this thinking
// // if the replace it with the non val element from the end
//
//
//
// // think to loop from the end
// // if if it is val, then move pointer to left
// // if it is not val?
// // keep moving, got a index is val, then what should I do?
// // abort
//
//
//
// // use about 10 mins to figure out the solution
//
// // first run, failed in this case
//
// // nums =[3,2,2,3] val = 3
// // my output is [2]
// // expected is [2,2]
//
//
// // found the issue when do for loop should do i <= j check
// // to avoid missing the element
//
//
// // still failed on case
//
// // nums = [4,5], val = 5
// // my output is []
// // expected is [4]
//
// // Debugging...
//
// // should return i instead of max(i-1, 0), the return is the count of non val.

class Solution {
    func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
        var i = 0
        var j = nums.count - 1

        while i <= j {
            if nums[i] == val {
                // Good: skip `val` values at the end before replacing nums[i].
                while i < j && nums[j] == val {
                    j -= 1
                }

                if i == j {
                    // Good: this final element is `val`, so there are `i`
                    // valid elements before it.
                    return i
                }

                // Good: order does not matter for this problem, so replacing
                // a `val` with a valid end element is allowed.
                nums[i] = nums[j]
                j -= 1
            }

            i += 1
        }

        return i
    }
}

// GPT's summary:
// What you did well:
// - Your two-pointer solution is correct.
// - You found the important condition `i <= j`, which prevents skipping
//   the last unchecked element.
// - You correctly return `i`, which is the count of non-val elements.
//
// Small correction to your notes:
// - If nums does not contain val, return nums.count, not 0.
// - The array does not need to be sorted.
// - The problem only requires the first k values to be valid; their order
//   may change.
//
// Key idea:
// - i scans from the front for values equal to val.
// - j scans from the end for a value that can replace nums[i].
// - Every value before i is a kept, non-val value.
//
// Swift syntax to remember:
// - `inout [Int]` allows the function to modify the caller's array.
// - An empty array works here: j becomes -1, `i <= j` is false,
//   and the function returns 0.
//
// Complexity:
// - Time: O(n), not O(n^2).
//   Although there is a nested while loop, i only moves right and j only
//   moves left. Together, they each visit at most n positions.
// - Space: O(1).