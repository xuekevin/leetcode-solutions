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
//     func zigzagLevelOrder(_ root: TreeNode?) -> [[Int]] {
//         guard let root = root else {
//             return []
//         }
//
//         var resultArr = [[Int]]()
//         var leftToRight = true
//         var queue = [TreeNode]()
//         queue.append(root)
//         var front = 0
//         var levelCount = 1
//         var curArr = [Int]()
//
//         while front < queue.count {
//             for i in front..<levelCount {
//                 let node = queue[front]
//                 curArr.append(node.val)
//                 front += 1
//
//                 if let left = node.left {
//                     queue.append(left)
//                 }
//
//                 if let right = node.right {
//                     queue.append(right)
//                 }
//             }
//
//             if leftToRight == true {
//                 resultArr.append(curArr)
//             } else {
//                 resultArr.append(Array.reversed(curArr))
//             }
//
//             leftToRight = !leftToRight
//             curArr = []
//             levelCount = queue.count - front
//         }
//
//         return resultArr
//     }
// }
//
// // compare level traverse, now we have a direction variable
// // left then we append left subtree first, right direction, we append right subtree first
//
// // start to write immediately
// // 14 mins finish
// // first run, got compiler error
// // Array.reverse() seems not return the new array, try reversed
// // ask gpt to fix

class Solution {
    func zigzagLevelOrder(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else {
            return []
        }

        var result = [[Int]]()
        var leftToRight = true
        var queue = [root]
        var front = 0
        var levelCount = 1

        while levelCount != 0 {
            var currentLevel = [Int]()

            // Wrong: `for i in front..<levelCount`
            // Why: `levelCount` is a number of nodes, not an ending index.
            // Correct: run exactly `levelCount` times.
            for _ in 0..<levelCount {
                let node = queue[front]
                front += 1
                currentLevel.append(node.val)

                // Good: always enqueue children left first, then right.
                // The zigzag direction changes output order, not BFS traversal order.
                if let left = node.left {
                    queue.append(left)
                }

                if let right = node.right {
                    queue.append(right)
                }
            }

            if leftToRight {
                result.append(currentLevel)
            } else {
                // Wrong: `Array.reversed(currentLevel)`
                // Why: `reversed()` is called on an array instance.
                // Correct: `currentLevel.reversed()` returns a reversed collection;
                // wrap it in Array to store it as [Int].
                result.append(Array(currentLevel.reversed()))
            }

            leftToRight.toggle()
            levelCount = queue.count - front
        }

        return result
    }
}

// GPT's summary:
// Mistakes you made:
// - `levelCount` represents a count, not a queue index.
// - Use `for _ in 0..<levelCount` to process that many nodes.
// - Use `Array(currentLevel.reversed())`, not `Array.reversed(currentLevel)`.
// - Do not reverse child-enqueue order. Keep normal BFS order and reverse
//   only the completed level's values when needed.
//
// Key idea:
// - Traverse one level at a time with BFS.
// - Collect its values in left-to-right order.
// - Reverse the collected values on every other level.
//
// Swift syntax to remember:
// - `_` means “this loop variable is intentionally unused.”
// - `array.reversed()` returns values in reverse order.
// - `toggle()` changes a Bool: true becomes false, false becomes true.
//
// Complexity:
// - Time: O(n), where n is the number of nodes.
// - Space: O(n) for the queue and returned result.