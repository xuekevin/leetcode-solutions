// Your original solution:
//
// class Solution {
//     func romanToInt(_ s: String) -> Int {
//         var map: [Character:Int] = [
//             "I":1,
//             "V":5,
//             "X": 10,
//             "L": 50,
//             "C": 100,
//             "D": 500,
//             "M": 1000
//         ]
//
//         var result = 0
//         let sArr = Array(s)
//         var i = sArr.count - 1
//         while i >= 0 {
//             let item = sArr[i]
//
//             if item == "I" {
//                 result += map[item]!
//             }
//
//             if item == "V" || item == "X" {
//                 if i != 0 && sArr[i-1] == "I" {
//                     result += map[item]! - map["I"]!
//                     i -= 1
//                 } else {
//                     result += map[item]!
//                 }
//             }
//
//             if item == "L" || item == "C" {
//                 if i != 0 && sArr[i-1] == "X" {
//                     result += map[item]! - map["X"]!
//                     i -= 1
//                 } else {
//                     result += map[item]!
//                 }
//             }
//
//             if item == "D" || item == "M" {
//                 if i != 0 && sArr[i-1] == "C" {
//                     result += map[item]! - map["C"]!
//                     i -= 1
//                 } else {
//                     result += map[item]!
//                 }
//             }
//             i -= 1
//         }
//         return result
//     }
// }
//
// // Pattern: Array,hashmap, for loop,
// // Card shape: check the item for array and then decide what corresponding num it is
// // State needed: result
// // Contract:      what is TRUE when one call returns?
// // Recall:         blank
// // thinking
// //kind like mapping
// // convert the rule to math logic
// // from left to write to traverse s string
// // if it is I, or X, or C, need to check its next item is bigger or small than it
// // or we read from right to left
// // can get answer quickly
// // ready to write code ater 6 mins
// // finish writing around 15 mins
// // ready to use example to verify
// // looks good, run, while still some silly synatx error, so next time must be more careful
// // got below synatx error
// // fix with force unwrap
// /**
// *
//
// if item == "I" {
//  20 |                 result += map[item]
//     |                              |- error: value of optional type 'Int?' must be unwrapped to a value of type 'Int'
//     |                              |- note: coalesce using '??' to provide a default when the optional value contains 'nil'
//     |                              `- note: force-unwrap using '!' to abort execution if the optional value contains 'nil'
//  21 |             }
//
// *
// /
//
// //// still compile error, must some other
// // will let gpt fix


// Fixed version: preserves your explicit Roman-pair approach.
class Solution {
    func romanToInt(_ s: String) -> Int {
        // Correct: use `let` because the dictionary never changes.
        let map: [Character: Int] = [
            "I": 1,
            "V": 5,
            "X": 10,
            "L": 50,
            "C": 100,
            "D": 500,
            "M": 1000
        ]

        var result = 0
        let characters = Array(s)
        var i = characters.count - 1

        while i >= 0 {
            let character = characters[i]

            if character == "I" {
                result += map[character]!
            } else if character == "V" || character == "X" {
                if i > 0 && characters[i - 1] == "I" {
                    result += map[character]! - map["I"]!
                    i -= 1
                } else {
                    result += map[character]!
                }
            } else if character == "L" || character == "C" {
                if i > 0 && characters[i - 1] == "X" {
                    result += map[character]! - map["X"]!
                    i -= 1
                } else {
                    result += map[character]!
                }
            } else {
                // The remaining valid symbols are D and M.
                if i > 0 && characters[i - 1] == "C" {
                    result += map[character]! - map["C"]!
                    i -= 1
                } else {
                    result += map[character]!
                }
            }

            i -= 1
        }

        return result
    }
}


// Upgrade version: one general right-to-left rule.
// Rename UpgradeSolution to Solution before submitting.
class UpgradeSolution {
    func romanToInt(_ s: String) -> Int {
        let values: [Character: Int] = [
            "I": 1,
            "V": 5,
            "X": 10,
            "L": 50,
            "C": 100,
            "D": 500,
            "M": 1000
        ]

        var result = 0
        var valueOnRight = 0

        for character in s.reversed() {
            let currentValue = values[character]!

            if currentValue < valueOnRight {
                // A smaller value before a larger value is subtractive.
                result -= currentValue
            } else {
                result += currentValue
            }

            valueOnRight = currentValue
        }

        return result
    }
}


// GPT's summary:
//
// Main compile error:
// - Your force unwraps were valid because the input contains Roman symbols.
// - The later compile error came from the block-comment terminator.
// - You wrote `* /`, but Swift requires `*/` with no space.
//
// Swift syntax to remember:
// - Opening a block comment: `/*`
// - Closing a block comment: `*/`
// - Dictionary lookup returns an optional: `map[key]` has type `Int?`.
// - When every possible key is guaranteed to exist, `map[key]!` is valid.
// - Use `[Character: Int]`, with normal spacing around the colon.
//
// Key idea:
// - When reading from right to left, subtract a value if it is smaller than
//   the value immediately to its right; otherwise, add it.
//
// Example: MCM
// - Read M: add 1000, result = 1000
// - Read C: C < M, subtract 100, result = 900
// - Read M: add 1000, result = 1900
//
// What you did well:
// - Your explicit handling of IV, IX, XL, XC, CD, and CM was correct.
// - Reading from right to left was a strong choice.
// - Your original algorithm was logically correct.
//
// Complexity:
// - Fixed version: O(n) time and O(n) space for Array(s).
// - Upgrade version: O(n) time and O(1) extra space.