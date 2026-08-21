// ============================================================
// FIX VERSION: Check each binary digit from right to left
// ============================================================

class fixSolution {
    func hammingWeight(_ n: Int) -> Int {
        var number = n
        var count = 0

        while number != 0 {
            // number & 1 is 1 when the final bit is 1.
            count += (number & 1)

            // Shift right to inspect the next bit.
            number >>= 1
        }

        return count
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Brian Kernighan's algorithm: remove one 1-bit per iteration.
// ============================================================

class Solution {
    func hammingWeight(_ n: Int) -> Int {
        var number = n
        var count = 0

        while number != 0 {
            // Removes the lowest set bit from number.
            number &= number - 1
            count += 1
        }

        return count
    }
}

// ============================================================
// SWIFT BUILT-IN VERSION
// ============================================================

/*
class Solution {
    func hammingWeight(_ n: Int) -> Int {
        return n.nonzeroBitCount
    }
}
*/

// ============================================================
// YOUR ORIGINAL CODE AND THINKING COMMENTS
// Normalized from the pasted HTML/escape formatting.
// ============================================================

/*
class Solution {
    func hammingWeight(_ n: Int) -> Int {
        var i = 0
        var count = 0
        var result = 0

        while result < n {
            result += pow(2, count)
            count += 1
        }

        return count
    }
}

// Thinking
// Need to know how to caculate the count of bit 1
// feel like it is more like a math knowledge
// will try in 5 mins
// if not working, will check gpt just remember the rule
// start writing directly
// 1's count is 2^0, 2^1 ....
// so write above solution
// in 4 mins
// some swift synatx error, will let gpt to fix

// Pattern: N/A
// Card shape: N/A
// State needed: N/A
// Contract: N/A
// Recall: N/A
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
MAIN LOGIC MISTAKE:

Your loop adds consecutive powers of two:

    2^0 + 2^1 + 2^2 + ...

until the sum reaches n.

That calculates something related to n's binary length, but it does not
count which binary positions are actually 1.


EXAMPLE: n = 11

Binary representation:

    1011

The 1-bits are:

    1 + 2 + 8

There are three 1-bits, so the answer is:

    3


YOUR CALCULATION:

    result = 0

Add 2^0:

    result = 1
    count = 1

Add 2^1:

    result = 3
    count = 2

Add 2^2:

    result = 7
    count = 3

Add 2^3:

    result = 15
    count = 4

Your code returns 4, but the correct answer is 3.


SWIFT SYNTAX ISSUE:

pow() works with floating-point values and usually returns Double.

This does not match an Int result directly:

    result += pow(2, count)

For powers of two using integers, bit shifting is more appropriate:

    1 << count

But generating every power is still not the right algorithm here.


FIX-VERSION IDEA:

The expression:

    number & 1

checks the rightmost bit.

Examples:

    1011 & 0001 = 1
    1010 & 0001 = 0

Then:

    number >>= 1

shifts every bit one place to the right so we can inspect the next bit.


FIX-VERSION TRACE: n = 11

Start:

    number = 1011
    count = 0

Round 1:

    1011 & 0001 = 1
    count = 1
    number >>= 1 -> 0101

Round 2:

    0101 & 0001 = 1
    count = 2
    number >>= 1 -> 0010

Round 3:

    0010 & 0001 = 0
    count = 2
    number >>= 1 -> 0001

Round 4:

    0001 & 0001 = 1
    count = 3
    number >>= 1 -> 0000

Return:

    3


UPGRADE RULE:

    number & (number - 1)

removes the lowest 1-bit.


EXAMPLE: number = 12

Binary:

    number     = 1100
    number - 1 = 1011

AND:

    1100
  & 1011
  ------
    1000

One 1-bit was removed.

Do it again:

    number     = 1000
    number - 1 = 0111

    1000
  & 0111
  ------
    0000

There were two iterations, so 12 has two 1-bits.


WHY number - 1 CHANGES THE LOWEST 1-BIT:

Subtracting one:

1. Changes the lowest 1-bit to 0.
2. Changes every 0 after it to 1.

ANDing with the original number removes those changed lower bits,
including that lowest 1-bit.


PATTERN:

    Bit manipulation

CARD SHAPE:

Basic:

    Check final bit with number & 1.
    Shift right with number >>= 1.

Upgrade:

    Repeatedly remove one set bit with:
    number &= number - 1

STATE:

    Remaining number
    Count of set bits

CONTRACT:

At the start of every upgrade iteration:

    count equals the number of 1-bits removed so far.

Each iteration removes exactly one additional 1-bit.


COMPLEXITY:

Basic fix:

    Time:  O(log n), one iteration per binary position
    Space: O(1)

Upgrade:

    Time:  O(k), where k is the number of 1-bits
    Space: O(1)
*/