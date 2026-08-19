// ============================================================
// FIXED VERSION: Follows your original solution
// ============================================================

class Solution {
    func evalRPN(_ tokens: [String]) -> Int {
        if tokens.count == 1 {
            // FIX: Int(String) returns Int?, so it must be unwrapped.
            return Int(tokens[0])!
        }

        var stack = [Int]()

        for token in tokens {
            if token == "*" || token == "/" || token == "+" || token == "-" {
                // The first value removed is the right-hand operand.
                let second = stack.removeLast()
                let first = stack.removeLast()

                // FIX: Give result an initial value so Swift knows that
                // it has been initialized before stack.append(result).
                var result = 0

                if token == "*" {
                    result = first * second
                } else if token == "/" {
                    result = first / second
                } else if token == "+" {
                    result = first + second
                } else {
                    result = first - second
                }

                stack.append(result)
            } else {
                // FIX: Int(token) returns Int?, but stack requires Int.
                stack.append(Int(token)!)
            }
        }

        // FIX: stack.last returns Int?, so it must be unwrapped.
        return stack.last!
    }
}

// ============================================================
// UPGRADE VERSION
// Parse numbers first and use switch for operators.
// Comment out the fixed version and uncomment this version to run it.
// ============================================================

/*
class Solution {
    func evalRPN(_ tokens: [String]) -> Int {
        var stack = [Int]()

        for token in tokens {
            // If conversion succeeds, this token is a number.
            if let number = Int(token) {
                stack.append(number)
                continue
            }

            // Otherwise, the token is an operator.
            let second = stack.removeLast()
            let first = stack.removeLast()

            switch token {
            case "+":
                stack.append(first + second)
            case "-":
                stack.append(first - second)
            case "*":
                stack.append(first * second)
            case "/":
                stack.append(first / second)
            default:
                break
            }
        }

        return stack.last!
    }
}
*/

// ============================================================
// ORIGINAL SOLUTION AND COMMENTS
// ============================================================

/*
class Solution {
    func evalRPN(_ tokens: [String]) -> Int {
        if tokens.count == 1 {
            return Int(tokens[0])
        }

        var stack = [Int]()
        for token in tokens {
            if token == "*" || token == "/" || token == "+" || token == "-" {
                // assume the token string is valid
                let second = stack.removeLast()
                let first = stack.removeLast()
                
                var result: Int
                if token == "*" {
                    result = first * second
                }
                if token == "/" {
                    result = first / second
                }
                if token == "+" {
                    result = first + second
                }
                if token == "-" {
                    result = first - second
                }
                stack.append(result)
            } else {
                stack.append(Int(token))
            }
        }
        return stack.last
    }
}

// Thinking
// checking the example 
// it's an array
// and kind like stack
// since we from back to front,
// and two type input, one is operators, one is the numbers

// so for loop for the array from right to left
// two cases
// if it is operators, will use later, so need a place to store, might use another array
// if it is num, pop, not correct, rethinking
// restart should start for loop from left to right
// push num into num stack
// if we have a operation, we pop 2 nums from stack, do the math, have a new num, then push into stack again
// think can start to write 
// 9 mins so far 

// Pattern: array, stack
// Card shape: as describe above
// State needed: stack for num
// Contract:      if it is operation, pop the 2 num from stack,
//                if it is num, just push into stack
// Recall:        half 

// finish writing in 19, must has synatx error will let gpt to fix
*/

// ============================================================
// GPT'S SUMMARY
// ============================================================

/*
WHAT YOU DID CORRECTLY:

1. You correctly recognized this as a stack problem.
2. You correctly changed your traversal to left-to-right.
3. When you find a number, you push it into the stack.
4. When you find an operator, you pop two numbers, calculate the
   result, and push the result back.
5. You popped the operands in the correct order:

       let second = stack.removeLast()
       let first = stack.removeLast()

   For subtraction and division, calculate:

       first - second
       first / second

SWIFT MISTAKES:

1. Int(String) returns an optional Int?.

   Wrong:
       return Int(tokens[0])

   Correct:
       return Int(tokens[0])!

2. An [Int] stack cannot accept an Int?.

   Wrong:
       stack.append(Int(token))

   Correct:
       stack.append(Int(token)!)

   Safer alternative:
       if let number = Int(token) {
           stack.append(number)
       }

3. stack.last also returns an optional.

   Wrong:
       return stack.last

   Correct:
       return stack.last!

4. Swift could not prove that `result` was initialized because you
   used separate if statements.

   Risky:
       var result: Int

   Fixed:
       var result = 0

   Cleaner:
       use an if/else-if chain or switch.

WHY THE UPGRADE VERSION IS CLEANER:

- It uses Int(token) to determine whether a token is a number.
- It avoids manually checking all four operators in one condition.
- switch clearly separates the behavior of each operator.
- It does not need a special case when tokens.count == 1.
- It does not need a temporary result variable.

COMPLEXITY:

Time: O(n), because every token is processed once.

Space: O(n), because the stack may hold multiple numbers before
encountering operators.
*/