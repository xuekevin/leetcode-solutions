// ============================================================
// FIX VERSION: Directly follows your odd/even center idea
// ============================================================

class fixSolution {
    func longestPalindrome(_ s: String) -> String {
        let characters = Array(s)

        if characters.isEmpty {
            return ""
        }

        var bestStart = 0
        var bestLength = 1

        for center in 0..<characters.count {
            // Case 1: Odd-length palindrome.
            // Example: "aba" has one center character.
            expand(
                characters,
                center,
                center,
                &bestStart,
                &bestLength
            )

            // Case 2: Even-length palindrome.
            // Example: "abba" has a center gap between two b characters.
            expand(
                characters,
                center,
                center + 1,
                &bestStart,
                &bestLength
            )
        }

        let bestEnd = bestStart + bestLength

        return String(characters[bestStart..<bestEnd])
    }

    func expand(
        _ characters: [Character],
        _ initialLeft: Int,
        _ initialRight: Int,
        _ bestStart: inout Int,
        _ bestLength: inout Int
    ) {
        var left = initialLeft
        var right = initialRight

        // Continue while both indexes are valid and the characters match.
        while left >= 0
            && right < characters.count
            && characters[left] == characters[right] {
            left -= 1
            right += 1
        }

        // left and right are now one position outside the palindrome.
        let currentStart = left + 1
        let currentLength = right - left - 1

        if currentLength > bestLength {
            bestStart = currentStart
            bestLength = currentLength
        }
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Same algorithm with a helper that returns the palindrome length.
// ============================================================

class Solution {
    func longestPalindrome(_ s: String) -> String {
        let characters = Array(s)

        if characters.isEmpty {
            return ""
        }

        var start = 0
        var end = 0

        for center in 0..<characters.count {
            // Palindrome centered on one character.
            let oddLength = expand(
                characters,
                center,
                center
            )

            // Palindrome centered between two characters.
            let evenLength = expand(
                characters,
                center,
                center + 1
            )

            let currentLength = max(oddLength, evenLength)
            let bestLength = end - start + 1

            if currentLength > bestLength {
                // Convert center and length into start/end indexes.
                start = center - (currentLength - 1) / 2
                end = center + currentLength / 2
            }
        }

        return String(characters[start...end])
    }

    // Contract:
    // Returns the length of the longest palindrome centered between
    // the supplied left and right positions.
    func expand(
        _ characters: [Character],
        _ initialLeft: Int,
        _ initialRight: Int
    ) -> Int {
        var left = initialLeft
        var right = initialRight

        while left >= 0
            && right < characters.count
            && characters[left] == characters[right] {
            left -= 1
            right += 1
        }

        return right - left - 1
    }
}

// ============================================================
// YOUR ORIGINAL CODE AND THINKING COMMENTS
// ============================================================

/*
class Solution {
    func longestPalindrome(_ s: String) -> String {
        
    }
}

// Thinking
// how to define palindromic 
// and we need longest 
// how to find a palindromic
// start from short length str
// might can start to choose every element as middle of a palindromic string
// the extend its left and right until it is break
// so it consider 2 cases if it is odd or even
// 1 element as center
// 2 element as center
// use example to figure out 

// for loop s 
// 1: b, longest: 1
// can't go left
// so choose b's next index as center 
// check ba, is not
// then choose a as center, go to left and go right,, longest now is 3
// keep going, until babad is not correct
// then chose a's next position, ab not valid, 
// move to b, aba is correct
// then move to a, and d 
// seems this can work, 
// the TC is do a search in a for loop, so tc should be O(n^2)
// it already 13 mins, will let gpt to figure out my solution is right or not

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
YOUR SOLUTION IDEA IS CORRECT.

Every palindrome has one of two center shapes:

1. Odd length:

       b a b
         ^
       center

   Start with:

       left = center
       right = center

2. Even length:

       a b b a
         ^ ^
        center gap

   Start with:

       left = center
       right = center + 1


WHY CHECK BOTH CASES?

If we check only one-character centers, we find:

    "a"
    "aba"
    "abcba"

But we miss:

    "aa"
    "abba"

If we check only two-character centers, we have the opposite problem.


EXAMPLE: "babad"

characters:

    index: 0 1 2 3 4
    value: b a b a d

Center = 0:

    Odd expansion:
        "b"

    Even expansion:
        "ba" does not match

    Best = "b"


Center = 1:

    Odd expansion:

        left = 1, right = 1 -> "a"
        left = 0, right = 2 -> "bab"
        left = -1, right = 3 -> stop

    Best = "bab"

    Even expansion:
        characters[1] != characters[2]
        "ab" is not a palindrome


Center = 2:

    Odd expansion:

        "b"
        "aba"
        next comparison is b and d, so stop

    "aba" also has length 3.

Because the code updates only when a strictly longer palindrome is
found, the existing answer "bab" remains.


WHY LENGTH IS:

    right - left - 1

When expansion stops, left and right are outside the palindrome.

Example:

    "bab"

After expansion:

    left = -1
    right = 3

Length:

    right - left - 1
    = 3 - (-1) - 1
    = 3


HOW THE UPGRADE CALCULATES START AND END:

For odd length 3 centered at index 1:

    start = 1 - (3 - 1) / 2
          = 0

    end = 1 + 3 / 2
        = 2

Result:

    characters[0...2] = "bab"


For even length 4 using center index 1:

    start = 1 - (4 - 1) / 2
          = 0

    end = 1 + 4 / 2
        = 3

Result:

    characters[0...3] = "abba"


WHY CONVERT STRING TO [Character]?

Swift String does not support integer subscripting:

    s[0] // Invalid Swift

Converting it allows:

    let characters = Array(s)
    characters[left]


PATTERN:

    Expand around center + two pointers

CARD SHAPE:

    For every possible center:
    1. Expand as an odd palindrome.
    2. Expand as an even palindrome.
    3. Update the longest result.

STATE NEEDED:

    start
    end
    left
    right

CONTRACT:

    expand(left, right) returns the length of the longest palindrome
    with exactly that center.


COMPLEXITY:

There are O(n) centers.

Each center may expand across O(n) characters.

Time:

    O(n²)

Swift character array and returned output:

    O(n) space

The expansion algorithm itself uses:

    O(1) auxiliary state
*/