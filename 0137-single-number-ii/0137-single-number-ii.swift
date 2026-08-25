/*
PROBLEM: 137. Single Number II

Every number appears exactly three times except one number, which
appears exactly once.

Requirements:
- Linear runtime: O(n)
- Constant extra space: O(1)

Examples:

    [2, 2, 3, 2] -> 3

    [0, 1, 0, 1, 0, 1, 99] -> 99


YOUR ORIGINAL THOUGHT:

class Solution {
    func singleNumber(_ nums: [Int]) -> Int {
    }
}

// Thinking
// this issue was belong to bit operation
// so thinking for this direction
// forget the rule, same number do the & or ^ what's the result
// this is more about bit knowledge, so will just ask gpt then remember
// this rule in the future

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/


// FIX VERSION:
// Count the number of 1s at each of the 32 bit positions.
// After `% 3`, only the single number's bit remains.

class fixSolution {
    func singleNumber(_ nums: [Int]) -> Int {
        var result: UInt32 = 0

        // The problem uses 32-bit signed integers.
        for bitPosition in 0..<32 {
            var oneCount = 0

            for number in nums {
                // Convert the signed Int into its 32-bit binary pattern.
                let bits = UInt32(bitPattern: Int32(number))

                // Move the target bit to the rightmost position.
                let currentBit = (bits >> bitPosition) & 1

                oneCount += Int(currentBit)
            }

            // Numbers appearing three times contribute a multiple of 3.
            // A remainder of 1 means the single number has a 1 here.
            if oneCount % 3 == 1 {
                result |= UInt32(1) << bitPosition
            }
        }

        // Convert the completed 32-bit pattern back to a signed integer.
        return Int(Int32(bitPattern: result))
    }
}


// GPT'S UPGRADE VERSION:
// Use `ones` and `twos` to count every bit modulo 3 simultaneously.
//
// For each bit:
// - state 00: seen zero times
// - state 01: seen once
// - state 10: seen twice
// - after the third time, return to 00

class Solution {
    func singleNumber(_ nums: [Int]) -> Int {
        var ones = 0
        var twos = 0

        for number in nums {
            // Add this number's bits to the "seen once" state.
            // Remove bits that are already in "seen twice".
            ones = (ones ^ number) & ~twos

            // Add this number's bits to the "seen twice" state.
            // Remove bits that are now in "seen once".
            twos = (twos ^ number) & ~ones
        }

        // Bits appearing three times have disappeared from both states.
        // Bits appearing once remain in `ones`.
        return ones
    }
}


/*
WHY ORDINARY XOR DOES NOT WORK

For Single Number I, every duplicated number appears twice:

    a ^ a = 0

Therefore XOR removes the duplicate pair.

But in Single Number II, each duplicated number appears three times:

    a ^ a ^ a
    = 0 ^ a
    = a

Three equal values do not disappear.

Example:

    2 ^ 2 ^ 2 ^ 3
    = 2 ^ 3

Therefore, simply XORing every number cannot solve this problem.


FIX VERSION IDEA: COUNT EACH BIT

Every integer contains 32 bits.

For each bit position:

1. Count how many numbers contain a 1.
2. Take that count modulo 3.
3. Values appearing three times disappear.
4. The remainder is the single number's bit.


EXAMPLE: [2, 2, 3, 2]

Four-bit representations:

    2 = 0010
    2 = 0010
    3 = 0011
    2 = 0010


BIT POSITION 0

Values:

    0 + 0 + 1 + 0 = 1

Modulo three:

    1 % 3 = 1

The answer's bit 0 is 1.


BIT POSITION 1

Values:

    1 + 1 + 1 + 1 = 4

The three copies of 2 contribute three 1s.
The single number 3 contributes one additional 1.

Modulo three:

    4 % 3 = 1

The answer's bit 1 is 1.


BIT POSITIONS 2 AND 3

All values are zero:

    0 % 3 = 0

Rebuilt answer:

    0011 = 3


HOW TO READ ONE BIT

Code:

    let currentBit = (bits >> bitPosition) & 1

Suppose:

    bits = 1101
    bitPosition = 2

Shift right by two:

    1101 >> 2 = 0011

Keep only the rightmost bit:

    0011 & 0001 = 0001

Therefore bit position 2 contains 1.


HOW TO SET ONE BIT

Code:

    result |= UInt32(1) << bitPosition

Suppose `bitPosition` is 2:

    UInt32(1) << 2 = 0100

Use OR to add it to the result:

      result
    | 0100
    ------
      updated result


WHY UInt32 AND Int32 ARE USED

The input can contain negative 32-bit integers.

A negative integer uses two's-complement representation. We need to
preserve its exact 32-bit pattern while counting bits.

Convert to an unsigned bit pattern:

    UInt32(bitPattern: Int32(number))

After rebuilding the result, interpret that pattern as signed again:

    Int(Int32(bitPattern: result))

This makes the solution work for both positive and negative answers.


UPGRADE VERSION IDEA: TWO BITMASKS

The upgrade processes all 32 positions at the same time.

For every bit, `ones` and `twos` store how many times that bit has
appeared modulo three:

    ones bit    twos bit    Meaning
       0           0        Seen 0 times
       1           0        Seen 1 time
       0           1        Seen 2 times
       0           0        Seen 3 times, reset


PROCESS ONE BIT THREE TIMES

Initial state:

    ones = 0
    twos = 0


First appearance:

    ones = 1
    twos = 0

The bit has been seen once.


Second appearance:

    ones = 0
    twos = 1

The bit has been seen twice.


Third appearance:

    ones = 0
    twos = 0

The bit has appeared three times and disappears.


WHY THE FINAL ANSWER IS `ones`

Every normal number appears three times, so all of its bits return to:

    ones = 0
    twos = 0

The single number appears once, so its bits remain inside:

    ones

Therefore:

    return ones


SWIFT BITWISE SYNTAX TO REMEMBER

XOR:

    a ^ b

AND:

    a & b

OR:

    a | b

NOT:

    ~a

Shift right:

    a >> position

Shift left:

    a << position

Set one bit:

    result |= 1 << position

Read one bit:

    (number >> position) & 1


GPT'S SUMMARY

What you understood correctly:
- This is a bit-manipulation problem.
- Ordinary storage such as a dictionary would use O(n) extra space.
- The key is finding a way to cancel values appearing three times.

Important rules:

    a ^ a = 0
    a ^ a ^ a = a

Therefore ordinary XOR solves duplicate pairs but does not solve
duplicate triples.

Fix-version pattern:
- Count each bit.
- Apply modulo 3.
- Rebuild the single number.

Upgrade-version pattern:
- Use two bitmasks as a modulo-3 state machine.
- `ones` stores bits seen once.
- `twos` stores bits seen twice.
- A third appearance removes the bit from both.

Fix-version loop contract:
- After processing one bit position, that position in `result` equals
  the corresponding bit in the number that appears once.

Upgrade-version loop contract:
- After processing each number, every bit in `ones` and `twos`
  represents its occurrence count modulo three.

Complexity:

Fix version:
- Time: O(32 * n), which simplifies to O(n).
- Space: O(1).

Upgrade version:
- Time: O(n).
- Space: O(1).

Recommendation:
- Learn the bit-counting version first because its reasoning is easier
  to reconstruct during an interview.
- Treat the `ones` and `twos` version as an advanced optimization after
  the modulo-3 idea is fully comfortable.
*/