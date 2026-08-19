/*
GPT'S LINE-BY-LINE EXPLANATION OF THE UPGRADE SOLUTION

Example:

    head  = 1 -> 2 -> 3 -> 4 -> 5
    left  = 2
    right = 4

Expected result:

    1 -> 4 -> 3 -> 2 -> 5
*/

class Solution {
    func reverseBetween(
        _ head: ListNode?,
        _ left: Int,
        _ right: Int
    ) -> ListNode? {
        /*
        Create a dummy node before the head:

            dummy -> 1 -> 2 -> 3 -> 4 -> 5

        This lets us use the same logic when left == 1.
        */
        let dummy = ListNode(0, head)

        /*
        beforeLeft starts at dummy.

            beforeLeft
                |
            dummy -> 1 -> 2 -> 3 -> 4 -> 5
        */
        var beforeLeft = dummy

        /*
        Move beforeLeft `left - 1` times.

        left = 2, so this loop runs once:

            for _ in 1..<2

        After moving:

                    beforeLeft
                        |
            dummy -> 1 -> 2 -> 3 -> 4 -> 5

        beforeLeft is now the node immediately before the section.
        */
        for _ in 1..<left {
            beforeLeft = beforeLeft.next!
        }

        /*
        current points to the first node of the section:

                          current
                             |
            dummy -> 1 -> 2 -> 3 -> 4 -> 5

        Node 2 will remain the tail of the reversed section.
        */
        var current = beforeLeft.next

        /*
        The section contains positions 2 through 4:

            2 -> 3 -> 4

        Node 2 stays in place as `current`.
        We move nodes 3 and 4 in front of it.

        Number of moves:

            right - left = 4 - 2 = 2
        */
        for _ in 0..<(right - left) {
            /*
            FIRST ITERATION

            Before:

                beforeLeft   current   movedNode
                     |          |          |
            dummy -> 1 ->       2 ->       3 -> 4 -> 5

            movedNode is the node immediately after current.
            */
            guard let movedNode = current?.next else {
                break
            }

            /*
            Remove movedNode from after current.

            First iteration:

                current?.next = movedNode.next

                2.next = 4

            Temporary structure:

                1 -> 2 -> 4 -> 5

            Node 3 is currently detached, but stored in movedNode.
            */
            current?.next = movedNode.next

            /*
            Point movedNode to the current beginning of the section.

            First iteration:

                movedNode.next = beforeLeft.next
                3.next = 2

            Detached section now looks like:

                3 -> 2 -> 4 -> 5
            */
            movedNode.next = beforeLeft.next

            /*
            Connect beforeLeft to movedNode.

            First iteration:

                1.next = 3

            List becomes:

                1 -> 3 -> 2 -> 4 -> 5

            Notice that current still points to node 2.
            */
            beforeLeft.next = movedNode

            /*
            SECOND ITERATION

            Current state:

                beforeLeft        current   movedNode
                     |               |          |
            dummy -> 1 -> 3 ->       2 ->       4 -> 5

            movedNode = 4

            1. Remove 4 from after 2:

                   2.next = 5

            2. Put 4 before the current section:

                   4.next = 3

            3. Connect node 1 to node 4:

                   1.next = 4

            Final list:

                dummy -> 1 -> 4 -> 3 -> 2 -> 5
            */
        }

        /*
        Skip the dummy node and return the real head:

            1 -> 4 -> 3 -> 2 -> 5
        */
        return dummy.next
    }
}

/*
THE KEY IDEA

`current` does not move.

For the example, current always points to node 2:

Initial:

    1 -> [2 -> 3 -> 4] -> 5
          ^
        current

Move 3 in front:

    1 -> [3 -> 2 -> 4] -> 5
               ^
             current

Move 4 in front:

    1 -> [4 -> 3 -> 2] -> 5
                    ^
                  current


POINTER INVARIANT

At the start of every loop iteration:

- beforeLeft.next is the head of the partially reversed section.
- current is the tail of the partially reversed section.
- current.next is the next node that must be moved to the front.


WHY `right - left` ITERATIONS?

The first node does not need to move.

For positions 2 through 4, there are three nodes:

    2, 3, 4

Keep 2 as current and move the other two nodes:

    number of moves = 3 - 1 = 2
                    = right - left


COMPLEXITY

Time: O(n)
Space: O(1)
*/