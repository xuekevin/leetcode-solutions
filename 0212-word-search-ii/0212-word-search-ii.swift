class Solution {
    class TrieNode {
        var children: [Character: TrieNode] = [:]
        var word: String? = nil
    }

    var result = [String]()

    func findWords(_ board: [[Character]], _ words: [String]) -> [String] {
        let root = TrieNode()

        // Build the Trie.
        for word in words {
            var node = root

            for ch in word {
                if node.children[ch] == nil {
                    node.children[ch] = TrieNode()
                }

                node = node.children[ch]!
            }

            // Store the complete word at its final Trie node.
            node.word = word
        }

        var board = board
        let m = board.count
        let n = board[0].count

        // Try every board cell as a possible word start.
        for row in 0..<m {
            for column in 0..<n {
                dfs(row, column, &board, root)
            }
        }

        return result
    }

    func dfs(
        _ row: Int,
        _ column: Int,
        _ board: inout [[Character]],
        _ node: TrieNode
    ) {
        // Check board boundaries first.
        guard row >= 0,
              row < board.count,
              column >= 0,
              column < board[0].count else {
            return
        }

        let ch = board[row][column]

        // Stop if this character does not continue a Trie word.
        guard let nextNode = node.children[ch] else {
            return
        }

        if let word = nextNode.word {
            result.append(word)

            // Avoid adding the same word again from another path.
            nextNode.word = nil
        }

        // Mark this cell as used in this current DFS path.
        board[row][column] = "#"

        dfs(row + 1, column, &board, nextNode)
        dfs(row - 1, column, &board, nextNode)
        dfs(row, column + 1, &board, nextNode)
        dfs(row, column - 1, &board, nextNode)

        // Backtrack: restore the original character.
        board[row][column] = ch
    }
}

/*
GPT's summary

Swift fixes:

1. Dictionary initialization

Wrong:
    var children: [Character: TrieNode] = []

Correct:
    var children: [Character: TrieNode] = [:]

2. `TreeNode` should be `TrieNode`.

Wrong:
    var nextNode: TreeNode?

3. You do not need `nextNode` here.
Swift can directly create or retrieve the child:

    if node.children[ch] == nil {
        node.children[ch] = TrieNode()
    }
    node = node.children[ch]!

4. `board` must be mutable because DFS marks cells as "#".

Correct:
    var board = board

5. `result` was missing.

    var result = [String]()

6. Your DFS parameter was named `s`, but the code used `c`.
Use one consistent name such as `column`.

7. This guard was unnecessary and would not compile:

Wrong:
    guard let node = node else { return }

Why:
- `node` is already a non-optional `TrieNode`.

Time Complexity:
- Building Trie: O(total characters in words)
- DFS: worst case O(m * n * 4^L), where L is the longest word
- Trie pruning makes it much faster in practice.

Space Complexity:
- Trie plus DFS recursion stack.
*/