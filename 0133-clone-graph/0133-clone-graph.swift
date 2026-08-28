// Your original solution:
// /**
//  * Definition for a Node.
//  * public class Node {
//  *     public var val: Int
//  *     public var neighbors: [Node?]
//  *     public init(_ val: Int) {
//  *         self.val = val
//  *         self.neighbors = []
//  *     }
//  * }
//  */
//
// class Solution {
//    func cloneGraph(_ node: Node?) -> Node? {
//        guard let start = node else {
//            return nil
//        }
//
//        let newNode = Node(start.val)
//        newNode.neighbors = start.neighbors
//        // need to have a maping for the old Node and the new Node
//        var nodeDict = [Node:Node]()
//        nodeDict[start] = newNode
//
//        var newNodeArr = [Node]()
//        newNodeArr.append(newNode)
//
//        for neighbor in start.neighbors {
//            helper(neighbor, &nodeDict, &newNodeArr)
//        }
//
//        for node in newNodeArr {
//            let oldNeighbors = node.neighbors
//            let newNeighbors = [Node]()
//            for neighbor in oldNeighbors {
//                newNeighbors.append(nodeDict[neighbor])
//            }
//            node.neighbors = newNeighbors
//        }
//        return newNode
//    }
//
//    func helper(_ node: Node?, _ nodeDict: inout [Node:Node], _ newNodeArr: inout [Node]) {
//        guard let node = node else {
//            return
//        }
//
//        if !nodeDict.contains(node) {
//            let newNode = Node(node.val)
//            newNode.neighbors = node.neighbors
//            nodeDict[node] = newNode
//            newNodeArr.append(newNode)
//        };
//
//        for neighbor in node.neighbors {
//            helper(neighbor, &nodeDict, &newNodeArr)
//        }
//    }
// }
//
// // Thinking
// // what this issue want me for
// // to clone the node
// // I can start first node
// // and create the node if I haven't created before
// // will write frist then try to figure out the solution
// // finish writing in around 30 mins
// // some swift synatx error, will let gpt to fix


// Fix version: keeps your two-pass mapping approach.
class fixSolution {
    func cloneGraph(_ node: Node?) -> Node? {
        guard let start = node else {
            return nil
        }

        // Wrong: `Node` may not be Hashable, so it cannot safely be a Dictionary key.
        // Correct: ObjectIdentifier uniquely identifies a class instance.
        var nodeDict = [ObjectIdentifier: Node]()

        // Store original nodes so we can connect their copied neighbors later.
        var oldNodeArr = [Node]()

        // First pass: create one copied node for every original node.
        helper(start, &nodeDict, &oldNodeArr)

        // Second pass: connect each copied node to copied neighbors.
        for oldNode in oldNodeArr {
            let copiedNode = nodeDict[ObjectIdentifier(oldNode)]!

            copiedNode.neighbors = oldNode.neighbors.map { neighbor in
                guard let neighbor = neighbor else {
                    return nil
                }

                return nodeDict[ObjectIdentifier(neighbor)]
            }
        }

        return nodeDict[ObjectIdentifier(start)]
    }

    func helper(
        _ node: Node,
        _ nodeDict: inout [ObjectIdentifier: Node],
        _ oldNodeArr: inout [Node]
    ) {
        let id = ObjectIdentifier(node)

        // Important: graphs can contain cycles.
        // If we already created this clone, stop this DFS path.
        if nodeDict[id] != nil {
            return
        }

        // Create and record the cloned node before visiting its neighbors.
        let copiedNode = Node(node.val)
        nodeDict[id] = copiedNode
        oldNodeArr.append(node)

        // Visit all original neighbors.
        for neighbor in node.neighbors {
            if let neighbor = neighbor {
                helper(neighbor, &nodeDict, &oldNodeArr)
            }
        }
    }
}


// Upgrade version: connect neighbors during DFS, so only one pass is needed.
class Solution {
    func cloneGraph(_ node: Node?) -> Node? {
        guard let node = node else {
            return nil
        }

        var nodeDict = [ObjectIdentifier: Node]()

        func dfs(_ node: Node) -> Node {
            let id = ObjectIdentifier(node)

            // If this original node already has a clone, reuse it.
            // This prevents infinite recursion for a cycle.
            if let copiedNode = nodeDict[id] {
                return copiedNode
            }

            // Create the clone before DFS into neighbors.
            let copiedNode = Node(node.val)
            nodeDict[id] = copiedNode

            // Recursively clone each neighbor and connect it immediately.
            for neighbor in node.neighbors {
                if let neighbor = neighbor {
                    copiedNode.neighbors.append(dfs(neighbor))
                }
            }

            return copiedNode
        }

        return dfs(node)
    }
}

/*
 GPT's summary

 Good:
 - You correctly knew this needs DFS plus an original-node -> cloned-node mapping.
 - You also noticed that neighbors need to point to cloned nodes, not original nodes.

 Mistakes you made:
 - Continuing DFS after finding an existing clone causes infinite recursion on cycles.
 - `let newNeighbors = [Node]()` cannot use `.append`; it must be `var`.
 - A provided LeetCode `Node` class may not be Hashable, so `[Node: Node]` can fail.
 - `nodeDict.contains(node)` is not the normal Dictionary lookup pattern.

 Swift syntax to remember:
 - Check a dictionary key:
   `if nodeDict[key] != nil { }`
 - Use a class instance as a stable dictionary key:
   `ObjectIdentifier(node)`
 - Append requires `var`:
   `var neighbors = [Node?]()`

 Complexity:
 - Time: O(V + E), where V is the number of nodes and E is the number of edges.
 - Space: O(V) for the mapping and recursion stack.
*/