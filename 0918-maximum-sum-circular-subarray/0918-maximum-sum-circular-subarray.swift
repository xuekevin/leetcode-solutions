/*
YOUR ORIGINAL SOLUTION:

class Solution {
    func maxSubarraySumCircular(_ nums: [Int]) -> Int {
        if nums.count == 1 {
            return nums[0]
        }

        var left = 0
        var right = 1
        var preSum = nums[0]
        var maxSum = nums[0]

        while left < nums.count && left != right {
            if preSum <= 0 {
                if left < right {
                    left = right
                    preSum = nums[left]
                    maxSum = max(preSum, maxSum)
                    right += 1
                } else {
                    return maxSum
                }
            } else {
                preSum += nums[right]
                maxSum = max(preSum, maxSum)
                right += 1
            }

            right = right % nums.count
        }

        return maxSum
    }
}

// Thinking
// because circular
// the start and end of the suarray changed
// so how to get maximum
// do the slide window action
// when to move the left start boundary
// if previous sum is negative, we can reset current be the new start
// compare with normal array the difference is once array is end, can keep more the end
// start writing in 5 mins
// write 17 mins
// use example to verify my thoughts
// 22 mins, assume fixing most of the issues
// ready to run, time out, means I have forever loop
// fix the while condition
// didn't pass the example 1
// fix the bug
// did pass the example 2
// realize my current solution didn't consider all the case to move left,
// already 27 mins, will let gpt fix

// Pattern: Array, Slide Window
// Card shape:
// State needed: var left, right, maxSum
// Contract:      origin is right <= n.count, now can be left <= n.count
// Recall:         half
*/


// FIX VERSION:
// Preserves your key idea of resetting a running sum when it becomes
// harmful, but uses Kadane's algorithm for both possible answer shapes.

class fixSolution {
    func maxSubarraySumCircular(_ nums: [Int]) -> Int {
        let normalMaximum = findMaximumSubarray(nums)

        // If every value is negative, the answer must be the largest
        // individual value. The circular calculation would incorrectly
        // select an empty subarray.
        if normalMaximum < 0 {
            return normalMaximum
        }

        let totalSum = nums.reduce(0, +)
        let normalMinimum = findMinimumSubarray(nums)

        // Remove the minimum middle section.
        // The values remaining at both ends form one circular subarray.
        let circularMaximum = totalSum - normalMinimum

        return max(normalMaximum, circularMaximum)
    }

    private func findMaximumSubarray(_ nums: [Int]) -> Int {
        var currentSum = nums[0]
        var maximumSum = nums[0]

        for number in nums.dropFirst() {
            // Either extend the previous subarray or start a new one.
            currentSum = max(number, currentSum + number)
            maximumSum = max(maximumSum, currentSum)
        }

        return maximumSum
    }

    private func findMinimumSubarray(_ nums: [Int]) -> Int {
        var currentSum = nums[0]
        var minimumSum = nums[0]

        for number in nums.dropFirst() {
            // Same idea as maximum Kadane, but find the minimum.
            currentSum = min(number, currentSum + number)
            minimumSum = min(minimumSum, currentSum)
        }

        return minimumSum
    }
}


// GPT'S UPGRADE VERSION:
// Calculate the total, maximum subarray, and minimum subarray
// together in one loop.

class Solution {
    func maxSubarraySumCircular(_ nums: [Int]) -> Int {
        var totalSum = nums[0]

        var currentMaximum = nums[0]
        var globalMaximum = nums[0]

        var currentMinimum = nums[0]
        var globalMinimum = nums[0]

        for number in nums.dropFirst() {
            currentMaximum = max(
                number,
                currentMaximum + number
            )
            globalMaximum = max(
                globalMaximum,
                currentMaximum
            )

            currentMinimum = min(
                number,
                currentMinimum + number
            )
            globalMinimum = min(
                globalMinimum,
                currentMinimum
            )

            totalSum += number
        }

        // All-negative case:
        // `totalSum - globalMinimum` would equal zero because the minimum
        // subarray would be the entire array. An empty subarray is invalid.
        if globalMaximum < 0 {
            return globalMaximum
        }

        return max(
            globalMaximum,
            totalSum - globalMinimum
        )
    }
}


/*
GPT'S EXPLANATION

A circular maximum subarray has only two possible shapes.

CASE 1: IT DOES NOT WRAP

Example:

    [5, -3, 5]
     ^

or:

    [1, -2, 3, -2]
            ^

This is the normal maximum-subarray problem.

Use Kadane's algorithm:

    normalMaximum = maximum subarray sum


CASE 2: IT WRAPS

Example:

    [5, -3, 5]
     ^       ^

The circular subarray takes values from the end and beginning:

    5 + 5 = 10

Another way to see this is:

    total array:     [5, -3, 5]
    remove minimum:      [-3]
    remaining:       [5]     [5]

Therefore:

    circularMaximum
    = totalSum - minimumSubarraySum
    = 7 - (-3)
    = 10


WHY FINDING THE MINIMUM WORKS

A wrapping subarray keeps:

    suffix + prefix

That means it excludes one continuous section in the middle:

    [prefix] [excluded middle] [suffix]

To maximize what remains, we should remove the smallest possible
middle section.

Therefore:

    wrapping maximum = total sum - minimum subarray


EXAMPLE: [5, -3, 5]

Maximum Kadane:

    globalMaximum = 7

This represents the normal non-wrapping array:

    [5, -3, 5]

Minimum Kadane:

    globalMinimum = -3

Total:

    totalSum = 7

Circular result:

    totalSum - globalMinimum
    = 7 - (-3)
    = 10

Final result:

    max(7, 10) = 10


ALL-NEGATIVE EXAMPLE: [-3, -2, -5]

Normal maximum:

    globalMaximum = -2

Minimum subarray:

    globalMinimum = -10

Total:

    totalSum = -10

The circular formula gives:

    totalSum - globalMinimum
    = -10 - (-10)
    = 0

But 0 represents removing the entire array and selecting nothing.
The problem requires a non-empty subarray.

Therefore, when every value is negative:

    return globalMaximum


GPT'S SUMMARY

What you understood correctly:
- A circular subarray can continue from the end back to the beginning.
- A negative running sum should not be kept for a normal maximum
  subarray.
- Resetting the running sum is the central idea behind Kadane's
  algorithm.

Why the two-pointer version did not work:

1. `% nums.count` only wraps the index.

   It does not track how many elements are currently inside the
   subarray. The same element can therefore be processed again.

2. `left != right` is not enough to describe the window.

   In a circular array, equal indexes can mean:
   - the window is empty, or
   - the window contains the entire array.

   The indexes alone cannot distinguish these cases.

3. Moving `left` only when `preSum <= 0` follows normal Kadane logic,
   but circular windows also need a strict maximum length of `n`.

4. A sliding window is not a natural fit here because the array
   contains negative values.

   With positive-only sliding-window problems, expanding and shrinking
   has predictable effects. With negative values, removing an element
   can either increase or decrease the sum.

Key formula:

    answer = max(
        maximum normal subarray,
        total sum - minimum normal subarray
    )

Exception:

    If all values are negative, return the maximum individual value.

Pattern:
- Kadane's algorithm / dynamic programming.

State needed:
- `currentMaximum`: best maximum subarray ending at the current index.
- `globalMaximum`: best maximum subarray seen anywhere.
- `currentMinimum`: best minimum subarray ending at the current index.
- `globalMinimum`: best minimum subarray seen anywhere.
- `totalSum`: sum of every array value.

Loop contract:
- After processing each number, `currentMaximum` is the largest
  subarray sum ending exactly at that number.
- `globalMaximum` is the largest subarray sum found so far.
- The same contract applies to the minimum variables.

Complexity:
- Time: O(n).
- Space: O(1).
*/