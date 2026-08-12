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
//     func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
//         if lists.count == 0 {
//             return nil
//         }
//
//         return mergeKListHelper(lists, 0, lists.count - 1)
//     }
//
//     func mergeKListHelper(_ lists: [ListNode?], _ start: Int, _ end: Int) -> ListNode? {
//         if start == end {
//             return lists[start]
//         }
//
//         var mid = start + (end - start) / 2
//
//         let leftNode = mergeKListHelper(lists, start, mid)
//         let rightNode = mergeKListHelper(lists, mid + 1, end)
//
//         return mergeTwoList(leftNode, rightNode)
//     }
//
//     func mergeTwoList(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
//         guard var p1 = list1 else {
//             return list2
//         }
//
//         guard var p2 = list2 else {
//             return list1
//         }
//
//         let dummy = ListNode()
//         var cur = ListNode()
//         dummy.next = cur
//
//         while p1 != nil && p2 != nil {
//             if p1.val < p2.val {
//                  cur = p1
//                  p1 = p1.next
//             } else {
//                 cur = p2
//                 p2 = p2.next
//             }
//             cur = cur?.next
//         }
//
//         if p1 != nil {
//             cur?.next = p1
//         }
//
//         if p2 != nil {
//             cur?.next = p2
//         }
//
//         return dummy.next
//     }
// }
//
// // Pattern: Greedy
// // Card shape: kind like binary search, to convert the list to sub lists, then to merge left and right
// // State needed: pass the current start and end
// // Contract:      recursive → what's TRUE when a call returns
// //                pass in the new start and end, generate new leftNode and right node, to do merge recursive
// // Recall: blank
//
// // use 19 mins
// // try to fix everything, got some synatx error, will let gpt to fix


// Fixed version:
class Solution {
    func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
        if lists.isEmpty {
            return nil
        }

        return mergeKListHelper(lists, 0, lists.count - 1)
    }

    func mergeKListHelper(
        _ lists: [ListNode?],
        _ start: Int,
        _ end: Int
    ) -> ListNode? {
        // Contract:
        // Return one sorted list containing every node from
        // lists[start...end].
        if start == end {
            return lists[start]
        }

        // Good: divide the lists into two groups.
        let middle = start + (end - start) / 2

        let leftNode = mergeKListHelper(lists, start, middle)
        let rightNode = mergeKListHelper(lists, middle + 1, end)

        return mergeTwoLists(leftNode, rightNode)
    }

    func mergeTwoLists(
        _ list1: ListNode?,
        _ list2: ListNode?
    ) -> ListNode? {
        // These must remain optional because each pointer eventually becomes nil.
        var p1 = list1
        var p2 = list2

        let dummy = ListNode()
        var tail = dummy

        // Correct: optional binding gives us non-optional nodes for comparison.
        while let node1 = p1, let node2 = p2 {
            if node1.val <= node2.val {
                // Attach the chosen node after the result's current tail.
                tail.next = node1
                p1 = node1.next
            } else {
                tail.next = node2
                p2 = node2.next
            }

            // Move tail to the node we just attached.
            tail = tail.next!
        }

        // One list may still contain nodes. It is already sorted.
        tail.next = p1 ?? p2

        return dummy.next
    }
}


// GPT's summary:
//
// Mistakes you made:
// - `guard var p1 = list1` unwraps p1 into a non-optional ListNode.
//   After that, `p1 != nil` and assigning `p1.next` do not fit its type.
// - `cur = p1` replaces the local pointer, but it does not connect that
//   node to the result list.
// - The required operation is `tail.next = chosenNode`.
// - `dummy.next = cur` created an unnecessary empty node at the beginning.
// - `cur = cur?.next` used optional chaining even though `cur` was declared
//   as a non-optional ListNode.
// - `furthest` was not relevant here; this problem is divide and conquer,
//   not greedy.
// - `mid` never changes, so it should be declared with `let`.
//
// Key linked-list pattern:
// - `dummy` permanently points before the result's first node.
// - `tail` points to the final node currently attached to the result.
// - Attach with `tail.next = node`.
// - Advance with `tail = tail.next!`.
// - Return `dummy.next`, not `dummy`.
//
// Why `p1` and `p2` stay optional:
// - They represent the current unprocessed nodes.
// - Moving through a list uses `p1 = node1.next`.
// - Eventually `next` is nil, which ends the loop.
//
// Recursive contract:
// - `mergeKListHelper(lists, start, end)` returns one sorted linked list
//   made from all lists between start and end.
// - The base case returns one list.
// - The recursive step merges the sorted result from each half.
//
// What you did well:
// - Dividing the k lists into two halves is the right scalable approach.
// - Your recursion ranges and base case were correct.
// - Your middle calculation was correct.
// - You correctly recognized that the final step is merging two sorted lists.
//
// Complexity:
// - Let N be the total number of nodes and k be the number of lists.
// - Time: O(N log k)
// - Recursive stack space: O(log k)
// - Extra node space: O(1), because existing nodes are reused.