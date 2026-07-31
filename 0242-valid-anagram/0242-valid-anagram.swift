// Your original solution:
//
// class Solution {
//     func isAnagram(_ s: String, _ t: String) -> Bool {
//         if s.count != t.count {
//             return false
//         }
//
//         var count = [Character: Int]()
//
//         for char in s {
//             count[char, default: 0] += 1
//         }
//
//         for char in t {
//             count[char, default: 0] -= 1
//
//             if count[char]! < 0 {
//                 return false
//             }
//         }
//
//         return true
//     }
// }
// // first, check the length if it is same length
// // second, we need to convert string to char array
// // and then for loop t, check if it is in s, if first letter in s,
// // we return false, if we can't find in s
// // otherwise, finish for loop, return true
//
//
// // spend 5 mins to figure out above
// // now I use exmaple to verify my thought, spend 1 min
//
//
// // to 8 mins I write out the code, but with Synatx error
//
// // the ask gpt give me above final version
//
// // the time complexty is O(n)
// // the space complexity is O(n)

class Solution {
    func isAnagram(_ s: String, _ t: String) -> Bool {
        // Good: different lengths can never be anagrams.
        guard s.count == t.count else {
            return false
        }

        var count = [Character: Int]()

        // Good: a String can be looped over directly as Characters.
        // You do not need to convert it to [Character] first.
        for char in s {
            count[char, default: 0] += 1
        }

        for char in t {
            count[char, default: 0] -= 1

            // Good: a negative count means t contains this character
            // more times than s does.
            if count[char]! < 0 {
                return false
            }
        }

        return true
    }
}

// GPT's summary:
// What you did well:
// - This is the standard optimal dictionary-counting solution.
// - You correctly check equal length before counting.
// - You correctly subtract counts while reading t and stop early
//   when a character appears too many times.
//
// Key idea:
// - Add one count for every character in s.
// - Subtract one count for every character in t.
// - A negative count means t needs a character that s does not have enough of.
//
// Swift syntax to remember:
// - Strings can be iterated directly: `for char in s`.
// - `dict[key, default: 0] += 1` reads a missing key as 0, then updates it.
// - `count[char]!` is safe here because both loops create or update
//   an entry for every character before it is read.
//
// Complexity:
// - Time: O(n), where n is the length of the strings.
// - Space: O(k), where k is the number of distinct characters.
//   In the worst case, k = n, so space is O(n).