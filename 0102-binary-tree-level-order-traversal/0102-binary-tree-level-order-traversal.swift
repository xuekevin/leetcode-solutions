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
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else {
            return []
        }

        var resultArr = [[Int]]()
        var front = 0
        var levelCount = 1
        var levelArr = [Int]()
        var queue = [TreeNode]()
        queue.append(root)

        while levelCount != 0 {
            let node = queue[front]
            levelArr.append(node.val)
            front += 1
            levelCount -= 1

            if let left = node.left {
                queue.append(left)
            }
            
            if let right = node.right {
                queue.append(right)
            }

            if levelCount == 0 {
                resultArr.append(levelArr)
                levelArr = []
                levelCount = queue.count - front
            }
        }

        return resultArr
    }
}

// finish writing in 5 mins

