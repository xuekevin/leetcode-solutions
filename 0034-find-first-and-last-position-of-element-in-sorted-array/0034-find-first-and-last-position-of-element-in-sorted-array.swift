// ============================================================
// FIX VERSION: Your accepted logic
// Correct, but O(n) in the worst case because of outward scanning.
// ============================================================

// class fixSolution {
//     func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
//         var left = 0
//         var right = nums.count - 1

//         while left <= right {
//             let middle = left + (right - left) / 2

//             if nums[middle] == target {
//                 var middleLeft = middle - 1
//                 var middleRight = middle + 1

//                 while middleLeft >= 0 && nums[middleLeft] == target {
//                     middleLeft -= 1
//                 }

//                 while middleRight < nums.count
//                     && nums[middleRight] == target {
//                     middleRight += 1
//                 }

//                 return [middleLeft + 1, middleRight - 1]
//             } else if nums[middle] > target {
//                 right = middle - 1
//             } else {
//                 left = middle + 1
//             }
//         }

//         return [-1, -1]
//     }
// }

// ============================================================
// GPT'S UPGRADE SOLUTION
// Uses binary search twice and satisfies O(log n).
// ============================================================

class Solution {
    func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
        // Find the first occurrence of target.
        let first = findFirst(nums, target)

        // If there is no first occurrence, target does not exist.
        if first == -1 {
            return [-1, -1]
        }

        // Target exists, so find its final occurrence.
        let last = findLast(nums, target)

        return [first, last]
    }

    // Returns the first index containing target, or -1 if not found.
    func findFirst(_ nums: [Int], _ target: Int) -> Int {
        var left = 0
        var right = nums.count - 1
        var result = -1

        while left <= right {
            let middle = left + (right - left) / 2

            if nums[middle] == target {
                // This is a possible answer.
                result = middle

                // Continue searching on the left for an earlier target.
                right = middle - 1
            } else if nums[middle] < target {
                left = middle + 1
            } else {
                right = middle - 1
            }
        }

        return result
    }

    // Returns the last index containing target, or -1 if not found.
    func findLast(_ nums: [Int], _ target: Int) -> Int {
        var left = 0
        var right = nums.count - 1
        var result = -1

        while left <= right {
            let middle = left + (right - left) / 2

            if nums[middle] == target {
                // This is a possible answer.
                result = middle

                // Continue searching on the right for a later target.
                left = middle + 1
            } else if nums[middle] < target {
                left = middle + 1
            } else {
                right = middle - 1
            }
        }

        return result
    }
}

// ============================================================
// ORIGINAL THINKING
// ============================================================

/*
Thinking:
- O(log n) suggests binary search.
- Find the target by comparing nums[middle] with target.
- After finding target, determine its lower and upper indexes.
- If middle < target, move left to middle + 1.
- If middle > target, move right to middle - 1.
- The closed-interval loop condition is left <= right.

Pattern: Binary Search

Card shape:
- Calculate middle.
- Compare it with target.
- Narrow the search interval.

State needed:
- left
- right
- middle
- saved boundary result

Contract:
- findFirst returns the earliest target index.
- findLast returns the latest target index.

Recall: landed
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
WHY YOUR VERSION BECOMES O(n):

After binary search finds one target, these loops scan outward:

    while middleLeft >= 0 && nums[middleLeft] == target
    while middleRight < nums.count && nums[middleRight] == target

Worst case:

    nums = [2, 2, 2, 2, 2, 2, 2]
    target = 2

Binary search finds one 2 in O(log n), but the outward loops inspect
almost every element. The total worst-case time is therefore O(n).


KEY BINARY-SEARCH IDEA:

Finding target is not enough. After finding it:

For the first position:
- Save middle as a possible answer.
- Continue searching left with right = middle - 1.

For the last position:
- Save middle as a possible answer.
- Continue searching right with left = middle + 1.

We do not return immediately after finding target because we are looking
for a specific boundary, not merely checking whether target exists.


EXAMPLE:

    nums = [5, 7, 7, 8, 8, 10]
    target = 8

findFirst:
- Finds 8 at index 4 and saves 4.
- Searches left.
- Finds 8 at index 3 and saves 3.
- Returns 3.

findLast:
- Finds 8 at index 4 and saves 4.
- Searches right.
- No later 8 exists.
- Returns 4.

Final result: [3, 4]


COMPLEXITY:

findFirst: O(log n)
findLast:  O(log n)

Total time:
    O(log n) + O(log n) = O(log n)

Space:
    O(1)
*/