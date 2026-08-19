// ============================================================
// FIX VERSION: Your solution with the Swift naming issue fixed
// ============================================================

class fixSolution {
    func sortedArrayToBST(_ nums: [Int]) -> TreeNode? {
        return helper(nums, 0, nums.count - 1)
    }

    func helper(
        _ nums: [Int],
        _ left: Int,
        _ right: Int
    ) -> TreeNode? {
        // An empty index range represents an empty subtree.
        if left > right {
            return nil
        }

        let middle = left + (right - left) / 2

        // FIX: Do not redeclare the parameter names left and right.
        let leftSubtree = helper(nums, left, middle - 1)
        let rightSubtree = helper(nums, middle + 1, right)

        let root = TreeNode(nums[middle])
        root.left = leftSubtree
        root.right = rightSubtree

        return root
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Create the root first, then recursively attach its subtrees.
// ============================================================

class Solution {
    func sortedArrayToBST(_ nums: [Int]) -> TreeNode? {
        return buildTree(nums, 0, nums.count - 1)
    }

    // Contract:
    // Returns a balanced BST containing nums[left...right].
    func buildTree(
        _ nums: [Int],
        _ left: Int,
        _ right: Int
    ) -> TreeNode? {
        // No values remain for this subtree.
        if left > right {
            return nil
        }

        // Choose the middle value to keep both sides balanced.
        let middle = left + (right - left) / 2
        let root = TreeNode(nums[middle])

        // Values before middle belong to the left subtree.
        root.left = buildTree(nums, left, middle - 1)

        // Values after middle belong to the right subtree.
        root.right = buildTree(nums, middle + 1, right)

        return root
    }
}

// ============================================================
// ORIGINAL SOLUTION
// ============================================================

/*
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
// write down very quick, should just 5 mins

// Pattern: Binary Tree
// Card shape: get the mid, to create root node,
//             then follow the same logic to create left and right
// State needed: update the left and right
// Contract: generate the node with the mid index
// Recall: landed
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
WHAT YOU GOT RIGHT:

1. Select the middle element as the subtree root.
2. Recursively build the left side from left...middle-1.
3. Recursively build the right side from middle+1...right.
4. Return nil when left > right.
5. Pass indexes instead of creating new subarrays.

SWIFT MISTAKE:

The helper already has parameters named `left` and `right`:

    func helper(_ nums: [Int], _ left: Int, _ right: Int)

You then tried to declare local variables with the same names:

    let left = helper(...)
    let right = helper(...)

Use different names:

    let leftSubtree = helper(...)
    let rightSubtree = helper(...)

BETTER RECURSIVE CONTRACT:

Instead of:

    "Generate the node with the middle index"

Use:

    helper(nums, left, right) returns the root of a balanced BST
    containing every value in nums[left...right].

EXAMPLE:

    nums = [-10, -3, 0, 5, 9]

First call:

    left = 0
    right = 4
    middle = 2
    root = 0

Then:

    left subtree uses [-10, -3]
    right subtree uses [5, 9]

Possible result:

             0
           /   \
        -10     5
          \      \
          -3      9

The exact balanced tree may differ because either middle can be chosen
when a range contains an even number of elements.

COMPLEXITY:

Time: O(n), because one node is created for every array element.

Auxiliary space: O(log n), because the generated tree is balanced and
the recursion stack follows the tree height.

Output space: O(n) for the returned tree.
*/