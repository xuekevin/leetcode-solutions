// Your original solution:
//
// class Solution {
//     func longestCommonPrefix(_ strs: [String]) -> String {
//         var map: [Character] = Array(strs[0])
//         
//         for i in 1..<strs.count {
//             let curStr = Array(strs[i])
//             var curMap = [Character]()
//             let minCount = min(curStr.count, map.count)
//             for j in 0..<minCount.count {
//                 let item = curStr[j]
//                 if item == map[j] {
//                     curMap.append(item)
//                 } else {
//                     break
//                 }
//             }
//             map = curMap
//         }
//         return String(map)
//     }
// }
//
// // Pattern: Array
// // Card shape: for loop
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank
// // Think
// // write above logic
// // might has some synatx error


// Fixed version:
class Solution {
    func longestCommonPrefix(_ strs: [String]) -> String {
        guard !strs.isEmpty else {
            return ""
        }

        // The first string is the initial prefix candidate.
        var prefix = Array(strs[0])

        for i in 1..<strs.count {
            let currentString = Array(strs[i])
            var updatedPrefix = [Character]()

            let minCount = min(currentString.count, prefix.count)

            // Wrong: 0..<minCount.count
            // Why: minCount is already an Int and Int has no `count`.
            // Correct: use minCount directly as the range boundary.
            for j in 0..<minCount {
                if currentString[j] == prefix[j] {
                    updatedPrefix.append(currentString[j])
                } else {
                    // The common prefix ends at the first mismatch.
                    break
                }
            }

            prefix = updatedPrefix

            // No later string can restore a prefix once it becomes empty.
            if prefix.isEmpty {
                return ""
            }
        }

        return String(prefix)
    }
}


// GPT's summary:
//
// Mistake you made:
// - `minCount` is an Int returned by `min(...)`.
// - Int does not have a `.count` property.
// - Write `0..<minCount`, not `0..<minCount.count`.
//
// What you did well:
// - Your overall algorithm is correct.
// - You used the first string as the initial prefix candidate.
// - You compared only up to the shorter length, preventing an index crash.
// - You stopped at the first mismatched character.
// - You updated the prefix after checking each string.
//
// Naming improvement:
// - `map` usually describes a dictionary or mapping operation.
// - This value represents the current prefix, so `prefix` is clearer.
// - `curMap` can be called `updatedPrefix`.
//
// Loop contract:
// - At the top of each outer-loop iteration, `prefix` is the common prefix
//   of every string already processed.
// - After comparing the next string, `prefix` becomes the common prefix of
//   all strings processed so far.
//
// Example: ["flower", "flow", "flight"]
// - Initial prefix: "flower"
// - Compare with "flow": prefix becomes "flow"
// - Compare with "flight": prefix becomes "fl"
// - Return "fl"
//
// Swift syntax to remember:
// - Int range: `0..<someInt`
// - Array length: `someArray.count`
// - Convert String to characters: `Array(string)`
// - Convert characters back to String: `String(characterArray)`
//
// Complexity:
// - Let n be the number of strings and m be the shortest relevant length.
// - Time: O(n * m) in the worst case.
// - Space: O(m) for the prefix and current character arrays.