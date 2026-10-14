/*
class Solution {
    var best = Int.min

    func diameterOfBinaryTree(_ root: TreeNode?) -> Int {
        depth(root)
        return best
    }

    func depth(_ node: TreeNode?) -> Int {
        guard let node = node else {
            return 0
        }

        let curSum = depth(node.left) + depth(node.right)
        let depthSum = 1 + max(depth(node.left), depth(node.right))

        best = max(best, max(depthSum, curSum))
        return depthSum
    }
}
*/

class Solution {
    var best = 0

    func diameterOfBinaryTree(_ root: TreeNode?) -> Int {
        depth(root)
        return best
    }

    // Returns the maximum depth downward from `node`, measured in nodes.
    func depth(_ node: TreeNode?) -> Int {
        guard let node = node else {
            return 0
        }

        let leftDepth = depth(node.left)
        let rightDepth = depth(node.right)

        // The diameter through this node is measured in edges.
        best = max(best, leftDepth + rightDepth)

        // Give the parent this subtree's longest downward path.
        return 1 + max(leftDepth, rightDepth)
    }
}

/*
GPT's summary

Good:
- You chose the right pattern: postorder traversal.
- `depth` returns information to its parent.
- `best` records the largest path found anywhere in the tree.

Mistake 1:
- You called `depth(node.left)` and `depth(node.right)` twice.

Wrong:
    let curSum = depth(node.left) + depth(node.right)
    let depthSum = 1 + max(depth(node.left), depth(node.right))

Why:
- Each recursive call traverses the entire subtree again.
- This can become very slow: O(2^n) for a skewed tree.

Correct:
    let leftDepth = depth(node.left)
    let rightDepth = depth(node.right)

Mistake 2:
- `depthSum` counts nodes in one downward path.
- But the problem asks for the diameter in edges.

For a leaf:
- leftDepth = 0
- rightDepth = 0
- diameter = 0 edges

So this is the diameter through the current node:
    leftDepth + rightDepth

Time Complexity: O(n)
Space Complexity: O(h), where h is tree height because of recursion.
*/