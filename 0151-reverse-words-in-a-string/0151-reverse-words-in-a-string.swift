// ============================================================
// FIX VERSION: Follows your reverse-all, then reverse-word idea
// ============================================================

class fixSolution {
    func reverseWords(_ s: String) -> String {
        // reversed() returns ReversedCollection<String>,
        // so convert it back into a String.
        let reversedString = String(s.reversed())

        // split() removes leading, trailing, and repeated spaces.
        let reversedWords = reversedString.split(separator: " ")

        // Must be var because we append to it.
        var resultWords = [String]()

        for word in reversedWords {
            // Each word is backward because the entire string was reversed.
            // Reverse each word again to restore its characters.
            resultWords.append(String(word.reversed()))
        }

        // Join the words with exactly one space.
        return resultWords.joined(separator: " ")
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Recommended: split words, reverse their order, then join.
// ============================================================

class Solution {
    func reverseWords(_ s: String) -> String {
        return s
            .split(separator: " ")
            .reversed()
            .joined(separator: " ")
    }
}

// ============================================================
// YOUR ORIGINAL CODE AND THINKING COMMENTS
// ============================================================

/*
class Solution {
    func reverseWords(_ s: String) -> String {
        let newStr = s.reversed()

        let newStrArr: [SubString] = newStr.split(" ")
        
        let resultArr = [SubString]()

        for word in newStrArr {
            resultArr.append(word.reversed())
        }

        return String(resultArr)
    }
}

// Thinking 
// I know this has a tricky solution
// reverse the whole string
// the reverse each word which split by the space
// going to write 
// skip writing below, since it is obvious
// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank

// finish writing in 4 mins
// should have some swift synatx issue
// will let gpt fix
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
YOUR LOGIC WAS CORRECT:

Example:

    s = "the sky is blue"

Reverse the entire string:

    "eulb si yks eht"

Split it into words:

    ["eulb", "si", "yks", "eht"]

Reverse each word:

    ["blue", "is", "sky", "the"]

Join them:

    "blue is sky the"


SWIFT MISTAKES:

1. `reversed()` does not return a String.

   This:

       let newStr = s.reversed()

   creates a ReversedCollection<String>.

   Convert it when a String is needed:

       let reversedString = String(s.reversed())


2. The type is `Substring`, not `SubString`.

   Wrong:

       [SubString]

   Correct:

       [Substring]


3. split() requires the separator label.

   Wrong:

       newStr.split(" ")

   Correct:

       newStr.split(separator: " ")


4. resultArr was declared with let.

   Wrong:

       let resultArr = [String]()
       resultArr.append(...)

   `let` arrays cannot be modified.

   Correct:

       var resultArr = [String]()


5. word.reversed() is not a String.

   Wrong:

       resultArr.append(word.reversed())

   Correct:

       resultArr.append(String(word.reversed()))


6. String(resultArr) does not join an array of words.

   Wrong:

       return String(resultArr)

   Correct:

       return resultArr.joined(separator: " ")


WHY split() HANDLES EXTRA SPACES:

Input:

    "  hello   world  "

This:

    s.split(separator: " ")

produces:

    ["hello", "world"]

Empty components are omitted by default.

After reversing and joining:

    "world hello"


WHY THE UPGRADE IS SIMPLER:

The problem only asks us to reverse the order of words.

There is no need to reverse every character first:

    split words
    reverse word order
    join words

Code:

    s.split(separator: " ")
        .reversed()
        .joined(separator: " ")


PATTERN:

    String processing + array reversal

CARD SHAPE:

    Split -> reverse -> join

STATE NEEDED:

    The sequence of words

CONTRACT:

    After splitting, each component is a valid non-empty word.
    After reversing, the words are in the required output order.


COMPLEXITY:

Fix version:

    Time:  O(n)
    Space: O(n)

Upgrade version:

    Time:  O(n)
    Space: O(n)

Both process all characters and create the output string.
*/