/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     public var val: Int
 *     public var left: TreeNode?
 *     public var right: TreeNode?
 *     public init() { self.val = 0; self.left = nil; self.right = nil; }
 *     public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
 *     public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
 *         self.val = val
 *         self.left = left
 *         self.right = right
 *     }
 * }
 */
class Solution {
    func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
        let rootNode = TreeNode()
        let rootVal = preorder[0]
        rootNode.val = rootVal

        var count = 0
        for item in inorder {
            if item == rootVal {
                break
            }
            count += 1
        }


        // means we have left subtree
        if count != 0  {
            let leftPreOrder = Array(preorder[1..<(1 + count)])
            let leftInOrder = Array(inorder[0..<count])
            rootNode.left = buildTree(leftPreOrder, leftInOrder)
        }
        
        if count + 1 < preorder.count {
            let rightPreOrder = Array(preorder[(count+1)..<preorder.count])
            let rightInOrder = Array(inorder[(count+1)..<inorder.count])
            rootNode.right = buildTree(rightPreOrder, rightInOrder)
        }
    
        return rootNode
    }
}

// Think
// use preorder and inorder we can find the root node of a tree
// after find the root, then we need to find the left which is the new root of substree
// then we need decompose this issue to sub tree, to generate new preorder and inorder for //subtree
// 2:30 start to write code
// don't know in swift how to write subarray with index and length, now google it
// 15 mins so far
// ready to run
// find some synatx error
// one is "error: cannot convert value of type 'ArraySlice<Int>' to expected argument type '[Int]' "
// fix it
// got crash, must have some index exception when create new preorder and inorder
// find I have logic error to generate new preorder and inorder
// fix it now
// FIX NOW
// SUBMIT NOW 
// use around 30+ mins
