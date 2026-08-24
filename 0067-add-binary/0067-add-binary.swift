/*
YOUR ORIGINAL SOLUTION:

class Solution {
    func addBinary(_ a: String, _ b: String) -> String {
        let aArr = Array(a)
        let bArr = Array(b)

        var x = aArr.count - 1
        var y = bArr.count - 1

        var resultArr = [Int]()
        var carry: Int = 0

        while x >= 0 && y >= 0 {
            let xItem = Int(aArr[x])
            let yItem = Int(aArr[y])
            let resItem = xItem ^ yItem ^ carry
            carry = xItem & yItem
            resultArr.append(resItem)
            x -= 1
            y -= 1
        }

        while x >= 0 {
            let xItem = Int(aArr[x])
            let resItem = xItem ^ carry
            carry = xItem & carry
            resultArr.append(resItem)
            x -= 1
        }

        while y >= 0 {
            let yItem = Int(aArr[y])
            let resItem = yItem ^ carry
            carry = yItem & carry
            resultArr.append(resItem)
            y -= 1
        }

        if carry != 0 {
            resultArr.append(carry)
        }

        return String(resultArr.reversed())
    }
}

// Thinking
// convert to arr
// then do the math
// after that then convert back to the string
// start writing directly
// finish writing in 15 mins
// start to check, fix several bugs
// start to use example to verify
// pass example 1
// going to run
// cause compile error
// will let gpt to fix

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/


// FIX VERSION:
// Preserves your separate-loop and bit-operation approach.

class fixSolution {
    func addBinary(_ a: String, _ b: String) -> String {
        let aArray = Array(a)
        let bArray = Array(b)

        var x = aArray.count - 1
        var y = bArray.count - 1
        var carry = 0
        var result = [Int]()

        while x >= 0 && y >= 0 {
            // Wrong: Int(aArray[x])
            // Why: aArray[x] is Character, but this initializer expects
            // a String representation here.
            // Correct: Int(String(aArray[x]))!
            let xValue = Int(String(aArray[x]))!
            let yValue = Int(String(bArray[y]))!

            // XOR gives the current result bit.
            let resultBit = xValue ^ yValue ^ carry

            // Wrong: carry = xValue & yValue
            // Why: this ignores a carry entering this calculation.
            //
            // Carry is 1 when at least two of these three bits are 1.
            let nextCarry =
                (xValue & yValue) |
                (xValue & carry) |
                (yValue & carry)

            result.append(resultBit)
            carry = nextCarry
            x -= 1
            y -= 1
        }

        while x >= 0 {
            let xValue = Int(String(aArray[x]))!
            let resultBit = xValue ^ carry
            carry = xValue & carry

            result.append(resultBit)
            x -= 1
        }

        while y >= 0 {
            // Wrong: Int(aArray[y])
            // Why: y belongs to bArray, not aArray.
            let yValue = Int(String(bArray[y]))!
            let resultBit = yValue ^ carry
            carry = yValue & carry

            result.append(resultBit)
            y -= 1
        }

        if carry == 1 {
            result.append(carry)
        }

        // Wrong: String(result.reversed())
        // Why: result contains Int values, but String does not directly
        // initialize from ReversedCollection<[Int]>.
        //
        // Correct: convert each Int to String and join them.
        return result.reversed().map(String.init).joined()
    }
}


// GPT'S UPGRADE VERSION:
// One loop handles both strings, including unequal lengths.

class Solution {
    func addBinary(_ a: String, _ b: String) -> String {
        let aArray = Array(a)
        let bArray = Array(b)

        var x = aArray.count - 1
        var y = bArray.count - 1
        var carry = 0
        var result = [Character]()

        // Continue while either string has digits or a carry remains.
        while x >= 0 || y >= 0 || carry != 0 {
            // Use 0 when one string has no remaining digits.
            let aValue = x >= 0
                ? Int(String(aArray[x]))!
                : 0

            let bValue = y >= 0
                ? Int(String(bArray[y]))!
                : 0

            let sum = aValue + bValue + carry

            // Binary digit is the remainder after division by 2.
            result.append(Character(String(sum % 2)))

            // Binary carry is the quotient after division by 2.
            carry = sum / 2

            x -= 1
            y -= 1
        }

        return String(result.reversed())
    }
}


/*
GPT'S SUMMARY

What you did well:
- Your overall approach was correct:
  start from the rightmost digits and move left.
- You correctly recognized that each calculation needs a carry.
- `xValue ^ yValue ^ carry` correctly calculates the result bit.
- Appending backward and reversing at the end is a good approach.

Mistakes you made:

1. Converting Character to Int:

   Wrong:
       Int(aArray[x])

   Correct:
       Int(String(aArray[x]))!

   `Array(a)` produces `[Character]`, so the Character must first be
   converted into a String.

2. You used the wrong array for `y`:

   Wrong:
       let yValue = Int(aArray[y])

   Correct:
       let yValue = Int(String(bArray[y]))!

3. Your carry calculation ignored the previous carry.

   Wrong:
       carry = xValue & yValue

   This fails for:

       xValue = 1
       yValue = 0
       carry = 1

   The calculation is 1 + 0 + 1 = 10 in binary, so the new carry must
   be 1. But `1 & 0` produces 0.

   Correct bit formula:

       carry = (x & y) | (x & carry) | (y & carry)

   Easier arithmetic formula:

       let sum = x + y + carry
       resultBit = sum % 2
       carry = sum / 2

4. `[Int]` cannot be directly converted into a String.

   For `[Int]`:

       result.reversed().map(String.init).joined()

   For `[Character]`:

       String(result.reversed())

Why the upgrade version is simpler:
- One loop handles both equal and unequal string lengths.
- A missing digit is treated as zero.
- The loop also processes a final carry.
- Ordinary addition makes the carry logic easier to verify.

Pattern:
- Two pointers / elementary addition.

State needed:
- `x`: current position in `a`.
- `y`: current position in `b`.
- `carry`: value passed into the next column.
- `result`: calculated bits in reverse order.

Loop contract:
- At the top of every iteration, all digits to the right of `x` and
  `y` have been processed, and `carry` contains the value that must be
  added to the current column.

Complexity:
- Let n = max(a.count, b.count).
- Fix version: O(n) time and O(n) space.
- Upgrade version: O(n) time and O(n) space.
*/