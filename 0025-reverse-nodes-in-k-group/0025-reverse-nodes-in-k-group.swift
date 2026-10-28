/*
My original code:

class Solution {
    func reverseKGroup(_ head: ListNode?, _ k: Int) -> ListNode? {
        guard let head = head else {
            return nil
        }

        let dummy = ListNode()
        dummy.next = head
        var pre = dummy

        while true {
            var tail = pre

            for i in 0..<k {
                // k times
                // the tail points the the groupEnd node if we have enough k nodes
                tail = tail?.next
            }

            guard let groupEnd = tail else {
                break
            }

            let nextGroupStart = groupEnd.next
            var prev = nextGroupStart
            var groupStart = pre.next!

            while groupStart != nextGroupStart {
                let next = groupStart.next
                groupStart.next = prev
                prev = groupStart
                groupStart = next
            }
            pre.next = groupEnd
            pre = groupEnd
        }

        return dummy.next
    }
}
*/

/*
Fixes needed:
1. `tail` must be `ListNode?`, because `tail?.next` can be nil.
2. `groupStart` must be optional for the same reason.
3. Use `!==` to compare linked-list node identity.
4. After reversal, `pre` must move to the OLD group start, not `groupEnd`.
*/

class Solution {
    func reverseKGroup(_ head: ListNode?, _ k: Int) -> ListNode? {
        let dummy = ListNode()
        dummy.next = head

        var pre: ListNode? = dummy

        while true {
            // Find the kth node after `pre`.
            var tail: ListNode? = pre

            for _ in 0..<k {
                tail = tail?.next
            }

            // Fewer than k nodes remain, so leave them unchanged.
            guard let groupEnd = tail else {
                break
            }

            let nextGroupStart = groupEnd.next
            var previous = nextGroupStart
            var groupStart = pre?.next

            // Reverse the k-node group.
            while groupStart !== nextGroupStart {
                let next = groupStart?.next
                groupStart?.next = previous
                previous = groupStart
                groupStart = next
            }

            // Save the old first node before reconnecting.
            let oldGroupStart = pre?.next

            // Connect previous part to the new group head.
            pre?.next = groupEnd

            // Old group start is now the end of this reversed group.
            pre = oldGroupStart
        }

        return dummy.next
    }
}

/*
GPT's summary

Your main logic was already correct:
- Find whether k nodes exist.
- Reverse those k nodes.
- Connect the reversed group back to the list.
- Leave a final group with fewer than k nodes unchanged.

Important pointer fact:

Before reversing:
pre -> 1 -> 2 -> 3 -> nextGroupStart

After reversing:
pre -> 3 -> 2 -> 1 -> nextGroupStart

So:
- `groupEnd` is the new head: 3
- old `groupStart` is the new end: 1
- Therefore `pre` must move to old `groupStart`.

Time Complexity: O(n)
Space Complexity: O(1)
*/