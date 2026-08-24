/*
YOUR ORIGINAL SOLUTION:

class Trie {
    init() {
    }

    func insert(_ word: String) {
    }

    func search(_ word: String) -> Bool {
    }

    func startsWith(_ prefix: String) -> Bool {
    }
}

/**
 * Your Trie object will be instantiated and called as such:
 * let obj = Trie()
 * obj.insert(word)
 * let ret_2: Bool = obj.search(word)
 * let ret_3: Bool = obj.startsWith(prefix)
 */

// Thinking
// Since it mentioned it about tree
// so need to figure out how to "use" tree to store
// or nothing related to tree
// quesiton is how to find prefix
// like give a prefix, I can find where this stored
// can like a dictionary cateloge
// use example to figure out
// for loop apple
// if a map we have stored any, if it is, then check under a map's if we have p store under
// then how to count whether we have or not
// if letter a-z has 26 dictionary
// apple, can get corresponding numbers 1,
// store corresponding number as the index for the word we insert
// when do search we can just check the number chaino numberstring
// but how to check "start with"
// check any existing string whether then has sub string
// like we ask apple, does it have sub string app?
// how to confirm?
// already 16 mins, give up

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/


// FIX VERSION:
// Your dictionary-catalog idea was the correct direction.

// Each TrieNode represents one position in the Trie.
final class TrieNode {
    // The key is the next character.
    // The value is the child node reached through that character.
    var children = [Character: TrieNode]()

    // This distinguishes a complete word from only a prefix.
    var isWord = false
}

class fixTrie {
    // The root does not represent a character.
    // It is the starting point for every word.
    private let root = TrieNode()

    init() {}

    func insert(_ word: String) {
        var currentNode = root

        for character in word {
            // If this character does not have a path yet,
            // create a new child node.
            if currentNode.children[character] == nil {
                currentNode.children[character] = TrieNode()
            }

            // Dictionary lookup returns TrieNode?.
            // It is safe to force unwrap because the node was either
            // already present or created immediately above.
            currentNode = currentNode.children[character]!
        }

        // Mark only the final node as a complete word.
        currentNode.isWord = true
    }

    func search(_ word: String) -> Bool {
        var currentNode = root

        for character in word {
            guard let nextNode = currentNode.children[character] else {
                return false
            }

            currentNode = nextNode
        }

        // The character path must exist and end at a complete word.
        return currentNode.isWord
    }

    func startsWith(_ prefix: String) -> Bool {
        var currentNode = root

        for character in prefix {
            guard let nextNode = currentNode.children[character] else {
                return false
            }

            currentNode = nextNode
        }

        // We only need the path to exist.
        // It does not need to end at a complete word.
        return true
    }
}


// GPT'S UPGRADE VERSION:
// `search` and `startsWith` perform the same traversal.
// This version extracts that repeated logic into `findNode`.

final class Node {
    var children = [Character: Node]()
    var isWord = false
}

class Trie {
    private let root = Node()

    init() {}

    func insert(_ word: String) {
        var node = root

        for character in word {
            // Use the existing child or create a new one.
            if let child = node.children[character] {
                node = child
            } else {
                let newNode = Node()
                node.children[character] = newNode
                node = newNode
            }
        }

        node.isWord = true
    }

    func search(_ word: String) -> Bool {
        // The path must exist and represent a complete word.
        return findNode(word)?.isWord == true
    }

    func startsWith(_ prefix: String) -> Bool {
        // The path only needs to exist.
        return findNode(prefix) != nil
    }

    // Contract:
    // Return the node at the end of `text` if the entire path exists.
    // Otherwise, return nil.
    private func findNode(_ text: String) -> Node? {
        var node = root

        for character in text {
            guard let child = node.children[character] else {
                return nil
            }

            node = child
        }

        return node
    }
}


/*
GPT'S EXAMPLE: INSERT "apple"

The root begins empty:

    root

Read "a":
- root has no "a" child.
- Create one.

    root
      |
      a

Read the first "p":
- The "a" node has no "p" child.
- Create one.

    root
      |
      a
      |
      p

Continue with "p", "l", and "e":

    root
      |
      a
      |
      p
      |
      p
      |
      l
      |
      e  <- isWord = true

Only the "e" node is marked as a complete word.


SEARCH "apple"

Follow this path:

    root -> a -> p -> p -> l -> e

The path exists, and the final node has:

    isWord == true

Therefore `search("apple")` returns true.


SEARCH "app"

Follow this path:

    root -> a -> p -> p

The path exists, but the final "p" node has:

    isWord == false

Therefore `search("app")` returns false.


STARTS WITH "app"

Follow this path:

    root -> a -> p -> p

The entire path exists. `startsWith` does not care whether the final
node is marked as a complete word.

Therefore `startsWith("app")` returns true.


AFTER INSERTING "app"

The same final "p" node becomes:

    isWord = true

Now both are true:

    search("app")       == true
    startsWith("app")   == true


GPT'S SUMMARY

Your correct initial idea:
- You described the Trie as a dictionary catalog.
- That is exactly the right model.
- Each node stores a dictionary from a character to its next node.
- A word is represented by a chain of nodes.

The important missing state:
- A path existing does not necessarily mean the path is a complete word.
- Each node needs an `isWord` Boolean.

Why `isWord` is necessary:

If only "apple" was inserted, the path for "app" exists because it is
part of "apple".

However:

    search("app")       should return false
    startsWith("app")   should return true

The character path alone cannot distinguish these operations.
`isWord` solves that distinction.

Why this is a tree:
- The root can have multiple children, such as "a", "b", and "c".
- Every child can have its own children.
- Words with the same prefix share the same beginning path.

Example:

Inserted words:

    app
    apple
    apply

Shared Trie:

    root
      |
      a
      |
      p
      |
      p  <- "app" ends here
      |
      l
     / \
    e   y
    ^   ^
 apple apply

Swift syntax to remember:

Dictionary from a character to a node:

    var children = [Character: Node]()

Dictionary lookup returns an optional:

    if let child = node.children[character] {
        node = child
    }

Create or update a dictionary entry:

    node.children[character] = Node()

Check whether an optional node exists:

    findNode(prefix) != nil

Check whether a found node marks a word:

    findNode(word)?.isWord == true

Why Node must be a class:
- Trie nodes need reference behavior.
- Multiple variables should be able to refer to and modify the same node.
- Swift classes are reference types.

Pattern:
- Trie / prefix tree.

State needed:
- `root`: entry point for all words.
- `children`: next available characters from each node.
- `isWord`: whether the current node ends a complete inserted word.

Complexity:
- Let L be the length of the input word or prefix.
- insert: O(L) time.
- search: O(L) time.
- startsWith: O(L) time.
- Total space: O(total number of inserted characters) in the worst case.
*/