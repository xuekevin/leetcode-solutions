// Your original solution:
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
//  */
// class Solution {
//     var curDepth = 0
//     func maxDepth(_ root: TreeNode?) -> Int {
//         if root == null {
//             return 0
//         }
//
//         let leftDepth = maxDepth(root.left)
//         let rightDepth = maxDepth(root.right)
//
//         return 1 + max(leftDepth, rightDepth)
//     }
// }
//
// // #Thoughts
// // Think from traverse way
// // preorder, enter node, increase depth, leave node decrease depth
// // 5 mins lost about how to do from travse way, think from how to do in recursive way
// // spend 9 mins
// // not in best status
// // synatx error if root == null
// // forget the synatx, ask gpt

class Solution {
    func maxDepth(_ root: TreeNode?) -> Int {
        // Wrong: if root == null
        // Why: Swift uses `nil`, not `null`.
        // Correct: use optional binding to unwrap `root`.
        guard let root = root else {
            return 0
        }

        // Wrong: maxDepth(root.left) before unwrapping root.
        // Why: `root` is a TreeNode? optional, so Swift cannot safely access `.left`.
        // Correct: after `guard let root = root`, root is a non-optional TreeNode.
        let leftDepth = maxDepth(root.left)
        let rightDepth = maxDepth(root.right)

        // Good: recursive formula is correct.
        // Why it works: max depth = current node 1 + larger depth of left/right subtree.
        return 1 + max(leftDepth, rightDepth)
    }
}

// GPT's summary:
// Mistakes you made:
// - You used `null`, but Swift uses `nil`.
// - `root` is `TreeNode?`, so you need to unwrap it before using `root.left` or `root.right`.
// - `curDepth` is not needed for this recursive return-value approach.
//
// Key idea:
// - Base case: if root is nil, depth is 0.
// - Recursive case: depth is 1 + max(left subtree depth, right subtree depth).
// - You can solve this either with traversal state (`curDepth`) or with recursive return values.
// - The recursive return-value version is cleaner for this problem.
//
// Swift syntax to remember:
// - `TreeNode?` means optional TreeNode.
// - `nil` means no value in Swift.
// - `guard let root = root else { return 0 }` unwraps the optional or exits.
// - After `guard let`, `root.left` and `root.right` are safe to access.
// - `max(a, b)` returns the larger value.
//
// Complexity:
// - Time: O(n), because every tree node is visited once.
// - Space: O(h), where h is tree height, because recursion uses the call stack.