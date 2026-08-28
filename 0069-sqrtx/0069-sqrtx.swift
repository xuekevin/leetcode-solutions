/*
YOUR ORIGINAL SOLUTION:

class Solution {
    func mySqrt(_ x: Int) -> Int {
        if x == 0 {
            return 0
        }
        if x < 4 {
            return 1
        }
        if x == 4 {
            return 2
        }

        var left = 0
        var right = x / 2

        while left < right {
            var mid = (left + right) / 2
            var cur = mid * mid

            if cur == x || cur == x - 1 {
                return cur
            } else if cur < x - 1 {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }

        return left - 1
    }
}

// thinking
// call recall the answer should stay in 2 -> x/2,
// then we can just do the the pow, then compare with x
// not sure if this ifficient, might can do binary search
// start to write after 3
// finish writing, quick check, lgtm
// ready to run, got wrong answer for case x = 8
// assume should return left - 1 instead of return left
// ready to submit, wrong answer
// didn't pass for x == 0
// still fix, will let gpt to fix

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/


// FIX VERSION:
// Preserves your binary-search approach.

// class fixSolution {
//     func mySqrt(_ x: Int) -> Int {
//         if x < 2 {
//             return x
//         }

//         var left = 1
//         var right = x / 2
//         var answer = 1

//         while left <= right {
//             // This form avoids potential overflow from left + right.
//             let middle = left + (right - left) / 2

//             // Use division instead of `middle * middle`.
//             // This avoids multiplication overflow for a large input.
//             if middle <= x / middle {
//                 // middle² <= x, so middle is a possible answer.
//                 answer = middle

//                 // Search for a larger valid integer.
//                 left = middle + 1
//             } else {
//                 // middle² > x, so middle is too large.
//                 right = middle - 1
//             }
//         }

//         return answer
//     }
// }


// GPT'S UPGRADE VERSION:
// We do not need a separate `answer` variable.
// When the search ends, `right` is the largest value whose square
// is less than or equal to x.

class Solution {
    func mySqrt(_ x: Int) -> Int {
        if x < 2 {
            return x
        }

        var left = 1
        var right = x / 2

        while left <= right {
            let middle = left + (right - left) / 2

            if middle <= x / middle {
                // middle is valid, but there may be a larger valid value.
                left = middle + 1
            } else {
                // middle is too large.
                right = middle - 1
            }
        }

        // The loop exits when left == right + 1:
        //
        // right = largest valid value
        // left  = first invalid value
        return right
    }
}


/*
GPT'S EXAMPLE: x = 8

We want the largest integer whose square is <= 8.

Initial:

    left = 1
    right = 4

Round 1:

    middle = 2
    2 <= 8 / 2
    2 <= 4, so 2² <= 8

    Move left:
    left = 3

Round 2:

    left = 3
    right = 4
    middle = 3

    3 <= 8 / 3
    3 <= 2 is false, so 3² > 8

    Move right:
    right = 2

Now:

    left = 3
    right = 2

The loop ends and returns right, which is 2.


GPT'S SUMMARY

Your main idea was correct:
- Square root can be found using binary search.
- For x >= 4, the integer square root is no greater than x / 2.
- Compare the middle value and discard half of the search range.

Mistakes you made:

1. You returned the square instead of the square root.

   Wrong:

       if cur == x {
           return cur
       }

   If middle is 3 and x is 9:

       cur = 3 * 3 = 9

   The answer is 3, not 9.

   Correct:

       return middle

2. `cur == x - 1` does not prove that middle is the answer.

   For x = 10:

       middle = 3
       middle² = 9
       x - 1 = 9

   This happens to work.

   But for x = 15:

       floor(sqrt(15)) = 3
       3² = 9

   Here, 9 is not equal to 14. The correct condition is:

       middle² <= x
       and
       (middle + 1)² > x

   Binary search can find that boundary without checking `x - 1`.

3. `while left < right` did not match your updates.

   You used:

       left = middle + 1
       right = middle - 1

   Those updates represent a closed interval, so the matching loop is:

       while left <= right

4. `return left - 1` was not always reliable with your original loop.

   Example x = 5:

       left = 0
       right = 2
       middle = 1
       left becomes 2
       loop ends
       return left - 1 = 1

   But floor(sqrt(5)) is 2.

5. `middle * middle` could overflow for sufficiently large integers.

   Safer comparison:

       middle <= x / middle

Binary-search invariant:
- Values before `left` have already been shown to be valid candidates.
- Values after `right` have already been shown to be too large.
- When the loop finishes, `right` is the largest valid integer.

Pattern:
- Binary search for the last valid value.

State needed:
- `left`: beginning of the remaining search range.
- `right`: end of the remaining search range.
- `middle`: current candidate.

Complexity:
- Time: O(log x).
- Space: O(1).
*/