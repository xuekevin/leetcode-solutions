/*
YOUR ORIGINAL SOLUTION:

class Solution {
    func rangeBitwiseAnd(_ left: Int, _ right: Int) -> Int {
    }
}

// Thinking
// bit wise and
// how to define in swift
// what's this issue try to solve ?
// bit operation I think there is tricky I can just recite
// will ask gpt to help

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/


// FIX VERSION:
// Find the common binary prefix of left and right.

class fixSolution {
    func rangeBitwiseAnd(_ left: Int, _ right: Int) -> Int {
        var leftNumber = left
        var rightNumber = right
        var shiftCount = 0

        // Remove different suffix bits until both numbers are equal.
        while leftNumber != rightNumber {
            leftNumber >>= 1
            rightNumber >>= 1
            shiftCount += 1
        }

        // Restore the common prefix to its original position.
        return leftNumber << shiftCount
    }
}


// GPT'S UPGRADE VERSION:
// Repeatedly remove the rightmost 1 from `right` until right <= left.

class Solution {
    func rangeBitwiseAnd(_ left: Int, _ right: Int) -> Int {
        var rightNumber = right

        while left < rightNumber {
            // Clear the rightmost 1 bit.
            rightNumber &= rightNumber - 1
        }

        return rightNumber
    }
}


/*
WHAT DOES THE PROBLEM ASK?

It asks us to apply bitwise AND to every number in the inclusive range:

    left & (left + 1) & (left + 2) & ... & right

For example:

    left = 5
    right = 7

Calculate:

    5 & 6 & 7

Binary:

    5 = 0101
    6 = 0110
    7 = 0111

AND every column:

      0101
    & 0110
    & 0111
    ------
      0100

Answer:

    4


SWIFT BITWISE-AND SYNTAX

Bitwise AND:

    let result = a & b

Compound assignment:

    result &= value

This means:

    result = result & value


BITWISE AND RULES

For each binary position:

    0 & 0 = 0
    0 & 1 = 0
    1 & 0 = 0
    1 & 1 = 1

A result bit stays 1 only when every number in the range has 1 at that
position.


WHY THE COMMON PREFIX IS THE ANSWER

Consider all numbers from 5 through 7:

    5 = 0101
    6 = 0110
    7 = 0111
        ^^
        common prefix

The common prefix is:

    01

The remaining suffix changes somewhere inside the range:

    01|01
    01|10
    01|11

Any changing suffix position eventually contains a zero in at least
one number. Because AND with zero produces zero, all changing suffix
bits become zero.

Therefore:

    common prefix = 01
    suffix        = 00
    result        = 0100


FIX VERSION LINE BY LINE

    var leftNumber = left
    var rightNumber = right

Create mutable copies of both boundaries.

    var shiftCount = 0

Record how many suffix positions we remove.

    while leftNumber != rightNumber {

If the values differ, they do not yet contain only their common prefix.

    leftNumber >>= 1
    rightNumber >>= 1

Shift both values right, removing one suffix bit.

    shiftCount += 1

Remember that one bit position was removed.

    return leftNumber << shiftCount

When the numbers become equal, that value is the common prefix.
Shift it left to restore its original position, filling the removed
suffix with zeros.


EXAMPLE: left = 5, right = 7

Start:

    leftNumber  = 0101
    rightNumber = 0111
    shiftCount  = 0

Round 1:

    0101 >> 1 = 0010
    0111 >> 1 = 0011

    leftNumber  = 0010
    rightNumber = 0011
    shiftCount  = 1

They are still different.

Round 2:

    0010 >> 1 = 0001
    0011 >> 1 = 0001

    leftNumber  = 0001
    rightNumber = 0001
    shiftCount  = 2

They are now equal. The common prefix is:

    0001

Restore it by shifting left twice:

    0001 << 2 = 0100

Answer:

    4


WHY WE ONLY COMPARE left AND right

If the boundary numbers differ at a bit position, the range between
them crosses a binary boundary at that position.

That guarantees the changing suffix contains both 0 and 1 somewhere
in the range. Consequently, its AND result must be zero.

Only the shared prefix is guaranteed to remain unchanged for every
number.


UPGRADE VERSION EXPLANATION

The upgrade uses this rule:

    number & (number - 1)

It removes the rightmost 1 bit from `number`.


EXAMPLE: 7

    7     = 0111
    7 - 1 = 0110

AND:

      0111
    & 0110
    ------
      0110

The rightmost 1 was removed.


Do it again:

    6     = 0110
    6 - 1 = 0101

AND:

      0110
    & 0101
    ------
      0100

Now `rightNumber` is 4, which is no longer greater than left = 5.

Return:

    4


WHY CLEARING RIGHTMOST 1s WORKS

If:

    left < right

then the lowest changing 1 in `right` cannot survive the AND of the
entire range. Some number between left and right has zero at that
position.

Therefore, we repeatedly remove changing rightmost 1 bits until the
remaining value is no greater than `left`. What remains is the common
prefix with zero suffix bits.


GPT'S SUMMARY

Core idea:
- The answer is the common binary prefix of `left` and `right`.
- Every bit after their common prefix changes somewhere in the range.
- A changing bit becomes zero after ANDing every number.

Swift syntax to remember:

    a & b       // Bitwise AND
    a &= b      // a = a & b
    a >> 1      // Shift right
    a >>= 1     // a = a >> 1
    a << count  // Shift left

Useful bit trick:

    number & (number - 1)

This clears the rightmost 1 bit.

Pattern:
- Bit manipulation / common binary prefix.

Fix-version state:
- `leftNumber`: shifted left boundary.
- `rightNumber`: shifted right boundary.
- `shiftCount`: number of removed suffix positions.

Fix-version loop contract:
- After every iteration, one non-common suffix position has been
  removed from both boundaries.
- When the values become equal, only their common prefix remains.

Complexity:

Fix version:
- Time: O(log right), because an integer has only logarithmically many
  binary positions.
- Space: O(1).

Upgrade version:
- Time: O(number of changing 1 bits), at most O(log right).
- Space: O(1).
*/