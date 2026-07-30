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
//     func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
//         if p == nil && q == nil {
//             return true
//         }
//         guard let p = p else {
//             return false
//         }
//
//         guard let q = q else {
//             return false
//         }
//
//         return p.val == q.val && isSameTree(p.left, q.left) && isSameTree(p.right, q.right)
//     }
// }
//
// // got crash for 2 mins writing
// // checking now
// // originally, just write return p?.val == q?.val && isSameTree(p?.left, q?.left) && isSameTree(p?.right, q?.right)
// // think can upwrap first to avoide nil access
// // update, try again

class Solution {
    func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
        // Good: if both nodes are nil, this part of the tree matches.
        if p == nil && q == nil {
            return true
        }

        // Good: if p is nil but q is not nil, trees are different.
        // Why it works: the previous if already handled "both nil".
        guard let p = p else {
            return false
        }

        // Good: if q is nil but p is not nil, trees are different.
        guard let q = q else {
            return false
        }

        // Good: after unwrapping, compare current values and both subtrees.
        // Why it works: same tree means same root value, same left subtree, and same right subtree.
        return p.val == q.val
            && isSameTree(p.left, q.left)
            && isSameTree(p.right, q.right)
    }
}

// GPT's summary:
// What you did well:
// - Your updated solution is correct.
// - You correctly separated the nil cases before accessing node values.
// - You correctly used recursion to compare root, left subtree, and right subtree.
// - `guard let` is a clean way to unwrap optional TreeNode values.
//
// About your first attempt:
// - `p?.val == q?.val` can compare optional Int values, but it is not enough by itself.
// - The bigger issue is the recursive calls like `p?.left` and `q?.left`.
// - Since `p` and `q` are optional, optional chaining makes the code harder to reason about.
// - Unwrapping first gives you normal `TreeNode` values, then `p.left` and `q.left` are clean `TreeNode?` values.
//
// Key idea:
// - If both nodes are nil, return true.
// - If only one node is nil, return false.
// - If both exist, compare values and recursively compare children.
//
// Swift syntax to remember:
// - `TreeNode?` means optional TreeNode.
// - `nil` means no value.
// - `guard let p = p else { return false }` unwraps or exits.
// - After `guard let`, `p.val`, `p.left`, and `p.right` are safe to use.
// - Multi-line Boolean returns can be split with `&&` for readability.
//
// Complexity:
// - Time: O(n), where n is the number of nodes visited.
// - Space: O(h), where h is the tree height from the recursion call stack.