class Solution {
    var maxSum = 0

    func maxSumBST(_ root: TreeNode?) -> Int {
        _ = helper(root)
        return maxSum
    }

    // Returns:
    // - isBST: whether this subtree is a valid BST
    // - min: smallest value in this subtree
    // - max: largest value in this subtree
    // - sum: sum of all node values in this subtree
    func helper(_ node: TreeNode?) -> (
        isBST: Bool,
        min: Int,
        max: Int,
        sum: Int
    ) {
        // An empty subtree is valid.
        // Its min/max values let its parent pass BST comparisons.
        guard let node = node else {
            return (true, Int.max, Int.min, 0)
        }

        let left = helper(node.left)
        let right = helper(node.right)

        // Current tree is a BST only when:
        // 1. Both child subtrees are BSTs.
        // 2. Every left value < node.val < every right value.
        guard left.isBST,
              right.isBST,
              left.max < node.val,
              node.val < right.min else {
            return (false, Int.min, Int.max, 0)
        }

        let currentSum = left.sum + right.sum + node.val
        maxSum = max(maxSum, currentSum)

        return (
            true,
            min(node.val, left.min),
            max(node.val, right.max),
            currentSum
        )
    }
}

/*
GPT's summary

Mistake 1: nil subtree

Wrong:
    return (false, Int.min, Int.max, 0)

Why:
- A missing child does not make a tree invalid.
- A leaf node has two nil children and must be a valid BST.

Correct:
    return (true, Int.max, Int.min, 0)

Mistake 2: BST comparison direction

Wrong:
    if node.val < left.max || node.val > right.min

Correct:
    left.max < node.val && node.val < right.min

Mistake 3: use `sum`, not `max`, to calculate money.

Wrong:
    left.max + right.max + node.val

Correct:
    left.sum + right.sum + node.val

`left.max` is the largest node value in the left subtree.
`left.sum` is the sum of every node in the left subtree.

Time Complexity: O(n)
Space Complexity: O(h), where h is the tree height.
*/