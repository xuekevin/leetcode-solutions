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
//     func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
//         let rootNode = TreeNode()
//         let rootVal = preorder[0]
//         rootNode.val = rootVal
//
//         var count = 0
//         for item in inorder {
//             if item == rootVal {
//                 break
//             }
//             count += 1
//         }
//
//
//         // means we have left subtree
//         if count != 0  {
//             let leftPreOrder = Array(preorder[1..<(1 + count)])
//             let leftInOrder = Array(inorder[0..<count])
//             rootNode.left = buildTree(leftPreOrder, leftInOrder)
//         }
//
//         if count + 1 < preorder.count {
//             let rightPreOrder = Array(preorder[(count+1)..<preorder.count])
//             let rightInOrder = Array(inorder[(count+1)..<inorder.count])
//             rootNode.right = buildTree(rightPreOrder, rightInOrder)
//         }
//
//         return rootNode
//     }
// }
//
// // Think
// // use preorder and inorder we can find the root node of a tree
// // after find the root, then we need to find the left which is the new root of substree
// // then we need decompose this issue to sub tree, to generate new preorder and inorder for //subtree
// // 2:30 start to write code
// // don't know in swift how to write subarray with index and length, now google it
// // 15 mins so far
// // ready to run
// // find some synatx error
// // one is "error: cannot convert value of type 'ArraySlice<Int>' to expected argument type '[Int]' "
// // fix it
// // got crash, must have some index exception when create new preorder and inorder
// // find I have logic error to generate new preorder and inorder
// // fix it now
// // FIX NOW
// // SUBMIT NOW
// // use around 30+ mins. accepted

class Solution {
    func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
        // Correct: prevent `preorder[0]` from crashing for an empty subtree.
        guard !preorder.isEmpty else {
            return nil
        }

        // Good: the first preorder value is always the subtree root.
        let rootVal = preorder[0]
        let rootNode = TreeNode(rootVal)

        // Good: values before rootVal in inorder belong to the left subtree.
        let leftCount = inorder.firstIndex(of: rootVal)!

        // `Array(...)` converts an ArraySlice<Int> into [Int].
        rootNode.left = buildTree(
            Array(preorder[1..<(1 + leftCount)]),
            Array(inorder[..<leftCount])
        )

        rootNode.right = buildTree(
            Array(preorder[(1 + leftCount)...]),
            Array(inorder[(leftCount + 1)...])
        )

        return rootNode
    }
}

// Better version: avoids repeatedly searching and copying subarrays.
class BetterSolution {
    func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
        var inorderIndex = [Int: Int]()

        for (index, value) in inorder.enumerated() {
            inorderIndex[value] = index
        }

        var preorderIndex = 0

        func build(_ leftBound: Int, _ rightBound: Int) -> TreeNode? {
            guard leftBound <= rightBound else {
                return nil
            }

            let rootValue = preorder[preorderIndex]
            preorderIndex += 1

            let root = TreeNode(rootValue)
            let middle = inorderIndex[rootValue]!

            root.left = build(leftBound, middle - 1)
            root.right = build(middle + 1, rightBound)

            return root
        }

        return build(0, inorder.count - 1)
    }
}

// GPT's summary:
// What you did well:
// - Your main recursive idea is correct and was accepted.
// - You correctly used preorder[0] as the root.
// - You correctly split inorder at the root to determine the left subtree size.
// - You learned that slices such as `preorder[1..<3]` are `ArraySlice<Int>`.
//   Wrap them in `Array(...)` when a function requires `[Int]`.
//
// Key idea:
// - Preorder: root, left subtree, right subtree.
// - Inorder: left subtree, root, right subtree.
// - Find the root in inorder; its position tells you how many nodes belong
//   to the left subtree. Then recursively build both parts.
//
// Swift syntax to remember:
// - `array.firstIndex(of: value)` returns an optional index.
// - `Array(preorder[1..<(1 + leftCount)])` converts a slice to an array.
// - `guard !preorder.isEmpty else { return nil }` avoids indexing an empty array.
//
// Complexity of your accepted version:
// - Time: O(n^2) because each recursive call searches inorder and copies arrays.
// - Space: O(n^2) in the worst case because of copied subarrays.
//
// Complexity of BetterSolution:
// - Time: O(n), using the value-to-inorder-index dictionary.
// - Space: O(n) for the dictionary and recursion stack.