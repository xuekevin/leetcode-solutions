// ============================================================
// FIX VERSION: Follows your pre, cur, next pointer approach
// This removes every value that appears more than once.
// ============================================================

class fixSolution {
    func deleteDuplicates(_ head: ListNode?) -> ListNode? {
        guard let head else {
            return nil
        }

        let dummy = ListNode(0, head)

        // pre is always the last confirmed unique node.
        var pre = dummy

        // cur is the beginning of the group currently being checked.
        var cur: ListNode? = head

        while cur != nil {
            // If cur and cur.next match, this entire value must be removed.
            if cur?.next != nil && cur?.val == cur?.next?.val {
                let duplicateValue = cur!.val

                // Move cur past every node containing duplicateValue.
                while cur != nil && cur!.val == duplicateValue {
                    cur = cur!.next
                }

                // Skip the entire duplicate group.
                pre.next = cur
            } else {
                // cur is unique, so it becomes the new confirmed node.
                pre = cur!
                cur = cur!.next
            }
        }

        return dummy.next
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Same algorithm with safer optional binding and clearer group logic.
// ============================================================

class Solution {
    func deleteDuplicates(_ head: ListNode?) -> ListNode? {
        let dummy = ListNode(0, head)
        var previous = dummy
        var current = head

        while let node = current {
            // A matching next value means this group is duplicated.
            if node.next?.val == node.val {
                let duplicateValue = node.val

                // Move current to the first node with a different value.
                while current?.val == duplicateValue {
                    current = current?.next
                }

                // Delete the entire duplicate group.
                previous.next = current
            } else {
                // This value appeared only once, so keep it.
                previous = node
                current = node.next
            }
        }

        return dummy.next
    }
}

// ============================================================
// ORIGINAL SOLUTION
// ============================================================

/*
class Solution {
    func deleteDuplicates(_ head: ListNode?) -> ListNode? {
        guard let node = head else {
            return nil
        }

        var cur: ListNode = node
        let dummyHead = ListNode()
        var pre = ListNode()
        dummyHead.next = cur
        pre.next = cur

        while cur.next != nil {
            var next = cur.next

            if cur.val != next!.val {
                cur = next!
                pre = cur
            } else {
                while next != nil && cur.val == next!.val {
                    cur = next!
                    next = next!.next
                }

                // start deletion
                pre.next = next

                if next != nil {
                    cur = next!
                } else {
                    break
                }
            }
        }

        return dummyHead.next
    }
}

// Thinking
// sorted linked list
// maintain a pre, cur, next pointer
// move cur, and compare cur with next
// if not duplicate
// move pointer
// if duplicate
// need to find all duplicate
// which means keep moving cur and next, if it still duplicate
// until not duplicate
// then use pre.next = next, then update cur
// 5mins so far

// Pattern: LinkedList pointer
// Card shape:
// State needed: pre, cur, next pointer
// Contract: while cur.next != nil
// Recall: landed
// 6 mins, ready to write code
// 14 mins finish writing, now check the code
// 2 mins exam do some small fix
// ready to run, oops got compile error about optional unwrap stuff
// fix it by using force unwrap
// didn't pass example one
// 23 mins so far, not sure what I did wrong
// will let gpt to fix
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
MAIN MISTAKE 1: `pre` WAS NOT CONNECTED TO THE RETURNED LIST

You created two different nodes:

    let dummyHead = ListNode()
    var pre = ListNode()

Then:

    dummyHead.next = cur
    pre.next = cur

The structure is:

    dummyHead -> cur
    pre -------> cur

Changing:

    pre.next = next

does not change dummyHead.next because `pre` and `dummyHead` are
different nodes.

Correct initialization:

    let dummy = ListNode(0, head)
    var pre = dummy


MAIN MISTAKE 2: `pre` MOVED TO THE WRONG NODE

You wrote:

    cur = next!
    pre = cur

After this, pre and cur point to the same node.

But the required invariant is:

    pre -> cur

`pre` must remain immediately before the group being checked.

For a unique current node, move in this order:

    pre = cur
    cur = cur.next


EXAMPLE:

    1 -> 2 -> 3 -> 3 -> 4 -> 4 -> 5

Start:

    dummy -> 1 -> 2 -> 3 -> 3 -> 4 -> 4 -> 5
      pre    cur

1 is unique:

    dummy -> 1 -> 2 -> 3 -> 3 -> 4 -> 4 -> 5
             pre  cur

2 is unique:

    dummy -> 1 -> 2 -> 3 -> 3 -> 4 -> 4 -> 5
                  pre  cur

3 is duplicated.

Move current past all 3s:

    current -> first 4

Then:

    previous.next = current

Result:

    dummy -> 1 -> 2 -> 4 -> 4 -> 5
                  pre  cur

4 is also duplicated.

Move current past all 4s and reconnect:

    dummy -> 1 -> 2 -> 5
                  pre  cur

5 is unique.

Final answer:

    1 -> 2 -> 5


WHY THE DUMMY NODE IS NECESSARY:

Input:

    1 -> 1 -> 1 -> 2 -> 3

The duplicate group begins at the head. There is no real node before it.

The dummy provides one:

    dummy -> 1 -> 1 -> 1 -> 2 -> 3

After skipping the 1s:

    dummy -> 2 -> 3

Return:

    dummy.next


CORRECT LOOP CONTRACT:

At the beginning of every iteration:

- previous is the last confirmed unique node.
- current is the first node of the group being examined.
- Everything before previous is already processed correctly.


OTHER IMPROVEMENTS:

1. `while cur.next != nil` does not naturally process the final node.

   Prefer:

       while cur != nil

2. Force unwrapping with `!` works under valid assumptions, but
   `while let node = current` is easier to reason about.

3. You do not need a separate `next` pointer outside the duplicate scan.


COMPLEXITY:

Time:
    O(n)

Every node is visited at most a constant number of times.

Space:
    O(1)

Only pointers and one dummy node are used.
*/