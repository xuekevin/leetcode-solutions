// ============================================================
// FIXED VERSION: Follows your digit + level approach
// ============================================================

class Solution {
    func intToRoman(_ num: Int) -> String {
        var number = num
        var level = 1
        var result = [String]()

        while number != 0 {
            let digit = number % 10
            result.append(helper(digit, level))
            number /= 10
            level += 1
        }

        // Digits were processed from right to left, so reverse the pieces.
        return result.reversed().joined()
    }

    func helper(_ digit: Int, _ level: Int) -> String {
        let one = ["", "I", "X", "C", "M"]
        let five = ["", "V", "L", "D", ""]
        let ten = ["", "X", "C", "M", ""]

        switch digit {
        case 0:
            return ""
        case 1...3:
            return String(repeating: one[level], count: digit)
        case 4:
            return one[level] + five[level]
        case 5:
            return five[level]
        case 6...8:
            return five[level]
                + String(repeating: one[level], count: digit - 5)
        case 9:
            return one[level] + ten[level]
        default:
            return ""
        }
    }
}

// ============================================================
// UPGRADE VERSION: Greedily subtract the largest Roman value
// ============================================================

/*
class Solution {
    func intToRoman(_ num: Int) -> String {
        let values = [
            1000, 900, 500, 400, 100, 90, 50,
            40, 10, 9, 5, 4, 1
        ]
        let symbols = [
            "M", "CM", "D", "CD", "C", "XC", "L",
            "XL", "X", "IX", "V", "IV", "I"
        ]

        var number = num
        var result = ""

        for i in 0..<values.count {
            while number >= values[i] {
                result += symbols[i]
                number -= values[i]
            }
        }

        return result
    }
}
*/

// ============================================================
// ORIGINAL THINKING
// ============================================================

/*
Thinking:
- Check each place-value digit and convert it to Roman numerals.
- Start from right to left because number % 10 gets the lowest digit.
- Track the current digit, level, remaining number, and result pieces.
- Since num <= 3999, level 4 only needs "M", "MM", or "MMM".

Pattern: Array, String
Card shape: Convert each place-value digit into Roman numerals.
State needed: result, current number, and level.
Recall: half
*/

// ============================================================
// GPT'S SUMMARY
// ============================================================

/*
WHAT WAS CORRECT:

- Processing each decimal digit independently works.
- `number % 10` gets the current lowest digit.
- `number / 10` removes that digit.
- Storing each converted piece and reversing at the end is valid.

SWIFT AND LOGIC MISTAKES:

1. Variable-name typo:
   `resulStr` and `resultStr` must use the same spelling.

2. The helper parameter needs `_` if called without a label:
   func helper(_ digit: Int, _ level: Int)

3. A switch requires braces:
   switch digit {
   case 0:
       ...
   }

4. `reversed()` does not modify an array in place:
   result.reversed()

5. `[String]` cannot be converted with `String(result)`.
   Use:
   result.reversed().joined()

6. Every function returning String must return something on every path.
   Adding `default: return ""` satisfies Swift's return checking.

WHY THE UPGRADE IS BETTER:

- It directly represents all valid Roman symbols.
- It avoids separate logic for every digit and level.
- It is shorter and easier to verify.

Complexity: O(1) time and O(1) auxiliary space because num <= 3999.
*/