// Your original solution:
// class Solution {
//     func isPalindrome(_ s: String) -> Bool {
//         let filterS = Array(s.lowercased().filter { $0 >= "a" && $0 <= "z" })
//         if filterS.count <= 1 {
//             return true
//         }
//
//         var left = 0
//         var right = filterS.count - 1
//
//         while left <= right {
//             if filterS[left] == filterS[right] {
//                 left+=1
//                 right-=1
//             } else {
//                 return false
//             }
//         }
//
//         return true
//     }
// }
// //#Thoughts
// // 1. first need to convert into lower case
// // 2. remove all non-alphanumeric characters
// // I don't know the function to do these 2
// // but after that we can have two pointers, left and right
// // and then compare the value, and move inwards
//
// // here is the thoughts. going to google how to do 1 and 2
// // find the answer: input.lowercased().filter { $0 >= "a" && $0 <= "z" }
// // 5 mins so far start to write code
// // 10 mins, check with example, now go throught the code again to check
// // ready to run
// // didn't pass s = " "
// // because it is also palindrome
// // I didn't read the question careful

class Solution {
    func isPalindrome(_ s: String) -> Bool {
        // Wrong: filter { $0 >= "a" && $0 <= "z" }
        // Why: the question says alphanumeric, so digits like "0"..."9" should also stay.
        // Correct: use isLetter || isNumber.
        let filtered = Array(s.lowercased().filter { $0.isLetter || $0.isNumber })

        var left = 0
        var right = filtered.count - 1

        // Wrong concern: s = " " should return true.
        // Why: after filtering, it becomes an empty array, and the loop should simply not run.
        // Correct: `while left < right` naturally handles empty and one-character arrays.
        while left < right {
            if filtered[left] != filtered[right] {
                return false
            }

            left += 1
            right -= 1
        }

        return true
    }
}

// GPT's summary:
// Mistakes you made:
// - Your two-pointer logic was good.
// - You filtered only letters, but the problem asks for alphanumeric characters, so digits must be included.
// - You thought `" "` failed because empty string is a special case, but a clean `while left < right` handles it naturally.
// - Your early `if filterS.count <= 1` was correct, but not necessary.
//
// Swift syntax to remember:
// - `s.lowercased()` converts the whole String to lowercase.
// - `.filter { condition }` keeps only characters that satisfy the condition.
// - `$0.isLetter || $0.isNumber` keeps alphabetic and numeric characters.
// - `left += 1` and `right -= 1` are valid Swift shorthand updates.
//
// Complexity:
// - Time: O(n), where n is `s.count`.
// - Space: O(n), because we build a filtered character array.
