// Your original solution:
// class Solution {
//     func isHappy(_ n: Int) -> Bool {
//         // to check if it is s cycle when do this loop
//         // so we use two pointers
//         var slow = n
//         var fast = n
//
//         while (fast != 1 && slow != fast) {
//             slow = squareNum(n)
//             fast = squareNum(squareNum(n))
//         }
//
//         if fast == 1 {
//             return true
//         }
//
//         return false
//     }
//
//     func squareNum(_ n: Int) -> Int {
//         var num = n
//         var sum = 0
//
//         while (num != 0) {
//             var cur = num % 10
//             sum += Math.square(cur)
//             num = num / 10
//         }
//         return sum
//     }
// }
//
// // # Thoughts
// // the bruce force seems doesn't work
// // the n can have be pretty big
// // I shouldn't cacluated each 位 square
// // have no any ideas
// // 3 mins so far, decide to check topic and discussion to see some hints
// // the hints we can do loop to get each individual digits
// // my first thought is wrong, I guess I feel it is difficult to get each digits
// // will try that,
// // 7 mins, back to try again, will start to write the code directly, feel the challenge is about how to write the logic
//
// // when is the exit? 
// // if N repeats itself, then we need a set to record
// // seems need a lot of Space, which I don't think we should go this approach
//
// // 10 mins, decide to check my previous solution directly
//
// // 14 mins so far,
// // check my previous submit, now it is fast slow pointer issue, will try to write code again
//
// // use 20 mins to finish
//
// // now check the code

class Solution {
    func isHappy(_ n: Int) -> Bool {
        var slow = n
        var fast = n

        repeat {
            // Wrong: slow = squareNum(n)
            // Why: this always moves from the original `n`, not from current `slow`.
            // Correct: move slow one step from its current value.
            slow = squareNum(slow)

            // Wrong: fast = squareNum(squareNum(n))
            // Why: this also always moves from original `n`, so fast does not keep advancing.
            // Correct: move fast two steps from its current value.
            fast = squareNum(squareNum(fast))
        } while fast != 1 && slow != fast

        return fast == 1
    }

    func squareNum(_ n: Int) -> Int {
        var num = n
        var sum = 0

        while num != 0 {
            // Wrong: var cur = num % 10
            // Why: `cur` never changes after assignment.
            // Correct: use `let` for constants.
            let cur = num % 10

            // Wrong: Math.square(cur)
            // Why: Swift does not have `Math.square`.
            // Correct: multiply the digit by itself.
            sum += cur * cur

            num = num / 10
        }

        return sum
    }
}

// GPT's summary:
// Mistakes you made:
// - Your fast/slow pointer idea was correct, but you kept calculating from original `n`.
// - `slow` should move from `slow`, and `fast` should move from `fast`.
// - Swift does not have `Math.square(cur)`.
// - You used `var` for `cur`, but `cur` never changes, so `let` is better.
//
// Swift syntax to remember:
// - Use `repeat { ... } while condition` when you need the loop body to run at least once.
// - `let cur = num % 10` gets the last digit.
// - `sum += cur * cur` squares a number in plain Swift.
// - `return fast == 1` is a shorter way to return true/false from a condition.
//
// Complexity:
// - Time: O(log n) per `squareNum` call, and the happy-number sequence quickly enters a small cycle.
// - Space: O(1), because fast/slow pointers do not use a Set.