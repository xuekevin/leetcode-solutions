// Your original solution:
//
// /**
// - Definition for singly-linked list.
// - public class ListNode {
// - public var val: Int
// - public var next: ListNode?
// - public init() { self.val = 0; self.next = nil; }
// - public init(_ val: Int) { self.val = val; self.next = nil; }
// - public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
// - }
//  */
// class Solution {
//     func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
//         var dummy = ListNode()
//         var cur = ListNode()
//         dummy = cur
//
//         var p1 = list1
//         var p2 = list2
//
//         while let node1 = list1, let node2 = list2  {
//             if node1.val < node2.val {
//                 cur.next = node1
//                 p1 = node1.next
//             } else {
//                 cur.next = node2
//                 p2 = node2.next
//             }
//
//             cur = cur.next
//         }
//         cur.next = p1 ? p1 : p2
//         return dummy
//     }
// }
//
// // still make some synatx error


// Fixed version:
class Solution {
    func mergeTwoLists(
        _ list1: ListNode?,
        _ list2: ListNode?
    ) -> ListNode? {
        // One dummy node is enough.
        let dummy = ListNode()
        var cur = dummy

        var p1 = list1
        var p2 = list2

        // Wrong: while let node1 = list1, let node2 = list2
        // Why: list1 and list2 never change, so the loop could run forever.
        // Correct: unwrap the moving pointers p1 and p2.
        while let node1 = p1, let node2 = p2 {
            if node1.val < node2.val {
                cur.next = node1
                p1 = node1.next
            } else {
                cur.next = node2
                p2 = node2.next
            }

            // Wrong: cur = cur.next
            // Why: cur.next has type ListNode?, but cur is ListNode.
            // Correct: it is safe to unwrap because we just assigned cur.next.
            cur = cur.next!
        }

        // Wrong: cur.next = p1 ? p1 : p2
        // Why: Swift's ternary condition must be Bool, not ListNode?.
        // Correct: nil-coalescing chooses whichever list remains.
        cur.next = p1 ?? p2

        // Wrong: return dummy
        // Why: dummy is the extra sentinel node.
        // Correct: the merged list begins at dummy.next.
        return dummy.next
    }
}


// GPT's summary:
//
// Mistakes you made:
// - You created two dummy nodes when only one was needed.
// - Your loop checked the original list1 and list2 instead of moving p1 and p2.
// - `cur.next` is optional, so assigning it to non-optional `cur` requires
//   unwrapping with `cur.next!`.
// - `p1 ? p1 : p2` is not valid because p1 is not a Boolean.
// - Returning `dummy` includes the extra sentinel node.
//
// Swift syntax to remember:
// - Nil-coalescing: `p1 ?? p2`
//   This returns p1 when it is non-nil; otherwise, it returns p2.
// - Optional binding:
//   `while let node1 = p1, let node2 = p2`
// - Since ListNode is a class, `var cur = dummy` makes both variables
//   reference the same node. It does not copy the node.
//
// Key linked-list pattern:
// - `dummy` remembers the beginning of the result.
// - `cur` tracks the end of the result.
// - Attach using `cur.next = node`.
// - Advance using `cur = cur.next!`.
// - Return `dummy.next`.
//
// What you did well:
// - Your comparison and choice logic were correct.
// - You correctly moved p1 or p2 after choosing a node.
// - You correctly understood that the remaining list can be attached at once.
//
// Complexity:
// - Time: O(n + m)
// - Space: O(1)