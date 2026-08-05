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
    var result = -1
    var start = 0
    func kthSmallest(_ root: TreeNode?, _ k: Int) -> Int {
        helper(root,k)
        return result
    }

    func helper(_ node: TreeNode?, _ k: Int) {
        guard let node = node else {
            return
        }
        helper(node.left, k)
        start += 1
        if start == k {
            result = node.val
            return
        }
        helper(node.right, k)
    }
}
// inorder traverse and the check the current index to compare with k
// 6 mins
// got wrong answer, stlll not carful, the result is the node.val, not the index, I made silly mistake again, and didn't check the code careful, should avoid this in the future

