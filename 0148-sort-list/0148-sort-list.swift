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
    func sortList(_ head: ListNode?) -> ListNode? {
        guard let node = head else {
            return nil
        }

        var count = 1

        var p = head
        var q = head
        while let pNode = p.next {
            count += 1
            p = pNode.next
        }

        helper(node, count)
    }

    func helper(_ start: ListNode?, _ total: Int) {
        // todo
    }
}

// Thinking
// sort linkedlist
// follow up solution is about O(nlogn), also ask for O(1) space
// looks like a binary sort
// think to find the mid first
// think to find the end first
// divide an conquer
// think to sort the left and right first
// then sort the total?
// question, if I have my left part and middle and right part sorted
// then middle > all left part
// then middle < all right part
// then I sort the left an right separately
// how to make the middle > all left part
// first find the middle
// by using the slow and faster pointer
// can find the middle, with the count
// which TC is O(n)
// then from head, if head val < mid, do nothing,
// if mid > cur.val, exchange
// for the right, same if mid > cur, do exchange
// the TC is still O(n)
// then for left and right separately do the same thing
// find the middle first
// then sort the middle first
// so I need a helper method
// can do the find and sort
// already 20 mins, will let gpt to fix
*/


// FIX VERSION: top-down merge sort.
// This matches your divide-and-conquer idea.

class fixSolution {
    func sortList(_ head: ListNode?) -> ListNode? {
        // A list with zero or one node is already sorted.
        guard let head = head, head.next != nil else {
            return head
        }

        // Find the final node in the left half.
        var slow = head
        var fast = head.next

        while fast != nil && fast?.next != nil {
            slow = slow.next!
            fast = fast?.next?.next
        }

        // Split the list into two separate lists.
        let rightHead = slow.next
        slow.next = nil

        // Recursively sort each half.
        let leftSorted = sortList(head)
        let rightSorted = sortList(rightHead)

        // Merge the two sorted halves.
        return merge(leftSorted, rightSorted)
    }

    private func merge(
        _ list1: ListNode?,
        _ list2: ListNode?
    ) -> ListNode? {
        let dummy = ListNode()
        var tail = dummy

        var left = list1
        var right = list2

        while let leftNode = left, let rightNode = right {
            if leftNode.val <= rightNode.val {
                tail.next = leftNode
                left = leftNode.next
            } else {
                tail.next = rightNode
                right = rightNode.next
            }

            tail = tail.next!
        }

        // One list may still have nodes remaining.
        tail.next = left ?? right

        return dummy.next
    }
}


// UPGRADE VERSION:
// Bottom-up merge sort: O(n log n) time and O(1) auxiliary space.

class Solution {
    func sortList(_ head: ListNode?) -> ListNode? {
        guard let head = head, head.next != nil else {
            return head
        }

        let length = getLength(head)
        let dummy = ListNode(0, head)

        // `size` is the length of the sorted runs we are merging.
        //
        // First pass: merge runs of size 1.
        // Next pass: merge runs of size 2.
        // Then size 4, 8, and so on.
        var size = 1

        while size < length {
            var previous: ListNode? = dummy
            var current = dummy.next

            while current != nil {
                let leftRun = current
                let rightRun = split(leftRun, size)
                current = split(rightRun, size)

                let merged = mergeRuns(leftRun, rightRun)

                previous?.next = merged.head
                previous = merged.tail
            }

            size *= 2
        }

        return dummy.next
    }

    private func getLength(_ head: ListNode) -> Int {
        var count = 0
        var current: ListNode? = head

        while current != nil {
            count += 1
            current = current?.next
        }

        return count
    }

    // Cut off a run containing at most `size` nodes.
    // Return the head of the remaining list.
    private func split(
        _ head: ListNode?,
        _ size: Int
    ) -> ListNode? {
        var current = head

        for _ in 1..<size {
            guard current?.next != nil else {
                return nil
            }

            current = current?.next
        }

        let remaining = current?.next
        current?.next = nil
        return remaining
    }

    // Return both the merged head and merged tail so we can attach
    // the next pair of runs in O(1).
    private func mergeRuns(
        _ list1: ListNode?,
        _ list2: ListNode?
    ) -> (head: ListNode?, tail: ListNode?) {
        let dummy = ListNode()
        var tail = dummy

        var left = list1
        var right = list2

        while let leftNode = left, let rightNode = right {
            if leftNode.val <= rightNode.val {
                tail.next = leftNode
                left = leftNode.next
            } else {
                tail.next = rightNode
                right = rightNode.next
            }

            tail = tail.next!
        }

        while let leftNode = left {
            tail.next = leftNode
            tail = leftNode
            left = leftNode.next
        }

        while let rightNode = right {
            tail.next = rightNode
            tail = rightNode
            right = rightNode.next
        }

        return (dummy.next, tail)
    }
}


/*
GPT'S SUMMARY

What you did well:
- You correctly identified divide and conquer.
- Merge sort is the right sorting algorithm for linked lists.
- Finding the middle with slow and fast pointers is the standard
  top-down merge-sort split.
- Sorting left and right halves, then merging them, is exactly the
  recurrence we want.

The key correction:
- Do not sort around the middle value like quicksort.
- Linked lists are ideal for merge sort because merging two sorted
  linked lists only changes `next` pointers.

Top-down logic:

    sortList(head)
    1. Find the middle.
    2. Break the list into left and right halves.
    3. Sort each half recursively.
    4. Merge the sorted halves.

Example:

    4 -> 2 -> 1 -> 3

Split:

    4 -> 2
    1 -> 3

Split again:

    4     2     1     3

Merge pairs:

    2 -> 4
    1 -> 3

Merge final lists:

    1 -> 2 -> 3 -> 4


Mistakes in the original code:

1. The counting loop skips nodes.

   Wrong:

       p = pNode.next

   After finding the next node, this jumps one additional node forward.
   For counting, use:

       p = p?.next

2. `q` and `count` are not needed for top-down merge sort.

   Slow and fast pointers find the middle in a single traversal.

3. `sortList` must return the helper result.

   A function returning `ListNode?` must return a value on every path.

4. `helper` must also return `ListNode?`, because a sorted sub-list
   needs to be connected back into the final list.

Why the upgrade version meets O(1) space:
- Recursive merge sort uses O(log n) call-stack space.
- Bottom-up merge sort avoids recursion.
- It merges runs of length 1, then 2, then 4, and so on.
- It only uses a few node pointers.

Pattern:
- Linked list
- Merge sort
- Divide and conquer

Contract for `merge`:
- Both input lists are already sorted.
- It returns one sorted list containing every node from both inputs.

Complexity:

Fix version, top-down:
- Time: O(n log n)
- Auxiliary space: O(log n) from recursion

Upgrade version, bottom-up:
- Time: O(n log n)
- Auxiliary space: O(1)
*/