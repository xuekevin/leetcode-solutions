// Your original solution:
// class Solution {
//     func isSubsequence(_ s: String, _ t: String) -> Bool {
//         var sleft = 0 
//         var sRight = s.count - 1
//         var tleft = 0
//         var tRight = t.count - 1
//         var sArr = Array(s)
//         var tArr = Array(t)
//
//         while (sleft <= sRight && tleft <= tRight) {
//             if sArr[sleft] == tArr[tleft] {
//                 sleft += 1
//                 tleft += 1
//             } else {
//                 tleft += 1
//             }
//
//             if sleft <= sRight && sArr[sRight] == tArr[tRight] {
//                 sRight -= 1
//                 tRight -= 1
//             } else {
//                 tRight -= 1
//             }
//         }
//         return sleft > sRight && tleft <= tRight
//     }
// }
//
// //# Thoughts
// // so I can a for loop
// // use two pointer to decide whether move or not
// // using example to verify my thoughts
//
// // s: a, t a 
// // s c , t c 
// // b, t, h,b d,, left == right, and we find the element, exit
//
// // 5 mins figure out to use two pointers to solove this
// // ready to write code
//
// // 12 mins write above, now use example to verify
//
// // use example verify founds several issues, 
// // mainly about how to write this 
// // return sleft >= sRight && tleft <= tRight
// // got complier error, need to convert string to array, then can compare
// // after change still wrong for exmaple 1
// // the exist return should be: return sleft > sRight && tleft <= tRight
// // still wrong, I think I made two many mistakes
// // going to ask gpt to fix

class Solution {
    func isSubsequence(_ s: String, _ t: String) -> Bool {
        // Wrong: using both left and right pointers for subsequence.
        // Why: subsequence order must be checked from left to right only.
        // Correct: use one pointer for `s`, and scan through `t`.
        let sArr = Array(s)

        var sIndex = 0

        for tChar in t {
            // Good: if all characters in `s` are matched, we can stop.
            // Why it works: `sIndex == sArr.count` means every s character appeared in order.
            if sIndex == sArr.count {
                return true
            }

            if sArr[sIndex] == tChar {
                sIndex += 1
            }
        }

        return sIndex == sArr.count
    }
}

// GPT's summary:
// Mistakes you made:
// - You tried to solve subsequence from both left and right.
// - The right-side pointer breaks the idea of subsequence, because subsequence is about preserving left-to-right order.
// - Your return condition became complicated because the algorithm had too many moving parts.
// - `tleft <= tRight` should not decide success; success only depends on whether all of `s` was matched.
//
// Key idea:
// - Keep one pointer on `s`.
// - Scan every character in `t` from left to right.
// - When `t` matches the current needed character in `s`, move the `s` pointer.
// - If the `s` pointer reaches the end, `s` is a subsequence of `t`.
//
// Swift syntax to remember:
// - `Array(s)` converts a String into `[Character]` so you can use integer indexing.
// - `for tChar in t` loops through every Character in a String.
// - `sIndex == sArr.count` means all characters in `s` were matched.
// - Use `let` for arrays that do not change, like `let sArr = Array(s)`.
//
// Complexity:
// - Time: O(n), where n is `t.count`; we scan `t` once.
// - Space: O(m), where m is `s.count`, because `Array(s)` stores the characters of `s`.



// GPT's note:
// Yes, this is still a two-pointer problem, but not every two-pointer problem uses
// `left` and `right` from opposite ends.
//
// For `isSubsequence`, the better two-pointer style is same-direction:
//
// var i = 0 // pointer for s
// var j = 0 // pointer for t
//
// Both pointers move left to right. We scan `t` once, and every time `t[j]`
// matches the current needed character `s[i]`, we move `i`.
//
// Opposite-direction two pointers:
// - left + right
// - Good for palindrome, two sum sorted, container with most water.
//
// Same-direction two pointers:
// - i + j, slow + fast
// - Good for subsequence, merging arrays, sliding window, removing duplicates.
//
// For `isSubsequence`, using left + right does not make it more efficient.
// It makes the logic harder and can become wrong because subsequence cares about
// preserving left-to-right order.
//
// Key idea:
// s = "abc"
// t = "ahbgdc"
//
// Ask:
// Can I find "a", then "b", then "c", in this order?
//
// So the clean logic is:
//
// var i = 0
// let sArr = Array(s)
//
// for tChar in t {
//     if i == sArr.count {
//         return true
//     }
//
//     if sArr[i] == tChar {
//         i += 1
//     }
// }
//
// return i == sArr.count
//
// Your instinct to use two pointers was good.
// The missing piece was choosing the correct style of two pointers.