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
func findTilt(_ root: TreeNode?) -> Int {
    var total = 0

    // Contract: returns the sum of all values in the subtree rooted at node; nil → 0
    func sum(_ node: TreeNode?) -> Int {
        guard let node = node else { return 0 }
        let l = sum(node.left)
        let r = sum(node.right)
        total += abs(l - r)
        return l + r + node.val
    }

    _ = sum(root)
    return total
}
}