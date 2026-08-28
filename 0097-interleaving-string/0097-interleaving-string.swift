/*
YOUR ORIGINAL SOLUTION:

class Solution {
    func isInterleave(_ s1: String, _ s2: String, _ s3: String) -> Bool {
    }
}

// Thinking
// this is dp issue
// try to figure out the dp base case
// and convert case
// already 5 mins, give up,
// have no idea
// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/


// FIX VERSION: 2D DP.
// This is the easiest version to learn first.

class fixSolution {
    func isInterleave(_ s1: String, _ s2: String, _ s3: String) -> Bool {
        let first = Array(s1)
        let second = Array(s2)
        let target = Array(s3)

        let m = first.count
        let n = second.count

        // An interleaving must use every character exactly once.
        guard m + n == target.count else {
            return false
        }

        // dp[i][j] means:
        // Can first[0..<i] and second[0..<j] form target[0..<(i + j)]?
        var dp = Array(
            repeating: Array(repeating: false, count: n + 1),
            count: m + 1
        )

        // Empty first + empty second forms empty target.
        dp[0][0] = true

        for i in 0...m {
            for j in 0...n {
                if i == 0 && j == 0 {
                    continue
                }

                // The next target character after using i + j - 1
                // characters from the two input strings.
                let targetIndex = i + j - 1

                // Take the final character from s1.
                let fromFirst = i > 0 &&
                    dp[i - 1][j] &&
                    first[i - 1] == target[targetIndex]

                // Take the final character from s2.
                let fromSecond = j > 0 &&
                    dp[i][j - 1] &&
                    second[j - 1] == target[targetIndex]

                dp[i][j] = fromFirst || fromSecond
            }
        }

        return dp[m][n]
    }
}


// UPGRADE VERSION: 1D DP.
// Same recurrence, but each row replaces the previous row.

class Solution {
    func isInterleave(_ s1: String, _ s2: String, _ s3: String) -> Bool {
        let first = Array(s1)
        let second = Array(s2)
        let target = Array(s3)

        let m = first.count
        let n = second.count

        guard m + n == target.count else {
            return false
        }

        // dp[j] represents the current value of dp[i][j].
        var dp = Array(repeating: false, count: n + 1)
        dp[0] = true

        for i in 0...m {
            for j in 0...n {
                if i == 0 && j == 0 {
                    continue
                }

                let targetIndex = i + j - 1

                // Before updating dp[j], it still stores the previous row:
                // dp[i - 1][j].
                let fromFirst = i > 0 &&
                    dp[j] &&
                    first[i - 1] == target[targetIndex]

                // dp[j - 1] was already updated in this row:
                // dp[i][j - 1].
                let fromSecond = j > 0 &&
                    dp[j - 1] &&
                    second[j - 1] == target[targetIndex]

                dp[j] = fromFirst || fromSecond
            }
        }

        return dp[n]
    }
}


/*
GPT'S SUMMARY

The DP state:

    dp[i][j] = true

means:

    The first i characters of s1 and the first j characters of s2
    can form the first i + j characters of s3.

Important: `i` and `j` are lengths, not character indexes.

So:

    dp[0][0] = true

because two empty prefixes can form an empty target prefix.


THE TRANSITION

To form:

    s3[0..<(i + j)]

the final target character is:

    s3[i + j - 1]

That character must come from one of two places.


CHOICE 1: TAKE FROM s1

Use `s1[i - 1]` as the final character.

This works when:

    dp[i - 1][j] is true

and:

    s1[i - 1] == s3[i + j - 1]

In code:

    let fromFirst = i > 0 &&
        dp[i - 1][j] &&
        first[i - 1] == target[targetIndex]


CHOICE 2: TAKE FROM s2

Use `s2[j - 1]` as the final character.

This works when:

    dp[i][j - 1] is true

and:

    s2[j - 1] == s3[i + j - 1]

In code:

    let fromSecond = j > 0 &&
        dp[i][j - 1] &&
        second[j - 1] == target[targetIndex]


If either choice works:

    dp[i][j] = fromFirst || fromSecond


SMALL EXAMPLE

    s1 = "ab"
    s2 = "cd"
    s3 = "acbd"

To construct "acbd":

    take "a" from s1
    take "c" from s2
    take "b" from s1
    take "d" from s2

Therefore the answer is true.

One successful path through the DP table is:

    dp[0][0]
    -> dp[1][0]   take "a" from s1
    -> dp[1][1]   take "c" from s2
    -> dp[2][1]   take "b" from s1
    -> dp[2][2]   take "d" from s2


WHY CHECK LENGTH FIRST?

If:

    s1.count + s2.count != s3.count

then s3 cannot use every character from both input strings exactly once.

Return false immediately.


PATTERN:
- Dynamic programming
- Two-string prefix matching

STATE NEEDED:
- `i`: number of s1 characters used.
- `j`: number of s2 characters used.
- `i + j`: number of s3 characters that must be formed.

CONTRACT:
- `dp[i][j]` is true exactly when the corresponding s1 and s2
  prefixes can form the matching-length prefix of s3.

SWIFT SYNTAX TO REMEMBER:

    let characters = Array(someString)

This converts a String into `[Character]` for integer indexing.

    Array(
        repeating: Array(repeating: false, count: columns),
        count: rows
    )

This creates a 2D Boolean array.

COMPLEXITY:

Fix 2D version:
- Time: O(m * n)
- Space: O(m * n)

Upgrade 1D version:
- Time: O(m * n)
- Space: O(n)
*/