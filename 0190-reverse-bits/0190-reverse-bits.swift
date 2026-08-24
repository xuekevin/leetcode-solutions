/*
YOUR ORIGINAL SOLUTION:

class Solution {
    func reverseBits(_ n: Int) -> Int {
        count = 32
        var num = n
        while count >= 0 {
            var temp = num -> 1
            num =
        }
    }
}

// Thinking
// vaguely remember do the shift operation can solve this
// but forgot how to write the in code
// basically shift the last position in the right, the shift it to the left side
// will let gpt to help

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/


// FIX VERSION:
// Your idea was correct: take bits from the right side of `num`
// and add them to the right side of `result`.

class fixSolution {
    func reverseBits(_ n: Int) -> Int {
        // Wrong: count = 32
        // Why: a local variable must be declared with `let` or `var`.
        var count = 32
        var num = n
        var result = 0

        // Correct: use `> 0`, not `>= 0`.
        // Starting from 32, `>= 0` would execute 33 times.
        while count > 0 {
            // Get the rightmost bit.
            let lastBit = num & 1

            // Make room in result, then place lastBit into that space.
            result = (result << 1) | lastBit

            // Wrong: num -> 1
            // Correct right-shift operator: >>
            num = num >> 1

            count -= 1
        }

        // Wrong: the original function did not return an Int.
        return result
    }
}


// GPT'S UPGRADE VERSION:
// Same algorithm, but a fixed-range loop expresses "repeat 32 times"
// more directly and avoids manually updating `count`.

class Solution {
    func reverseBits(_ n: Int) -> Int {
        var num = n
        var result = 0

        for _ in 0..<32 {
            result <<= 1
            result |= num & 1
            num >>= 1
        }

        return result
    }
}


/*
GPT'S LINE-BY-LINE EXAMPLE

Use a smaller 4-bit example:

    num = 1101
    result = 0000

We still use the same logic, but repeat four times instead of 32.

Round 1:

    lastBit = num & 1
            = 1101 & 0001
            = 1

    result <<= 1
    0000 becomes 0000

    result |= lastBit
    0000 | 0001 = 0001

    num >>= 1
    1101 becomes 0110

Round 2:

    lastBit = 0110 & 0001 = 0
    result: 0001 << 1 = 0010
    result: 0010 | 0 = 0010
    num:    0110 >> 1 = 0011

Round 3:

    lastBit = 0011 & 0001 = 1
    result: 0010 << 1 = 0100
    result: 0100 | 1 = 0101
    num:    0011 >> 1 = 0001

Round 4:

    lastBit = 0001 & 0001 = 1
    result: 0101 << 1 = 1010
    result: 1010 | 1 = 1011
    num:    0001 >> 1 = 0000

Final result:

    Original: 1101
    Reversed: 1011


GPT'S SUMMARY

Your idea:
- Your original idea was correct.
- Remove the rightmost bit from `num`.
- Shift `result` left.
- Add the removed bit to `result`.
- Repeat exactly 32 times.

Swift bitwise syntax:

    value & 1     // Get the rightmost bit
    value << 1    // Shift left by one bit
    value >> 1    // Shift right by one bit
    value | bit   // Combine a bit with value

Compound assignment syntax:

    result <<= 1  // Same as result = result << 1
    result |= bit // Same as result = result | bit
    num >>= 1     // Same as num = num >> 1

Mistakes you made:
- `count` needed to be declared with `var`.
- The right-shift operator is `>>`, not `->`.
- The result needed its own variable.
- The loop must execute exactly 32 times.
- The function needed to return an `Int`.

Pattern:
- Bit manipulation.

State needed:
- `num`: the unprocessed input bits.
- `result`: the bits already reversed.
- A loop that executes exactly 32 times.

Loop contract:
- At the top of each iteration, `result` contains the input bits
  already removed from `num`, arranged in reverse order.

Complexity:
- Time: O(1), because the loop always executes exactly 32 times.
- Space: O(1).
*/