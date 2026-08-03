// Your original solution:
//
// /**
// - Definition for a Node.
// - public class Node {
// - public var val: Int
// - public var left: Node?
// - public var right: Node?
// - public var next: Node?
// - public init(_ val: Int) {
// - self.val = val
// - self.left = nil
// - self.right = nil
// - self.next = nil
// - }
// - }
// */
//
// class Solution {
//
//     func connect(_ root: Node?) -> Node? {
//         guard let root = root else {
//             return root
//         }
//
//         var queue = [Node]()
//
//         if queue.count == 0 {
//             queue.append(root)
//         }
//
//         var count = queue.count
//
//         while count > 0 && queue.count > 0 {
//             let node = queue.removeFirst()
//             count -= 1
//             if count > 0 {
//                 // not remove
//                 node.next = queue[0]
//             } else {
//                 node.next = nil
//             }
//
//             if let left = node.left {
//                 queue.append(left)
//             }
//             if let right = node.right {
//                 queue.append(right)
//             }
//
//             if count == 0 {
//                 count = queue.count
//             }
//         }
//         return root
//     }
// }
//
// // Pattern: level traverse
// // Card shape: might use stack or queue to get the same level items
// // should use queue, since we need FIFO
// // State needed:
// // Contract: this function returns ___: not sure
// // Recall: blank
// // but think I can try to write the code based on current info I mentioned above
// // finish writing in 22 mins
// // now examine the logic and basic synatx error
// // fix some logic error in 4 mins
// // now try to run the code
// // run pass, 27 mins, now submit, passed!

class Solution {
    func connect(_ root: Node?) -> Node? {
        guard let root = root else {
            return nil
        }

        var queue = [root]
        var front = 0

        while front < queue.count {
            // Good: this marks the end of the current level before
            // children are added to the queue.
            let levelEnd = queue.count
            var previous: Node?

            while front < levelEnd {
                let node = queue[front]
                front += 1

                // Good: connect each node to the previous node in this level.
                previous?.next = node
                previous = node

                if let left = node.left {
                    queue.append(left)
                }
                if let right = node.right {
                    queue.append(right)
                }
            }

            // Good: the final node in every level points to nil.
            previous?.next = nil
        }

        return root
    }
}

// GPT's summary:
// What you did well:
// - Your BFS / level-order traversal idea is correct and passed.
// - You correctly tracked how many nodes remained in the current level.
// - You correctly set the last node of each level to nil.
// - You correctly set `next` before appending children, so the front
//   of the queue is still the next node from the same level.
//
// Small improvement:
// - `if queue.count == 0 { queue.append(root) }` is unnecessary because
//   a newly created queue is always empty. Use `var queue = [root]`.
// - `queue.removeFirst()` is O(n) for a Swift Array because all remaining
//   elements shift left. Use a `front` index instead.
//
// Key idea:
// - Process exactly one level at a time.
// - Keep a `previous` node and connect `previous?.next = node`.
// - After the level ends, set its final node's `next` to nil.
//
// Swift syntax to remember:
// - `previous?.next = node` uses optional chaining.
// - `if let left = node.left` safely unwraps an optional child.
// - An array plus a moving index can act as an efficient queue.
//
// Complexity:
// - Your original code: O(n^2) time in Swift because of `removeFirst()`.
// - Improved code: O(n) time and O(n) space.