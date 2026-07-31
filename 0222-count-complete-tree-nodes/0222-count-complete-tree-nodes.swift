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
//     var depth = 0
//     var leafCount = 0
//     func countNodes(_ root: TreeNode?) -> Int {
//         guard let root = root else {
//             return 0
//         }
//         // TC O(log(n))
//         depth = height(root)
//         // didn't visit every node so TC is not O(n)
//         levelTraverse(root, 0)
//         var count = 0
//         for i in 0..<(depth-1) {
//             count += 2^i
//         }
//         return count + leafCount
//     }
//
//     func height(_ root: TreeNode?) -> Int {
//         guard let root = root else {
//             return 0
//         }
//         
//         return 1 + height(root.left)
//     }
//
//     func levelTraverse(_ root: TreeNode?, _ level: Int) {
//         guard let root = root else {
//             return
//         }
//         var curlevel = level + 1
//
//         if curlevel == depth - 1 {
//             if let left = root.left {
//                 leafCount += 1
//             }
//
//             if let right = root.right {
//                 leafCount += 1
//             }
//         }
//         
//         levelTraverse(root.left, curlevel)
//         levelTraverse(root.right, curlevel) 
//     }
// }
// // Think
// // do traverse in O(n), the we have the count I assume
// // question is what is O(n)
// // try to do some traverse I can think
// // start to code in 6 mins
// // finish in 2 mins, try submit
// // think my TC is O(n), since I visit every node
// // which might not what then issue, what since it want less thant O(n)
// 
// /**
// *
//     func countNodes(_ root: TreeNode?) -> Int {
//         guard let root = root else {
//             return 0
//         }
//         return 1 + countNodes(root.left) + countNodes(root.right)
//     }
// */
//
// // rethinking, do the level traverse.
// // all we need to have the level, then for last level we count the leaf count
// // so become to how to get height and all the leafs, but does that mean it also TC O(n)?
// // think I can just visit left most to get the height
// // then how to get the leaf or just go to the last level do the traverse
// // should do the height count along with reach the leaf
// // spend 30 mins so far
// // try run, made several small mistake cause compiler error. should avoid this
// // got wrong answer,now quick debug, assume my logic is correct
// // 40 mins, but think my logic is correct
// // so ask gpt to fix

class Solution {
    func countNodes(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }

        let leftHeight = getLeftHeight(root)
        let rightHeight = getRightHeight(root)

        // Good: use complete-tree property.
        // Why it works: if left height == right height, this subtree is perfect.
        // A perfect tree with height h has 2^h - 1 nodes.
        if leftHeight == rightHeight {
            return (1 << leftHeight) - 1
        }

        // Correct: if not perfect, recursively count both sides.
        // Why it is faster than plain O(n): each recursive step can skip whole perfect subtrees.
        return 1 + countNodes(root.left) + countNodes(root.right)
    }

    func getLeftHeight(_ node: TreeNode?) -> Int {
        var node = node
        var height = 0

        while node != nil {
            height += 1
            node = node?.left
        }

        return height
    }

    func getRightHeight(_ node: TreeNode?) -> Int {
        var node = node
        var height = 0

        while node != nil {
            height += 1
            node = node?.right
        }

        return height
    }
}

// GPT's summary:
// Mistakes you made:
// - Your first simple recursion `1 + left + right` is correct, but it is O(n).
// - Your second idea tried to use complete-tree height, which is the right direction.
// - But `levelTraverse` still recursively visits many nodes, so it can still become O(n).
// - `2^i` is not exponent in Swift. `^` is bitwise XOR.
// - You used `left` and `right` variables inside `if let`, but never used those values.
// - Global `depth` and `leafCount` make state harder to reason about across recursion/calls.
//
// Key idea:
// - For a complete binary tree, compare leftmost height and rightmost height.
// - If they are equal, the subtree is perfect.
// - Perfect tree node count is `2^height - 1`.
// - In Swift, use bit shift for powers of 2: `(1 << height) - 1`.
// - If heights are not equal, recursively count left and right subtrees.
//
// Swift syntax to remember:
// - `^` is bitwise XOR in Swift, not power.
// - `1 << h` means 2 to the h power for integer shifts.
// - `var node = node` lets you move a local optional pointer in a loop.
// - `node = node?.left` safely moves to the left child.
// - `while node != nil { ... }` loops until the optional becomes nil.
//
// Complexity:
// - Time: O((log n)^2) for a complete binary tree.
// - Space: O(log n), because recursion height is the tree height.