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
    var result = 0
    func sumNumbers(_ root: TreeNode?) -> Int {
        helper(root, 0)
        return result
    }

    func helper(_ node: TreeNode?, _ num: Int) {
        guard let node = node else {
            return
        }

        var updatedNum = num * 10 + node.val

        if node.left == nil && node.right == nil {
            result += updatedNum
        } else {
            helper(node.left, updatedNum)
            helper(node.right, updatedNum)
        } 
    }
}

// Think
// Use a global num to track the result
// when reach to leaf then cacluate the path number and the sum
// the path number can be cacluated by level and val of the node
// 15 mins finish writing, now use example to verify
// origin I write helper(_ node: TreeNode?, _ num: Int, _ level: Int) {
// turns out no need to use level, so remove it
// 19 mins, run success, now submit
// got wrong answer, for corner case if only one node,
// should first call helper(root, 0)
// previous I first call helper(root.left, root.val) and helper(root.left, root.val)
// now resubmit

