// ============================================================
// FIX VERSION: Follows your XOR loop idea
// ============================================================

class fixSolution {
    func singleNumber(_ nums: [Int]) -> Int {
        var result = 0

        for number in nums {
            // Same as: result = result ^ number
            result ^= number
        }

        return result
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Functional version using reduce.
// ============================================================

class Solution {
    func singleNumber(_ nums: [Int]) -> Int {
        return nums.reduce(0) { result, number in
            result ^ number
        }
    }
}

// ============================================================
// YOUR ORIGINAL CODE AND THINKING COMMENTS
// Normalized from the pasted HTML/escape formatting.
// ============================================================

/*
class Solution {
    func singleNumber(_ nums: [Int]) -> Int {
    }
}

// Thinking
// this issue belong to bit operation
// so assume I need to use it
// assume if two same num 做 异或操作，可以等于0
// so can do for loop for the nums, and do 异或 for all the num
// the one left is the single one
// not sure how to write 异或 in swift

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
YOUR LOGIC IS CORRECT.

"异或" is XOR.

Swift syntax:

    a ^ b

XOR assignment:

    result ^= number

This is equivalent to:

    result = result ^ number


IMPORTANT XOR RULES:

1. A value XOR itself becomes zero:

       a ^ a = 0

2. A value XOR zero remains unchanged:

       a ^ 0 = a

3. XOR is commutative:

       a ^ b = b ^ a

4. XOR is associative:

       (a ^ b) ^ c = a ^ (b ^ c)

Because order and grouping do not matter, every duplicated pair cancels.


EXAMPLE:

    nums = [4, 1, 2, 1, 2]

Start:

    result = 0

Process 4:

    result = 0 ^ 4
           = 4

Process 1:

    result = 4 ^ 1

Process 2:

    result = 4 ^ 1 ^ 2

Process the second 1:

    result = 4 ^ 1 ^ 2 ^ 1

Rearrange using XOR's commutative property:

    result = 4 ^ (1 ^ 1) ^ 2
           = 4 ^ 0 ^ 2
           = 4 ^ 2

Process the second 2:

    result = 4 ^ 2 ^ 2
           = 4 ^ (2 ^ 2)
           = 4 ^ 0
           = 4

Return:

    4


BINARY EXAMPLE:

    2 = 0010
    2 = 0010

XOR:

    0010
  ^ 0010
  ------
    0000


WHY START WITH ZERO?

The initial value should not change the first number:

    0 ^ number = number

Therefore:

    var result = 0


LOOP CONTRACT:

At the beginning of every iteration:

    result is the XOR of every number processed so far.

After all numbers are processed:

    all duplicate pairs have canceled, leaving only the single number.


PATTERN:

    Bit manipulation

CARD SHAPE:

    Initialize result to zero.
    XOR every number into result.
    Return result.

STATE:

    result

CONTRACT:

    result stores the XOR of all processed values.

RECALL:

    Landed


COMPLEXITY:

Time:

    O(n)

Every number is processed once.

Space:

    O(1)

Only one result variable is stored.


WHY THIS IS BETTER THAN A SET OR DICTIONARY:

A Set or dictionary can also find the unique value, but requires:

    O(n) extra space

XOR satisfies the requested constant-space solution:

    O(1) extra space
*/