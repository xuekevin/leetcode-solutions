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
//     func invertTree(_ root: TreeNode?) -> TreeNode? {
//         guard let root = root else {
//             return nil
//         }
//
//         let left = invertTree(root.left)
//         let right = invertTree(root.right)
//         root.left = right
//         root.right = left
//         return root
//     }
// }
//
// // # Thoughts
// // exchange it's "left and right"
// // decompose, if it is only one root, basically just exchange, it's left right
// // the think to use recursive
// // TC O(n)
// // SC O(h), height is the level of the tree, because we have stack to do the recursive
// // spend 5 mins, ready to run and sumbit
// // pass, now use gpt to summary

class Solution {
    func invertTree(_ root: TreeNode?) -> TreeNode? {
        // Good: base case for empty tree.
        // Why it works: if root is nil, there is nothing to invert.
        guard let root = root else {
            return nil
        }

        // Good: recursively invert both subtrees first.
        // Why it works: after these calls, `left` is the inverted old-left subtree,
        // and `right` is the inverted old-right subtree.
        let left = invertTree(root.left)
        let right = invertTree(root.right)

        // Good: swap the left and right children.
        // Why it works: inverting a tree means every node's left/right children are exchanged.
        root.left = right
        root.right = left

        return root
    }
}

// GPT's summary:
// What you did well:
// - Your solution passed and is clean.
// - Your decomposition was correct: invert left, invert right, then swap.
// - You correctly used `guard let` to handle the nil root case.
// - Your time and space complexity analysis was right.
//
// Key idea:
// - Invert Tree is a recursive decomposition problem.
// - For each node, invert its left subtree and right subtree.
// - Then swap those two returned subtrees.
// - Return the current root.
//
// Swift syntax to remember:
// - `TreeNode?` means the node can be nil.
// - `guard let root = root else { return nil }` unwraps the optional root.
// - `let left = invertTree(root.left)` stores the inverted left subtree.
// - Assigning `root.left = right` and `root.right = left` mutates the tree node.
// - Returning `TreeNode?` allows returning either a real node or nil.
//
// Complexity:
// - Time: O(n), because every node is visited once.
// - Space: O(h), where h is the tree height, because recursion uses the call stack.