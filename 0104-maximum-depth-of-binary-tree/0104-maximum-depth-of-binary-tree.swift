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
//     var maxDepth = 0
//     func maxDepth(_ root: TreeNode?) -> Int {
//         guard let root = root else {
//             return 0
//         }
//         traverse(root, 0)
//         return maxDepth
//     }
//
//     func traverse(_ node: TreeNode?, _ depth: Int) -> Void {
//         guard let node = node else {
//             return
//         }
//         let curDepth = depth + 1
//
//         // forget how to write in swift synatx, or not sure
//
//         if node.left == nil && node.right == nil {
//             maxDepth = max(maxDepth, curDepth)
//         }
//
//         traverse(node.left, curDepth)
//         traverse(node.right, curDepth)
//     }
// }
//
// // #Thoughts
// // now try with traverse mindset again
// // 

class Solution {
    // Good: this stores the best depth found so far during traversal.
    // Small note: this name can pass on LeetCode, but `answer` can be clearer
    // because the method is also named `maxDepth`.
    var maxDepth = 0

    func maxDepth(_ root: TreeNode?) -> Int {
        // Good: guard-let handles the empty tree case.
        // Why it works: if root is nil, the tree has depth 0.
        guard let root = root else {
            return 0
        }

        // Good: start traversal from root with depth 0.
        traverse(root, 0)

        return maxDepth
    }

    // Good: `-> Void` is valid Swift.
    // Style note: it is optional, so many Swift solutions write this without `-> Void`.
    func traverse(_ node: TreeNode?, _ depth: Int) -> Void {
        // Good: unwrap optional TreeNode before using node.left / node.right.
        guard let node = node else {
            return
        }

        let curDepth = depth + 1

        // Good: update answer at leaf nodes.
        // Why it works: when both children are nil, this path is complete.
        if node.left == nil && node.right == nil {
            maxDepth = max(maxDepth, curDepth)
        }

        traverse(node.left, curDepth)
        traverse(node.right, curDepth)
    }
}

// GPT's summary:
// What you did well:
// - Your submitted solution passed, so the traversal logic is valid.
// - You correctly used `guard let` to unwrap optional TreeNode values.
// - You correctly carried `depth` down the recursive calls.
// - You correctly updated the max depth when reaching a leaf node.
//
// Correction to GPT's earlier comment:
// - I said `var maxDepth` conflicts with `func maxDepth(_:)`.
// - Since your submit passed, that is not a required syntax fix in this LeetCode context.
// - Renaming the variable to `answer` or `maxDepthValue` is only a readability improvement.
//
// Key idea:
// - This is traversal with external state.
// - Enter node: `curDepth = depth + 1`.
// - If the node is a leaf, update the stored max depth.
// - Recurse into left and right children.
//
// Swift syntax to remember:
// - `TreeNode?` means optional TreeNode.
// - `guard let node = node else { return }` unwraps an optional or exits.
// - `nil` means no value in Swift.
// - `func traverse(...) -> Void` is valid, but `-> Void` can be omitted.
// - `max(a, b)` returns the larger value.
//
// Complexity:
// - Time: O(n), because every node is visited once.
// - Space: O(h), where h is the tree height from the recursion call stack.