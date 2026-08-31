// Your original solution:
// class Solution {
//    func fullJustify(_ words: [String], _ maxWidth: Int) -> [String] {
//    }
// }
//
// // Thinking
// // maxWidth decide how many word we can put in one line
// // for loop the words, words[i]
// // sum the current words, and compare with maxWidth
// // as long as i smaller, keep add in cur line
// // if it > maxWidth, then don't add to cur line, then caculate how many space left, and how many words we have so for
// // then we can caculate the seperation of space, we can first know how many separate we have then we can caulation the space count for each separation
// // after that move th line of 2
// // then move to line of 3
// // this logic seems pretty straight forward to me
// // 5 mins so far
// // will ask gpt to finish remaining
//
// // Pattern:
// // Card shape:
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank


class Solution {
    func fullJustify(_ words: [String], _ maxWidth: Int) -> [String] {
        var result = [String]()
        var start = 0

        while start < words.count {
            var end = start
            var lettersCount = 0

            // Add as many words as this line can fit.
            //
            // `end - start` is the minimum number of spaces needed
            // between words already chosen for this line.
            while end < words.count &&
                lettersCount + words[end].count + (end - start) <= maxWidth {
                lettersCount += words[end].count
                end += 1
            }

            let wordsInLine = end - start
            let isLastLine = end == words.count
            var line = ""

            // Last line and one-word lines are left-justified.
            if isLastLine || wordsInLine == 1 {
                for i in start..<end {
                    if i > start {
                        line += " "
                    }

                    line += words[i]
                }

                // Add trailing spaces until this line reaches maxWidth.
                line += String(repeating: " ", count: maxWidth - line.count)
            } else {
                // Total whitespace that must be placed between words.
                let totalSpaces = maxWidth - lettersCount

                // Example: 4 words create 3 gaps.
                let gaps = wordsInLine - 1

                // Every gap receives at least this many spaces.
                let spacesPerGap = totalSpaces / gaps

                // Extra spaces go into earlier gaps first.
                let extraSpaces = totalSpaces % gaps

                for i in start..<end {
                    line += words[i]

                    // Do not add spaces after the last word.
                    if i < end - 1 {
                        let gapIndex = i - start

                        // Earlier gaps get one extra space.
                        let spacesForThisGap = spacesPerGap +
                            (gapIndex < extraSpaces ? 1 : 0)

                        line += String(
                            repeating: " ",
                            count: spacesForThisGap
                        )
                    }
                }
            }

            result.append(line)

            // Start building the next line.
            start = end
        }

        return result
    }
}

/*
 GPT's summary

 Good:
 - Your overall plan was correct:
   build one line, calculate its spaces, then move to the next line.
 - You correctly recognized that word count determines the number of gaps.

 Key ideas:
 - Fit words while:
   lettersCount + minimum required gaps <= maxWidth
 - If there are 4 words, there are 3 gaps.
 - For normal lines, distribute spaces as evenly as possible.
 - Any remaining extra spaces go to the leftmost gaps.
 - The final line is left-justified, not evenly justified.

 Example:
 words = ["This", "is", "an", "example"]
 maxWidth = 16

 Suppose a line has:
 "This", "is", "an"

 lettersCount = 4 + 2 + 2 = 8
 totalSpaces = 16 - 8 = 8
 gaps = 2

 spacesPerGap = 8 / 2 = 4
 extraSpaces = 8 % 2 = 0

 Result:
 "This    is    an"

 Swift syntax to remember:
 - Repeat spaces:
   `String(repeating: " ", count: numberOfSpaces)`
 - Integer division:
   `totalSpaces / gaps`
 - Remainder:
   `totalSpaces % gaps`

 Complexity:
 - Time: O(total number of characters written)
 - Space: O(total output size)
*/