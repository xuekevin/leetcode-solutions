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

    func hasPathSum(_ root: TreeNode?, _ targetSum: Int) -> Bool {
        guard let root = root else {
            return false
        }

        if root.left == nil && root.right == nil {
            return targetSum == root.val
        }
        
        return hasPathSum(root.left, targetSum - root.val) || hasPathSum(root.right, targetSum - root.val)
    }
}

// Think
// think to do traverse from top to bottom
// and add up if we find the targetSum
// start to write code around 1 mins
// but seems not think careful,
// rethinking
// do traverse, pass down the path sum when do traverse, when go to leaf, then check if current
// sum == targetSum
// now think I can use decompose's logic to address this
// which is recursive
// not fully sure my logic is right
// but should get the answer
// the TC is O(n)
// the SC is O(logn)
// 10 mins ready to run, pass

