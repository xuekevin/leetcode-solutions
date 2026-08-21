// ============================================================
// FIX VERSION: Follows your carry + reversed-result approach
// ============================================================

class fixSolution {
    func plusOne(_ digits: [Int]) -> [Int] {
        // Result is initially created from least significant digit
        // to most significant digit.
        var newDigits = [Int]()

        var index = digits.count - 1
        var carry = 1

        while index >= 0 {
            let sum = digits[index] + carry

            carry = sum / 10
            newDigits.append(sum % 10)

            index -= 1
        }

        // Example: [9, 9] becomes [0, 0] with carry 1.
        if carry == 1 {
            newDigits.append(1)
        }

        // reversed() returns a reversed collection, so convert it to [Int].
        return Array(newDigits.reversed())
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Modify a copy and return as soon as the carry stops.
// ============================================================

class Solution {
    func plusOne(_ digits: [Int]) -> [Int] {
        var result = digits

        for index in stride(
            from: result.count - 1,
            through: 0,
            by: -1
        ) {
            if result[index] < 9 {
                // No carry is needed after this addition.
                result[index] += 1
                return result
            }

            // 9 + 1 becomes 0, and the carry continues left.
            result[index] = 0
        }

        // Reaching here means every original digit was 9.
        // Example: [9, 9, 9] becomes [1, 0, 0, 0].
        result.insert(1, at: 0)

        return result
    }
}

// ============================================================
// YOUR ORIGINAL CODE AND THINKING COMMENTS
// Normalized from the pasted HTML/escape formatting.
// ============================================================

/*
class Solution {
    func plusOne(_ digits: [Int]) -> [Int] {
        var newDigits = [Int]()
        var j = digits.count - 1
        var carry = 1

        while j >= 0 {
            var digit = digits[j] + carry
            carry = digit / 10
            newDigits.append(digit % 10)
            j -= 1
        }

        if carry == 1 {
            newDigits.append(1)
        }

        return newDigits.reversed()
    }
}

// Thinking
// need to do the math
// and the output the array int again
// Pattern: Array,
// Card shape: no existing card
// State needed: start j = digits.count - 1,
// check if we have carry to left, then j -= 1
// create a new digits to record from the origin's lower to higher
// in the end reversed the array
// Contract: get the value of each significant for each
// Recall: landed
// 4 mins start to write
// 8 mins finish
// need to check
// fix typo after several run failure
// accepted
// submit, pass
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
WHAT YOU GOT RIGHT:

1. Start from the final digit because addition begins at the lowest
   place value.

2. Initialize carry to 1 because the task is to add one:

       var carry = 1

3. Calculate the current digit and new carry using:

       carry = sum / 10
       digit = sum % 10

4. Add a final 1 when the carry remains after processing all digits.

5. Your time and space approach is valid.


EXAMPLE: [1, 2, 9]

Start:

    carry = 1
    newDigits = []

Process 9:

    sum = 9 + 1 = 10
    carry = 10 / 10 = 1
    digit = 10 % 10 = 0
    newDigits = [0]

Process 2:

    sum = 2 + 1 = 3
    carry = 3 / 10 = 0
    digit = 3 % 10 = 3
    newDigits = [0, 3]

Process 1:

    sum = 1 + 0 = 1
    carry = 0
    digit = 1
    newDigits = [0, 3, 1]

Reverse:

    [1, 3, 0]


EXAMPLE: [9, 9]

Process the final 9:

    newDigits = [0]
    carry = 1

Process the first 9:

    newDigits = [0, 0]
    carry = 1

Append the remaining carry:

    newDigits = [0, 0, 1]

Reverse:

    [1, 0, 0]


SWIFT SYNTAX:

`reversed()` does not necessarily return the same concrete array type.

Use:

    Array(newDigits.reversed())

instead of:

    newDigits.reversed()

Also, `digit` never changes after it is created, so prefer:

    let digit = digits[index] + carry

rather than:

    var digit = digits[index] + carry


WHY THE UPGRADE CAN RETURN EARLY:

If a digit is less than 9, adding one does not create another carry.

Example:

    [1, 2, 3]

The final digit becomes 4:

    [1, 2, 4]

No earlier digit can change, so return immediately.


UPGRADE TRACE: [1, 2, 9]

Start:

    result = [1, 2, 9]

Index 2 is 9:

    result[2] = 0

Result:

    [1, 2, 0]

Index 1 is 2:

    result[1] += 1
    result = [1, 3, 0]

Return immediately.


PATTERN:

    Array traversal + carry

STATE:

    Current index
    Carry, in your version
    Mutable result array, in the upgrade

CONTRACT:

Your version:

    After processing an index, newDigits contains the completed digits
    from the original number's right side in reverse order.

Upgrade:

    At every iteration, all digits to the right of index have already
    been converted to zero because the carry is still active.


COMPLEXITY:

Your fixed version:

    Time:  O(n)
    Space: O(n) for the returned result

Upgrade:

    Time:  O(n) in the worst case
    Space: O(n) for the returned result copy

Ignoring the required output storage, the upgrade uses O(1) additional
working state.
*/