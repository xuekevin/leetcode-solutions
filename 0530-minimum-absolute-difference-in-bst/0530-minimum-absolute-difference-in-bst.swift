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
//     var minVal = Int.max
//     var nodeArr = [Int]()
//     func getMinimumDifference(_ root: TreeNode?) -> Int {
//         guard let root = root else {
//             return 0
//         }
//         helper(root)
//         // assume at least we have 2 nodes
//         return minVal
//     }
//
//     func helper(_ node: TreeNode?) {
//         guard let node = node else {
//             return
//         }
//
//         helper(node.left)
//         nodeArr.append(node.val)
//         if nodeArr.count > 1 {
//             minVal = min(minVal, (nodeArr[nodeArr.count - 1] - nodeArr[nodeArr.count - 2]))
//         }
//         helper(node.right)
//     }
// }
//
// // should be traverse and, compare node with its left and right
// // the update the global min value
// // finish writing in 5 mins
// // made a mistake it mentioned any two different node, not only the node connected
// /*
// *
// 
// class Solution {
//     var minVal = Int.max
//     func getMinimumDifference(_ root: TreeNode?) -> Int {
//         helper(root)
//         if minVal == Int.max {
//             return 0
//         }
//         return minVal
//     }
//
//     func helper(_ node: TreeNode?) {
//         guard let node = node else {
//             return
//         }
//
//         if let left = node.left {
//             minVal = min(minVal, abs(node.val - left.val))
//         }
//
//         if let right = node.right {
//             minVal = min(minVal, abs(node.val - right.val))
//         }
//         helper(node.left)
//         helper(node.right)
//     }
// }
// - /
// // start to re-write, show check the issue more careful
// // since it is BST, so I can do in order traverse
// // the check the  adjacemnt abs diff
// // got compiler error ,not sure the reason

class Solution {
    var minDifference = Int.max
    var inorderValues = [Int]()

    func getMinimumDifference(_ root: TreeNode?) -> Int {
        // Reset state in case this Solution object is used again.
        minDifference = Int.max
        inorderValues = []

        guard let root = root else {
            return 0
        }

        helper(root)
        return minDifference
    }

    func helper(_ node: TreeNode?) {
        guard let node = node else {
            return
        }

        // Good: inorder traversal visits BST values in sorted order.
        helper(node.left)

        inorderValues.append(node.val)

        if inorderValues.count > 1 {
            let last = inorderValues[inorderValues.count - 1]
            let previous = inorderValues[inorderValues.count - 2]

            // Good: sorted values make this difference non-negative,
            // so `abs(...)` is unnecessary.
            minDifference = min(minDifference, last - previous)
        }

        helper(node.right)
    }
}

// Better version: keep only the previous inorder value instead of every value.
class BetterSolution {
    var minDifference = Int.max
    var previousValue: Int?

    func getMinimumDifference(_ root: TreeNode?) -> Int {
        minDifference = Int.max
        previousValue = nil

        inorder(root)
        return minDifference
    }

    func inorder(_ node: TreeNode?) {
        guard let node = node else {
            return
        }

        inorder(node.left)

        if let previousValue = previousValue {
            minDifference = min(minDifference, node.val - previousValue)
        }

        previousValue = node.val
        inorder(node.right)
    }
}

// GPT's summary:
// What you did well:
// - You corrected your first idea after noticing the problem compares any
//   two nodes, not only parent and child nodes.
// - You recognized the BST property: inorder traversal produces sorted values.
// - You correctly compare adjacent inorder values.
// - Your main solution is correct.
//
// Mistakes you made:
// - Your pasted block comment starts with `/*` but ends with `- /`.
//   Correct comment closing syntax is `*/`.
// - The first direct-child comparison approach can miss the true closest
//   values because inorder-adjacent nodes are not always direct children.
//
// Key idea:
// - Sort implicitly by doing inorder traversal.
// - In a sorted list, the minimum difference must be between adjacent values.
// - Therefore, compare each inorder value with the previous one.
//
// Swift syntax to remember:
// - Close a block comment with `*/`.
// - `if let previousValue = previousValue` unwraps an optional value.
// - In sorted order, `current - previous` is already non-negative.
//
// Complexity:
// - Your array version: O(n) time and O(n) extra space.
// - BetterSolution: O(n) time and O(h) extra space for recursion,
//   where h is the tree height.