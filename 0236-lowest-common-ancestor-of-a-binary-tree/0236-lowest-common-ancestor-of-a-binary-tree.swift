// Your original solution:
// /**
// - Definition for a binary tree node.
// - public class TreeNode {
// - public var val: Int
// - public var left: TreeNode?
// - public var right: TreeNode?
// - public init(_ val: Int) {
// - self.val = val
// - self.left = nil
// - self.right = nil
// - }
// - }
//  */
//
// class Solution {
//     func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
//         
//     }
// }
//
// // Think 
// // understand what's LCA
// // kind like backtrace
// // when do traverse, will meet p and q
// // think to do post order, which start from leaf first
// // use example to think different scenarios
// // challenge is how to use code to represent LCA
// // 10 mins, also hungury, ask gpt to help
// // current take away is do traverse, after meet p and q, record the sequence, then base on seququece to decide the LCA, but seem no rule yet

class Solution {
    func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        // Good: your "postorder/backtrace" instinct is correct.
        // Why it works: each recursive call returns whether this subtree contains p or q.
        guard let root = root else {
            return nil
        }

        // Correct: if current node is p or q, return it upward.
        // Why: this node may be the LCA, or it may be one side found under an ancestor.
        if root === p || root === q {
            return root
        }

        let left = lowestCommonAncestor(root.left, p, q)
        let right = lowestCommonAncestor(root.right, p, q)

        // Correct: if both sides found something, current root is the LCA.
        // Why: p and q are split between left and right subtrees.
        if left != nil && right != nil {
            return root
        }

        // Correct: return whichever side found p or q.
        // Why: this carries the found node upward to ancestors.
        return left != nil ? left : right
    }
}

// GPT's summary:
// What you did well:
// - Your idea of "backtrace" / postorder thinking was right.
// - You noticed traversal should discover p and q from below, then decide the ancestor.
// - You do not need to store full root-to-node sequences.
// - The recursive return value can represent the useful information.
//
// Key idea:
// - If root is nil, return nil.
// - If root is p or q, return root.
// - Search left subtree.
// - Search right subtree.
// - If both left and right return non-nil, current root is the LCA.
// - If only one side returns non-nil, pass that result upward.
//
// Why no sequence is needed:
// - A node receives answers from its children.
// - left != nil means "p or q exists somewhere in my left subtree".
// - right != nil means "p or q exists somewhere in my right subtree".
// - If both are true, this node is where the paths meet.
//
// Swift syntax to remember:
// - `TreeNode?` means optional TreeNode.
// - `guard let root = root else { return nil }` unwraps root or returns nil.
// - `root === p` checks whether two class references point to the exact same object.
// - Use `===` for TreeNode identity, not just value equality.
// - `left != nil ? left : right` is Swift's ternary expression.
//
// Complexity:
// - Time: O(n), because in the worst case every node is visited once.
// - Space: O(h), where h is tree height from the recursion call stack.