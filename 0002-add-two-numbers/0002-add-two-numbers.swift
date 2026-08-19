// ============================================================
// FIX VERSION: Follows your original structure
// ============================================================

class fixSolution {
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var current: ListNode? = ListNode()
        let dummy = current

        var p = l1
        var q = l2
        var carry = 0

        // Include carry because the last addition may create another digit.
        while p != nil || q != nil || carry != 0 {
            // p and q may have different lengths. A missing node means 0.
            let pValue = p?.val ?? 0
            let qValue = q?.val ?? 0
            var value = pValue + qValue + carry

            if value >= 10 {
                value -= 10
                carry = 1
            } else {
                carry = 0
            }

            let newNode = ListNode(value)
            current?.next = newNode
            current = current?.next

            p = p?.next
            q = q?.next
        }

        return dummy?.next
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Recommended LeetCode submission
// ============================================================

class Solution {
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        // Dummy node gives us a stable node before the real result.
        let dummy = ListNode()
        var current = dummy

        // Pointers used to traverse the two input lists.
        var p = l1
        var q = l2

        // Carry from the previous digit addition.
        var carry = 0

        // Continue while either list has a node or a carry remains.
        while p != nil || q != nil || carry != 0 {
            // `?? 0` unwraps the optional value.
            // If one list has ended, its current value is treated as zero.
            let firstValue = p?.val ?? 0
            let secondValue = q?.val ?? 0

            // Add both digits and the carry from the previous position.
            let sum = firstValue + secondValue + carry

            // The current result digit is the remainder after division by 10.
            let digit = sum % 10

            // The carry is 1 when sum >= 10; otherwise it is 0.
            carry = sum / 10

            // Add the calculated digit to the result list.
            current.next = ListNode(digit)

            // Move current to the node that was just created.
            current = current.next!

            // Move both input pointers forward.
            p = p?.next
            q = q?.next
        }

        // Skip the dummy node and return the real result.
        return dummy.next
    }
}

// ============================================================
// ORIGINAL SOLUTION
// ============================================================

/*
class Solution {
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var curNode: ListNode? = ListNode()
        var p = l1
        var q = l2
        var dummy = curNode
        var add = 0
        while p != nil || q != nil {
            let sum = p?.val + q?.val
            let cur = sum + add
            if cur < 10 {
                add = 0
            } else {
                cur -= 10
                add = 1 
            }

            let newNode = ListNode()
            newNode.val = cur
            curNode?.next = newNode
            curNode = curNode?.next
            p = p?.next
            q = q?.next
        }

        return dummy?.next
    }
}

// Thinking
// left is lower
// so we have an "carry" after each node caculation
// think I can start 2 mins
// finish in 14 mins
// quick checking， lgtm
// ready to run
// `- error: binary operator '+' cannot be applied to two 'Int?' operands
// swift need unwrap first
// will let gpt to fix 

// Pattern: LinkedList,
// Card shape: foor loop two linkedin list, the add the val
// State needed: curNode, add
// Contract: every loop, we get a new val for the result list cur node,
//           also update the add variable
// Recall: landed
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
WHAT YOU GOT RIGHT:

- The digits are stored from lowest place value to highest.
- Traverse both lists from their heads.
- Maintain a carry between additions.
- Use a dummy node to simplify construction of the result list.

MISTAKES:

1. Optional integers cannot be added directly.

   Wrong:
       p?.val + q?.val

   Correct:
       (p?.val ?? 0) + (q?.val ?? 0)

2. `let cur` cannot be changed with `cur -= 10`.

   Use `var cur`, or calculate:
       digit = sum % 10

3. The original loop loses a final carry.

   Example:
       5 + 5 = 10

   After both lists end, we still need a node containing 1.

   Correct condition:
       while p != nil || q != nil || carry != 0

4. The lists may have different lengths. When one pointer is nil,
   its value should be treated as zero.

WHY THE UPGRADE IS CLEANER:

The two arithmetic expressions directly represent decimal addition:

    let digit = sum % 10
    carry = sum / 10

Example, sum = 17:

    digit = 17 % 10 = 7
    carry = 17 / 10 = 1

COMPLEXITY:

Time: O(max(m, n))
Space: O(max(m, n)) for the returned linked list

The algorithm visits every node at most once.
*/