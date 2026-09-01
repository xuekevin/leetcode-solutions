// Your original solution:
// class Solution {
//    func calculate(_ s: String) -> Int {
//    }
// }
//
// // Thinking
// // read the character then decide how to do the caculation
// // since we read from left to right
// // when we got + -, we do operation with previous and next
// // but what if we saw (, the we reset the sub operation start
// // if ew saw ), we should do the sub operation, with the charaters we already have
// // this need stack to maintain the push and pop
// // use example to figure out the detail
// // s = "1 + 1"
// // 1 push to stack
// // track this is an operation
// // 1 number, pre is operation, so pop the operation and. the num
// // check it is + , then just add, if it is -, need to make sure the pre - cur
// // what if ' ' we can just ignore
// // for (, mark it is a start of left sub operation, stack push
// // for 1+ (4+5+2),
// // we saw （, keep push,
// // based on the lgoic about num + or -, we caculate 4+5+2 = 11, then push back to stack,
// // saw ), then pop until we saw (, then pop (, and keep poping, we saw + then keep popping, saw number, so we do 1+11 = 12
// // saw (, no matched ) poped yet, so keep push 12 back to stack, saw - then push, also mark it is an operation, saw 3, then pop, operation and number to do operation
// // pretty much follow this logic
// // to do the operation
// // 13 mins so far
// // will let gpt to fix remaining
//
// // Pattern:
// // Card shape:
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank


class Solution {
    func calculate(_ s: String) -> Int {
        // Result of the current parenthesis level.
        var result = 0

        // Number currently being read.
        // This supports multi-digit values such as 123.
        var number = 0

        // Sign that belongs to `number`.
        // 1 means +number, -1 means -number.
        var sign = 1

        // For each `(`, store:
        // [result before (, sign before (]
        var stack = [Int]()

        for char in s {
            if char.isNumber {
                // Build a multi-digit number.
                //
                // Read "123":
                // number: 0 -> 1 -> 12 -> 123
                number = number * 10 + Int(String(char))!
            } else if char == "+" {
                // Finish the previous number using its saved sign.
                result += sign * number

                // Reset for the next number.
                number = 0
                sign = 1
            } else if char == "-" {
                // Finish the previous number using its saved sign.
                result += sign * number

                // The next number will be negative.
                number = 0
                sign = -1
            } else if char == "(" {
                // Save the outer expression context.
                stack.append(result)
                stack.append(sign)

                // Start a brand-new inner expression.
                result = 0
                number = 0
                sign = 1
            } else if char == ")" {
                // First, finish the last number inside the parentheses.
                result += sign * number

                // Reset because this inner expression is complete.
                number = 0

                // Restore the sign before `(`.
                let previousSign = stack.removeLast()

                // Restore the result before `(`.
                let previousResult = stack.removeLast()

                // Combine:
                // previousResult + previousSign * innerResult
                result = previousResult + previousSign * result
            }

            // Spaces do nothing, so there is no separate `else` needed.
        }

        // Finish the final number.
        return result + sign * number
    }
}

/*
 GPT's summary

 Good:
 - You correctly identified that parentheses require a stack.
 - You correctly noticed spaces should be ignored.
 - You correctly understood that `)` completes a sub-expression.

 Cleaner stack idea:
 - Do not push every individual number and operator.
 - When seeing `(`, save only:
   1. the result before `(`
   2. the sign before `(`
 - Calculate the inner expression normally.
 - When seeing `)`, combine the saved outer context with the inner result.

 Example:
 s = "1 + (4 + 5 + 2) - 3"

 Before `(`:
 result = 1
 sign = 1
 stack = [1, 1]

 Inside `(`:
 4 + 5 + 2 = 11
 result = 11

 At `)`:
 previousResult = 1
 previousSign = 1
 result = 1 + 1 * 11 = 12

 Then:
 12 - 3 = 9

 Swift syntax to remember:
 - Convert one Character to Int:
   `Int(String(char))!`
 - Build a multi-digit number:
   `number = number * 10 + digit`
 - Stack push:
   `stack.append(value)`
 - Stack pop:
   `stack.removeLast()`

 Complexity:
 - Time: O(n)
 - Space: O(n) in the worst case for nested parentheses.
*/

// TBH, not quite follow this solution, next time need deep investigation
