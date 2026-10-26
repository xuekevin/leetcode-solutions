/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init() { self.val = 0; self.next = nil; }
 *     public init(_ val: Int) { self.val = val; self.next = nil; }
 *     public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
 * }
 */
class Solution {
    func reverseKGroup(_ head: ListNode?, _ k: Int) -> ListNode? {
        var dummy = ListNode()
        dummy.next = head
        var pre = dummy

        while true {
            // 1. find the kth node of this group
            var groupEnd: ListNode? = pre

            for i in 0..<k {
                groupEnd = groupEnd?.next
            }

            guard let end = groupEnd else {
                break
            }

            // 2. reverse the group; the first node's next becomes nextGroupStart
            var groupStart = pre.next!
            var nextStart = end.next
            var cur: ListNode? = groupStart
            var prev: ListNode? = nextStart

            while cur !== nextStart {
                let next = cur?.next
                cur?.next = prev
                prev = cur
                cur = next
            }
            
            // 3. reconnect: pre → new head of group (the old kth node)
            pre.next = end
            // 4. advance: the old first node is now the tail = pre for the next group
            pre = groupStart
        }
        
        return dummy.next
    }
}