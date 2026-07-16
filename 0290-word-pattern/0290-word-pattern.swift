// Your original solution:
// class Solution {
//     func wordPattern(_ pattern: String, _ s: String) -> Bool {
//         var sArr = [String]()
//         var curStr = ""
//         for (index,item) in s.enumerated() {
//             if item != " " {
//                 curStr.append(item)
//             } else {
//                 sArr.append(curStr)
//                 curStr = ""
//             }
//             if index == s.count - 1 {
//                 sArr.append(curStr)
//             }
//         }
//         
//         var pToS = [Character:String]()
//         var sToP = [String:Character]()
//
//         for (pChar,sStr) in zip(pattern, sArr) {
//             if let mappingStr = pToS[pChar] {
//                 if mappingStr != sStr {
//                     return false
//                 }
//             } else {
//                 pToS[pChar] = sStr
//             }
//
//             if let mappingChar = sToP[sStr] {
//                 if mappingChar != pChar {
//                     return false
//                 } else {
//                     sToP[sStr] = pChar
//                 }
//             }
//         }
//         return true
//     }
// }
// // #Thoughts
// // do the mapping 
// // char to string
// // but we have space
// // so first I need to convert s to a String array
// // then I can do the mapping
//
//
// // 3 mins so far
//
// // Start to try to write the code
//
// // 12 mins after writing the code 
//
// // now check with example
//
// // 16 mins then try first run, passed
//
// // got wrong answer

class Solution {
    func wordPattern(_ pattern: String, _ s: String) -> Bool {
        // Wrong: manually splitting the string by checking every character.
        // Why: this is easy to get slightly wrong and makes the code longer.
        // Correct: Swift has `split(separator:)`, then convert each Substring to String.
        let words = s.split(separator: " ").map { String($0) }

        // Wrong: using zip(pattern, sArr) without checking count.
        // Why: zip stops at the shorter sequence, so extra pattern chars or extra words are ignored.
        // Correct: return false when the counts are different.
        if pattern.count != words.count {
            return false
        }

        var pToS = [Character: String]()
        var sToP = [String: Character]()

        for (pChar, word) in zip(pattern, words) {
            if let mappingStr = pToS[pChar] {
                if mappingStr != word {
                    return false
                }
            } else {
                pToS[pChar] = word
            }

            if let mappingChar = sToP[word] {
                if mappingChar != pChar {
                    return false
                }
            } else {
                // Wrong: your original code only assigned `sToP[sStr] = pChar`
                // inside the `if let` branch's `else`.
                // Why: when `sStr` is new, you never stored word -> pattern mapping.
                // Correct: put the new mapping in the outer `else`.
                sToP[word] = pChar
            }
        }

        return true
    }
}

// GPT's summary:
// Mistakes you made:
// - Your mapping idea was correct: this is basically the isomorphic-string pattern.
// - You forgot to check `pattern.count == words.count`; `zip` hides length mismatches.
// - You did not add a new mapping for `sToP` when the word was not already in the dictionary.
// - Your manual split worked for normal inputs, but `s.split(separator: " ")` is cleaner Swift.
//
// Swift syntax to remember:
// - `s.split(separator: " ")` splits a String into `[Substring]`.
// - `.map { String($0) }` converts `[Substring]` into `[String]`.
// - `zip(pattern, words)` loops two sequences together, but stops at the shorter one.
// - For two-way mapping, use two dictionaries: `[Character: String]` and `[String: Character]`.
//
// Complexity:
// - Time: O(n + m), where n is `s.count` and m is `pattern.count`.
// - Space: O(w), where w is the number of words/mappings stored.