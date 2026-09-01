// Your original solution:
// class Solution {
//    func ladderLength(_ beginWord: String, _ endWord: String, _ wordList: [String]) -> Int {
//    }
// }
// // Thinking
// // vaguely remembered I saw this issue before in the book, but can't recall in detail
// // corner case if wordList is not contain endWord then return false
// // use example to figure out the solution
// // this is BFS section
// // so compare with beginWord and endWord, character by character
// // notice the difference
// // hit -> cog
// // replace h to c, cit, it doesn't exist in wordList
// // move to next, hit -> hot, it existing in wordList
// // then hot -> cog, then check if hot -> hog, doesn't exist
// // then what's logic to decide which character to replace?
// //  or just bruteforce ?
// // hot, start h -> d and wordList contains it
// // the change to dot, dot -> cog, find can change dot -> dog
// // hard to change this logic to code
// // time is up, let gpt to follow


class Solution {
    func ladderLength(
        _ beginWord: String,
        _ endWord: String,
        _ wordList: [String]
    ) -> Int {
        // Wrong: return false.
        // Why: this function must return an Int length.
        guard wordList.contains(endWord) else {
            return 0
        }

        // A Set gives O(1) average lookup for generated words.
        var availableWords = Set(wordList)

        // Queue item:
        // (current word, number of words in this transformation sequence)
        var queue = [(beginWord, 1)]
        var front = 0

        // If beginWord appears in wordList, do not revisit it later.
        availableWords.remove(beginWord)

        let letters = Array("abcdefghijklmnopqrstuvwxyz")

        while front < queue.count {
            let (currentWord, length) = queue[front]
            front += 1

            // Convert String so we can replace characters by index.
            var characters = Array(currentWord)

            // Try changing each character position.
            for index in 0..<characters.count {
                let originalCharacter = characters[index]

                // Try every possible replacement letter.
                for letter in letters {
                    if letter == originalCharacter {
                        continue
                    }

                    // Make one one-character mutation.
                    characters[index] = letter
                    let nextWord = String(characters)

                    // This one mutation reaches the final word.
                    if nextWord == endWord {
                        return length + 1
                    }

                    // Only words in wordList are valid next steps.
                    if availableWords.contains(nextWord) {
                        queue.append((nextWord, length + 1))

                        // Mark visited immediately when adding to the queue.
                        // This prevents cycles and duplicate work.
                        availableWords.remove(nextWord)
                    }
                }

                // Restore before changing the next position.
                characters[index] = originalCharacter
            }
        }

        return 0
    }
}

/*
 GPT's summary

 Good:
 - You correctly recognized BFS.
 - You correctly saw that a valid next word differs by exactly one character.
 - Brute-forcing each replacement letter is the intended approach.

 Example:
 beginWord = "hit"
 endWord = "cog"
 wordList = ["hot", "dot", "dog", "lot", "log", "cog"]

 BFS levels:
 1: "hit"
 2: "hot"
 3: "dot", "lot"
 4: "dog", "log"
 5: "cog"

 Answer: 5

 How "hit" finds "hot":
 - Change index 0: ait, bit, cit, ...
 - Change index 1: hat, hbt, hct, ...
 - Change index 2: hia, hib, ..., hot, ...
 - "hot" is in wordList, so add it to the queue.

 Important:
 - The answer counts words in the sequence, not transformations.
 - hit -> hot -> dot -> dog -> cog has 5 words.
 - If endWord is missing from wordList, return 0.

 Complexity:
 - Let n = wordList.count and l = word length.
 - Each visited word tries l positions and 26 letters.
 - Time: approximately O(n * l * 26).
 - Space: O(n) for the Set and queue.
*/