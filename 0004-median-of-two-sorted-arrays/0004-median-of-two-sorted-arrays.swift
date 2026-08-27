// Thinking
// the runtime is log(m+n)
// so should use binary search
// nums1 and num2 are sorted
// should can still follow the binary search logic
// can I first get nums1's median then get nums2, medican
// the caculate the average of these 2
// for a sorted Array 
// the median is simple
// just get the middle index
// can I first merge two array, use log(m+n)
// then just get the middle of the item
// which should be o(1)
// so issue become how to merge two array with log(m+n)
// so I can compare the middle of two array 
// then what's next
// need logic to decide how to merge two array
// try to use example to figure out a solution
// example 1
// middle 1 = 1
// middle 2 = 2
// mid2 > mid1, so 1. I can insert mid2 after middle 1, but where to insert still need to figure out
// what else I can get, also has bounary left1 right1, left2, right2
//  need to list all pass case:
// case mid2 > mid1, then compare left2 with right1,? or compare mid2 with right1,
// if mid2 >= right1, then means, two array has no overlap, so newMid is (mid1 + mid2) / 2
// if mid2 < right1, means ...
// then case mid2 <= mid1
// time is up
// will let gpt to figure out next
// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank


class Solution {
    func findMedianSortedArrays(
        _ nums1: [Int],
        _ nums2: [Int]
    ) -> Double {
        // Binary-search the shorter array so the partition index
        // always stays in a valid range.
        if nums1.count > nums2.count {
            return findMedianSortedArrays(nums2, nums1)
        }

        let m = nums1.count
        let n = nums2.count
        let leftHalfCount = (m + n + 1) / 2

        var left = 0
        var right = m

        while left <= right {
            // `partition1` means: how many nums1 elements go left.
            let partition1 = left + (right - left) / 2

            // Choose nums2's partition so the left side contains
            // exactly half the total elements.
            let partition2 = leftHalfCount - partition1

            // Values next to the two partitions.
            let left1 = partition1 == 0
                ? Int.min
                : nums1[partition1 - 1]

            let right1 = partition1 == m
                ? Int.max
                : nums1[partition1]

            let left2 = partition2 == 0
                ? Int.min
                : nums2[partition2 - 1]

            let right2 = partition2 == n
                ? Int.max
                : nums2[partition2]

            // This means every left-side number is <= every right-side
            // number, so the partition is correct.
            if left1 <= right2 && left2 <= right1 {
                if (m + n) % 2 == 1 {
                    return Double(max(left1, left2))
                }

                return Double(max(left1, left2) + min(right1, right2))
                    / 2.0
            }

            // nums1 placed a value too large on the left side.
            if left1 > right2 {
                right = partition1 - 1
            } else {
                // nums1 needs more values on the left side.
                left = partition1 + 1
            }
        }

        return 0.0 // Unreachable for valid sorted inputs.
    }
}

/*
HOW TO THINK ABOUT IT

Do not merge the arrays. Merging is O(m + n), but the problem requires
O(log(m + n)).

Also, do not average each array's individual median.

Example:

    nums1 = [1, 2]
    nums2 = [100]

Individual medians:

    1.5 and 100

Their average is 50.75, but the merged array is:

    [1, 2, 100]

The real median is 2.


THE KEY IDEA: MAKE TWO LEFT HALVES

We want to partition both arrays so:

    every value on the left <= every value on the right

For:

    nums1 = [1, 3]
    nums2 = [2]

A correct partition is:

    [1 | 3]
    [2 | ]

Combined left side:

    [1, 2]

Combined right side:

    [3]

There are three total values, so the median is the largest value on
the left side:

    max(1, 2) = 2


WHAT WE BINARY SEARCH

We binary-search `partition1`, which is the number of values taken
from `nums1` for the left side.

If:

    partition1 = 1

then:

    nums1 = [left1 | right1]

where:

    left1  = nums1[partition1 - 1]
    right1 = nums1[partition1]

We then calculate the matching partition in nums2:

    partition2 = leftHalfCount - partition1

This guarantees the total number of values on the left side is always
correct. We only need to find the partition where the values are in
the correct order.


VALID PARTITION RULE

The partition is valid when:

    left1 <= right2
    left2 <= right1

If this is false:

    left1 > right2

then nums1 put a value that is too large on the left. Move its
partition left:

    right = partition1 - 1

Otherwise:

    left2 > right1

nums1 needs more values on its left side:

    left = partition1 + 1


WHY Int.min AND Int.max?

At an array boundary, a partition can have no left or right value.

For example:

    nums1 = [ | 1, 3]

There is no left1 value. Treat it as negative infinity:

    left1 = Int.min

Likewise:

    nums1 = [1, 3 | ]

There is no right1 value. Treat it as positive infinity:

    right1 = Int.max


ODD VS EVEN TOTAL LENGTH

Odd total count:

    median = largest value on the left

    max(left1, left2)

Even total count:

    median = average of the two middle values

    (max(left1, left2) + min(right1, right2)) / 2


PATTERN:
- Binary search on a partition, not on a value.

STATE NEEDED:
- `partition1`: number of nums1 values on the left.
- `partition2`: matching number of nums2 values on the left.
- Four boundary values: `left1`, `right1`, `left2`, `right2`.

CONTRACT:
- Each binary-search iteration keeps the total left-side size correct.
- It searches for the partition where both left boundaries are no
  greater than the opposite right boundaries.

COMPLEXITY:
- Time: O(log(min(m, n))).
- Space: O(1).
*/

// This need to resolve, need to figure out the logic again before next try
