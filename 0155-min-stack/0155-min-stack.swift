// Your original solution:
//
// class MinStack {
//
//     init() {
//         
//     }
//     
//     func push(_ value: Int) {
//         
//     }
//     
//     func pop() {
//         
//     }
//     
//     func top() -> Int {
//         
//     }
//     
//     func getMin() -> Int {
//         
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
// // Pattern: Stack, Array, Map,
// // Card shape:
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank
// // Thinking
// // must O(1),
// // push and pop, I can just use array to implement, but remove first, the TC is not O(1), if I delete
// // so I should not deletion, just change the top pointer
// // top also just array's first
// // getMin I should use a variable to maintain
// // push, then compare, what if I pop, how to get next min
// // but push also need to compare with all element in the stack to get the minimum
// // how to make it be O(1)
// // compare with the existing minimum, then update the minimum
// // but when we do pop, how to get the new minimum, after we pop the minimum one
// // so blocked by to find new min I need to do all  the compare and sort , which is definitely not O(1)
// // blocked by this O(1) getMin


// Fixed version:
class MinStack {
    // Every stack entry stores:
    // 1. Its own value.
    // 2. The minimum value from the bottom through this entry.
    private var stack = [(value: Int, minimum: Int)]()

    init() {}

    func push(_ value: Int) {
        let previousMinimum = stack.last?.minimum ?? value
        let currentMinimum = min(value, previousMinimum)

        stack.append((value: value, minimum: currentMinimum))
    }

    func pop() {
        // Good: remove from the end of an Array, not the beginning.
        _ = stack.popLast()
    }

    func top() -> Int {
        // The problem guarantees this is called on a nonempty stack.
        return stack.last!.value
    }

    func getMin() -> Int {
        // The top entry remembers the minimum for the entire current stack.
        return stack.last!.minimum
    }
}


// GPT's summary:
//
// Key idea you missed:
// - One global minimum is not enough because popping it loses the previous
//   minimum.
// - Instead, every stack level remembers the minimum at that level.
// - After pop(), the new top already contains the correct previous minimum.
//
// Example:
// - push(-2): store (value: -2, minimum: -2)
// - push(0):  store (value:  0, minimum: -2)
// - push(-3): store (value: -3, minimum: -3)
// - getMin(): -3
// - pop(): remove (-3, -3)
// - getMin(): the new top already stores -2
//
// Duplicate minimum example:
// - push(-2): store (-2, -2)
// - push(-2): store (-2, -2)
// - pop(): one -2 remains, and getMin() still returns -2.
//
// What you did well:
// - You correctly chose an Array to implement the stack.
// - You correctly noticed that removing the first element is O(n).
// - You correctly identified that pop() is the difficult part when the
//   current minimum is removed.
// - No dictionary or sorting is needed.
//
// Stack direction:
// - Use the end of the Array as the top.
// - Push: `append(...)`
// - Pop: `popLast()`
// - Top: `last`
//
// Swift syntax to remember:
// - Named tuple array:
//   `[(value: Int, minimum: Int)]()`
// - Read the final element safely:
//   `stack.last?.minimum`
// - Provide a value when an optional is nil:
//   `stack.last?.minimum ?? value`
// - `popLast()` returns an optional, so `_ = stack.popLast()` explicitly
//   ignores the removed value.
//
// Contract:
// - After every push or pop, each entry's `minimum` equals the smallest
//   value from the bottom of the stack through that entry.
// - Therefore, `stack.last!.minimum` is always the current global minimum.
//
// Complexity:
// - push(): O(1) amortized
// - pop(): O(1)
// - top(): O(1)
// - getMin(): O(1)
// - Space: O(n)