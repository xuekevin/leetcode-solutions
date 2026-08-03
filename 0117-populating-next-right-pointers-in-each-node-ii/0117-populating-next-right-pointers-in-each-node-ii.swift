/**
 * Definition for a Node.
 * public class Node {
 *     public var val: Int
 *     public var left: Node?
 *     public var right: Node?
 *	   public var next: Node?
 *     public init(_ val: Int) {
 *         self.val = val
 *         self.left = nil
 *         self.right = nil
 *         self.next = nil
 *     }
 * }
 */

class Solution {

    func connect(_ root: Node?) -> Node? {
        guard let root = root else {
            return root
        }

        var queue = [Node]()
        
        if queue.count == 0 {
            queue.append(root)
        }

        var count = queue.count

        while count > 0 && queue.count > 0 {
            let node = queue.removeFirst()
            count -= 1
            if count > 0 {
                // not remove
                node.next = queue[0]
            } else {
                node.next = nil
            }

            if let left = node.left {
                queue.append(left)
            }
            if let right = node.right {
                queue.append(right)
            }

            if count == 0 {
                count = queue.count
            }
        }
        return root
    }
}

// Pattern: level traverse
// Card shape: might use stack or queue to get the same level items
// should use queue, since we need FIFO
// State needed: 
// Contract: this function returns ___: not sure
// Recall: blank
// but think I can try to write the code based on current info I mentioned above
// finish writing in 22 mins
// now examine the logic and basic synatx error
// fix some logic error in 4 mins
// now try to run the code
// run pass, 27 mins, now submit


