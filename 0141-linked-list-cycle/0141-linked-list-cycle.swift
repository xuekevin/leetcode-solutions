// Your original solution:
//
// /**
// - Definition for singly-linked list.
// - public class ListNode {
// - public var val: Int
// - public var next: ListNode?
// - public init(_ val: Int) {
// - self.val = val
// - self.next = nil
// - }
// - }
//  */
//
// class Solution {
//     func hasCycle(_ head: ListNode?) -> Bool {
//         guard let node = head, node.next != nil else {
//             return false
//         }
//
//         var p: ListNode? = node
//         var q: ListNode? = node
//
//         while p != q || p != nil || q != nil {
//             p = p?.next
//             q = q?.next?.next
//         }
//         if p == q && p != nil {
//             return true
//         } else {
//             return false
//         }
//     }
// }
//
// // Pattern: two pointers, slow and fast
// // Card shape: go through linkedlist, fast and slow, pointers, when two pointer meets, means has a cycle
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank
//
// // thinking
// // know it is two pointers, fast slow
// // when slow == fast, what's next, this is just to see if it is cycle, so it is not about the cycle entry
// // 4 mins to start to write
// // 10 mins, ready to run
// // has some swift synatx error I can't recall, will let gpt fix but the logic in this solution is correct


// Fixed version:
class Solution {
    func hasCycle(_ head: ListNode?) -> Bool {
        var slow = head
        var fast = head

        // Continue only while fast can move two steps.
        while let fastNode = fast, let nextNode = fastNode.next {
            slow = slow?.next
            fast = nextNode.next

            // Wrong: slow == fast
            // Why: ListNode does not conform to Equatable.
            // Correct: `===` checks whether both variables reference
            // the exact same ListNode object.
            if slow === fast {
                return true
            }
        }

        // If fast reaches nil, the list has an ending and no cycle.
        return false
    }
}


// GPT's summary:
//
// What you did well:
// - You selected Floyd's slow-and-fast-pointer algorithm.
// - You correctly moved one pointer one step and the other two steps.
// - You correctly understood that meeting means a cycle exists.
// - You correctly recognized that finding the cycle entry is not required.
//
// Mistakes you made:
// - `p != q` and `p == q` use value equality.
// - ListNode is a class without Equatable conformance, so compare node
//   identity using `!==` and `===`.
// - `p != nil || q != nil` is not the correct continuation condition.
// - The algorithm should stop when fast cannot move two steps.
// - Starting slow and fast at the same node means they must move before
//   checking whether they meet.
//
// Why the loop checks fast and fast.next:
// - Slow only moves one step, but fast moves two steps.
// - To safely move fast twice, both fast and fast.next must exist.
// - Optional binding unwraps both nodes:
//   `while let fastNode = fast, let nextNode = fastNode.next`
//
// Why meeting proves there is a cycle:
// - Inside a cycle, fast gains one node on slow during every iteration.
// - Because the cycle has a finite number of nodes, fast must eventually
//   catch slow.
// - Without a cycle, fast eventually reaches nil.
//
// Loop contract:
// - At the top of every iteration, fast can safely move two steps.
// - Slow has moved half as quickly as fast.
// - If they reference the same node after moving, a cycle exists.
//
// Swift syntax to remember:
// - Same class instance: `node1 === node2`
// - Different class instances: `node1 !== node2`
// - `==` and `!=` compare values and require Equatable conformance.
// - Optional chaining for two steps: `node?.next?.next`
//
// Complexity:
// - Time: O(n)
// - Space: O(1)