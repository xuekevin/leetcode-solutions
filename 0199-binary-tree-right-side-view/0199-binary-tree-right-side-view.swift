/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     public var val: Int
 *     public var left: TreeNode?
 *     public var right: TreeNode?
 *     public init() { self.val = 0; self.left = nil; self.right = nil; }
 *     public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
 *     public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
 *         self.val = val
 *         self.left = left
 *         self.right = right
 *     }
 * }
 */
class Solution {
    func rightSideView(_ root: TreeNode?) -> [Int] {
        guard let root = root else {
            return []
        }

        var queue = [TreeNode]()
        var rightArr = [Int]()
        queue.append(root)
        var first = 0
        var levelCount = 1
        while levelCount != 0 {
            let node = queue[first]
            first += 1
            levelCount -= 1
            if let left = node.left {
                queue.append(left)
            }

            if let right = node.right {
                queue.append(right)
            }

            // end of the level
            if levelCount == 0 {
                rightArr.append(node.val)
                levelCount = queue.count - first
            }
        }

        return rightArr
    }
}

// think
// seems like level traverse
// do the level and keep tracking of the last element of each level
// to do level traverse, need to use queue
// popfirst then put its sub trees into the queue
// 3 mins so far, ready to write the code
// seems I don't need to do recursive, so no need to have a helper method. delete the helper method I created so far
// 16 finish coding, now use example to verify
// spend sometime to figure out what's the exit of while loop
// 20 mins use example to verify, then notice my logic is not correct, so update
// 24 mins so far, ready to run, pass, ready to submit 