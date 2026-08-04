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
//
// class BSTIterator {
//
//     var inorderArr = [Int]()
//     var first = 0
//
//     init(_ root: TreeNode?) {
//         inorder(root)
//     }
//
//     func next() -> Int {
//         let val = inorderArr[first]
//         first += 1
//         return val
//     }
//
//     func hasNext() -> Bool {
//         return first !=  inorderArr.count
//     }
//
//     func inorder(_ root: TreeNode?) {
//         guard let root = root else {
//             return
//         }
//         inorder(root.left)
//         inorderArr.append(root.val)
//         inorder(root.right)
//     }
// }
//
// /**
// - Your BSTIterator object will be instantiated and called as such:
// - let obj = BSTIterator(root)
// - let ret_1: Int = obj.next()
// - let ret_2: Bool = obj.hasNext()
// */
//
// // use 4 mins to read the issue
// // think how to do the next, should be, should be in order traverse
// // a node's next,
// // different cases
// // if it has right node, should be its most right
// // if no right node, and it is the left node of its upper root,
// // if it is right node, and no right, then next is nil
// // or when we init, we should create the inorder, so we can just go through the array to have the next and hasNext info
// // 10 mins so far, now think how to do in order traverse
// // 15 mins finish writing the code
// // quick check,seems correct to me
// // got compiler error, made silly synatx error
// // didn't pass the test case, the code logic has some thing wrong, didn't update the index of next correctly
// // silly mistake below call method after return
// /**
// *
//     
//     func next() -> Int {
//         return inorderArr[first]
//         first += 1
//     }
// */
//
// // fix but found another bug, also silly bug, when decide hasNext
// // should avoid
// // I should more careful next time when I go through my code before submit
// // fixed, now submit passed, 20 mins total
//
//  // Pattern:
// // Card shape: in order traverse
// // State needed:  use a global array to track all the inorder data, also use a var to track the index of the first
// // Contract: this function returns ___ nil
// // Recall: landed

class BSTIterator {
    private var inorderArr = [Int]()
    private var first = 0

    init(_ root: TreeNode?) {
        inorder(root)
    }

    func next() -> Int {
        // Good: advance `first` before returning, so the next call
        // reads the following inorder value.
        let value = inorderArr[first]
        first += 1
        return value
    }

    func hasNext() -> Bool {
        // Good: `<` clearly means there is an unread value remaining.
        return first < inorderArr.count
    }

    private func inorder(_ root: TreeNode?) {
        guard let root = root else {
            return
        }

        // Good: inorder traversal of a BST visits values in sorted order.
        inorder(root.left)
        inorderArr.append(root.val)
        inorder(root.right)
    }
}

// Better version: store only the path to the next smallest node.
class BetterBSTIterator {
    private var stack = [TreeNode]()

    init(_ root: TreeNode?) {
        pushLeftPath(root)
    }

    func next() -> Int {
        let node = stack.removeLast()

        // After visiting node, its right subtree contains the next values.
        pushLeftPath(node.right)

        return node.val
    }

    func hasNext() -> Bool {
        return !stack.isEmpty
    }

    private func pushLeftPath(_ node: TreeNode?) {
        var current = node

        while let node = current {
            stack.append(node)
            current = node.left
        }
    }
}

// GPT's summary:
// What you did well:
// - Your inorder-array solution is correct and passed.
// - You recognized that inorder traversal returns BST values in ascending order.
// - You fixed the important issue: code after `return` never runs.
// - You correctly use an index instead of removing values from the array.
//
// Small correction to your notes:
// - `next()` returns an Int, not nil. The problem guarantees `next()` is
//   called only after `hasNext()` returns true.
//
// Swift syntax to remember:
// - Code after `return` is unreachable.
// - `array.removeLast()` is O(1), unlike `removeFirst()`.
// - `private` keeps helper state and methods inside the iterator class.
//
// Complexity of your accepted version:
// - Initialization: O(n) time and O(n) space.
// - `next()`: O(1).
// - `hasNext()`: O(1).
//
// Complexity of BetterBSTIterator:
// - Initialization: O(h) time and O(h) space, where h is tree height.
// - `next()`: O(1) amortized time.
// - `hasNext()`: O(1).