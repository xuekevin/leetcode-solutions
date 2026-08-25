/**
 * Definition for a Node.
 * public class Node {
 *     public var val: Int
 *     public var next: Node?
 *     public var random: Node?
 *     public init(_ val: Int) {
 *         self.val = val
 *         self.next = nil
 *    	   self.random = nil
 *     }
 * }
 */

class Solution {
    func copyRandomList(_ head: Node?) -> Node? {
        if head == nil {
            return nil
        }
        var nodeArr = [Node]()
        var nodeMapping = [Node: Node]()
        var randomIndexArr = [Int]()
        var p = head
        while let node = p {
            let val = node.val
            let newNode = Node(val)
            nodeMapping[node] = newNode
            nodeArr.append(newNode)
            p = node.next
        }

        for i in 0..<nodeArr.count {
            let curNode = nodeArr[i]
            if i == nodeArr.count - 1 {
                curNode.next = nil
            } else {
                curNode.next = nodeArr[i+1]
            }
        }

        p = head
        var index = 0 

        while let node = p {
            let newNode = nodeArr[index]
            if let random = node.random {
                let newRandom = nodeMapping[random]
                newNode.random = newRandom
            } else {
                newNode.random = nil 
            }
            p = node.next
            index += 1
        }

        return nodeArr.first
    }
}
// Thinking
// Spend 2 mins to read the issue
// basically the logic is to do a copy of existing head
// challenge part is the random pointer
// how to find the random pointers
// use example to figure out
// node 1
// create one copy node, as the head node also
// for next node, do the copy create, for random, it pointer to node 1, it has an index
// so we can base index to find the node we want to pointer, but then ew need to do pointer move for each find
// can we avoid this? 
// might can have a helper method, input is the index
// the return is the node
// alerady 12 mins, ready to writ code
// figure out when I am writing
// spend 29 mins
// quick check
// lgtm, 33 mins, ready to run, fix a typo, then pass test case
// ready to submit, 


// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank

