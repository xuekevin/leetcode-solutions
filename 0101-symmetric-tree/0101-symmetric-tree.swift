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
//     var left = [Int]()
//     var right = [Int]()
//     
//     func isSymmetric(_ root: TreeNode?) -> Bool {
//         guard let root = root else {
//             return true
//         }
//
//         leftOrder(root.left)
//         rightOrder(root.right)
//         for i in 0..<left.count {
//             if left[i] != right[i] {
//                 return false
//             }
//         }
//         return true        
//     }
//
//     func leftOrder(_ node: TreeNode?) {
//         guard let node = node else {
//             return
//         }
//         leftOrder(node.left)
//         leftOrder(node.right)
//         left.append(node.val)
//     } 
//
//     func rightOrder(_ node: TreeNode?) {
//         guard let node = node else {
//             return
//         }
//         rightOrder(node.right)
//         rightOrder(node.left)
//         right.append(node.val)
//     } 
// }
//
// // # Think
// // how to define symmetric
// // do left first traverse of left part
// // do right first traverse of right part
// // spend 5 mins so far
// // start to write
// // finish writing, assume not the best solution
// // but use traverse logic
// // also not sure: if I can do left == right to compare two array in swift
// // 13 mins so far
// // but assume the logic is correct
// // got wrong answer, assume can't compare left and right like this
// // still wrong, already 16 mins
// // ready to ask gpt

class Solution {
    func isSymmetric(_ root: TreeNode?) -> Bool {
        // Good: an empty tree is symmetric.
        guard let root = root else {
            return true
        }

        // Wrong idea: storing traversal values in arrays only.
        // Why: values alone do not preserve nil child positions, so different shapes can look equal.
        // Correct: compare the left and right subtrees directly as mirrors.
        return isMirror(root.left, root.right)
    }

    func isMirror(_ left: TreeNode?, _ right: TreeNode?) -> Bool {
        // Good: if both sides are nil, they match.
        if left == nil && right == nil {
            return true
        }

        // Correct: if only one side is nil, the shape is different.
        guard let left = left else {
            return false
        }

        guard let right = right else {
            return false
        }

        // Good: mirror means:
        // 1. current values match
        // 2. left.left mirrors right.right
        // 3. left.right mirrors right.left
        return left.val == right.val
            && isMirror(left.left, right.right)
            && isMirror(left.right, right.left)
    }
}

// GPT's summary:
// Mistakes you made:
// - Your mirror traversal idea was close.
// - The real issue was not Swift array comparison; Swift can compare arrays with `left == right` when elements are Equatable.
// - The issue is that `[Int]` traversal loses nil-position / tree-shape information.
// - You also needed to check `left.count == right.count` before looping, otherwise one array could be shorter.
// - Global arrays can keep old values if the same Solution instance is reused, so direct recursion is cleaner.
//
// Key idea:
// - Symmetric tree means the left subtree and right subtree are mirrors.
// - Compare two nodes at the same time.
// - `left.val` must equal `right.val`.
// - `left.left` must mirror `right.right`.
// - `left.right` must mirror `right.left`.
//
// Swift syntax to remember:
// - Arrays of Int can be compared directly: `left == right`.
// - `guard let left = left else { return false }` unwraps optional TreeNode.
// - A helper can take two optional nodes: `func isMirror(_ left: TreeNode?, _ right: TreeNode?) -> Bool`.
// - Multi-line Boolean expressions can be split with `&&`.
//
// Complexity:
// - Time: O(n), because every node is visited once.
// - Space: O(h), where h is tree height from the recursion call stack.