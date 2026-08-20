// ============================================================
// FIX VERSION: Dynamic programming
// Follows your idea of checking earlier elements.
// ============================================================

class fixSolution {
    func lengthOfLIS(_ nums: [Int]) -> Int {
        if nums.isEmpty {
            return 0
        }

        // dp[i] = length of the longest increasing subsequence
        // that must end at index i.
        var dp = Array(repeating: 1, count: nums.count)
        var maxLength = 1

        for current in 0..<nums.count {
            // Check every earlier number as a possible predecessor.
            for previous in 0..<current {
                if nums[previous] < nums[current] {
                    dp[current] = max(
                        dp[current],
                        dp[previous] + 1
                    )
                }
            }

            maxLength = max(maxLength, dp[current])
        }

        return maxLength
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Binary search, O(n log n)
// ============================================================

class Solution {
    func lengthOfLIS(_ nums: [Int]) -> Int {
        // tails[i] stores the smallest possible ending value
        // of an increasing subsequence with length i + 1.
        var tails = [Int]()

        for number in nums {
            var left = 0
            var right = tails.count

            // Find the first value in tails that is >= number.
            while left < right {
                let middle = left + (right - left) / 2

                if tails[middle] < number {
                    left = middle + 1
                } else {
                    right = middle
                }
            }

            if left == tails.count {
                // number is larger than every tail, so it extends
                // the longest subsequence found so far.
                tails.append(number)
            } else {
                // Replace an existing tail with a smaller or equal value.
                // This creates a better ending for a future subsequence.
                tails[left] = number
            }
        }

        return tails.count
    }
}

// ============================================================
// ORIGINAL SOLUTION
// ============================================================

/*
class Solution {
    func lengthOfLIS(_ nums: [Int]) -> Int {
        if nums.count == 1 {
            return 1
        }
        var start = 0
        var end = 1
        var pre = 0
        var maxlength = 1

        while end < nums.count {
            if nums[pre] >= nums[end] {
                maxLength = max(maxLength, end - start)
                start = end
                pre = end
            }
            end += 1
        }

        return maxLength
    }
}

// Thinking
// need strictly increasing
// also need to update
// sub sequence issue
// use example to figure out the solution
// var start, var end = 0
// var pre = start
// move end, end += 1
// if nums[end] <= nums[pre], increase break
// update max length
// start = end
// pre = start
// if nums[end] > nums[pre] {
// keep moving
// pretty much can start to write
// in 5 mins
// Pattern: kind like slide window
// Card shape: do for loop, maintain a slide window with start and end
// State needed: start and end
// Contract: every iteration, whether increase the window,
//           or reset the window to update the max length
// Recall: landed

// wait make a mistake
// as longer as it is increasing subsequnce, no need to be sub array
// need to rethink, next time need by more careful when start to write
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
MAIN LOGIC MISTAKE:

A sliding window finds a contiguous subarray.

A subsequence can skip elements.

Example:

    nums = [1, 5, 2, 3, 4]

The longest increasing subsequence is:

    [1, 2, 3, 4]

It skips 5, so it is not one continuous window.


OTHER MISTAKES:

1. Variable names are case-sensitive:

       var maxlength = 1
       maxLength = ...

   `maxlength` and `maxLength` are different Swift variables.

2. `pre` was not updated when nums[end] was increasing.

3. The final increasing section was never used to update maxLength.

4. Resetting start when one smaller value appears can discard useful
   earlier values that could still be part of a subsequence.


DP CONTRACT:

    dp[i] is the length of the longest increasing subsequence
    that ends exactly at nums[i].

For every earlier index j:

    if nums[j] < nums[i]

then nums[i] can be added after the subsequence ending at j:

    dp[i] = max(dp[i], dp[j] + 1)


DP EXAMPLE:

    nums = [1, 5, 2, 3, 4]

    dp[0] = 1                         // [1]
    dp[1] = 2                         // [1,5]
    dp[2] = 2                         // [1,2]
    dp[3] = 3                         // [1,2,3]
    dp[4] = 4                         // [1,2,3,4]

Answer = 4.


UPGRADE EXAMPLE:

    nums = [10, 9, 2, 5, 3, 7, 101, 18]

tails changes like this:

    10  -> [10]
    9   -> [9]
    2   -> [2]
    5   -> [2, 5]
    3   -> [2, 3]
    7   -> [2, 3, 7]
    101 -> [2, 3, 7, 101]
    18  -> [2, 3, 7, 18]

The final length is 4.


IMPORTANT:

`tails` is not always the actual longest subsequence.

Its contract is:

    tails[i] is the smallest ending value found for an increasing
    subsequence of length i + 1.

A smaller ending value is better because future numbers have a greater
chance of extending it.


WHY FIND THE FIRST VALUE >= NUMBER?

The subsequence must be strictly increasing.

If tails contains:

    [2, 3, 7]

and number is 3, we replace the existing 3. We do not append another 3,
because equal numbers do not form a strictly increasing subsequence.


COMPLEXITY:

DP fix:
    Time:  O(n²)
    Space: O(n)

Binary-search upgrade:
    Time:  O(n log n)
    Space: O(n)
*/


// TBH, the DP logic is easy to understand, but the binary search logic I still need time to fully understand and write by myself in the future