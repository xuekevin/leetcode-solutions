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
//     var result = 0
//     func sumNumbers(_ root: TreeNode?) -> Int {
//         helper(root, 0)
//         return result
//     }
//
//     func helper(_ node: TreeNode?, _ num: Int) {
//         guard let node = node else {
//             return
//         }
//
//         var updatedNum = num * 10 + node.val
//
//         if node.left == nil && node.right == nil {
//             result += updatedNum
//         } else {
//             helper(node.left, updatedNum)
//             helper(node.right, updatedNum)
//         }
//     }
// }
//
// // Think
// // Use a global num to track the result
// // when reach to leaf then cacluate the path number and the sum
// // the path number can be cacluated by level and val of the node
// // 15 mins finish writing, now use example to verify
// // origin I write helper(_ node: TreeNode?, _ num: Int, _ level: Int) {
// // turns out no need to use level, so remove it
// // 19 mins, run success, now submit
// // got wrong answer, for corner case if only one node,
// // should first call helper(root, 0)
// // previous I first call helper(root.left, root.val) and helper(root.left, root.val)
// // now resubmit. accepted

class Solution {
    var result = 0

    func sumNumbers(_ root: TreeNode?) -> Int {
        // Good: start at root with no digits yet.
        helper(root, 0)
        return result
    }

    func helper(_ node: TreeNode?, _ num: Int) {
        guard let node = node else {
            return
        }

        // Good: append the current digit to the path number.
        // Example: 12 becomes 12 * 10 + 3 = 123.
        let updatedNum = num * 10 + node.val

        if node.left == nil && node.right == nil {
            // Good: a root-to-leaf path is complete only at a leaf.
            result += updatedNum
            return
        }

        helper(node.left, updatedNum)
        helper(node.right, updatedNum)
    }
}

// GPT's summary:
// What you did well:
// - Your top-down DFS solution is correct and passed.
// - You correctly carry the current path number as a function parameter.
// - You correctly removed `level`; the number itself already carries
//   the position of each digit.
// - Starting with `helper(root, 0)` handles a one-node tree correctly.
//
// Key idea:
// - At each node: `newNumber = oldNumber * 10 + node.val`.
// - When a leaf is reached, add its complete path number to `result`.
//
// Swift syntax to remember:
// - Use `let` for `updatedNum` because it is never reassigned.
// - `guard let node = node else { return }` safely handles an empty child.
// - A leaf satisfies `node.left == nil && node.right == nil`.
//
// Complexity:
// - Time: O(n), where n is the number of tree nodes.
// - Space: O(h) for the recursion stack, where h is the tree height.
//   This is O(log n) for a balanced tree and O(n) for a skewed tree.