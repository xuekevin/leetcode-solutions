/*
YOUR ORIGINAL SOLUTION:

/**
 * Definition for a Node.
 * public class Node {
 *     public var val: Int
 *     public var next: Node?
 *     public var random: Node?
 *     public init(_ val: Int) {
 *         self.val = val
 *         self.next = nil
 *         self.random = nil
 *     }
 * }
 */

class Solution {
    func copyRandomList(_ head: Node?) -> Node? {
        if head == nil {
            return nil
        }
        var nodeArr = [Node]()
        var nodeMapping = [Node: Node]()
        var randomIndexArr = [Int]()
        var p = head
        while let node = p {
            let val = node.val
            let newNode = Node(val)
            nodeMapping[node] = newNode
            nodeArr.append(newNode)
            p = node.next
        }

        for i in 0..<nodeArr.count {
            let curNode = nodeArr[i]
            if i == nodeArr.count - 1 {
                curNode.next = nil
            } else {
                curNode.next = nodeArr[i+1]
            }
        }

        p = head
        var index = 0

        while let node = p {
            let newNode = nodeArr[index]
            if let random = node.random {
                let newRandom = nodeMapping[random]
                newNode.random = newRandom
            } else {
                newNode.random = nil
            }
            p = node.next
            index += 1
        }

        return nodeArr.first
    }
}

// Thinking
// Spend 2 mins to read the issue
// basically the logic is to do a copy of existing head
// challenge part is the random pointer
// how to find the random pointers
// use example to figure out
// node 1
// create one copy node, as the head node also
// for next node, do the copy create, for random, it pointer to node 1, it has an index
// so we can base index to find the node we want to pointer, but then ew need to do pointer move for each find
// can we avoid this?
// might can have a helper method, input is the index
// the return is the node
// alerady 12 mins, ready to writ code
// figure out when I am writing
// spend 29 mins
// quick check
// lgtm, 33 mins, ready to run, fix a typo, then pass test case
// ready to submit, pass

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/


// FIX/REVIEW VERSION:
// Your submitted solution is correct.
// This version removes the unused `randomIndexArr`.

class fixSolution {
    func copyRandomList(_ head: Node?) -> Node? {
        guard let head = head else {
            return nil
        }

        var copiedNodes = [Node]()
        var originalToCopy = [Node: Node]()

        // First pass:
        // Create one copied node for every original node.
        var current: Node? = head

        while let original = current {
            let copy = Node(original.val)

            copiedNodes.append(copy)
            originalToCopy[original] = copy

            current = original.next
        }

        // Second step:
        // Connect the copied nodes through their next pointers.
        for index in 0..<copiedNodes.count {
            if index + 1 < copiedNodes.count {
                copiedNodes[index].next = copiedNodes[index + 1]
            }
        }

        // Third step:
        // Connect each copied random pointer.
        current = head
        var index = 0

        while let original = current {
            let copy = copiedNodes[index]

            if let originalRandom = original.random {
                copy.random = originalToCopy[originalRandom]
            }

            current = original.next
            index += 1
        }

        return copiedNodes.first
    }
}


// GPT'S UPGRADE VERSION:
// Interleave each copied node with its original node.
// This reduces extra space from O(n) to O(1).

class Solution {
    func copyRandomList(_ head: Node?) -> Node? {
        guard let head = head else {
            return nil
        }

        // Pass 1:
        // Insert each copied node immediately after its original node.
        //
        // Before:
        // A -> B -> C
        //
        // After:
        // A -> A' -> B -> B' -> C -> C'
        var current: Node? = head

        while let original = current {
            let copy = Node(original.val)
            let originalNext = original.next

            original.next = copy
            copy.next = originalNext

            current = originalNext
        }

        // Pass 2:
        // Set each copied node's random pointer.
        current = head

        while let original = current {
            let copy = original.next

            // The copy of original.random is immediately after
            // original.random.
            copy?.random = original.random?.next

            current = copy?.next
        }

        // Pass 3:
        // Separate the original and copied linked lists.
        let copiedHead = head.next
        current = head

        while let original = current {
            let copy = original.next
            let nextOriginal = copy?.next

            // Restore the original list.
            original.next = nextOriginal

            // Connect the copied list.
            copy?.next = nextOriginal?.next

            current = nextOriginal
        }

        return copiedHead
    }
}


/*
GPT'S EXAMPLE

Original list:

    A -> B -> C

Random pointers:

    A.random -> C
    B.random -> A
    C.random -> B


PASS 1: INSERT COPIES

Insert every copy directly after its original:

    A -> A' -> B -> B' -> C -> C'

This position gives us an important rule:

    copy of A = A.next
    copy of B = B.next
    copy of C = C.next


PASS 2: CONNECT RANDOM POINTERS

Suppose:

    A.random = C

We need:

    A'.random = C'

Because C' is immediately after C:

    C' = C.next
       = A.random.next

Therefore:

    A'.random = A.random?.next

In code:

    copy?.random = original.random?.next

The same rule works for every node.


PASS 3: SEPARATE THE TWO LISTS

Combined list:

    A -> A' -> B -> B' -> C -> C'

Restore original links:

    A -> B -> C

Build copied links:

    A' -> B' -> C'


GPT'S SUMMARY

What you did well:
- Your submitted solution is correct.
- You correctly recognized that random pointers are the difficult part.
- Your original-to-copy dictionary is the key insight.
- The mapping allows a copied random pointer to be found in O(1):

      copy.random = originalToCopy[original.random]

- You created every copied node before assigning random pointers.
  This guarantees that every random target already exists in the map.

Small improvements to your version:

1. `randomIndexArr` was never used.

   It can be removed:

       var randomIndexArr = [Int]()

2. The array is not required when using the dictionary.

   The dictionary can also connect the next pointer:

       copy.next = originalToCopy[original.next]
       copy.random = originalToCopy[original.random]

3. Explicitly setting a new node's pointers to nil is unnecessary.

   New nodes already begin with:

       next = nil
       random = nil

Why the upgrade version uses O(1) extra space:
- It does not use an array or dictionary.
- Each copy is temporarily stored directly after its original node.
- That physical position acts like the original-to-copy mapping.

Pattern:
- Linked list / node mapping / interleaving nodes.

Fix-version state:
- `copiedNodes`: copied nodes in list order.
- `originalToCopy`: maps each original node to its copy.
- `current`: traverses the original list.

Upgrade-version state:
- `current`: traverses the combined list.
- `copy`: the node immediately after the current original.
- `nextOriginal`: the next original node.

Contract:
- After pass 1, every original node is followed by its copy.
- After pass 2, every copied random pointer is correct.
- After pass 3, the original list is restored and the copied list is
  completely independent.

Complexity:

Fix version:
- Time: O(n).
- Space: O(n) for the array and dictionary.

Upgrade version:
- Time: O(n).
- Auxiliary space: O(1).
- The returned copied nodes do not count as auxiliary space.
*/