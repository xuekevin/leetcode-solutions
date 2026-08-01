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
//     func flatten(_ root: TreeNode?) {
//         helper(root)
//     }
//
//     func helper(_ node: TreeNode?) -> TreeNode? {
//         guard let node = node else {
//             return nil
//         }
//         if node.left == nil && node.right == nil {
//             return node
//         }
//
//         let left = node.left
//         let right = node.right
//         var leftEnd = helper(left)
//         var rightEnd = helper(right)
//
//         if left != nil {
//             node.left = nil
//             node.right = left
//             leftEnd?.right = right
//         }
//
//         return rightEnd
//     }
// }
// // Think
// // it is like to do preorder traverse
// // first visit root node
// // but the challenge is after visiting also need to change the tree structure
// // decompose this issue, this is like
// // we always move the left node (if exist) as the new right node, and move the old right node as the right node of the new right node
// // 5 mins so far, start to write
// // thinking whether using traverse and recursive
// // need to return new right most node
// // finish code in 18 mins
// // now verfiy with example
// // 30 mins so far after fixing code
// // now try run again
// // fix synatx, run pass
// // but submit didn't pass the test case
// // over 30mins let gpt to fix

class Solution {
    func flatten(_ root: TreeNode?) {
        helper(root)
    }

    // Returns the rightmost node (tail) of this flattened subtree.
    @discardableResult
    func helper(_ node: TreeNode?) -> TreeNode? {
        guard let node = node else {
            return nil
        }

        if node.left == nil && node.right == nil {
            return node
        }

        let left = node.left
        let right = node.right
        let leftEnd = helper(left)
        let rightEnd = helper(right)

        if let left = left {
            // Good: make the flattened left subtree become node's right side.
            node.left = nil
            node.right = left

            // Good: attach the original right subtree after the left subtree.
            leftEnd?.right = right
        }

        // Wrong: `return rightEnd`
        // Why: if node has a left subtree but no right subtree,
        // `rightEnd` is nil even though the flattened tree has a tail.
        // Correct: use the right tail when it exists; otherwise use the left tail.
        return rightEnd ?? leftEnd
    }
}

// GPT's summary:
// Mistakes you made:
// - Your restructuring logic was correct, but the returned tail was wrong
//   when there was a left subtree and no right subtree.
// - Example: node 1 with only left child 2 should return node 2 as the tail,
//   but `return rightEnd` returned nil.
//
// Key idea:
// - Flatten the left and right subtrees first.
// - If a left subtree exists:
//   1. Move it to `node.right`.
//   2. Set `node.left = nil`.
//   3. Attach the original right subtree to the tail of the left subtree.
// - Return the tail so the parent can attach its original right subtree.
//
// Swift syntax to remember:
// - `if let left = left` unwraps the optional and gives a non-optional node.
// - `rightEnd ?? leftEnd` uses `rightEnd` when it is not nil;
//   otherwise it uses `leftEnd`.
// - `@discardableResult` allows `flatten` to call `helper(root)`
//   without using its returned tail.
//
// Complexity:
// - Time: O(n), where n is the number of nodes.
// - Space: O(h) for recursion, where h is the tree height.