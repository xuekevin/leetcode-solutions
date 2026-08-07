// Your original solution:
//
// class Solution {
//     var resultArr = [[Int]]()
//
//     func combine(_ n: Int, _ k: Int) -> [[Int]] {
//         var pathArr = [Int]()
//         helper(pathArr, 1, n, k)
//         return resultArr
//     }
//
//     helper(_ &pathArr: [Int], _ curN: Int, _ n: Int, _ k: Int) {
//         if pathArr.count == k {
//             resultArr.append(pathArr)
//             return
//         }
//
//         for choice in curN..<(n+1) {
//             pathArr.append(choice)
//             helper(pathArr, choice+1, n, k)
//             pathArr.removeLast()
//         }
//     }
// }
//
// // Pattern: backtracking
// // Card shape: get the final combine the add in resultArr, do a for loop for the choice,
// // State needed: also need to call out if the choice has been used, can use index range to do this
// // Contract: helper(_ &pathArr: [Int], lowerIndex: Int, maxIndex: Index, _ n: Int, _ k: Int)
// // Recall: half
// // start writing after 5 mins
// // finish writing 13 mins, I know I have some swift synatx error, will ask gpt to fix

// Fixed version: your backtracking approach.
class Solution {
    var resultArr = [[Int]]()

    func combine(_ n: Int, _ k: Int) -> [[Int]] {
        resultArr = []

        var pathArr = [Int]()

        // Correct: use `&` at the call site for an inout parameter.
        helper(&pathArr, 1, n, k)

        return resultArr
    }

    // Contract: add every length-k combination that starts with choices
    // from curN through n, after the values already in pathArr.
    func helper(
        _ pathArr: inout [Int],
        _ curN: Int,
        _ n: Int,
        _ k: Int
    ) {
        if pathArr.count == k {
            // Good: pathArr is one complete combination.
            resultArr.append(pathArr)
            return
        }

        // Good: starting from curN prevents reusing numbers and prevents
        // duplicate combinations such as [1, 2] and [2, 1].
        for choice in curN..<(n + 1) {
            pathArr.append(choice)                  // Choose.
            helper(&pathArr, choice + 1, n, k)     // Recurse.
            pathArr.removeLast()                   // Unchoose.
        }
    }
}

// Upgrade version: rename UpgradeSolution to Solution before submitting.
// Prune choices when too few numbers remain to fill the combination.
class UpgradeSolution {
    var resultArr = [[Int]]()

    func combine(_ n: Int, _ k: Int) -> [[Int]] {
        resultArr = []

        var pathArr = [Int]()
        helper(&pathArr, 1, n, k)

        return resultArr
    }

    func helper(
        _ pathArr: inout [Int],
        _ curN: Int,
        _ n: Int,
        _ k: Int
    ) {
        if pathArr.count == k {
            resultArr.append(pathArr)
            return
        }

        let remainingSlots = k - pathArr.count

        // The final valid starting choice is:
        // n - remainingSlots + 1.
        // Any larger choice cannot leave enough numbers to finish.
        let lastChoice = n - remainingSlots + 1

        for choice in curN...lastChoice {
            pathArr.append(choice)
            helper(&pathArr, choice + 1, n, k)
            pathArr.removeLast()
        }
    }
}

// GPT's summary:
// What you did well:
// - You identified this as backtracking.
// - You correctly used a path array, a start value, and choose/recurse/unchoose.
// - Using `choice + 1` is the key detail that prevents duplicates.
//
// Mistakes you made:
// - A helper method must begin with `func`.
// - Use `inout` in the parameter declaration, not `&`.
// - Use `&pathArr` only when calling a function with an inout parameter.
//
// Swift syntax to remember:
// - Function definition: `func helper(_ path: inout [Int], ...)`.
// - Function call: `helper(&path, ...)`.
// - `pathArr.removeLast()` undoes the previous `append` choice.
//
// Fixed version complexity:
// - Time: O(C(n, k) * k), including copying each output combination.
// - Extra space: O(k) for the recursion path, excluding output.
//
// Upgrade version:
// - Same worst-case complexity.
// - Prunes branches that cannot possibly reach length k, so it does less work.