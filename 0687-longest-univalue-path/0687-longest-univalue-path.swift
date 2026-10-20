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

    var maxPath = 0
    func longestUnivaluePath(_ root: TreeNode?) -> Int {
        helper(root)
        return maxPath
    }

    func helper(_ node: TreeNode?) -> Int {
        guard let node = node else {
            return 0
        }

        let leftPath = helper(node.left)
        let rightPath = helper(node.right)

        var leftCurPath = 0
        var rightCurPath = 0

        if node.left?.val == node.val {
            leftCurPath = leftPath + 1
        }

        if node.right?.val == node.val {
            rightCurPath = rightPath + 1
        }
        maxPath = max(maxPath, leftCurPath + rightCurPath)
        return max(leftCurPath, rightCurPath)        
    }
}

// TC O(n)
// SC O(h) height of the tree

