// Your original solution:
//
// class Solution {
//     var result = -1
//     var start = 0
//     func kthSmallest(_ root: TreeNode?, _ k: Int) -> Int {
//         helper(root,k)
//         return result
//     }
//
//     func helper(_ node: TreeNode?, _ k: Int) {
//         guard let node = node else {
//             return
//         }
//         helper(node.left, k)
//         start += 1
//         if start == k {
//             result = node.val
//             return
//         }
//         helper(node.right, k)
//     }
// }
// // inorder traverse and the check the current index to compare with k
// // 6 mins
// // got wrong answer, stlll not carful, the result is the node.val, not the index, I made silly mistake again, and didn't check the code careful, should avoid this in the future

// Fixed version: your approach, with state reset for safety.
class Solution {
    var result = -1
    var visitedCount = 0

    func kthSmallest(_ root: TreeNode?, _ k: Int) -> Int {
        result = -1
        visitedCount = 0

        helper(root, k)
        return result
    }

    func helper(_ node: TreeNode?, _ k: Int) {
        guard let node = node else {
            return
        }

        // Good: inorder traversal of a BST visits values in sorted order.
        helper(node.left, k)

        visitedCount += 1

        if visitedCount == k {
            // Good: save the node value, not the visit count.
            result = node.val
            return
        }

        helper(node.right, k)
    }
}

// Upgrade version: rename UpgradeSolution to Solution before submitting.
// This version stops every recursive call as soon as it finds the answer.
class UpgradeSolution {
    var result = -1
    var visitedCount = 0

    func kthSmallest(_ root: TreeNode?, _ k: Int) -> Int {
        _ = helper(root, k)
        return result
    }

    // Return true when the k-th smallest node has been found.
    @discardableResult
    func helper(_ node: TreeNode?, _ k: Int) -> Bool {
        guard let node = node else {
            return false
        }

        // If the answer was found on the left, pass true upward immediately.
        if helper(node.left, k) {
            return true
        }

        visitedCount += 1

        if visitedCount == k {
            result = node.val
            return true
        }

        // Search right only when the answer is not found yet.
        return helper(node.right, k)
    }
}

// GPT's summary:
// What you did well:
// - You chose the correct inorder traversal pattern.
// - You correctly identified the answer as `node.val` when the visit count is k.
//
// Fixed version:
// - Correct, simple, and O(n) time.
// - It may continue traversing after finding the k-th value.
//
// Upgrade version:
// - Uses Bool as a “stop signal”.
// - `true` travels upward through every parent call, so traversal ends early.
// - Time: O(h + k) in the useful early-stop case; O(n) worst case.
// - Space: O(h) for recursion in both versions.