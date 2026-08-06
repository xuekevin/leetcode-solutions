// Your original solution:
//
// class Solution {
//
//     var resultArr = [String]()
//     func letterCombinations(_ digits: String) -> [String] {
//         let map: [Character: String] = [
//                 "2": "abc",
//                 "3": "def",
//                 "4": "ghi",
//                 "5": "jkl",
//                 "6": "mno",
//                 "7": "pqrs",
//                 "8": "tuv",
//                 "9": "wxyz"
//             ]
//
//             helper(digits, 0, map, 0, "")
//             return resultArr
//     }
//
//     func helper(_ digits: String, digitsIndex, _ map: [Character: String], letterIndex, _ existingStr: String) {
//         if digitsIndex >= digits.count {
//             return
//         }
//
//         guard let num = digits[digitsIndex], let letter = map[num] else {
//             return
//         }
//
//         if letterIndex >= letter.count {
//             return
//         }
//
//         let curStr = letter[letterIndex]
//
//
//
//
//
//         // last digit
//         if digitsIndex == digits.count - 1 {
//             let resultStr = existingStr + curStr
//             resultArr.append(resultStr)
//         }
//
//
//
//     }
// }
//
// // Think
// // first wrap the map of all the number to its alphbet set
// // then its like do the foor loop
// // make the choose of first digit
// // then make the choice for the seccond, etc
// // question, do we have duplicate for the number
// // if it is we can remove the duplicate in final result
// // 3 mins so far, ready to write code
// // 15 mins, kind of lost how to write backtracking
// // thinking...
// // create a helper method
// // should have a method that can recursive to call to get the letter for each choice
// // keep writing this helper method
// // already 33 mins, I think I lost
// // going to ask gpt to fix
//
// // Pattern:
// // Card shape:
// // State needed:
// // Contract: this function returns ___     ← if it's recursive
// // Recall: landed / half / blank

// Fixed version: preserves your recursive idea.
class Solution {
    var resultArr = [String]()

    func letterCombinations(_ digits: String) -> [String] {
        // Good: empty input has no combinations.
        guard !digits.isEmpty else {
            return []
        }

        resultArr = []

        let map: [Character: String] = [
            "2": "abc", "3": "def", "4": "ghi", "5": "jkl",
            "6": "mno", "7": "pqrs", "8": "tuv", "9": "wxyz"
        ]

        // Wrong: `digits[digitsIndex]`
        // Why: Swift String does not support Int indexing directly.
        // Correct: convert it to [Character] for coding-challenge indexing.
        let digitArray = Array(digits)

        helper(digitArray, 0, map, "")
        return resultArr
    }

    // Contract: create every complete combination starting at digitsIndex,
    // using `existingStr` as the letters already chosen.
    func helper(
        _ digits: [Character],
        _ digitsIndex: Int,
        _ map: [Character: String],
        _ existingStr: String
    ) {
        // Wrong: returning immediately at the end.
        // Correct: the completed string is an answer, so save it first.
        if digitsIndex == digits.count {
            resultArr.append(existingStr)
            return
        }

        guard let letters = map[digits[digitsIndex]] else {
            return
        }

        // Good: try every possible letter for the current digit.
        // A separate `letterIndex` is unnecessary.
        for letter in letters {
            helper(
                digits,
                digitsIndex + 1,
                map,
                existingStr + String(letter)
            )
        }
    }
}

// Upgrade version: rename UpgradeSolution to Solution before submitting.
// Uses an explicit choose -> recurse -> unchoose backtracking path.
class UpgradeSolution {
    func letterCombinations(_ digits: String) -> [String] {
        guard !digits.isEmpty else {
            return []
        }

        let map: [Character: String] = [
            "2": "abc", "3": "def", "4": "ghi", "5": "jkl",
            "6": "mno", "7": "pqrs", "8": "tuv", "9": "wxyz"
        ]

        let digitArray = Array(digits)
        var result = [String]()
        var path = [Character]()

        func backtrack(_ digitsIndex: Int) {
            if digitsIndex == digitArray.count {
                result.append(String(path))
                return
            }

            for letter in map[digitArray[digitsIndex]]! {
                path.append(letter)             // Choose.
                backtrack(digitsIndex + 1)     // Recurse.
                path.removeLast()              // Unchoose.
            }
        }

        backtrack(0)
        return result
    }
}

// GPT's summary:
// Mistakes you made:
// - The helper parameters need explicit types, such as `_ digitsIndex: Int`.
// - Swift String cannot use Int subscripts like `digits[0]`.
// - At the base case, append the completed string before returning.
// - You do not need to remove duplicates. Each ordered letter choice creates
//   a distinct combination.
//
// Key idea:
// - Recursion state: current digit index plus the path chosen so far.
// - For each current digit, loop through its letters.
// - After choosing a letter, recurse to the next digit.
//
// Fixed version:
// - Uses `existingStr + String(letter)` for each recursive call.
// - Time: O(4^n * n), where n is digits.count.
// - Extra space: O(n) for recursion, excluding output.
//
// Upgrade version:
// - Uses one mutable `[Character]` path with choose/recurse/unchoose.
// - Same asymptotic complexity, but avoids creating many intermediate strings.
// - It is the more reusable backtracking template.