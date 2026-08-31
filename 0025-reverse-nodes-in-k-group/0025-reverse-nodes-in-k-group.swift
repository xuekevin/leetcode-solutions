// Your original solution:
// /**
//  * Definition for singly-linked list.
//  * public class ListNode {
//  *     public var val: Int
//  *     public var next: ListNode?
//  *     public init() { self.val = 0; self.next = nil; }
//  *     public init(_ val: Int) { self.val = val; self.next = nil; }
//  *     public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
//  * }
//  */
// class Solution {
//    func reverseKGroup(_ head: ListNode?, _ k: Int) -> ListNode? {
//    }
// }
// // Thinking
// // reading issue
// // check the example
// // so basically  if reverse every k list, if the reamining items less than k, then don't reverse
// // so need to maintain the start pointer
// // and find the end of the k
// // do the loop first, i = 1, i <=k i++, then find the node k
// // if remaining node less than k, then do nothing
// // the how to do the reverse of k,
// //  basically move the cur.next to the start.next,
// // start.next.next = cur
// // cur.next = the last.next
// // I know how to do it
// // the TC, assume it is O(K) traverse, then traverse again O(k) do reverse, do n/k times
// // SC is O(1)
//
// // Pattern: LinkedList, two pointers
// // Card shape: as I mentioned above
// // State needed: start, pre, cur, next, pointers,
// // Contract:      find the k node we need to do partial reverser
// // Recall:         half
// // 10 mins so far
// // for remaining implementation will let gpt to help


class Solution {
    func reverseKGroup(_ head: ListNode?, _ k: Int) -> ListNode? {
        // A dummy node makes reversing the first group work the same
        // as reversing every later group.
        let dummy = ListNode(0)
        dummy.next = head

        // `groupPrev` is the node immediately before the current k-group.
        var groupPrev: ListNode? = dummy

        while true {
            // Find the kth node of the current group.
            var groupEnd = groupPrev

            for _ in 0..<k {
                groupEnd = groupEnd?.next
            }

            // Good: if fewer than k nodes remain, do not reverse them.
            guard let groupEnd = groupEnd else {
                break
            }

            // Save the node after this group.
            // After reversal, the old group start must point here.
            let nextGroupStart = groupEnd.next

            // Reverse exactly k nodes.
            //
            // At first, `previous` points to the node after the group.
            // This lets the final reversed node reconnect correctly.
            var previous = nextGroupStart
            var current = groupPrev?.next

            for _ in 0..<k {
                // Save the next node before breaking this connection.
                let next = current?.next

                // Reverse the current node's pointer.
                current?.next = previous

                // Move both reversal pointers forward.
                previous = current
                current = next
            }

            // Before reversal:
            // groupPrev -> A -> B -> C -> nextGroupStart
            //
            // After reversal:
            // groupPrev -> C -> B -> A -> nextGroupStart
            //
            // `previous` is now C, the new start of this group.
            // `groupPrev?.next` is still A, the old start and new end.
            let oldGroupStart = groupPrev?.next
            groupPrev?.next = previous

            // Move to the end of the reversed group
            // so the next loop can process the next k-group.
            groupPrev = oldGroupStart
        }

        return dummy.next
    }
}

/*
 GPT's summary

 What you did well:
 - You correctly identified the key rule:
   if fewer than k nodes remain, do not reverse them.
 - You correctly expected O(1) extra space.
 - Your time-complexity idea was right:
   checking and reversing each group costs O(k), repeated about n / k times,
   which is O(n) total.

 Key pointers:
 - groupPrev: node before the current group.
 - groupEnd: kth node; proves a full group exists.
 - nextGroupStart: node after the current group.
 - previous and current: reverse the k links.

 Why `previous = nextGroupStart`:
 - When the old first node becomes the final node after reversal,
   its `.next` must already point to the next unchanged group.

 Example:
 1 -> 2 -> 3 -> 4 -> 5, k = 2

 First group:
 groupPrev -> 1 -> 2 -> 3

 Reverse:
 groupPrev -> 2 -> 1 -> 3

 Then move groupPrev to node 1 and process:
 3 -> 4

 Final:
 2 -> 1 -> 4 -> 3 -> 5

 Complexity:
 - Time: O(n)
 - Space: O(1)
*/