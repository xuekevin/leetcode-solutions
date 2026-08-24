/*
YOUR ORIGINAL SOLUTION:

/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init() { self.val = 0; self.next = nil; }
 *     public init(_ val: Int) { self.val = val; self.next = nil; }
 *     public init(_ val: Int, _ next: ListNode?) {
 *         self.val = val
 *         self.next = next
 *     }
 * }
 */
class Solution {
    func rotateRight(_ head: ListNode?, _ k: Int) -> ListNode? {
        guard let node = head else {
            return nil
        }
        let dummyHead = ListNode()
        dummyHead.next = node
        var p = node
        var end = node
        var totalCount = 1

        while p.next != nil {
            totalCount += 1
            p = p?.next
        }

        end = p
        end.next = node

        var count = 1

        // find new Head

        var q = head
        while count < totalCount - k {
            q = q?.next
            count += 1
        }

        let newHead = q?.next
        q?.next = nil
        return newHead
    }
}

// Thinking
// move k times from right, and append in the front
// need to first find the end of the list
// the do k step remove and append
// 1 mins, start writing
// 7 mins realize I need to find the new end after every move
// might can put end.next = head
// then find new head,
// new head is from length - k
// will use this logic
// finish writing, now checking
// lgtm, ready to run
// got compile error

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/


// FIX VERSION:
// Your circular-list idea is correct.

class fixSolution {
    func rotateRight(_ head: ListNode?, _ k: Int) -> ListNode? {
        guard let head = head else {
            return nil
        }

        var tail = head
        var totalCount = 1

        // Wrong:
        // var p = node
        // p = p?.next
        //
        // Why:
        // Because `node` was unwrapped, Swift inferred p as ListNode,
        // but `p?.next` produces ListNode?.
        //
        // Correct:
        // Keep tail non-optional and unwrap its next node.
        while let nextNode = tail.next {
            tail = nextNode
            totalCount += 1
        }

        // Wrong: totalCount - k
        // Why: k can be greater than the list length.
        //
        // Rotating a list of length 5 by 7 positions is equivalent
        // to rotating it by 7 % 5 = 2 positions.
        let rotations = k % totalCount

        // Connect the original tail to the original head.
        // The linked list is temporarily circular.
        tail.next = head

        // The new tail is at position `totalCount - rotations`,
        // using one-based positions.
        var newTail = head
        var count = 1

        while count < totalCount - rotations {
            newTail = newTail.next!
            count += 1
        }

        let newHead = newTail.next

        // Break the circle after the new tail.
        newTail.next = nil

        return newHead
    }
}


// GPT'S UPGRADE VERSION:
// Same optimal algorithm, with an early return when no rotation is needed.

class Solution {
    func rotateRight(_ head: ListNode?, _ k: Int) -> ListNode? {
        guard let head = head, head.next != nil else {
            return head
        }

        // First pass: find the length and original tail.
        var length = 1
        var oldTail = head

        while let nextNode = oldTail.next {
            oldTail = nextNode
            length += 1
        }

        let rotations = k % length

        // The list remains unchanged after rotating by its full length.
        if rotations == 0 {
            return head
        }

        // Convert the list into a circle.
        oldTail.next = head

        // After rotating right by `rotations`, the new tail is
        // `length - rotations - 1` moves away from the original head.
        var newTail = head

        for _ in 0..<(length - rotations - 1) {
            newTail = newTail.next!
        }

        let newHead = newTail.next
        newTail.next = nil

        return newHead
    }
}


/*
GPT'S EXAMPLE

Input:

    1 -> 2 -> 3 -> 4 -> 5
    k = 2

Step 1: Find the length and tail.

    length = 5
    oldTail = 5

Step 2: Normalize k.

    rotations = 2 % 5 = 2

Step 3: Connect the tail to the head.

    1 -> 2 -> 3 -> 4 -> 5
    ^                   |
    |___________________|

Step 4: Find the new tail.

The final two nodes must move to the front:

    [1 -> 2 -> 3] [4 -> 5]
              ^
           new tail

The new tail is `length - rotations - 1` moves from the head:

    5 - 2 - 1 = 2 moves

Start at 1:

    Move 1: 2
    Move 2: 3

Therefore:

    newTail = 3
    newHead = newTail.next = 4

Step 5: Break the circle after 3.

Result:

    4 -> 5 -> 1 -> 2 -> 3


GPT'S SUMMARY

What you did well:
- Your main algorithm was correct.
- Finding the list length first is necessary.
- Connecting `tail.next = head` is a clean way to rotate the list.
- You correctly understood that the new head is related to
  `length - k`.

Mistakes you made:

1. Optional-type mismatch:

   Wrong:

       var p = node
       p = p?.next

   `p` is inferred as `ListNode`, but `p?.next` is `ListNode?`.

   Correct non-optional traversal:

       while let nextNode = tail.next {
           tail = nextNode
       }

2. You did not normalize k.

   Wrong:

       totalCount - k

   If:

       totalCount = 3
       k = 4

   then:

       totalCount - k = -1

   But rotating four times is equivalent to rotating once.

   Correct:

       let rotations = k % totalCount

3. The dummy head was not used.

   You created:

       let dummyHead = ListNode()
       dummyHead.next = node

   But no later operation depended on it. This problem does not require
   a dummy head because the new head is found directly.

4. After creating the circle, it must always be broken:

       newTail.next = nil

Pattern:
- Linked list / circular list / two-pass traversal.

State needed:
- `length`: number of nodes.
- `oldTail`: original final node.
- `rotations`: effective rotation count.
- `newTail`: node before the new head.
- `newHead`: first node in the rotated list.

Contract:
- After the first traversal, `length` is the total node count and
  `oldTail` points to the final node.
- After locating `newTail`, its next node is the correct new head.

Complexity:
- Time: O(n).
- Space: O(1).
*/