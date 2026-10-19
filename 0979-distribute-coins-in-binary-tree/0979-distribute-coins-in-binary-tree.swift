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

    var move = 0
    func distributeCoins(_ root: TreeNode?) -> Int {
        helper(root)
        return move
    }

    func helper(_ node: TreeNode?) -> Int {
        guard let node = node else {
            return 0
        }

        var totalNeed = node.val
        let leftMove = helper(node.left)
        let rightMove = helper(node.right)
        move += abs(leftMove) + abs(rightMove) 
        return totalNeed + leftMove + rightMove - 1
    }
}