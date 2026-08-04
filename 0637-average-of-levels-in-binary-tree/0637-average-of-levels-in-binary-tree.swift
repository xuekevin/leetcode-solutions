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
//     func averageOfLevels(_ root: TreeNode?) -> [Double] {
//         guard let root = root else {
//             return [0]
//         }
//
//         var result = [Double]()
//         var queue = [TreeNode]()
//         queue.append(root)
//         var first = 0
//         var levelCount = 1
//         var count = levelCount
//         var curSum = 0
//
//         while levelCount != 0 {
//             let node = queue[first]
//             curSum += node.val
//             first += 1
//             levelCount -= 1
//
//             if let left = node.left {
//                 queue.append(left)
//             }
//
//             if let right = node.right {
//                 queue.append(right)
//             }
//
//             if levelCount == 0 {
//                 let average: Double = ((Double) curSum) / ((Double) count)
//                 result.append(average)
//                 levelCount = queue.count - first
//                 count = levelCount
//                 curSum = 0
//             }
//         }
//         return result
//     }
// }
//
// // level traverse
// // still use queue
// // 30 sec start to write
// // 8 mins finish, now check with example
// // turns out have the carsh exception, wrote wrong while condition
// // shouldn't have such mistake
// // another mistake is not sure how to get average =  (Double) (curSum / count)

class Solution {
    func averageOfLevels(_ root: TreeNode?) -> [Double] {
        // Wrong: `return [0]`
        // Why: an empty tree has no levels, so it has no averages.
        // Correct: return an empty array.
        guard let root = root else {
            return []
        }

        var result = [Double]()
        var queue = [root]
        var front = 0
        var nodesLeftInLevel = 1
        var nodesInLevel = 1
        var currentSum = 0.0

        while nodesLeftInLevel != 0 {
            let node = queue[front]
            front += 1
            nodesLeftInLevel -= 1

            // Correct: convert an Int using `Double(value)`.
            currentSum += Double(node.val)

            if let left = node.left {
                queue.append(left)
            }

            if let right = node.right {
                queue.append(right)
            }

            if nodesLeftInLevel == 0 {
                // Good: sum and node count are for exactly one level.
                let average = currentSum / Double(nodesInLevel)
                result.append(average)

                nodesLeftInLevel = queue.count - front
                nodesInLevel = nodesLeftInLevel
                currentSum = 0.0
            }
        }

        return result
    }
}

// GPT's summary:
// Mistakes you made:
// - An empty tree should return `[]`, not `[0]`.
// - Swift does not use `(Double) value` for type conversion.
//
// Key idea:
// - Use BFS to process one tree level at a time.
// - Add every value from the current level to `currentSum`.
// - When the level ends, divide its sum by its number of nodes.
//
// Swift syntax to remember:
// - Convert an Int to Double with `Double(value)`.
// - `Double(curSum) / Double(count)` avoids integer division.
// - `queue.count - front` gives the number of unprocessed queued nodes.
//
// Complexity:
// - Time: O(n), where n is the number of nodes.
// - Space: O(n) in the worst case for the queue.