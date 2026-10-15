class Solution {
    func rob(_ root: TreeNode?) -> Int {
        let answer = helper(root)
        return max(answer.rob, answer.skip)
    }

    // Returns:
    // - rob:  maximum money if we rob this node
    // - skip: maximum money if we do not rob this node
    func helper(_ node: TreeNode?) -> (rob: Int, skip: Int) {
        guard let node = node else {
            return (rob: 0, skip: 0)
        }

        let left = helper(node.left)
        let right = helper(node.right)

        // If we rob this node, we must skip both direct children.
        let rob = node.val + left.skip + right.skip

        // If we skip this node, each child can be robbed or skipped.
        let skip = max(left.rob, left.skip) + max(right.rob, right.skip)

        return (rob: rob, skip: skip)
    }
}

/*
GPT's summary

Your good idea:
- Return two values from every node:
  1. `rob`: rob the current node.
  2. `skip`: do not rob the current node.

Your mistake was here:

Wrong:
    let skip = left.rob + right.rob

Why:
- When we skip the current node, we are allowed to choose the better
  option independently for each child.
- Maybe robbing a child is better; maybe skipping that child is better.

Correct:
    let skip = max(left.rob, left.skip) + max(right.rob, right.skip)

Also:
- `maxValue` is not needed.
- The final answer must come from the root:
    max(answer.rob, answer.skip)

Time Complexity: O(n)
Space Complexity: O(h), where h is the tree height.
*/