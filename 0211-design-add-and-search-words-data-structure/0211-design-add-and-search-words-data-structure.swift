// Your original solution:
// class WordDictionary {
//
//    var dict = [TreeNode]()
//    init() {
//    }
//    func addWord(_ word: String) {
//        var dictArr: [Character] = Array(word)
//    }
//    func search(_ word: String) -> Bool {
//    }
//
//    class TreeNode {
//        var node: Character
//        var children: [TreeNode]
//        var isEnd: Bool
//
//        init() {
//            node = ""
//            children = []
//            isEnd = false
//        }
//    }
// }
//
// /**
//  * Your WordDictionary object will be instantiated and called as such:
//  * let obj = WordDictionary()
//  * obj.addWord(word)
//  * let ret_2: Bool = obj.search(word)
//  */
//
// // Thinking
// // this can be a tree structure
// // can define a TreeNode, like an issue I checked yesterday
// // use example to figure out if it is working
// // have a startNode
// // when I do "addWord"
// // when I do "search"
// // time out, will ask gpt to help
//
// // Pattern:
// // Card shape:
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank


class WordDictionary {
    // The root represents the starting point of every word.
    private let root = TrieNode()

    init() {
    }

    func addWord(_ word: String) {
        var current = root

        for char in word {
            // Create the next child only when it does not exist yet.
            if current.children[char] == nil {
                current.children[char] = TrieNode()
            }

            // Move down one level in the Trie.
            current = current.children[char]!
        }

        // This node represents the final character of a complete word.
        current.isEnd = true
    }

    func search(_ word: String) -> Bool {
        // Convert String to an array so the helper can use an Int index.
        return search(Array(word), 0, root)
    }

    // Contract:
    // Returns true when word[index...] can be matched starting at `node`.
    private func search(
        _ word: [Character],
        _ index: Int,
        _ node: TrieNode
    ) -> Bool {
        // We matched every character.
        // It is only a match if this is the end of a previously added word.
        if index == word.count {
            return node.isEnd
        }

        let char = word[index]

        if char == "." {
            // '.' can represent any one letter.
            // Try every possible child node.
            for child in node.children.values {
                if search(word, index + 1, child) {
                    return true
                }
            }

            return false
        }

        // Normal character: follow only its matching child node.
        guard let nextNode = node.children[char] else {
            return false
        }

        return search(word, index + 1, nextNode)
    }

    private class TrieNode {
        // Wrong: `var node: Character` with `node = ""`.
        // Why: `""` is a String, not a Character.
        //
        // Correct: we do not need to store a character in each node.
        // The dictionary key already tells us which letter leads to this node.
        var children = [Character: TrieNode]()

        // True means an inserted word ends at this node.
        var isEnd = false
    }
}

/*
 GPT's summary

 Good:
 - You correctly identified that this problem needs a tree structure.
 - The tree is a Trie: one level for each letter in a word.
 - `isEnd` is needed so "bad" does not accidentally make "ba" a valid word.

 Key idea:
 - addWord("bad"):
   root -> "b" -> "a" -> "d", then mark "d".isEnd = true.
 - search("bad"):
   follow b, then a, then d.
 - search(".ad"):
   '.' tries every root child, then continues with a and d.

 Mistakes you were close to:
 - `children: [TreeNode]` would require manually searching every child
   to find a letter.
 - `[Character: TrieNode]` directly maps each letter to its child.
 - `.` cannot follow one fixed child; it must recursively try all children.

 Swift syntax to remember:
 - Dictionary lookup:
   `current.children[char]`
 - Dictionary values:
   `for child in node.children.values { }`
 - Convert a String for integer indexing:
   `let characters = Array(word)`

 Complexity:
 - addWord: O(n), where n is the word length.
 - search without '.': O(n).
 - search with '.': can branch through the Trie; worst case O(26^n).
*/