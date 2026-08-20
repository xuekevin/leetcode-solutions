// ============================================================
// YOUR OWN FIX VERSION
// Correct after fixing the cycle and lastPre initialization.
// ============================================================

class fixSolution {
    func partition(_ head: ListNode?, _ x: Int) -> ListNode? {
        let dummyHead = ListNode(0, head)
        var pre: ListNode? = dummyHead
        var lastPre: ListNode? = nil
        var cur = head

        while let node = cur {
            if lastPre != nil && node.val < x {
                let lastPreNext = lastPre?.next
                let curNext = cur?.next

                // Insert cur after the < x section.
                lastPre?.next = cur

                // Remove cur from its old position.
                pre?.next = curNext

                // Connect cur to the >= x section.
                cur?.next = lastPreNext

                // The inserted node becomes the new < x tail.
                lastPre = cur

                // Continue from the next unprocessed node.
                cur = curNext
            } else {
                // Record the boundary when the first >= x node appears.
                if node.val >= x && lastPre == nil {
                    lastPre = pre
                }

                pre = cur
                cur = cur?.next
            }
        }

        return dummyHead.next
    }
}

// ============================================================
// GPT'S FIX VERSION
// Follows your in-place movement idea with clearer invariants.
// ============================================================

class GPTFixSolution {
    func partition(_ head: ListNode?, _ x: Int) -> ListNode? {
        let dummy = ListNode(0, head)

        // Final node in the processed < x section.
        var lessTail = dummy

        // Skip the initial nodes that are already < x.
        while let next = lessTail.next, next.val < x {
            lessTail = next
        }

        // previous is immediately before current.
        var previous = lessTail
        var current = lessTail.next

        while let node = current {
            if node.val < x {
                // Remove node from its current position.
                previous.next = node.next

                // Insert node after the < x section.
                node.next = lessTail.next
                lessTail.next = node

                // Update the end of the < x section.
                lessTail = node

                // previous stays because the node after it was removed.
                current = previous.next
            } else {
                previous = node
                current = node.next
            }
        }

        return dummy.next
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Recommended: build two chains using the original nodes.
// ============================================================

class Solution {
    func partition(_ head: ListNode?, _ x: Int) -> ListNode? {
        let lessDummy = ListNode()
        var lessTail = lessDummy

        let greaterDummy = ListNode()
        var greaterTail = greaterDummy

        var current = head

        while let node = current {
            // Save next before modifying node.next.
            let next = node.next

            // Disconnect the current node from its old location.
            node.next = nil

            if node.val < x {
                lessTail.next = node
                lessTail = node
            } else {
                greaterTail.next = node
                greaterTail = node
            }

            current = next
        }

        // Join the two stable partitions.
        lessTail.next = greaterDummy.next

        return lessDummy.next
    }
}

// ============================================================
// YOUR ORIGINAL CODE AND THINKING COMMENTS
// ============================================================

/*
class Solution {
    func partition(_ head: ListNode?, _ x: Int) -> ListNode? {
        let dummyHead = ListNode(0, head)
        var pre: ListNode? = dummyHead
        var lastPre: ListNode? = nil  
        var cur = head 

        while let node = cur {
            if lastPre != nil && node.val < x {
                let lastPreNext = lastPre?.next
                let curNext = cur?.next
                lastPreNext?.next = cur
                cur?.next = lastPreNext
                pre?.next = curNext
                cur = curNext
                lastPre = lastPre?.next
            } else {
                if lastPre == nil {
                    lastPre = pre
                }
                
                pre = cur
                cur = cur?.next
            } 
        }

        return dummyHead.next
    }
}

// Thinking
// traverse the head
// if node < x, do nothing,
// if it is, write down the pre pointer
// then find the x node, write down the pointer
// also need to preserve the relation order
// can I create new linkedList?
// the issue seems doesn't mean I can't create new lindlist
// 7 mins so far
// will use create new linkedList logic to start
// Pattern: LinkedList
// Card shape: NA
// State needed: do too traverse, first round, create linkedlist only node < x, second round, just append node greater or 
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank


// actually I realize I no need to sort node greater than or equal to x
// will spend 5 more mins to adjust my thoughts
// find fist node >= x
// wirte down cur pre pointer
// then moving, find node < x
// let temp1 = pre.next
// let temp2 = cur.next
// pre.next = cur, cur.next = temp1
// temp1 = temp2, 
// pre = cur
// cur = temp2
// 12 mins ready to write
// finish in 22 mins
// do a quick check
// find issue and fix, start to run 
// again find compile error, some typo
// did a bunch fix, got a time limit exceeded, will let gpt to fix
*/

// ============================================================
// GPT'S SUMMARY
// ============================================================

/*
YOUR HIGH-LEVEL LOGIC WAS VALID:

1. Find the beginning of the >= x section.
2. Continue traversing the list.
3. When a later node < x is found, remove it.
4. Insert it before the >= x section.
5. Preserve the original order of both groups.


MISTAKE 1: A CYCLE WAS CREATED

Original:

    lastPreNext?.next = cur
    cur?.next = lastPreNext

This creates:

    lastPreNext -> cur
          ^         |
          |_________|

That cycle prevents traversal from reaching nil, causing Time Limit
Exceeded.

Your correction:

    lastPre?.next = cur
    cur?.next = lastPreNext

Correct structure:

    lastPre -> cur -> lastPreNext


MISTAKE 2: lastPre WAS INITIALIZED TOO EARLY

Original:

    if lastPre == nil {
        lastPre = pre
    }

This could run before finding any node >= x.

Your correction:

    if node.val >= x && lastPre == nil {
        lastPre = pre
    }

Now lastPre correctly represents the final node in the < x section.


EXAMPLE

Input:

    1 -> 4 -> 3 -> 2 -> 5 -> 2
    x = 3

After reaching 4:

    1 -> 4 -> 3 -> 2 -> 5 -> 2
    ^
 lastPre

Move the first 2:

    1 -> 2 -> 4 -> 3 -> 5 -> 2
         ^
      lastPre

Move the second 2:

    1 -> 2 -> 2 -> 4 -> 3 -> 5

Both groups preserve their original order:

    < x:  [1, 2, 2]
    >= x: [4, 3, 5]


YOUR FIX VERSION'S LOOP CONTRACT:

At the beginning of each iteration:

- lastPre is the final node in the processed < x section.
- pre is the node immediately before cur.
- cur is the next node being examined.
- The relative order of processed nodes is preserved.


WHY GPT'S UPGRADE IS EASIER:

Instead of moving nodes into the middle of one list, maintain:

    less chain:    all nodes < x
    greater chain: all nodes >= x

Example:

    less:    1 -> 2 -> 2
    greater: 4 -> 3 -> 5

Then connect:

    lessTail.next = greaterDummy.next

This uses the original nodes. Only two dummy nodes are added.


COMPLEXITY

Your own fix:

    Time:  O(n)
    Space: O(1)

GPT's fix:

    Time:  O(n)
    Space: O(1)

GPT's upgrade:

    Time:  O(n)
    Space: O(1)
*/