class Solution {
    func diffWaysToCompute(_ expression: String) -> [Int] {
        let characters = Array(expression)
        return ways(characters, 0, characters.count - 1)
    }

    // Returns every possible result from characters[start...end].
    func ways(_ characters: [Character], _ start: Int, _ end: Int) -> [Int] {
        var results = [Int]()
        var hasOperator = false

        // Try every operator as the last operation to perform.
        for index in start...end {
            let ch = characters[index]

            if ch.isNumber {
                continue
            }

            hasOperator = true

            let leftResults = ways(characters, start, index - 1)
            let rightResults = ways(characters, index + 1, end)

            // Combine every possible left result with every right result.
            for left in leftResults {
                for right in rightResults {
                    switch ch {
                    case "+":
                        results.append(left + right)
                    case "-":
                        results.append(left - right)
                    case "*":
                        results.append(left * right)
                    default:
                        break
                    }
                }
            }
        }

        // No operator means this substring is one whole number, such as "45".
        if !hasOperator {
            let numberString = String(characters[start...end])
            return [Int(numberString)!]
        }

        return results
    }
}

/*
GPT's summary

Your key idea was right:
- Split the expression at an operator.
- Recursively calculate every left result and right result.
- Combine every left result with every right result.

Main logic correction:

Wrong:
- Find the first operator, split once, and stop.

Why:
- Different parenthesizations use different operators as their final operation.

For "2-1-1":

Split at the first "-":
    2 - (1 - 1) = 2

Split at the second "-":
    (2 - 1) - 1 = 0

Therefore the result must be:
    [2, 0]

Handling multi-digit numbers:
- If a substring has no operators, it is one full number.
- For example, "45" becomes:

    let numberString = String(characters[start...end])
    return [Int(numberString)!]

Swift syntax fixes:
- `ch.isNumber`, not `ch.isNumber()`
- Loop through indexes with:
    for index in start...end
- Arrays require a type or initial value:
    var results = [Int]()
- `leftResults` and `rightResults` need `let` or `var`.

Time Complexity:
- Exponential in the number of operators because the problem asks us to
  generate every possible parenthesization/result.
*/