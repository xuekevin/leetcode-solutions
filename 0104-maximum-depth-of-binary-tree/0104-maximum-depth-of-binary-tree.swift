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
    var maxDepth = 0
    func maxDepth(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }
        traverse(root, 0)
        return maxDepth
    }

    func traverse(_ node: TreeNode?, _ depth: Int) -> Void {
        guard let node = node else {
            return
        }
        let curDepth = depth + 1

        // forget how to write in swift synatx, or not sure

        if node.left == nil && node.right == nil {
            maxDepth = max(maxDepth, curDepth)
        }

        traverse(node.left, curDepth)
        traverse(node.right, curDepth)
    }
}

// #Thoughts
// now try with traverse mindset again
// 