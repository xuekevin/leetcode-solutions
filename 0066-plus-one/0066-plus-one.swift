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
// State needed: start j = digits.count - 1, check if we have carry to left, then j -= 1
// create a new digits to record from the origin's lower to higher
// in the end reversed the array
// Contract:      get the value of each significant for each
// Recall:        landed
// 4 mins start to write 
// 8 mins finish
// need to check
// fix typo after several run failure
// accepted
// submit 


