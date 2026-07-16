// Your original solution:
// class Solution {
//     func canConstruct(_ ransomNote: String, _ magazine: String) -> Bool {
//         var dict = [Character:Int]()
//
//         for item in magazine {
//             if let count = dict[item] {
//                 dict[item] += 1
//             }
//             dict[item] = 1
//         }
//
//         for item in ransomNote {
//             if let count = dict[item] {
//                 if count == 0 {
//                     return false
//                 }
//                 dict[item] -= 1
//             }
//             return false
//         }
//         return true
//     }
// }
// // # Thoughts:
// // for loop ransomNote and then I can check if this item is in magzine or not,
// // after use I need remove it from magazine, so I think I can create a copy of magazine,
// // but it means I need extra space to store that
// // or I create a dict for magazine, to count the letter
// // and then do the for loop for ransomNote, faster for search
//
// // spend 5 mins so far
//
// // now let me verify my thoughts with example
//
// // exmaple 3:
// // dict: [(a:2), (b:1)], the for loop ransomNote, can find a then dict value -=1
//
// // spend 6 mins so far, start to write the code
//
// // spend 10 mins write the code above
//
// // now verify with example, looks good to me
//
// // got some compile error, now check with gpt to get correct code

class Solution {
    func canConstruct(_ ransomNote: String, _ magazine: String) -> Bool {
        var dict = [Character: Int]()

        for item in magazine {
            // Wrong:
            // if let count = dict[item] {
            //     dict[item] += 1
            // }
            // dict[item] = 1
            //
            // Why: after increasing the count, your code still runs `dict[item] = 1`,
            // so every character count gets reset back to 1.
            //
            // Correct: use dictionary default syntax to start from 0 only when missing.
            dict[item, default: 0] += 1
        }

        for item in ransomNote {
            // Wrong: return false is outside the `if`, so the loop returns false after
            // checking the first character, even if that character exists.
            //
            // Correct: return false only when the character is missing or count is 0.
            guard let count = dict[item], count > 0 else {
                return false
            }

            // Wrong: dict[item] -= 1 can complain because dict[item] is an Optional<Int>.
            // Correct: after `guard` proves it exists, assign the new count directly.
            dict[item] = count - 1
        }

        return true
    }
}

// GPT's summary:
// Mistakes you made:
// - You reset `dict[item]` to 1 every time after increasing it.
// - You put `return false` inside the ransomNote loop but outside the failed lookup case.
// - You tried to mutate `dict[item]` directly even though dictionary lookup returns an optional.
//
// Swift syntax to remember:
// - `dict[item, default: 0] += 1` means use 0 if the key does not exist yet.
// - `guard let count = dict[item], count > 0 else { return false }` unwraps and checks in one step.
// - Dictionary lookup `dict[key]` returns `Int?`, because the key might not exist.
//
// Complexity:
// - Time: O(m + n), where m is `magazine.count` and n is `ransomNote.count`.
// - Space: O(k), where k is the number of unique characters in `magazine`.