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

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank