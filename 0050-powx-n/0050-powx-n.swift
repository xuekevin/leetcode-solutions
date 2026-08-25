/*
YOUR ORIGINAL SOLUTION:

class Solution {
    func myPow(_ x: Double, _ n: Int) -> Double {
        if n == 0 {
            return 1
        }

        var count = n > 0 ? n : abs(n)
        var isNegative = n < 0
        var res: Double = 1

        for i in 0..<count {
            res = res * x
        }

        if isNegative {
            res = 1 / res
        }

        return res
    }
}

// Thinking
// n can be + or -
//
// when n is pos,
// pow is do n times multiple for x
// negative is more like 1 / (x^n)
// finish writing in 9
// quick check
// ready to run, success
// ready to submit,  time out
// assume not that easy
// will let gpt to help

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/


// FIX VERSION:
// Your mathematical understanding was correct.
// The timeout is fixed using divide and conquer.

class fixSolution {
    func myPow(_ x: Double, _ n: Int) -> Double {
        // `magnitude` returns the absolute magnitude as UInt.
        // Unlike abs(n), it is also safe when n == Int.min.
        let exponent = n.magnitude
        let result = power(x, exponent)

        return n < 0 ? 1.0 / result : result
    }

    private func power(
        _ base: Double,
        _ exponent: UInt
    ) -> Double {
        if exponent == 0 {
            return 1.0
        }

        // Calculate only half of the exponent.
        let half = power(base, exponent / 2)

        if exponent % 2 == 0 {
            // x^10 = x^5 * x^5
            return half * half
        } else {
            // x^11 = x^5 * x^5 * x
            return half * half * base
        }
    }
}


// GPT'S UPGRADE VERSION:
// Iterative binary exponentiation.
// It has the same O(log n) time but avoids recursion-stack space.

class Solution {
    func myPow(_ x: Double, _ n: Int) -> Double {
        var base = n < 0 ? 1.0 / x : x
        var exponent = n.magnitude
        var result = 1.0

        while exponent > 0 {
            // If the current binary digit is 1, include the current base.
            if exponent % 2 == 1 {
                result *= base
            }

            // Prepare the base for the next binary position.
            base *= base

            // Remove the binary digit that was just processed.
            exponent /= 2
        }

        return result
    }
}


/*
GPT'S EXAMPLE: x = 2, n = 10

Normal multiplication performs:

    2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2

That requires 10 rounds.

Fast exponentiation notices:

    2^10
    = 2^5 * 2^5

And:

    2^5
    = 2^2 * 2^2 * 2

And:

    2^2
    = 2^1 * 2^1

The exponent is repeatedly divided by two:

    10 -> 5 -> 2 -> 1 -> 0

That requires only O(log n) rounds.


ITERATIVE VERSION LINE BY LINE

Starting values:

    base = 2
    exponent = 10
    result = 1

Round 1:

    exponent = 10, which is even
    Do not multiply result.

    base = 2 * 2 = 4
    exponent = 10 / 2 = 5

State:

    result = 1
    base = 4
    exponent = 5

Round 2:

    exponent = 5, which is odd
    result = 1 * 4 = 4

    base = 4 * 4 = 16
    exponent = 5 / 2 = 2

State:

    result = 4
    base = 16
    exponent = 2

Round 3:

    exponent = 2, which is even
    Do not multiply result.

    base = 16 * 16 = 256
    exponent = 2 / 2 = 1

State:

    result = 4
    base = 256
    exponent = 1

Round 4:

    exponent = 1, which is odd
    result = 4 * 256 = 1024

    exponent becomes 0

Return:

    1024


WHY THIS WORKS WITH BINARY

The binary representation of 10 is:

    1010

Therefore:

    10 = 8 + 2

So:

    2^10
    = 2^(8 + 2)
    = 2^8 * 2^2
    = 256 * 4
    = 1024

Each loop handles one binary digit of the exponent.


NEGATIVE EXPONENT EXAMPLE

For:

    x = 2
    n = -3

Instead of calculating first and dividing afterward, the upgrade
version changes the base:

    base = 1 / 2 = 0.5
    exponent = 3

Then:

    0.5^3 = 0.125

This is equivalent to:

    1 / 2^3 = 1 / 8 = 0.125


GPT'S SUMMARY

What you did well:
- Your understanding of positive exponents was correct.
- Your understanding of negative exponents was correct:

      x^(-n) = 1 / x^n

- Your code produced correct results for ordinary-sized inputs.
- The timeout was caused by performance, not your basic math.

Why your solution timed out:

Your loop runs `abs(n)` times:

    for _ in 0..<count {
        result *= x
    }

If n is approximately 2,000,000,000, the loop may perform approximately
two billion multiplications.

Your version:
- Time: O(|n|).

Fast exponentiation:
- Time: O(log |n|).

For an exponent around two billion:

    O(n):     about 2,000,000,000 rounds
    O(log n): about 31 rounds

Small Swift improvements:

1. Variables that do not change should use `let`.

   Original:

       var isNegative = n < 0

   Better:

       let isNegative = n < 0

2. An unused loop index should be `_`.

   Original:

       for i in 0..<count

   Better:

       for _ in 0..<count

3. `abs(Int.min)` can overflow.

   Potentially unsafe:

       abs(n)

   Safe magnitude:

       n.magnitude

   `magnitude` returns a UInt representing the nonnegative magnitude.

Pattern:
- Divide and conquer.
- Binary exponentiation.

Recursive contract:
- `power(base, exponent)` returns `base` raised to `exponent`.

Iterative state:
- `result`: powers already selected for the final answer.
- `base`: power represented by the current binary position.
- `exponent`: binary positions that remain to be processed.

Iterative loop contract:
- At the top of every loop, `result` contains the selected powers
  already processed, while `base^exponent` represents the contribution
  that still remains.

Complexity:

Original version:
- Time: O(|n|).
- Space: O(1).

Fix recursive version:
- Time: O(log |n|).
- Space: O(log |n|) for the recursion stack.

Upgrade iterative version:
- Time: O(log |n|).
- Space: O(1).
*/