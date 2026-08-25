/*
YOUR ORIGINAL SOLUTION:

class Solution {
    func trailingZeroes(_ n: Int) -> Int {
    }
}

// Thinking
// how to define n!
// and how to define it has tailing zero
// for last 0
// it multiple 10
// for 2 zero, it multpile 100
// don't know the rule
// seems it is an other math issue
// will just ask gpt to help
// and remember

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/


class Solution {
    func trailingZeroes(_ n: Int) -> Int {
        var number = n
        var zeroCount = 0

        // Count how many factors of 5 exist inside n!.
        while number >= 5 {
            number /= 5
            zeroCount += number
        }

        return zeroCount
    }
}


/*
GPT'S EXPLANATION

A trailing zero is created by multiplying 10:

    10 = 2 * 5

Therefore, every matching pair of:

    one factor 2
    one factor 5

creates one trailing zero.


WHY ONLY COUNT 5?

Inside a factorial, factors of 2 appear much more frequently than
factors of 5.

Example:

    10! = 1 * 2 * 3 * 4 * 5 * 6 * 7 * 8 * 9 * 10

Factors of 2 appear in:

    2, 4, 6, 8, 10

Factors of 5 appear in:

    5, 10

There are always enough factors of 2 to pair with the factors of 5.

Therefore:

    number of trailing zeros
    = number of factors of 5 inside n!


FIRST COUNT: MULTIPLES OF 5

Every multiple of 5 contributes at least one factor of 5:

    5, 10, 15, 20, 25, ...

The number of multiples of 5 from 1 through n is:

    n / 5


BUT SOME NUMBERS CONTRIBUTE MORE THAN ONE 5

For example:

    25 = 5 * 5

So 25 contributes two factors of 5.

The first calculation:

    n / 5

already counts one of those factors.

We must count the extra factor using:

    n / 25


Likewise:

    125 = 5 * 5 * 5

It contributes three factors of 5.

These are counted through:

    n / 5
    n / 25
    n / 125


GENERAL FORMULA

    trailing zeros
    = n / 5
    + n / 25
    + n / 125
    + n / 625
    + ...

Stop when the division result becomes zero.


EXAMPLE: n = 10

    10 / 5 = 2
    10 / 25 = 0

Answer:

    2

Indeed:

    10! = 3628800

It has two trailing zeros.


EXAMPLE: n = 25

Multiples of 5:

    5, 10, 15, 20, 25

That initially gives five factors of 5.

But:

    25 = 5 * 5

So 25 contributes one additional factor.

Calculation:

    25 / 5  = 5
    25 / 25 = 1

Total:

    5 + 1 = 6

Therefore, 25! has six trailing zeros.


EXAMPLE: n = 100

First division:

    100 / 5 = 20

This counts one factor of 5 from:

    5, 10, 15, ..., 100

Second division:

    100 / 25 = 4

This counts one additional factor from:

    25, 50, 75, 100

Third division:

    100 / 125 = 0

Total:

    20 + 4 = 24

Therefore, 100! has 24 trailing zeros.


LINE-BY-LINE EXPLANATION

    var number = n

`number` will repeatedly be divided by 5.

    var zeroCount = 0

Stores the total number of factors of 5.

    while number >= 5 {

Continue while another factor-of-5 level exists.

    number /= 5

The values of `number` become:

    n / 5
    n / 25
    n / 125
    ...

    zeroCount += number

Add the number of factors contributed by the current level.

    return zeroCount

Every factor of 5 can pair with an available factor of 2, so the total
is also the number of trailing zeros.


WHY NOT CALCULATE n! DIRECTLY?

Factorials become extremely large.

For example:

    20! = 2,432,902,008,176,640,000

Larger factorials quickly exceed the range of Swift's `Int`.

Also, calculating the complete factorial does unnecessary work. We only
need to count factors of 5, not calculate the factorial's value.


GPT'S SUMMARY

Key rule to remember:

    A trailing zero comes from 10.
    10 = 2 * 5.
    Factorials contain more 2s than 5s.
    Therefore, count factors of 5.

Formula:

    n / 5 + n / 25 + n / 125 + ...

Why divide repeatedly:
- `n / 5` counts every number containing at least one factor of 5.
- `n / 25` counts the second factor in multiples of 25.
- `n / 125` counts the third factor in multiples of 125.
- Continue until the result becomes zero.

Pattern:
- Math / factor counting.

State needed:
- `number`: current factor-of-5 level.
- `zeroCount`: total number of factors of 5.

Loop contract:
- After every iteration, `zeroCount` includes all factors of 5 from
  the powers of 5 processed so far.

Complexity:
- Time: O(log₅ n).
- Space: O(1).
*/