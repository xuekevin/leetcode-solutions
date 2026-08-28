/*
YOUR ORIGINAL SOLUTION:

class LRUCache {
    init(_ capacity: Int) {
    }

    func get(_ key: Int) -> Int {
    }

    func put(_ key: Int, _ value: Int) {
    }
}

/**
 * Your LRUCache object will be instantiated and called as such:
 * let obj = LRUCache(capacity)
 * let ret_1: Int = obj.get(key)
 * obj.put(key, value)
 */

// Thinking

// get and put run in O(1)
// get be O(1), so can use a dictionary to store
// when put, also can use dictionary
// but how to track the capacity
// the size of the dict
// evict the least recently used key
// so need to sort the least recently used key
// how to do  this, keep track the last used time?
// or used a queue to track, the node, newly added put in the first,
// every time get, also remove it to the first, but need to move in
// the data structure
// this is LinkedList section
// so we can use LinkedList to track the LRU
// how it work
// put, the first point to the node
// the keep put, add the new one
// when get, move the current put in the end of linkedList
// how to find the pointer, store the dictionary I mentioned early
// and also can find its previous and next
// the move to the end of linkedList
// every time we need to evict we just move the linkedlist head to next
// this logic is pretty straightward, will let gpt to fix

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/


class LRUCache {
    // A doubly linked list is necessary:
    // it can remove a known node in O(1).
    private final class Node {
        var key: Int
        var value: Int
        var previous: Node?
        var next: Node?

        init(_ key: Int = 0, _ value: Int = 0) {
            self.key = key
            self.value = value
        }
    }

    private let capacity: Int
    private var nodesByKey = [Int: Node]()

    // `leastRecent` and `mostRecent` are sentinel nodes.
    // Real nodes always live between them.
    private let leastRecent = Node()
    private let mostRecent = Node()

    init(_ capacity: Int) {
        self.capacity = capacity

        leastRecent.next = mostRecent
        mostRecent.previous = leastRecent
    }

    func get(_ key: Int) -> Int {
        guard let node = nodesByKey[key] else {
            return -1
        }

        // Accessing a node makes it most recently used.
        moveToMostRecent(node)

        return node.value
    }

    func put(_ key: Int, _ value: Int) {
        if let existingNode = nodesByKey[key] {
            // Updating an existing key also counts as using it.
            existingNode.value = value
            moveToMostRecent(existingNode)
            return
        }

        let newNode = Node(key, value)
        nodesByKey[key] = newNode
        addAsMostRecent(newNode)

        if nodesByKey.count > capacity {
            // The first real node is the least recently used node.
            let nodeToRemove = leastRecent.next!

            remove(nodeToRemove)
            nodesByKey.removeValue(forKey: nodeToRemove.key)
        }
    }

    private func moveToMostRecent(_ node: Node) {
        remove(node)
        addAsMostRecent(node)
    }

    private func remove(_ node: Node) {
        // Sentinel nodes guarantee these pointers exist for real nodes.
        node.previous!.next = node.next
        node.next!.previous = node.previous
    }

    private func addAsMostRecent(_ node: Node) {
        // Insert directly before the most-recent sentinel.
        node.previous = mostRecent.previous
        node.next = mostRecent

        mostRecent.previous!.next = node
        mostRecent.previous = node
    }
}


/*
GPT'S SUMMARY

What you did well:
- Your overall design is exactly right.
- Dictionary provides O(1) key-to-node lookup.
- A linked list tracks recency order.
- `get` moves the accessed node to the most-recent end.
- When capacity is exceeded, remove the least-recent node.
- The dictionary must store the node itself, not only its value.

Why a doubly linked list is required:

A singly linked list can find a node through the dictionary, but it
cannot remove that node in O(1), because it does not know the previous
node.

A doubly linked list stores both:

    node.previous
    node.next

So removal is always:

    node.previous!.next = node.next
    node.next!.previous = node.previous


LIST ORDER

    leastRecent <-> ... real nodes ... <-> mostRecent

The two ends are sentinel nodes. They are not cache entries.

The first real node:

    leastRecent.next

is the least recently used item.

The final real node:

    mostRecent.previous

is the most recently used item.


EXAMPLE: capacity = 2

    put(1, 1)

    leastRecent <-> [1] <-> mostRecent

    put(2, 2)

    leastRecent <-> [1] <-> [2] <-> mostRecent

    get(1)

Move 1 to the most-recent end:

    leastRecent <-> [2] <-> [1] <-> mostRecent

    put(3, 3)

The cache exceeds capacity, so evict the first real node, 2:

    leastRecent <-> [1] <-> [3] <-> mostRecent

    get(2) returns -1


STATE NEEDED

    nodesByKey:
    Maps every key directly to its linked-list node.

    leastRecent:
    Sentinel before the least recently used real node.

    mostRecent:
    Sentinel after the most recently used real node.

    capacity:
    Maximum number of real nodes allowed.


CONTRACT

At every moment:
- Every dictionary node appears exactly once in the linked list.
- The list is ordered from least recently used to most recently used.
- `leastRecent.next` is the eviction candidate.
- `mostRecent.previous` is the newest or most recently accessed node.

COMPLEXITY

    get: O(1)
    put: O(1)
    space: O(capacity)
*/