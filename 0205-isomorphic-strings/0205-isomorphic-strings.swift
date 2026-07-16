// Your original solution:
// class Solution {
//     func isIsomorphic(_ s: String, _ t: String) -> Bool {
//         var sDict = [Character:Int]()
//         var tDict = [Character:Int]()
//
//         for item in s {
//             sDict[item, default: 0] = 1
//         }
//
//         for item in t {
//             tDict[item, default: 0] = 1
//         }
//
//
//
//     }
// }
//
// // # Thoughts
//
// // basically same pattern between s and t
// // means using a dict to count the letter
// // the count for each letter should be the same I think
// // since we also consider the order of characters
// // so can just do for loop for s and t, then generate 2 dict to compare the count
//
// // 4 mins so far
//
// // start to use example to verify
//
// // [(e:1),(g:2)]
// // [(a:1), (d:2)]
// // so count match
//
// // 6 mins to start to write the code
//
// // 9 mins, stuck in here
// // // compare sDict with tDict ? don't know how to do it
// // thinking other way
// // think about mapping the dict key
// // also how to foor loop the dict with order
// // kind of compare with sDict with tDict?
// // 12 mins so far, read to check gpt to figure it out

class Solution {
    func isIsomorphic(_ s: String, _ t: String) -> Bool {
        // Wrong: only counting characters in each string.
        // Why: isomorphic means each character in `s` maps to exactly one character in `t`,
        // and each character in `t` maps back to exactly one character in `s`.
        // Correct: track the mapping while walking both strings in the same order.
        var sToT = [Character: Character]()
        var tToS = [Character: Character]()

        // Wrong: the original function has no return after the loops.
        // Why: a Bool function must return true or false on every path.
        // Correct: return false when a mapping conflict appears, otherwise return true at the end.

        // Wrong: separate `for item in s` and `for item in t` loops lose position-pair information.
        // Why: we need to compare s[0] with t[0], s[1] with t[1], etc.
        // Correct: use `zip(s, t)` to loop through both strings together.
        for (sChar, tChar) in zip(s, t) {
            if let mappedChar = sToT[sChar] {
                // Wrong idea: comparing counts like e:1/g:2 vs a:1/d:2.
                // Why: counts can match but mapping can still be invalid.
                // Correct: if `sChar` was mapped before, it must map to the same `tChar`.
                if mappedChar != tChar {
                    return false
                }
            } else {
                sToT[sChar] = tChar
            }

            if let mappedChar = tToS[tChar] {
                // Wrong idea: only checking s -> t mapping.
                // Why: two different chars in `s` cannot map to the same char in `t`.
                // Correct: also check reverse mapping t -> s.
                if mappedChar != sChar {
                    return false
                }
            } else {
                tToS[tChar] = sChar
            }
        }

        return true
    }
}

// GPT's summary:
// Mistakes you made:
// - You tried to compare character counts, but this problem is about one-to-one character mapping.
// - You used two separate loops, which loses the position relationship between `s` and `t`.
// - Your function did not return a Bool at the end.
// - `sDict[item, default: 0] = 1` always sets the count to 1; it does not count frequency.
//
// Swift syntax to remember:
// - `zip(s, t)` lets you loop through two sequences together: `for (a, b) in zip(s, t)`.
// - `[Character: Character]()` creates a dictionary mapping one Character to another Character.
// - `if let mappedChar = dict[key] { ... }` unwraps an optional dictionary value.
// - A function returning `Bool` must return `true` or `false` on every possible path.
//
// Complexity:
// - Time: O(n), where n is the length of the strings.
// - Space: O(k), where k is the number of unique characters stored in the mappings.