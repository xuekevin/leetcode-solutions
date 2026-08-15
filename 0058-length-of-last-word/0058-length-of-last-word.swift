// Your original solution:
//
// class Solution {
//     func lengthOfLastWord(_ s: String) -> Int {
//         let charArr = Array(s)
//         var curCount = 0
//         var wordCount = 0
//         
//         for i in 0..<charArr.count {
//             if charArr[i] == " " {
//                 if curCount != 0 {
//                     wordCount = curCount
//                     curCount = 0
//                 }
//             } else {
//                 curCount += 1
//             }
//         }
//         if curCount != 0 {
//             wordCount = curCount
//         }
//         return wordCount
//     }
// }
//
// // Pattern: Array
// // Card shape:
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank
// // Thinking
// // for loop
// // recording the start of the word by default, got a space, means a end, reset the start
// // encounter a space, skip
// // last word is the last start to the end of string, skip empty space
// // ready to write code
// // done in 10 mins, use example to verify. LGTM
// // ready to run, pass
// // ready to submit, pass


// Reviewed version: your forward-scan approach
class Solution {
    func lengthOfLastWord(_ s: String) -> Int {
        let characters = Array(s)
        var currentLength = 0
        var lastWordLength = 0

        for character in characters {
            if character == " " {
                if currentLength > 0 {
                    // A word just ended, so remember its length.
                    lastWordLength = currentLength
                    currentLength = 0
                }
            } else {
                currentLength += 1
            }
        }

        // If the string does not end with a space,
        // the final word has not yet been copied.
        if currentLength > 0 {
            lastWordLength = currentLength
        }

        return lastWordLength
    }
}


// Upgrade version: scan backward and stop early.
// Rename UpgradeSolution to Solution before submitting.
class UpgradeSolution {
    func lengthOfLastWord(_ s: String) -> Int {
        var length = 0

        for character in s.reversed() {
            if character == " " {
                if length > 0 {
                    // We have counted the last word and reached
                    // the space before it.
                    break
                }

                // length == 0 means this is a trailing space.
                continue
            }

            length += 1
        }

        return length
    }
}


// GPT's summary:
//
// What you did well:
// - Your original solution is correct and passed.
// - You correctly reset the current count only after completing a word.
// - You correctly handled trailing spaces.
// - You correctly handled a string whose final character belongs to a word.
//
// Small improvement to your version:
// - Because Swift strings can be iterated directly, an index is unnecessary:
//   `for character in s`
// - Converting with `Array(s)` is useful when integer indexing is required,
//   but this algorithm only needs sequential traversal.
//
// Why backward traversal is useful:
// - The answer only depends on the final word.
// - Starting from the end lets us skip trailing spaces.
// - Once counting begins, the next space ends the last word.
// - We can stop without examining the earlier words.
//
// Backward loop contract:
// - While length == 0, we are skipping trailing spaces.
// - Once length > 0, we are counting characters in the last word.
// - The first following space means the last word is complete.
//
// Swift syntax to remember:
// - Traverse a String backward:
//   `for character in s.reversed()`
// - A Swift String can be iterated as Character values without Array(s).
//
// Complexity:
// - Reviewed version: O(n) time and O(n) space for Array(s).
// - Upgrade version: O(n) worst-case time and O(1) extra space.
// - The upgrade may stop earlier after reading only the last word and
//   trailing spaces.