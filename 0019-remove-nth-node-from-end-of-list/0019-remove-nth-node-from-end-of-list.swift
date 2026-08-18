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
//     func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
//         guard let node = head else {
//             return nil
//         }
//
//         var fast = node
//         var count = 0
//         var slow = node
//         while fast != nil {
//             count += 1
//             if count >= n + 1 {
//                 slow = slow?.next
//             }
//             fast = fast?.next
//         }
//         // remove slow's next
//         var temp = slow?.next
//         slow?.next = temp?.next
//
//         return head
//     }
// }
//
// // Thinking
// // linkedlist
// // remove from n from end
// // can use two pointers to find the nth from end
// // when fast pointer first, slow start after n times
// // then we fast to the end, slow point to the nth from end
// // delete it
// // need to use record n+1 from end, since we need to delete n from end
//
// // Pattern: linked list, pointers
// // Card shape:
// // remove from n from end
// // can use two pointers to find the nth from end
// // when fast pointer first, slow start after n times
// // then we fast to the end, slow point to the nth from end
// // delete it
// // need to use record n+1 from end, since we need to delete n from end
//
// // State needed: slow and fast pointer
// // Contract:      traverse until fast to the end, then we find the nth from end
// // Recall:        landed
//
// // start write around 3 mins
// // finish writing in 6 mins, assume there is some synatx error
// // will let gpt to point out


// Fixed version:
class Solution {
    func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
        // The dummy node gives every real node a previous node,
        // including the original head.
        let dummy = ListNode(0, head)

        var slow: ListNode? = dummy
        var fast: ListNode? = dummy

        // Move fast n nodes ahead of slow.
        for _ in 0..<n {
            fast = fast?.next
        }

        // Move both pointers while preserving their n-node distance.
        // When fast reaches the last node, slow is directly before
        // the node that must be removed.
        while fast?.next != nil {
            fast = fast?.next
            slow = slow?.next
        }

        // Remove slow.next.
        slow?.next = slow?.next?.next

        // Return dummy.next because the original head may have been removed.
        return dummy.next
    }
}


// GPT's summary:
//
// What you did well:
// - You correctly selected the two-pointer pattern.
// - You correctly understood that we need the node before the target.
// - You correctly planned to keep fast ahead of slow.
//
// Swift type mistake:
// - `guard let node = head` unwraps node into a non-optional ListNode.
// - Therefore, `var fast = node` and `var slow = node` are also inferred as
//   non-optional ListNode values.
// - Later, `fast?.next` returns ListNode?, which cannot be assigned back to
//   a non-optional variable.
//
// Correct declaration:
// - `var fast: ListNode? = dummy`
// - `var slow: ListNode? = dummy`
//
// Logic issues:
// - The count condition moved slow one step too many.
// - More importantly, the original approach cannot remove the head because
//   slow begins at the head and only removes slow.next.
//
// Failing case:
// - head = [1], n = 1
// - The node that must be removed is the head itself.
// - There is no real node before it.
// - A dummy node provides that missing previous node.
//
// Why the dummy node works:
// - Original: 1 -> 2 -> 3
// - With dummy: dummy -> 1 -> 2 -> 3
// - If node 1 must be removed, slow can remain at dummy.
// - Then `slow.next = slow.next?.next` removes node 1.
//
// Pointer contract:
// - After moving fast n steps, fast remains n nodes ahead of slow.
// - When fast reaches the last node, slow is immediately before the node
//   that is n positions from the end.
//
// Swift syntax to remember:
// - Explicit optional type:
//   `var fast: ListNode? = dummy`
// - Move through an optional linked list:
//   `fast = fast?.next`
// - Remove the next node:
//   `slow?.next = slow?.next?.next`
// - A temporary variable is unnecessary for this assignment.
//
// Complexity:
// - Time: O(length of list)
// - Space: O(1)