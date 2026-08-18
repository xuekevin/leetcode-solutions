// Your original solution:
//
// class MinStack {
//
//     var stack = [(Int,Int)]()
//
//     init() {
//         // reset
//         stack = []
//     }
//     
//     func push(_ value: Int) {
//         if stack.isEmpty {
//             stack.append((value,value))
//         } else
//             let newMin = min(stack.last.$1, value)
//             stack.append((value,newMin))
//         }
//     }
//     
//     func pop() {
//         if !stack.isEmpty {
//             stack.removeLast()
//         }
//     }
//     
//     func top() -> Int {
//         if !stack.isEmpty {
//             return stack.last.$0
//         }
//         // need the issue to define for this case
//         return 0
//     }
//     
//     func getMin() -> Int {
//         if !stack.isEmpty {
//             return stack.last.$1
//         }
//         // need the issue to define for this case
//         return 0
//     }
// }
//
// /**
// - Your MinStack object will be instantiated and called as such:
// - let obj = MinStack()
// - obj.push(value)
// - obj.pop()
// - let ret_3: Int = obj.top()
// - let ret_4: Int = obj.getMin()
//  */
//
// // finish writing in 8 mins
// // I know I have some synatx error maybe, to control the time
// // will let gpt to fix, and all I need to learn is swift knowledge


// Fixed version:
class MinStack {
    // Named tuple elements are clearer than `.0` and `.1`.
    private var stack = [(value: Int, minimum: Int)]()

    // The property is already initialized above, so no reset is required.
    init() {}

    func push(_ value: Int) {
        if let lastEntry = stack.last {
            // Correct: optional binding unwraps `stack.last`.
            let newMinimum = min(lastEntry.minimum, value)
            stack.append((value: value, minimum: newMinimum))
        } else {
            stack.append((value: value, minimum: value))
        }
    }

    func pop() {
        if !stack.isEmpty {
            stack.removeLast()
        }
    }

    func top() -> Int {
        // LeetCode guarantees this is called only on a nonempty stack.
        return stack.last!.value
    }

    func getMin() -> Int {
        // LeetCode guarantees this is called only on a nonempty stack.
        return stack.last!.minimum
    }
}


// GPT's summary:
//
// Your algorithm:
// - Your MinStack logic was correct.
// - Every tuple stores its value and the minimum at that stack level.
// - Only Swift syntax and optional handling needed correction.
//
// Swift mistakes:
//
// 1. `else` requires braces for multiple statements.
//
// Wrong:
// else
//     let newMin = ...
//     stack.append(...)
//
// Correct:
// else {
//     let newMin = ...
//     stack.append(...)
// }
//
// 2. Tuple elements use `.0` and `.1`, not `$0` and `$1`.
//
// Unnamed tuple:
// let item = (10, 5)
// item.0 // 10
// item.1 // 5
//
// `$0` and `$1` are shorthand parameter names used inside closures.
//
// 3. `stack.last` returns an optional.
//
// Type:
// stack.last // (value: Int, minimum: Int)?
//
// Even after checking `!stack.isEmpty`, Swift does not automatically
// unwrap `stack.last`. Use optional binding:
//
// if let lastEntry = stack.last {
//     let minimum = lastEntry.minimum
// }
//
// Or force unwrap when the problem guarantees the stack is nonempty:
//
// stack.last!.value
//
// 4. Initializing the property twice is unnecessary.
//
// This already creates an empty array:
// private var stack = [(value: Int, minimum: Int)]()
//
// Therefore, `init() { stack = [] }` can simply be `init() {}`.
//
// Empty-stack behavior:
// - LeetCode guarantees that top() and getMin() are called only when the
//   stack is nonempty.
// - Returning 0 would be misleading because 0 could be a real stack value.
// - For a general-purpose API, these methods could return `Int?`, but the
//   required LeetCode interface returns `Int`.
//
// Complexity:
// - push(): O(1) amortized
// - pop(): O(1)
// - top(): O(1)
// - getMin(): O(1)
// - Space: O(n)