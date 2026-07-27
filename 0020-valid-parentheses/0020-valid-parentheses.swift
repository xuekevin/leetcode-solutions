// Your original solution:
// class Solution {
//     func isValid(_ s: String) -> Bool {
//         var countA = 0
//         var countB = 0
//         var countC = 0
//
//         for item in s {
//             if item == "(" {
//                 countA += 1
//             } else if item == ")" {
//                 if countA <= 0 {
//                     return false
//                 }
//                 countA -= 1
//             }
//
//             if item == "{" {
//                 countB += 1
//             } else if item == "}" {
//                 if countB <= 0 {
//                     return false
//                 }
//                 countB -= 1
//             }
//
//             if item == "[" {
//                 countC += 1
//             } else if item == "]" {
//                 if countC <= 0 {
//                     return false
//                 }
//                 countC -= 1
//             }
//         }
//         if countA == 0 && countB == 0 && countC == 0 {
//             return true
//         }
//         return false
//     }
// }
//
// // # thoughts
// // basically need has a open match a close
// // also if we see close first no, open also invalid
// // think use a count to check this match
// // 1:30 start to write the code
// // 5 mins finish writing
// // now verify with the example
// // made a mistake, my case will think ( and ] match
// // now fix
// // but the code is not elegant, will try submit first
// // compile error should use "" instead of ''
// // also made a mistake my solution think this ([)] is true
// // now realize I made a mistake, think I only need to handle the match, but forget need to also make sure no overlap
// // if only one type of brackets then my solutiojn is correct
// // time out, already use 19 mins
// // ask gpt

class Solution {
    func isValid(_ s: String) -> Bool {
        var stack = [Character]()

        for item in s {
            if item == "(" || item == "{" || item == "[" {
                // Good: when we see an opening bracket, remember it.
                // Why it works: the most recent opening bracket must be closed first.
                stack.append(item)
            } else {
                // Wrong: using only counts for each bracket type.
                // Why: counts cannot detect invalid overlap like `([)]`.
                // Correct: use a stack and compare the closing bracket with the most recent opener.
                guard let last = stack.popLast() else {
                    return false
                }

                if item == ")" && last != "(" {
                    return false
                }

                if item == "}" && last != "{" {
                    return false
                }

                if item == "]" && last != "[" {
                    return false
                }
            }
        }

        // Good: after processing everything, no unclosed opening brackets should remain.
        return stack.isEmpty
    }
}

// GPT's summary:
// Mistakes you made:
// - Your count idea works only if there is one bracket type.
// - With multiple bracket types, order matters, not just count.
// - `([)]` has balanced counts, but it is invalid because `[` must close before `(`.
// - You correctly noticed the overlap issue yourself; that is the key insight.
//
// Key idea:
// - Use a stack for "most recent opener must close first".
// - When you see `(`, `{`, `[`, push it.
// - When you see `)`, `}`, `]`, pop the last opener and check if it matches.
// - If the stack is empty when closing, or the popped opener does not match, return false.
//
// Swift syntax to remember:
// - `var stack = [Character]()` creates an empty Character array.
// - `stack.append(item)` pushes onto the stack.
// - `stack.popLast()` removes and returns the last element as an optional.
// - `guard let last = stack.popLast() else { return false }` safely handles an empty stack.
// - Swift uses double quotes for Character comparison too, like `item == "("`.
//
// Complexity:
// - Time: O(n), where n is `s.count`.
// - Space: O(n), because in the worst case all characters are opening brackets stored in the stack.