// Your original solution:
//
// class Solution {
//     func levelOrder(_ root: TreeNode?) -> [[Int]] {
//         guard let root = root else {
//             return []
//         }
//
//         var resultArr = [[Int]]()
//         var front = 0
//         var levelCount = 1
//         var levelArr = [Int]()
//         var queue = [TreeNode]()
//         queue.append(root)
//
//         while levelCount != 0 {
//             let node = queue[front]
//             levelArr.append(node.val)
//             front += 1
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
//                 resultArr.append(levelArr)
//                 levelArr = []
//                 levelCount = queue.count - front
//             }
//         }
//
//         return resultArr
//     }
// }
//
// // finish writing in 5 mins

class Solution {
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else {
            return []
        }

        var result = [[Int]]()
        var queue = [root]
        var front = 0
        var nodesLeftInLevel = 1
        var currentLevel = [Int]()

        while nodesLeftInLevel != 0 {
            let node = queue[front]
            front += 1
            nodesLeftInLevel -= 1

            // Good: collect values from the current level.
            currentLevel.append(node.val)

            if let left = node.left {
                queue.append(left)
            }

            if let right = node.right {
                queue.append(right)
            }

            if nodesLeftInLevel == 0 {
                // Good: the level is complete, so save it and start fresh.
                result.append(currentLevel)
                currentLevel = []

                // Good: remaining queue nodes are exactly the next level.
                nodesLeftInLevel = queue.count - front
            }
        }

        return result
    }
}

// GPT's summary:
// What you did well:
// - This solution is correct.
// - You used BFS with a queue, which is the natural fit for level order.
// - You correctly collected one array per level.
// - You avoided `removeFirst()` by using `front` as the queue position.
// - Finishing this cleanly in five minutes is real progress.
//
// Key idea:
// - `nodesLeftInLevel` separates one level from the next.
// - When it reaches 0, `currentLevel` is complete.
// - Children added during that level become the next level.
//
// Complexity:
// - Time: O(n), where n is the number of nodes.
// - Space: O(n) in the worst case for the queue and returned result.