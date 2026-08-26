/*
YOUR ORIGINAL SOLUTION:

class Solution {
    var memo = [[Int]]()

    func minDistance(_ word1: String, _ word2: String) -> Int {
        let m = word1.count
        let n = word2.count

        for i in 0..<m {
            for j in 0..<n {
                memo[i][j] = -1
            }
        }

        return dp(Array(word1), Array(word2), m-1, n-1)
    }

    func dp(
        _ word1: [Character],
        _ word2: [Character],
        _ i: Int,
        _ j: Int
    ) -> Int {
        if i == -1 {
            // j + 1 is the total count operation need to do
            return j + 1
        }

        if j == -1 {
            return i + 1
        }

        if memo[i][j] != -1 {
            return memo[i][j]
        }

        if word1[i] == word2[j] {
            memo[i][j] = dp(word1, word2, i-1, j-1)
        } else {
            let operation1 = dp(word1, word2, i-1, j) + 1
            let operation2 = dp(word1, word2, i, j-1) + 1
            let operation3 = dp(word1, word2, i-1, j-1) + 1
            memo[i][j] = min(operation1, min(operation2, operation3))
        }

        return memo[i][j]
    }
}

// Thinking
//
// Pattern: DP issue
// Card shape: dp function
// dp[i][j] means the minimum number I need to operation for
// word1[0..i] and word[0..j]
// think base case
// dp[0][0] = word1[0] == word2[0] ? 0 : 1
// think convert logic
// stop in here
// now can recall should start from end, since 2 words are different length
// dp[i] should word[0..(i-1)]
//
// dp[i][j] = dp[i-1][j-1] +
// already 15 mins
// need to check the doc again to figure out how to write dp function
// checked the doc
// now know the logic
// dp[i][j] i, j can be the index, but I should start from the end
// kind like top down
// if word1[i] = word[j]
// dp(i,j) = dp(i-1, j-1)
// else
// dp(i,j) : dp(i-1, j) + 1
// means insert last in word1's i then be same with word2
// dp(i, j-1) +1
// means delete last j in word2
// dp(i-1, j-1) + 1 means doing operation
// dp[0][0] = 0
// dp[i][0] = i
// dp[0][j] = j
// ready to start to write code
//
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
//
// spend around 30 mins
// has some synatx, will let gpt to fix
*/


// FIX VERSION:
// Your recurrence and base cases were correct.
// The crash happens because `memo` was empty when you accessed memo[i][j].

class fixSolution {
    private var memo = [[Int]]()

    func minDistance(_ word1: String, _ word2: String) -> Int {
        let word1Array = Array(word1)
        let word2Array = Array(word2)

        let m = word1Array.count
        let n = word2Array.count

        // Wrong:
        //
        // for i in 0..<m {
        //     for j in 0..<n {
        //         memo[i][j] = -1
        //     }
        // }
        //
        // Why:
        // `memo` was still an empty array. Subscript assignment does not
        // automatically create rows and columns.
        //
        // Correct: create an m-by-n array first.
        memo = Array(
            repeating: Array(repeating: -1, count: n),
            count: m
        )

        return dp(word1Array, word2Array, m - 1, n - 1)
    }

    private func dp(
        _ word1: [Character],
        _ word2: [Character],
        _ i: Int,
        _ j: Int
    ) -> Int {
        // word1 is empty, so insert every remaining word2 character.
        if i < 0 {
            return j + 1
        }

        // word2 is empty, so delete every remaining word1 character.
        if j < 0 {
            return i + 1
        }

        if memo[i][j] != -1 {
            return memo[i][j]
        }

        if word1[i] == word2[j] {
            // Matching final characters require no new operation.
            memo[i][j] = dp(word1, word2, i - 1, j - 1)
        } else {
            // Delete word1[i].
            let delete = dp(word1, word2, i - 1, j) + 1

            // Insert word2[j] after word1's current prefix.
            let insert = dp(word1, word2, i, j - 1) + 1

            // Replace word1[i] with word2[j].
            let replace = dp(word1, word2, i - 1, j - 1) + 1

            memo[i][j] = min(delete, insert, replace)
        }

        return memo[i][j]
    }
}


// GPT'S UPGRADE VERSION:
// Bottom-up DP using only one row of memory.

class Solution {
    func minDistance(_ word1: String, _ word2: String) -> Int {
        let first = Array(word1)
        let second = Array(word2)

        let m = first.count
        let n = second.count

        // dp[j] initially means:
        // converting an empty word1 into the first j characters of word2.
        var dp = Array(0...n)

        for i in 1..<(m + 1) {
            // Before overwriting dp[0], save the old diagonal value.
            var previousDiagonal = dp[0]

            // Converting the first i word1 characters into an empty word2
            // requires i deletions.
            dp[0] = i

            for j in 1..<(n + 1) {
                // dp[j] currently stores the value from the row above:
                // previousRow[j].
                let previousRowValue = dp[j]

                if first[i - 1] == second[j - 1] {
                    // Matching characters use the previous diagonal.
                    dp[j] = previousDiagonal
                } else {
                    // dp[j]     = previous row, same column: delete
                    // dp[j - 1] = current row, previous column: insert
                    // previousDiagonal = previous row/column: replace
                    dp[j] = 1 + min(
                        dp[j],
                        dp[j - 1],
                        previousDiagonal
                    )
                }

                // Prepare the diagonal value for the next column.
                previousDiagonal = previousRowValue
            }
        }

        return dp[n]
    }
}


/*
GPT'S EXPLANATION

Your DP definition is correct:

    dp(i, j)

means:

    the minimum operations required to convert
    word1[0...i] into word2[0...j]


BASE CASE 1

If:

    i == -1

then word1's current prefix is empty.

To create word2[0...j], insert all j + 1 characters:

    return j + 1


BASE CASE 2

If:

    j == -1

then word2's current prefix is empty.

Delete all i + 1 characters from word1:

    return i + 1


WHEN THE FINAL CHARACTERS MATCH

If:

    word1[i] == word2[j]

we do not need an operation for these characters.

Therefore:

    dp(i, j) = dp(i - 1, j - 1)


WHEN THE FINAL CHARACTERS DO NOT MATCH

We have three choices.


1. DELETE word1[i]

Before:

    word1[0...i]

Delete its final character, leaving:

    word1[0...(i - 1)]

State:

    dp(i - 1, j) + 1


2. INSERT word2[j]

Insert word2[j] at the end of word1's current prefix.

That inserted character now matches word2[j], so the remaining problem
is matching word1[0...i] with word2[0...(j - 1)]:

    dp(i, j - 1) + 1


3. REPLACE word1[i]

Replace word1[i] with word2[j].

The final characters now match, leaving:

    dp(i - 1, j - 1) + 1


Take the minimum:

    dp(i, j) = 1 + min(
        dp(i - 1, j),       // delete
        dp(i, j - 1),       // insert
        dp(i - 1, j - 1)    // replace
    )


EXAMPLE: "horse" -> "ros"

Start from the final characters:

    horse
        ^
    ros
      ^

'e' and 's' do not match, so choose the cheapest of:

- Delete 'e'
- Insert 's'
- Replace 'e' with 's'

The recursive function solves all three smaller states and memoization
ensures each state is calculated only once.


THE MAIN MISTAKE

You declared:

    var memo = [[Int]]()

This creates an empty two-dimensional array:

    []

Then you tried:

    memo[i][j] = -1

Swift subscripts only access existing elements. They do not expand an
array automatically, so this crashes.

Correct two-dimensional initialization:

    memo = Array(
        repeating: Array(repeating: -1, count: n),
        count: m
    )

This creates:

    m rows
    n columns in each row


SMALL CORRECTION TO YOUR OPERATION COMMENTS

You wrote that:

    dp(i - 1, j) + 1

means insert. It actually represents deleting word1[i].

And:

    dp(i, j - 1) + 1

represents inserting word2[j] into word1.

The recurrence itself was correct; only the operation names were
reversed.


TOP-DOWN CONTRACT

When:

    dp(word1, word2, i, j)

returns, it gives the minimum number of operations required to convert:

    word1[0...i]

into:

    word2[0...j]


WHY THE UPGRADE NEEDS ONLY ONE ROW

The two-dimensional recurrence uses only:

    dp[i - 1][j]       // above
    dp[i][j - 1]       // left
    dp[i - 1][j - 1]   // diagonal

In the one-dimensional array:

    dp[j]

before updating means the value above.

    dp[j - 1]

after updating means the value to the left.

    previousDiagonal

stores the old diagonal value.


GPT'S SUMMARY

What you did well:
- You correctly identified this as dynamic programming.
- Your state definition was correct.
- Your recursive direction from the ends of both strings was correct.
- Both base cases were correct.
- Your three recurrence calls were correct.
- You correctly added memoization.

Mistakes:
- `memo` was never allocated before subscript access.
- The names of insertion and deletion were reversed in your comments.
- Converting each String to `[Character]` once is clearer than doing it
  inside repeated recursive work.

Swift syntax to remember:

Create an m-by-n integer array:

    Array(
        repeating: Array(repeating: -1, count: n),
        count: m
    )

Convert String for integer subscript access:

    let characters = Array(word)

Minimum of three values:

    min(a, b, c)

Pattern:
- Dynamic programming / edit distance.

Complexity:

Fix top-down version:
- Time: O(m * n).
- Space: O(m * n) for memoization, plus recursion stack.

Upgrade bottom-up version:
- Time: O(m * n).
- Space: O(n), where n is word2.count.
*/