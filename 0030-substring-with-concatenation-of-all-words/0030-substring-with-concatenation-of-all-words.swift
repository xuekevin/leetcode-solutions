// Your original solution:
// class Solution {
//    func findSubstring(_ s: String, _ words: [String]) -> [Int] {
//    }
// }
//
// // Thinking
// // spend 2 mins to read the isue
// // basically for loop the s
// // the find the string item in words
// // after for loop then if can't find return []
// // so need to main the start points
// // because words are same length string item
// // so we can use that string length as the unit window to search in s
// // traverse in s
// // i = 0 find the subString s[i..i+wordItem.count-1], not sure how to write in swift, write as curStr
// // then to see if words contains curStr, if it is, then we can first record the index of the i, then first word we found, as start
// // also we mentioned a isVisited Dict, if the word has been visited we should skip
// // now keep move i = i+wordItem.count, until we find all word in words
// // if we can't find, then we should change the i to start from start+1
// // this is kind of like bruteforce
// // the TC should be pretty big, find a start the do O(n), then restart, so can be O(n^2)
// // SC is the dictionary I mentioned above
// // time is up, 10 mins
// // will let gpt to figure out the remaining


class Solution {
    func findSubstring(_ s: String, _ words: [String]) -> [Int] {
        guard !s.isEmpty, !words.isEmpty else {
            return []
        }

        let wordLength = words[0].count
        let wordCount = words.count
        let totalLength = wordLength * wordCount
        let characters = Array(s)

        guard totalLength <= characters.count else {
            return []
        }

        // Count every required word.
        //
        // Wrong: a Boolean visited dictionary.
        // Why: words may contain duplicates, such as ["foo", "foo"].
        var targetCount = [String: Int]()

        for word in words {
            targetCount[word, default: 0] += 1
        }

        var result = [Int]()

        // There are `wordLength` possible word alignments.
        //
        // For word length 3:
        // offset 0: [0...2], [3...5], [6...8]
        // offset 1: [1...3], [4...6], [7...9]
        // offset 2: [2...4], [5...7], [8...10]
        for offset in 0..<wordLength {
            var left = offset
            var right = offset

            // Count words currently inside this window.
            var windowCount = [String: Int]()
            var matchedWords = 0

            // Grow the window one whole word at a time.
            while right + wordLength <= characters.count {
                let word = String(characters[right..<(right + wordLength)])
                right += wordLength

                if let allowedCount = targetCount[word] {
                    // Add this word to the current window.
                    windowCount[word, default: 0] += 1
                    matchedWords += 1

                    // Too many copies of `word`.
                    // Shrink from the left until this word is valid again.
                    while windowCount[word, default: 0] > allowedCount {
                        let leftWord = String(
                            characters[left..<(left + wordLength)]
                        )

                        windowCount[leftWord, default: 0] -= 1
                        matchedWords -= 1
                        left += wordLength
                    }

                    // The window contains exactly all required words.
                    if matchedWords == wordCount {
                        result.append(left)
                    }
                } else {
                    // This word is not in `words`.
                    // No valid concatenation can include it.
                    windowCount.removeAll()
                    matchedWords = 0
                    left = right
                }
            }
        }

        return result
    }
}

/*
 GPT's summary

 Good:
 - You noticed all words have the same length.
 - That means we should move through `s` in word-sized units.
 - You also recognized that restarting from every start index is brute force.

 Key idea:
 - Build `targetCount` from `words`.
 - Scan `s` with a sliding window of whole words.
 - If a word appears too many times, remove words from the left.
 - If the window contains exactly `words.count` valid words,
   its left index is an answer.

 Example:
 s = "barfoothefoobarman"
 words = ["foo", "bar"]

 targetCount:
 "foo": 1
 "bar": 1

 At index 0:
 ["bar", "foo"] is valid.
 Add 0.

 At index 9:
 ["foo", "bar"] is valid.
 Add 9.

 Result:
 [0, 9]

 Swift syntax to remember:
 - Convert a String for integer-based slicing:
   `let characters = Array(s)`
 - Build a substring from a Character slice:
   `String(characters[start..<end])`
 - Increment a dictionary count:
   `dict[key, default: 0] += 1`

 Complexity:
 - Let n = s.count, m = words.count, and l = word length.
 - Time: O(n) word-window operations, with O(l) to build each String slice.
 - Space: O(m) for the frequency dictionaries.
*/