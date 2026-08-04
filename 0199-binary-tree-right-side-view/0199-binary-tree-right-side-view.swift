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
//     func rightSideView(_ root: TreeNode?) -> [Int] {
//         guard let root = root else {
//             return []
//         }
//
//         var queue = [TreeNode]()
//         var rightArr = [Int]()
//         queue.append(root)
//         var first = 0
//         var levelCount = 1
//         while levelCount != 0 {
//             let node = queue[first]
//             first += 1
//             levelCount -= 1
//             if let left = node.left {
//                 queue.append(left)
//             }
//
//             if let right = node.right {
//                 queue.append(right)
//             }
//
//             // end of the level
//             if levelCount == 0 {
//                 rightArr.append(node.val)
//                 levelCount = queue.count - first
//             }
//         }
//
//         return rightArr
//     }
// }
//
// // think
// // seems like level traverse
// // do the level and keep tracking of the last element of each level
// // to do level traverse, need to use queue
// // popfirst then put its sub trees into the queue
// // 3 mins so far, ready to write the code
// // seems I don't need to do recursive, so no need to have a helper method. delete the helper method I created so far
// // 16 finish coding, now use example to verify
// // spend sometime to figure out what's the exit of while loop
// // 20 mins use example to verify, then notice my logic is not correct, so update
// // 24 mins so far, ready to run, pass, ready to submit, pass

class Solution {
    func rightSideView(_ root: TreeNode?) -> [Int] {
        guard let root = root else {
            return []
        }

        var queue = [root]
        var result = [Int]()
        var front = 0
        var nodesLeftInLevel = 1

        while nodesLeftInLevel != 0 {
            let node = queue[front]
            front += 1
            nodesLeftInLevel -= 1

            if let left = node.left {
                queue.append(left)
            }

            if let right = node.right {
                queue.append(right)
            }

            if nodesLeftInLevel == 0 {
                // Good: the final processed node of a level is the node
                // visible from the right side.
                result.append(node.val)

                // Good: everything still in the queue belongs to the next level.
                nodesLeftInLevel = queue.count - front
            }
        }

        return result
    }
}

// GPT's summary:
// What you did well:
// - Your BFS / level-order approach is correct and passed.
// - You correctly avoid `removeFirst()` by using a moving index (`front`).
// - You correctly identify the rightmost node as the final node processed
//   in each level.
// - Your exit condition works: after the final level, there are no queued
//   nodes left, so `nodesLeftInLevel` becomes 0.
//
// Key idea:
// - Process the tree one level at a time from left to right.
// - The final node processed in a level is the right-side-view value.
// - `nodesLeftInLevel` separates the current level from children added
//   for the next level.
//
// Swift syntax to remember:
// - `queue.count - front` is the number of unprocessed queue elements.
// - `if let left = node.left` safely unwraps an optional child.
// - `guard let root = root else { return [] }` handles an empty tree.
//
// Complexity:
// - Time: O(n), where n is the number of nodes.
// - Space: O(n) in the worst case for the queue.