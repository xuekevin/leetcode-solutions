// Your original solution:
// class Solution {
//     func lengthOfLongestSubstring(_ s: String) -> Int {
//         // var left = 0
//         // var right = 0
//
//         if s.count == 1 {
//             return 1
//         }
//
//         var arr = [Character]()
//         
//         var maxLength = 0
//
//         for item in s {
//             if !arr.contains(item) {
//                 arr.append(item)
//             } else {
//                 // update the length
//                 maxLength = max(maxLength, arr.count)
//
//                 // decide to move the left
//                 // delete all the items include current duplicate in the arr
//                 // so how to do that?
//                 // maybe I can just get the index of duplicate one
//                 var updateIndex = 0
//                 for (index, value) in arr.enumerated() {
//                     if value == item {
//                         updateIndex = index
//                     }
//                 }
//
//                 var i = 0
//
//                 while i <= updateIndex {
//                     arr.removeFirst()
//                     i += 1
//                 }
//
//                 arr.append(item)
//                 // seems I don't need the left and right
//             }   
//         }
//
//         // update the length
//         maxLength = max(maxLength, arr.count)
//
//         return maxLength
//     }
// }
//
// //# Thoughts
// // to find the longest sub string, thinking use slide window to get the longest one
// // basically, increasing window size if there is no duplicate
// // other wise, we found the substring and then we compare with the longest also shrink the window
// // that's the plan
//
// // 2 mins so far, ready to write code
// // 14 mins finish the code, now use example to verify
// // 2 mins check, seems good to me 
// // ready to run and submit
// // got synatx, because I typo the enumarated 
//
// // try again
// // got Program crashed: Illegal instruction at 0x000055dfbb577fed ***
//
// // because I foget to update i, in the while loop, so it runs forever
// // after that it pass
// // TC O(n)
// // SC O(n)
// // submit , got wrong answer for empty string case,
// // it should return 1,instead of 0
// // and this corner case,
// // still wrong answer, must something wrong
// // seems like I need do // update the length
//                 // maxLength = max(maxLength, arr.count) after go out of the loop
// // now finally passed
// // now pasted in GPT to see the comments

class Solution {
    func lengthOfLongestSubstring(_ s: String) -> Int {
        var window = [Character]()
        var maxLength = 0

        for item in s {
            if !window.contains(item) {
                // Good: if the character is not in the current window, expand the window.
                window.append(item)
            } else {
                // Good: update max before shrinking.
                // Why it works: the current window is valid before adding the duplicate.
                maxLength = max(maxLength, window.count)

                // Good: find the duplicate in the current window.
                // Why it works: we need to remove everything up to and including the old duplicate.
                var duplicateIndex = 0
                for (index, value) in window.enumerated() {
                    if value == item {
                        duplicateIndex = index
                        break
                    }
                }

                var i = 0
                while i <= duplicateIndex {
                    // Watch out: removeFirst() is O(window size), so this version can be slower.
                    // It passes, but the real complexity is not strict O(n) in Swift Array.
                    window.removeFirst()
                    i += 1
                }

                window.append(item)
            }
        }

        // Good: final update is needed.
        // Why it works: the longest substring might be at the end and never hit a duplicate.
        maxLength = max(maxLength, window.count)

        return maxLength
    }
}

// Better version:
class BetterSolution {
    func lengthOfLongestSubstring(_ s: String) -> Int {
        let chars = Array(s)
        var lastSeen = [Character: Int]()
        var left = 0
        var maxLength = 0

        for right in 0..<chars.count {
            let char = chars[right]

            // Correct: if char was seen inside the current window, move left after its old index.
            if let previousIndex = lastSeen[char], previousIndex >= left {
                left = previousIndex + 1
            }

            lastSeen[char] = right
            maxLength = max(maxLength, right - left + 1)
        }

        return maxLength
    }
}

// GPT's summary:
// What you did well:
// - Your sliding window idea was correct.
// - Your window stores the current substring without duplicates.
// - You correctly remove characters through the previous duplicate before appending the current character.
// - You correctly added a final `maxLength` update after the loop.
//
// Mistakes / things to watch:
// - Empty string should return 0, not 1. Your final passed version already returns 0 for empty string.
// - The crash came from forgetting `i += 1`, which made the `while` loop infinite.
// - `arr.contains(item)` is O(k), and `removeFirst()` on Array is also O(k), so this version is not truly O(n).
// - The dictionary version is the standard O(n) sliding window approach.
//
// Swift syntax to remember:
// - `for (index, value) in arr.enumerated()` gives both index and value.
// - `break` exits the loop once you find what you need.
// - `Array(s)` converts String to `[Character]` for integer indexing.
// - Dictionary lookup with `if let previousIndex = lastSeen[char]` safely unwraps an optional.
//
// Complexity:
// - Your version time: O(n * k) in practice, where k is current window size, because `contains` and `removeFirst` scan/shift the array.
// - Better version time: O(n), because each character index is processed once with dictionary lookup.
// - Space: O(k), where k is the number of unique characters in the current window / dictionary.