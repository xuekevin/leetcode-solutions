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
    func sortedArrayToBST(_ nums: [Int]) -> TreeNode? {
        return helper(nums, 0, nums.count - 1)
    }

    func helper(_ nums: [Int], _ left: Int, _ right: Int) -> TreeNode? {
        if left > right {
            return nil
        }

        let mid = (left + right) / 2
        let left = helper(nums, left, mid - 1)
        let right = helper(nums, mid + 1, right)
        let root = TreeNode(nums[mid])
        root.left = left
        root.right = right
        return root
    }
}

// Thinking
// kind like binary search
// for loop the nums
// nums are sorted
// start from the middle, put middle as the root node
// the get left and right root node
// write down very quick ,should just 5 mins

// Pattern: Binary Tree
// Card shape: get the mid, to create root node, then follow the same logic to create left and right
// State needed: update the left and right
// Contract:      generate the node with the mid index
// Recall:        landed