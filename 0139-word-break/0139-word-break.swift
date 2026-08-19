// ============================================================
// FIX VERSION: Correct logic, but may get Time Limit Exceeded
// because it repeatedly solves the same remaining strings.
// ============================================================

class fixSolution {
    func wordBreak(_ s: String, _ wordDict: [String]) -> Bool {
        if s.isEmpty {
            return true
        }

        for word in wordDict {
            if s.hasPrefix(word) {
                let remaining = String(s.dropFirst(word.count))

                if wordBreak(remaining, wordDict) {
                    return true
                }
            }
        }

        return false
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION: Memoized recursion
// This is the recommended submission.
// ============================================================

class Solution {
    func wordBreak(_ s: String, _ wordDict: [String]) -> Bool {
        // Convert the String into an array so integer indexing is available.
        let characters = Array(s)

        // Convert each dictionary word for character-by-character comparison.
        let words = wordDict.map { Array($0) }

        // memo[start] answers:
        // "Can the substring beginning at start be segmented?"
        var memo = [Int: Bool]()

        // Contract:
        // helper(start) returns true if characters[start...] can be
        // constructed using words from wordDict.
        func helper(_ start: Int) -> Bool {
            // Reaching the end means every character was matched.
            if start == characters.count {
                return true
            }

            // Return the saved answer if this suffix was already solved.
            if let savedResult = memo[start] {
                return savedResult
            }

            // Try every dictionary word as the next choice.
            for word in words {
                // The word cannot match if it extends past the string.
                if start + word.count > characters.count {
                    continue
                }

                // Compare this word with the string at the current position.
                var matches = true

                for i in 0..<word.count {
                    if characters[start + i] != word[i] {
                        matches = false
                        break
                    }
                }

                // If the word matches, recursively solve the suffix after it.
                if matches && helper(start + word.count) {
                    memo[start] = true
                    return true
                }

                // If this choice fails, continue and try another word.
            }

            // No dictionary word produced a successful segmentation.
            memo[start] = false
            return false
        }

        // Begin with the entire string.
        return helper(0)
    }
}

// ============================================================
// ORIGINAL THINKING
// ============================================================

/*
Thinking:
- Compare the string with words from wordDict.
- Choose a matching word.
- Recursively check the remaining string.
- If one choice fails, try another choice.
- If the remaining string becomes empty, return true.

Pattern: recursion, backtracking, dynamic programming
Card shape: Try every word matching the current prefix.
State needed: remaining string or start index.
Contract: helper(start) returns whether s[start...] can be segmented.
Recall: half
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
WHY THE FIX VERSION MAY NOT PASS:

The recursive logic is correct, but it can solve the same suffix many
times. Its worst-case time complexity is exponential, commonly O(2^n).

Example:

    s = "aaaaaaaaab"
    wordDict = ["a", "aa", "aaa", "aaaa"]

Many combinations are attempted before they all eventually fail at "b".


HOW THE UPGRADE WORKS:

1. `helper(start)` treats `start` as the beginning of the remaining string.

2. For every dictionary word, it checks whether that word matches the
   characters beginning at `start`.

3. If the word matches, the next recursive call starts after that word:

       helper(start + word.count)

4. If a recursive choice returns false, the loop tries another word.

5. If `start == characters.count`, the entire string was consumed,
   so the answer is true.

6. `memo[start]` saves the result for each suffix. If another recursive
   path reaches the same start index, its answer is returned immediately.


EXAMPLE:

    s = "leetcode"
    wordDict = ["leet", "code"]

    helper(0)
    "leet" matches
        helper(4)
        "code" matches
            helper(8)
            8 == characters.count, so return true

The true result travels back through every recursive call.


WHY USE A START INDEX:

Using an index avoids repeatedly creating new remaining strings:

    String(s.dropFirst(word.count))

It also gives every suffix a stable identity that can be used as the
memoization key.


COMPLEXITY:

Fix version:
- Time: O(2^n) in the worst case
- Space: O(n) recursive depth, plus copied substrings

Upgrade version:
- Time: O(n * w * L)
- Space: O(n), excluding converted character arrays

n = length of s
w = number of dictionary words
L = average or maximum dictionary-word length
*/