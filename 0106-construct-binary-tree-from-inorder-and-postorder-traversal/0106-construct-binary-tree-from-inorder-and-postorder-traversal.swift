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
//     func buildTree(_ inorder: [Int], _ postorder: [Int]) -> TreeNode? {
//         if postorder.count == 0 {
//             return nil
//         }
//
//         let root = TreeNode()
//         let rootVal = postorder[postorder.count - 1]
//         root.val = rootVal
//
//         var rootIndex = 0
//
//         while rootIndex < inorder.count {
//             if inorder[rootIndex] == rootVal {
//                 break
//             }
//             rootIndex += 1
//         }
//
//         if rootIndex > 0 {
//             let leftInorder = Array(inorder.(0,rootIndex))
//             let leftPostorder = Array(postorder.subArray(0,rootIndex))
//             root.left = buildTree(leftInorder,leftPostorder)
//         }
//
//         if rootIndex < inorder.count {
//             let rightInorder = Array(inorder.subArray(rootIndex+1,inorder.count))
//             let rightPostorder = Array(postorder.subArray(rootIndex,postorder.count-1))
//             root.right = buildTree(rightInorder,rightPostorder)
//         }
//
//         return root
//     }
// }
//
// // Pattern: binary tree, decompose
// // Card shape: recursive
// // State needed: keep update the inorder and the post order for sub tree
// // Contract: this function returns ___ the root node of subtree
// // Recall: landed / half / blank: half
//
// // post order to get the root node
// // then use that to get the new inorder and post order array
// // try to recall the mistake I made for preorder and inorder issue
// // 2 mins so far ready to write code
// // finish writing, but do concern my tc and sc
// // tc is O(n)
// // SC, since I create new sub array, vaguely remember there is some way to avoid this
// // also concern for the swift synatx error I made
// // now let met try to re-run
// // made several synatx error, let me examine more careful
// // figure the synatx: value of type '[Int]' has no member 'subArray' in solution.swift
// // now run with gpt to fix this

class Solution {
    func buildTree(_ inorder: [Int], _ postorder: [Int]) -> TreeNode? {
        guard !postorder.isEmpty else {
            return nil
        }

        // Good: the final postorder value is the root of this subtree.
        let rootVal = postorder[postorder.count - 1]
        let root = TreeNode(rootVal)

        // Good: inorder splits the left and right subtrees at the root.
        let rootIndex = inorder.firstIndex(of: rootVal)!

        // Wrong: `inorder.(0, rootIndex)` and `array.subArray(...)`
        // Why: Swift arrays use subscript ranges, and slices are ArraySlice<Int>.
        // Correct: use `Array(array[start..<end])`.
        root.left = buildTree(
            Array(inorder[0..<rootIndex]),
            Array(postorder[0..<rootIndex])
        )

        // Good: right subtree values come after rootIndex in inorder,
        // but before the final root value in postorder.
        root.right = buildTree(
            Array(inorder[(rootIndex + 1)..<inorder.count]),
            Array(postorder[rootIndex..<(postorder.count - 1)])
        )

        return root
    }
}

// Better version: no subarray copies and no repeated inorder searches.
class BetterSolution {
    func buildTree(_ inorder: [Int], _ postorder: [Int]) -> TreeNode? {
        var inorderIndex = [Int: Int]()

        for (index, value) in inorder.enumerated() {
            inorderIndex[value] = index
        }

        var postorderIndex = postorder.count - 1

        func build(_ leftBound: Int, _ rightBound: Int) -> TreeNode? {
            guard leftBound <= rightBound else {
                return nil
            }

            let rootValue = postorder[postorderIndex]
            postorderIndex -= 1

            let root = TreeNode(rootValue)
            let middle = inorderIndex[rootValue]!

            // Important: read postorder backward, so build right first.
            root.right = build(middle + 1, rightBound)
            root.left = build(leftBound, middle - 1)

            return root
        }

        return build(0, inorder.count - 1)
    }
}

// GPT's summary:
// What you did well:
// - You correctly chose the last postorder value as the root.
// - You correctly used inorder to separate the left and right subtrees.
// - Your recursive contract is good: each call returns the root of its subtree.
//
// Mistakes you made:
// - Swift does not have `subArray` for Array.
// - Your original right-subtree condition should only run when
//   `rootIndex + 1 < inorder.count`.
// - Your slice-copying approach is O(n^2), not O(n).
//
// Swift syntax to remember:
// - `Array(array[start..<end])` converts a slice into `[Int]`.
// - `array.firstIndex(of: value)` finds an index and returns an optional.
// - `array[start..<end]` excludes `end`.
//
// Complexity:
// - Fixed version: O(n^2) time and O(n^2) extra space in the worst case.
// - BetterSolution: O(n) time and O(n) space.