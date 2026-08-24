/*
YOUR ORIGINAL SOLUTION:

class Solution {
    func isPalindrome(_ x: Int) -> Bool {
        if x < 0 {
            return false
        }

        var leftToRightArr = [Int]()
        var rightToLeftArr = [Int]()

        var num = x

        while num != 0 {
            let cur = num % 10
            rightToLeftArr.append(cur)

            if leftToRightArr.count == 0 {
                leftToRightArr.append(cur)
            } else {
                leftToRightArr.insert(cur, at: 0)
            }

            num = num / 10
        }

        return leftToRightArr == rightToLeftArr
    }
}

// Thinking
// math issue
// first if it is negative,
// it is not palindrome
// start writing quickly
// finish writing as above
// 7 mins
// might have swift synatx issue
// submited in 8
// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/


// FIX/REVIEW VERSION:
// Your solution is correct and has no Swift syntax errors.

class fixSolution {
    func isPalindrome(_ x: Int) -> Bool {
        // Good: negative integers cannot be palindromes because
        // their decimal representation begins with "-".
        if x < 0 {
            return false
        }

        var originalOrder = [Int]()
        var reversedOrder = [Int]()
        var number = x

        while number != 0 {
            let digit = number % 10

            // Reading digits with `% 10` produces them from right to left.
            reversedOrder.append(digit)

            // Inserting each digit at the beginning reconstructs the
            // original left-to-right order.
            originalOrder.insert(digit, at: 0)

            // Remove the last digit.
            number /= 10
        }

        // Swift arrays support element-by-element equality comparison.
        //
        // For x == 0, both arrays are empty, so this correctly returns true.
        return originalOrder == reversedOrder
    }
}


// GPT'S UPGRADE VERSION:
// Reverse only half of the number.
// This uses O(1) extra space and avoids possible full-number overflow.

class Solution {
    func isPalindrome(_ x: Int) -> Bool {
        // Negative values are not palindromes.
        //
        // Any positive number ending in 0 is also not a palindrome,
        // because its first digit cannot be 0.
        // The number 0 itself is an exception.
        if x < 0 || (x % 10 == 0 && x != 0) {
            return false
        }

        var firstHalf = x
        var reversedSecondHalf = 0

        // Stop after reversing approximately half the digits.
        while firstHalf > reversedSecondHalf {
            let lastDigit = firstHalf % 10

            reversedSecondHalf =
                reversedSecondHalf * 10 + lastDigit

            firstHalf /= 10
        }

        // Even number of digits:
        // 1221 -> firstHalf = 12, reversedSecondHalf = 12
        //
        // Odd number of digits:
        // 12321 -> firstHalf = 12, reversedSecondHalf = 123
        //
        // For an odd digit count, remove the middle digit with `/ 10`.
        return firstHalf == reversedSecondHalf ||
               firstHalf == reversedSecondHalf / 10
    }
}


/*
GPT'S SUMMARY

What you did well:
- Your solution is logically correct and passes.
- You correctly rejected negative numbers.
- You correctly extracted digits with `% 10`.
- You correctly removed processed digits with `/ 10`.
- Swift can directly compare two `[Int]` arrays using `==`.

Small improvement to your version:
- You do not need a special case before calling `insert`.
- `array.insert(value, at: 0)` also works when the array is empty.

Performance issue:
- `insert(digit, at: 0)` is O(d), because Swift must shift every existing
  element one position to the right.
- Calling it once per digit makes your total time O(d²), where d is the
  number of digits.

Upgrade idea:
- Reverse only the second half of the number.
- Compare the reversed second half with the remaining first half.
- For an odd number of digits, ignore the middle digit using `/ 10`.

Pattern:
- Math / digit manipulation.

State needed:
- `firstHalf`: the unprocessed beginning of the number.
- `reversedSecondHalf`: the processed ending in reverse order.

Loop contract:
- At the top of each iteration, `firstHalf` contains the remaining
  leading digits, and `reversedSecondHalf` contains the removed trailing
  digits in reverse order.

Complexity:

Fix version:
- Time: O(d²) because of repeated insertion at index 0.
- Space: O(d).

Upgrade version:
- Time: O(d).
- Space: O(1).
*/