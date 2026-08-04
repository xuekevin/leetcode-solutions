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
//     func isValidBST(_ root: TreeNode?) -> Bool {
//         guard let root = root else {
//             return false
//         }
//
//
//         var isValid = true
//
//         if let left = root.left, left.val >= root.val {
//             return false
//         }
//
//         if let right = root.right, right.val <= root.val {
//             return false
//         }
//
//         return helper(left, Int.min, node.val) && helper(right, node.val, Int.max)
//     }
//
//     func helper(_ root: TreeNode?, _ minVal: Int, _ maxVal: Int) -> Bool {
//         guard let root = root else {
//             return true
//         }
//
//         if root.val <= minVal || root.val >= maxVal {
//             return false
//         }
//
//         // var curMinVal = min(root.Val, minVal)
//
//         //
//         return helper(node.left, Int.min, node.val) && helper(node.right, node.val, )
//
//
//
//     }
// }
//
// // think pretty staright forward
// // compare with left and right node
// // then also make sure sub tree follow the same pattern
// // also need to pass down the parent root down to subtree, to follow the left < root < right logic
// // 2 mins start to write
// // 10 mins, realize I need to pass 2 value, one is min, one is max
// // 17 mins so far, I think I made a mistake to handle what's the pass in parameter for the recurisve
// // will ask gpt to fix

class Solution {
    func isValidBST(_ root: TreeNode?) -> Bool {
        // Good: an empty tree is a valid BST.
        return helper(root, nil, nil)
    }

    // `lowerBound` and `upperBound` are inherited from every ancestor.
    func helper(
        _ node: TreeNode?,
        _ lowerBound: Int?,
        _ upperBound: Int?
    ) -> Bool {
        guard let node = node else {
            return true
        }

        if let lowerBound = lowerBound, node.val <= lowerBound {
            return false
        }

        if let upperBound = upperBound, node.val >= upperBound {
            return false
        }

        // Good: for the left subtree, node.val becomes the new upper bound.
        // Keep the old lower bound because it still applies.
        let isLeftValid = helper(node.left, lowerBound, node.val)

        // Good: for the right subtree, node.val becomes the new lower bound.
        // Keep the old upper bound because it still applies.
        let isRightValid = helper(node.right, node.val, upperBound)

        return isLeftValid && isRightValid
    }
}

// GPT's summary:
// Mistakes you made:
// - Checking only each node against its direct children is not enough.
// - `left` and `right` only exist inside their own `if let` blocks,
//   so they cannot be used in the later return statement.
// - `node` was not defined; use the helper parameter name consistently.
// - An empty tree should return true for this problem.
//
// Key idea:
// - Every node must stay inside a valid range from all ancestors.
// - Left subtree: lowerBound < node.val < parent.val.
// - Right subtree: parent.val < node.val < upperBound.
//
// Example that direct-child comparison misses:
//
//       5
//      / \
//     1   6
//        /
//       3
//
// - 3 is correctly less than its parent 6.
// - But 3 is in 5's right subtree, so it must also be greater than 5.
// - The inherited lower bound catches this: 3 <= 5, so return false.
//
// Swift syntax to remember:
// - `if let lowerBound = lowerBound` unwraps an optional bound.
// - Use `Int?` bounds instead of `Int.min` and `Int.max`.
//   This also works if a tree node actually contains Int.min or Int.max.
//
// Complexity:
// - Time: O(n), where n is the number of nodes.
// - Space: O(h) for recursion, where h is the tree height.