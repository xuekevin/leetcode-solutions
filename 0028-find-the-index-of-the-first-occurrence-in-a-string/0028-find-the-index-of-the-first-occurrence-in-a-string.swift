// ============================================================
// FIX VERSION: Follows your x/y pointer and backtracking approach
// ============================================================

class fixSolution {
    func strStr(_ haystack: String, _ needle: String) -> Int {
        if needle.isEmpty {
            return 0
        }

        let haystackCharacters = Array(haystack)
        let needleCharacters = Array(needle)

        if needleCharacters.count > haystackCharacters.count {
            return -1
        }

        var x = 0
        var y = 0
        var start = -1

        while x < haystackCharacters.count {
            // There are not enough remaining characters to complete
            // the current match or any later match.
            if haystackCharacters.count - x
                < needleCharacters.count - y {
                return -1
            }

            if haystackCharacters[x] == needleCharacters[y] {
                // Record the beginning of this candidate match.
                if start == -1 {
                    start = x
                }

                x += 1
                y += 1

                // Every needle character matched.
                if y == needleCharacters.count {
                    return start
                }
            } else {
                if start != -1 {
                    // Retry from one position after the failed start.
                    x = start + 1
                    y = 0

                    // Important: begin a completely new candidate.
                    start = -1
                } else {
                    // No partial match existed, so move haystack forward.
                    x += 1
                }
            }
        }

        return -1
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Recommended: explicitly test each possible starting position.
// ============================================================

class Solution {
    func strStr(_ haystack: String, _ needle: String) -> Int {
        if needle.isEmpty {
            return 0
        }

        let haystackCharacters = Array(haystack)
        let needleCharacters = Array(needle)

        if needleCharacters.count > haystackCharacters.count {
            return -1
        }

        let finalStart =
            haystackCharacters.count - needleCharacters.count

        // Only these indexes have enough remaining characters.
        for start in 0...finalStart {
            var offset = 0

            // Compare needle with haystack beginning at start.
            while offset < needleCharacters.count
                && haystackCharacters[start + offset]
                    == needleCharacters[offset] {
                offset += 1
            }

            // Every needle character matched.
            if offset == needleCharacters.count {
                return start
            }
        }

        return -1
    }
}

// ============================================================
// YOUR ORIGINAL CODE AND THINKING COMMENTS
// Normalized from the pasted HTML/escape formatting.
// ============================================================

/*
class Solution {
    func strStr(_ haystack: String, _ needle: String) -> Int {
        if needle.count > haystack.count {
            return -1
        }

        var x = 0
        var y = 0
        let stackCount = haystack.count
        let needleCount = needle.count

        var start: Int = -1

        while x < stackCount {
            if stackCount - x < needleCount - y {
                return -1
            }

            if haystack[x] == needle[y] {
                if start == -1 {
                    start = x
                } else if y == needleCount - 1 {
                    return start
                }

                x += 1
                y += 1
            } else {
                if start != -1 {
                    x = start + 1
                    y = 0
                } else {
                    x += 1
                }
            }
        }

        return start
    }
}

// Thinking
// search and match
// logic is maintain pointers when do the for loop,
// need to can do backtrack if not match,

// Pattern: Array
// Card shape: not sure
// State needed: maintain the two pointers,
// 1. x: index to match for haystack
// 2. p: the shift for needle index
// Contract: every iteration I can know if current character in needle
//           match haystack's cur character or not
// Recall: landed

// 5 mins so far
// ready to write
// finish in 17 mins
// use example to check
// upgrade the code
// ready to run
// still has compile error, means I am careless
// also notice some synatx error, will let gpt to fix,
// which is helpful for me to track the swift knowledge I missed
// I think my logic is correct
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
YOUR HIGH-LEVEL LOGIC WAS CORRECT:

1. Use x to traverse haystack.
2. Use y to track the current needle character.
3. Save the candidate's starting position.
4. If a partial match fails, retry one position after that start.
5. Return the start when every needle character matches.


MISTAKE 1: SWIFT STRING INTEGER INDEXING

Swift String cannot be indexed directly using Int:

    haystack[x]
    needle[y]

This is invalid because Swift strings may contain characters with
different byte lengths.

For coding challenges, convert them to arrays:

    let haystackCharacters = Array(haystack)
    let needleCharacters = Array(needle)

Then integer indexing is available:

    haystackCharacters[x]
    needleCharacters[y]


MISTAKE 2: start WAS NOT RESET

After a failed partial match, you wrote:

    x = start + 1
    y = 0

But start kept its old value.

Example:

    haystack = "mississippi"
    needle = "issip"

After a candidate fails, x can repeatedly be assigned the same value,
causing an infinite loop.

Correct:

    x = start + 1
    y = 0
    start = -1


MISTAKE 3: ONE-CHARACTER NEEDLE

You checked for completion only inside:

    else if y == needleCount - 1

When the first character matches, `start == -1` is true, so the
completion condition is skipped.

For:

    haystack = "a"
    needle = "a"

y becomes 1 and the next access can go beyond the needle array.

Safer sequence:

    x += 1
    y += 1

    if y == needleCharacters.count {
        return start
    }


MISTAKE 4: FINAL RETURN

Returning start after the loop can return the beginning of an incomplete
match.

If the full needle was not matched, return:

    -1


FIX-VERSION CONTRACT:

At the beginning of every iteration:

- x is the haystack position currently being compared.
- y is the number of needle characters already matched.
- If y > 0, start is the beginning of that partial match.
- If a mismatch occurs, the next candidate begins at start + 1.


UPGRADE EXAMPLE:

    haystack = "sadbutsad"
    needle = "sad"

Possible starts run from 0 through 6.

Start 0:

    haystack[0] == needle[0]  // s == s
    haystack[1] == needle[1]  // a == a
    haystack[2] == needle[2]  // d == d

offset becomes 3, which equals needle.count.

Return:

    0


OVERLAPPING-CANDIDATE EXAMPLE:

    haystack = "mississippi"
    needle = "issip"

Start 1 compares:

    i s s i
    i s s i

Then:

    s != p

That candidate fails.

The algorithm continues with start 2 rather than skipping possible
overlapping candidates.


PATTERN:

    String matching / brute-force substring search

CARD SHAPE:

    Try every valid starting index.
    Compare every needle character from that start.
    Return the first complete match.

STATE:

Fix version:

    x
    y
    start

Upgrade:

    start
    offset

CONTRACT:

For each start, compare:

    haystack[start + offset]

with:

    needle[offset]

until a mismatch occurs or the entire needle matches.


COMPLEXITY:

Let:

    m = haystack length
    n = needle length

Worst-case time:

    O((m - n + 1) * n)
    commonly written as O(m * n)

Swift array conversion and storage:

    O(m + n)

A more advanced KMP solution can achieve O(m + n) time, but the
brute-force version is simpler and sufficient unless linear time is
specifically required.
*/