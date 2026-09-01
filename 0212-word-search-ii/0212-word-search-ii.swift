// Your original solution:
// class Solution {
//    func findWords(_ board: [[Character]], _ words: [String]) -> [String] {
//    }
// }
//
// // Thinking
// // so this is about to find words in the boards
// // so where to start
// // start from [i][j] in board
// // if it is == word[index], then start to see if it match in all 4 directions
// // if it doesn't the move i, j, then do it again, until we find
// // kind like DFS
// // need maintain the index about current match
// // then once we find all, then store it in the output result


class Solution {
    func findWords(_ board: [[Character]], _ words: [String]) -> [String] {
        guard !board.isEmpty, !board[0].isEmpty else {
            return []
        }

        // Build one Trie containing every word.
        let root = TrieNode()

        for word in words {
            var current = root

            for char in word {
                if current.children[char] == nil {
                    current.children[char] = TrieNode()
                }

                current = current.children[char]!
            }

            // A non-nil word means this Trie path is a complete word.
            current.word = word
        }

        // Make a mutable local copy so DFS can mark a cell as used.
        var board = board
        var result = [String]()

        func dfs(_ row: Int, _ column: Int, _ node: TrieNode) {
            // Stop outside the board.
            if row < 0 || row >= board.count ||
                column < 0 || column >= board[0].count {
                return
            }

            let char = board[row][column]

            // '#' means this cell is already used in the current word path.
            if char == "#" {
                return
            }

            // If the current character is not a Trie child,
            // no word can continue from this path.
            guard let nextNode = node.children[char] else {
                return
            }

            // Found one complete word.
            if let word = nextNode.word {
                result.append(word)

                // Prevent adding the same word again from another board path.
                nextNode.word = nil
            }

            // Mark this cell as used before moving to neighbors.
            board[row][column] = "#"

            // Search all four directions.
            dfs(row - 1, column, nextNode)
            dfs(row + 1, column, nextNode)
            dfs(row, column - 1, nextNode)
            dfs(row, column + 1, nextNode)

            // Backtrack: restore the cell for other DFS paths.
            board[row][column] = char
        }

        // Start DFS from every board cell.
        for row in 0..<board.count {
            for column in 0..<board[0].count {
                dfs(row, column, root)
            }
        }

        return result
    }

    private class TrieNode {
        // Each letter points to the next prefix node.
        var children = [Character: TrieNode]()

        // Non-nil only when a full word ends at this node.
        var word: String?
    }
}

/*
 GPT's summary

 Good:
 - Your main search idea is correct:
   start at each board cell, then DFS in four directions.
 - You correctly identified the needed state:
   current word position / current matched prefix.

 Why use a Trie:
 - Calling DFS separately for every word repeats shared prefixes.
 - Example:
   "oath" and "oak" both start with "oa".
 - The Trie lets one DFS path check all words sharing that prefix.

 DFS contract:
 dfs(row, column, node) means:
 - We are standing at board[row][column].
 - `node` represents the prefix matched before this cell.
 - Try to move into the Trie child matching this cell's character.

 Backtracking:
 - Change board[row][column] to "#".
 - This prevents reusing the same cell in one word.
 - Search four neighbors.
 - Restore the original character before returning.

 Duplicate prevention:
 - `nextNode.word = nil`
 - A word may be found through more than one path.
 - After adding it once, set it to nil so it is not added again.

 Complexity:
 - Building the Trie: O(total characters in words).
 - DFS worst case: O(rows * columns * 4^L),
   where L is the longest word length.
 - The Trie prunes paths that are not prefixes of any requested word.
*/