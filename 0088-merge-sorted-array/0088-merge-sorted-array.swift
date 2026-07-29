class Solution {
    func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        var i = m - 1
        var j = n - 1
        var k = m + n - 1

        while i >= 0 && j >= 0 {
            if nums1[i] <= nums2[j] {
                nums1[k] = nums2[j]
                j -= 1
            } else {
                nums1[k] = nums1[i]
                i -= 1
            }
            k -= 1
        }

        while i >= 0 {
            nums1[k] = nums1[i]
            i -= 1
            k -= 1
        }

        while j >= 0 {
            nums1[k] = nums2[j]
            j -= 1
            k -= 1
        }
    }
}

// # Thoughts
// basically nums1.length > nums.length
// Pattern: Two pointers
// Card shape: do for loop for both nums, compare and update nums1 and move both two pointers
// State needed: nothing special, two variable represent the index 
// Recall: landed
// 2.30 mins start to write code
// start too early before I fully figure out the solution, will spend more time to think how to write code
// still think need a temp array, but I think they want me to do the change in nums1 directly
// I guess it is hard to do without temp array
// will use a temp array
// actually I can think from back to get the answer
// then it is no overlap issue
// 16 mins finish writing, now using example to verify

// Example 1: nums1 = [1,2,3,0,0,0], m = 3, nums2 = [2,5,6], n = 3
// i = 2, j = 2, k = 5
// ... seems good to me 
// check exmaple 2 and 3 seems correct,
// now check if there is any synatx error
// 20 mins ready to run, pass
// submit










