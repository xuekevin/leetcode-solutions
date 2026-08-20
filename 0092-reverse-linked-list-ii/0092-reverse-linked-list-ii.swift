// ============================================================
// FIX VERSION: Follows your pointer-reversal idea
// ============================================================

class fixSolution {
    func reverseBetween(
        _ head: ListNode?,
        _ left: Int,
        _ right: Int
    ) -> ListNode? {
        if left == right {
            return head
        }

        let dummy = ListNode(0, head)
        var beforeLeft = dummy

        // Move to the node immediately before position left.
        for _ in 1..<left {
            beforeLeft = beforeLeft.next!
        }

        // The original left node will become the segment's tail.
        let segmentTail = beforeLeft.next

        var current = beforeLeft.next
        var previous: ListNode? = nil

        // Reverse every node from left through right.
        for _ in left...right {
            let next = current?.next
            current?.next = previous
            previous = current
            current = next
        }

        // previous is the new segment head.
        beforeLeft.next = previous

        // current is the first node after the reversed segment.
        segmentTail?.next = current

        return dummy.next
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// One-pass head-insertion technique
// ============================================================

class Solution {
    func reverseBetween(
        _ head: ListNode?,
        _ left: Int,
        _ right: Int
    ) -> ListNode? {
        let dummy = ListNode(0, head)
        var beforeLeft = dummy

        // Find the node immediately before the reversed section.
        for _ in 1..<left {
            beforeLeft = beforeLeft.next!
        }

        // current remains the tail of the reversed section.
        var current = beforeLeft.next

        // Move each node after current to the front of the section.
        for _ in 0..<(right - left) {
            guard let movedNode = current?.next else {
                break
            }

            // Remove movedNode from after current.
            current?.next = movedNode.next

            // Insert movedNode immediately after beforeLeft.
            movedNode.next = beforeLeft.next
            beforeLeft.next = movedNode
        }

        return dummy.next
    }
}

// ============================================================
// ORIGINAL SOLUTION
// ============================================================

/*
class Solution {
    func reverseBetween(_ head: ListNode?, _ left: Int, _ right: Int)
        -> ListNode? {
        var leftDummy = ListNode()
        var rightDummy = ListNode()
        var dummyHead = ListNode(-501)
        var cur = head
        dummyHead.next = cur
        var pre: ListNode? = dummyHead
        var leftPre = pre
        var count = 0

        while cur != nil {
            count += 1
            if count == left {
                leftDummy.next = cur
                leftPre = pre
            }

            if count == right {
                rightDummy.next = cur
            }

            pre = cur
            cur = cur?.next
        }

        var left = leftDummy.next
        var right = rightDummy.next

        while left != rightDummy.next?.next {
            let temp = left?.next
            left?.next = right?.next
            right = left
            left = temp
        }

        if leftPre.val != 501 {
            leftPre.next = right
        }

        return dummyHead.next
    }
}
*/

// ============================================================
// ORIGINAL THINKING
// ============================================================

/*
Thinking:
- Find the node at left and the node at right.
- Save the node before left.
- Reverse the nodes from left through right.
- Reconnect the reversed section to the rest of the list.

Pattern: Linked list, pointers

State needed:
- Node before left
- Current node
- Previous node
- Node after right

Contract:
After each reversal iteration, `previous` is the head of the portion
already reversed, and `current` is the next node to process.

Recall: half
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
MAIN PROBLEM IN THE ORIGINAL REVERSAL:

You wrote:

    left?.next = right?.next
    right = left

After `right` changes, `right?.next` is not the previously reversed
head. This causes nodes to skip each other and breaks the segment.

Standard reversal needs:

    let next = current?.next
    current?.next = previous
    previous = current
    current = next


HOW THE FIX VERSION RECONNECTS THE LIST:

Before:

    beforeLeft -> 2 -> 3 -> 4 -> afterRight

After reversing 2 through 4:

    beforeLeft -> 4 -> 3 -> 2 -> afterRight

The important pointers are:

    beforeLeft  = node before 2
    previous    = 4, the new segment head
    segmentTail = 2, the original segment head
    current     = afterRight

Reconnect using:

    beforeLeft.next = previous
    segmentTail.next = current


WHY THE DUMMY NODE HELPS:

If left == 1, there is no real node before the reversed section.

The dummy creates one:

    dummy -> head

Therefore, the same reconnection logic works whether left is 1 or not.
No sentinel value such as -501 is needed.


SWIFT ISSUES:

1. `leftPre` is optional, so direct access is invalid:

       leftPre.val
       leftPre.next

   Optional access would require:

       leftPre?.val
       leftPre?.next

2. The sentinel was -501, but the check used 501:

       dummyHead = ListNode(-501)
       leftPre.val != 501

3. Local variables named `left` and `right` conflict with the parameter
   names and make the code difficult to follow.

4. `leftDummy` and `rightDummy` add nodes but do not simplify the actual
   reversal or reconnection.


HOW THE UPGRADE WORKS:

Example section:

    before -> 2 -> 3 -> 4 -> 5

Keep current at 2.

Move 3 after before:

    before -> 3 -> 2 -> 4 -> 5

Move 4 after before:

    before -> 4 -> 3 -> 2 -> 5

The section is now reversed without a separate reversal pass.


COMPLEXITY:

Time: O(n)
Space: O(1)

Both versions change pointers in place and create only one dummy node.
*/