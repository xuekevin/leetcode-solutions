// Your original solution:
//
// /**
// - Definition for a binary tree node.
// - public class TreeNode {
// - public var val: Int
// - public var left: TreeNode?
// - public var right: TreeNode?
// - public init() { self.val = 0; self.left = nil; self.right = nil; }
// - public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
// - public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
// - self.val = val
// - self.left = left
// - self.right = right
// - }
// - }
// */
// class Solution {
//
//     func hasPathSum(_ root: TreeNode?, _ targetSum: Int) -> Bool {
//         guard let root = root else {
//             return false
//         }
//
//         if root.left == nil && root.right == nil {
//             return targetSum == root.val
//         }
//
//         return hasPathSum(root.left, targetSum - root.val) || hasPathSum(root.right, targetSum - root.val)
//     }
// }
//
// // Think
// // think to do traverse from top to bottom
// // and add up if we find the targetSum
// // start to write code around 1 mins
// // but seems not think careful,
// // rethinking
// // do traverse, pass down the path sum when do traverse, when go to leaf, then check if current
// // sum == targetSum
// // now think I can use decompose's logic to address this
// // which is recursive
// // not fully sure my logic is right
// // but should get the answer
// // the TC is O(n)
// // the SC is O(logn)
// // 10 mins ready to run, pass

class Solution {
    func hasPathSum(_ root: TreeNode?, _ targetSum: Int) -> Bool {
        guard let root = root else {
            // Good: an empty tree has no root-to-leaf path.
            return false
        }

        if root.left == nil && root.right == nil {
            // Good: only check the sum when this is a leaf.
            // The remaining target must exactly equal this leaf's value.
            return targetSum == root.val
        }

        // Good: pass the remaining sum into each subtree.
        // `||` returns true as soon as either subtree finds a valid path.
        return hasPathSum(root.left, targetSum - root.val)
            || hasPathSum(root.right, targetSum - root.val)
    }
}

// GPT's summary:
// What you did well:
// - Your recursive logic is correct and passed.
// - You recognized that this is a top-down traversal: each call carries
//   the remaining target sum for the current path.
// - You correctly wait until reaching a leaf before deciding whether a path works.
//
// Key idea:
// - Subtract each visited node's value from `targetSum`.
// - At a leaf, return whether the remaining target equals that leaf's value.
//
// Swift syntax to remember:
// - `guard let root = root else { return false }` unwraps an optional safely.
// - `root.left == nil && root.right == nil` checks whether a node is a leaf.
// - `||` means “or” and short-circuits when the left expression is true.
//
// Complexity:
// - Time: O(n), where n is the number of nodes.
// - Space: O(h) for the recursion stack, where h is tree height.
//   It is O(log n) for a balanced tree and O(n) for a completely skewed tree.