// Your original solution:
// class Solution {
//    func minWindow(_ s: String, _ t: String) -> String {
//    }
// }
//
// // Thinking
// // how to find the minimum
// // first find the t then shrink the window
// // how to setup slide window
// // just contains the character, no need to maintain the order
// // main the left and right, once we find all t character, we update current output
// // then we can shrink the window, move left, if we removed the t character, then we can keep shink until we meeting anothter t character, then can start to move right, to see we can find the removed character, if it is, then deside if we can update the current output, if not, remove the left t character, until we find another t charcter, then keep moving right, unless we can't
// // some corner case, if s.count < t.count
// // return ""
// // pretty much my thought
// // the TC should be O(n), no back direction search
// // Pattern:
// // Card shape:
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank


class Solution {
    func minWindow(_ s: String, _ t: String) -> String {
        guard s.count >= t.count else {
            return ""
        }

        // Convert String so we can use Int indexes safely.
        let characters = Array(s)

        // requiredCount stores how many copies of each character t needs.
        //
        // Example: t = "AABC"
        // requiredCount = ["A": 2, "B": 1, "C": 1]
        var requiredCount = [Character: Int]()

        for char in t {
            requiredCount[char, default: 0] += 1
        }

        // Number of distinct character types that must be satisfied.
        let requiredKinds = requiredCount.count

        // Count characters currently inside the sliding window.
        var windowCount = [Character: Int]()

        var left = 0
        var formedKinds = 0

        // Track the best valid window found so far.
        var minStart = 0
        var minLength = Int.max

        for right in 0..<characters.count {
            let rightChar = characters[right]

            // Expand the window by adding the right character.
            windowCount[rightChar, default: 0] += 1

            // This character type becomes fully satisfied.
            if let required = requiredCount[rightChar],
               windowCount[rightChar] == required {
                formedKinds += 1
            }

            // The window contains every character required by t.
            while formedKinds == requiredKinds {
                // Record this valid window before shrinking it.
                let currentLength = right - left + 1

                if currentLength < minLength {
                    minLength = currentLength
                    minStart = left
                }

                // Shrink the window by removing its left character.
                let leftChar = characters[left]
                windowCount[leftChar, default: 0] -= 1

                // Removing this character made the window invalid.
                if let required = requiredCount[leftChar],
                   windowCount[leftChar, default: 0] < required {
                    formedKinds -= 1
                }

                left += 1
            }
        }

        // No valid window was ever found.
        guard minLength != Int.max else {
            return ""
        }

        // Convert the best Character range back into a String.
        return String(characters[minStart..<(minStart + minLength)])
    }
}

/*
 GPT's summary

 Good:
 - Your main plan was correct:
   expand right -> find a valid window -> shrink left.
 - Character order does not matter.
 - You correctly identified the `s.count < t.count` corner case.

 Important detail:
 - This is not only about whether a character exists.
 - You must count duplicates.

 Example:
 t = "AABC"

 A valid window needs:
 A: 2
 B: 1
 C: 1

 A window containing only "ABC" is not valid because it has only one A.

 State needed:
 - requiredCount: character frequencies required by t.
 - windowCount: character frequencies in the current window.
 - formedKinds: how many distinct required characters currently have
   enough copies in the window.
 - left: beginning of the current window.
 - minStart and minLength: best answer seen so far.

 Why it is O(n):
 - `right` moves from left to right once.
 - `left` also moves from left to right once.
 - Neither pointer moves backward.

 Complexity:
 - Time: O(s.count + t.count)
 - Space: O(s.count + t.count) in this Swift version because of
   `Array(s)` and the dictionaries.
*/