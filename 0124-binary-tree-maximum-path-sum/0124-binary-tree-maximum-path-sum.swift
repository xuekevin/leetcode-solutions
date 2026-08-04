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
//     var maxPath = Int.min
//     func maxPathSum(_ root: TreeNode?) -> Int {
//         helper(root)
//         return maxPath
//     }
//
//     func helper(_ root: TreeNode?) -> Int {
//         guard let root = root else {
//             return 0
//         }
//
//         let leftPath = helper(root.left)
//         let rightPath = helper(root.right)
//
//         var curPath = root.val
//         if leftPath > 0 {
//             curPath += leftPath
//         }
//
//         if rightPath > 0 {
//             curPath += rightPath
//         }
//         maxPath = max(curPath, maxPath)
//         return curPath
//     }
// }
//
// // think, when to remove or add the node?
// // what kind of traverse we will use? maybe inorder?
// // decompose the issue, to left, subtree and right subtree
// // then connct both subtree to update the max path sum
// // sub issue, just a 3 node tree, we can decide, whether keep left or right node to get the max path
// // 7 mins so far, ready to write the code
// // 13 mins finish writing, now checking
// // notice that I need to have a helper method to return the final maxPath
// // 16 mins ready to run, passed
// // now submit, got wrong answer that,[-3] case, I thught the issue mentioned: "Given the root of a binary tree, return the maximum path sum of any non-empty path."
// // if this is the case, then I need to init maxPath with Integer.min, but seems it will cause synatx error. checed with gpt should be Int.min
// // try submit again, still wrong answer, ready to use gpt to figure it out
//
// // Pattern:
// // Card shape: traverse every node
// // State needed: update the sum, and also actively remove the node, after recursive
// // Contract: this function returns ___ the subtree's path sum
// // Recall: half

class Solution {
    var maxPath = Int.min

    func maxPathSum(_ root: TreeNode?) -> Int {
        // Reset in case this Solution object is used more than once.
        maxPath = Int.min
        helper(root)
        return maxPath
    }

    // Returns the best single downward path starting at `root`.
    func helper(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }

        // Good: ignore a subtree if its best path is negative.
        let leftGain = max(helper(root.left), 0)
        let rightGain = max(helper(root.right), 0)

        // Good: a complete path can use both children, with root as its top.
        let pathThroughRoot = root.val + leftGain + rightGain
        maxPath = max(maxPath, pathThroughRoot)

        // Wrong: `return curPath`, where curPath contains both left and right.
        // Why: the parent can extend only one side of this path. Returning both
        // sides would create an invalid path that branches twice.
        // Correct: return root plus only the better downward child path.
        return root.val + max(leftGain, rightGain)
    }
}

// GPT's summary:
// Mistakes you made:
// - `Int.min` was the correct fix for an all-negative tree such as [-3].
//   With it, [-3] should return -3.
// - The real bug is returning a path that includes both left and right
//   children. Such a path is valid for updating `maxPath`, but cannot be
//   extended upward to the parent.
//
// Key idea:
// - At every node, do two different jobs:
//   1. Update the global answer with a path that can use left + root + right.
//   2. Return a one-direction path: root + either left or right.
//
// Example of why only one side can be returned:
//
//        0
//       / \
//     10   1
//     / \
//    5   5
//
// - At node 10, 5 -> 10 -> 5 has sum 20, so it is valid for `maxPath`.
// - But node 0 cannot extend that path to include 1, because that would
//   branch at node 10 and again at node 0. A valid path cannot do that.
//
// Swift syntax to remember:
// - `Int.min` is Swift's smallest Int value.
// - `max(value, 0)` removes a negative path contribution.
// - `max(leftGain, rightGain)` chooses one child path to return upward.
//
// Complexity:
// - Time: O(n), where n is the number of nodes.
// - Space: O(h) for recursion, where h is tree height.