// Your original solution:
//
// class Solution {
//     var result = [String]()
//     func generateParenthesis(_ n: Int) -> [String] {
//         result = []
//         var path = [Character]()
//         helper(n,0,0,&path)
//         return result
//     }
//
//     func helper(_ n: Int, _ left: Int, _ right: Int, _ path: inout [Character]) {
//         if left + right == 2*n {
//             result.append(String(path))
//             return
//         }
//
//         // two choice every time
//
//         let choices: [Character] = ["(", ")"]
//
//         for item in choices {
//             if item == "(" {
//                 if left == n {
//                     continue
//                 } else {
//                     path.append(item)
//                     helper(n, left+1, right, &path)
//                     path.removeLast()
//                 }
//             } else {
//                 if left == 0 || right == n || left == right {
//                     continue
//                 } else {
//                     path.append(item)
//                      helper(n, left, right+1, &path)
//                      path.removeLast()
//                 }
//             }
//         }
//     }
// }
//
// // Pattern: backtracking
// // Card shape:
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank
// // thinking:
// // what is a vaild parentese
// // 1 choice left first
// // 2. if choose right, need to see whether it has left in the path already
// // 3. left max count is n
// // 4. and if existing left count = n, all we can choice remaining is right
// // so need two variable to maintain left count and right count
// // before we do choice
// // and once total count == 2n, then it is the final answer
// // 5 mins ready to write,
// // 18 mins, now check with example
// // looks good, ready to run, oops compiler error, should be 2*n not 2n
// // fix the swift synatx error, run pass, need to manually declare the type of choices let choices: [Character] = ["(", ")"] be character type
// // submit

// Fixed version: your two-choice backtracking pattern.
class Solution {
    var result = [String]()

    func generateParenthesis(_ n: Int) -> [String] {
        result = []

        var path = [Character]()
        helper(n, 0, 0, &path)

        return result
    }

    // Contract: add every valid parenthesis string that extends `path`.
    func helper(
        _ n: Int,
        _ left: Int,
        _ right: Int,
        _ path: inout [Character]
    ) {
        if left + right == 2 * n {
            result.append(String(path))
            return
        }

        // Good: your loop models the two possible choices.
        let choices: [Character] = ["(", ")"]

        for item in choices {
            if item == "(" {
                // Good: do not add more than n opening parentheses.
                if left == n {
                    continue
                }

                path.append(item)
                helper(n, left + 1, right, &path)
                path.removeLast()
            } else {
                // Good: do not close before opening, and do not allow
                // right parentheses to catch up with left parentheses.
                if left == 0 || right == n || left == right {
                    continue
                }

                path.append(item)
                helper(n, left, right + 1, &path)
                path.removeLast()
            }
        }
    }
}

// Upgrade version: rename UpgradeSolution to Solution before submitting.
// This is the same algorithm, written with direct branches instead of
// a choices array. It is mainly a readability upgrade, not a speed upgrade.
class UpgradeSolution {
    var result = [String]()

    func generateParenthesis(_ n: Int) -> [String] {
        result = []

        var path = [Character]()
        helper(n, 0, 0, &path)

        return result
    }

    func helper(
        _ n: Int,
        _ left: Int,
        _ right: Int,
        _ path: inout [Character]
    ) {
        if left + right == 2 * n {
            result.append(String(path))
            return
        }

        if left < n {
            path.append("(")
            helper(n, left + 1, right, &path)
            path.removeLast()
        }

        if right < left {
            path.append(")")
            helper(n, left, right + 1, &path)
            path.removeLast()
        }
    }
}

// GPT's summary:
// What you did well:
// - Your solution already follows the backtracking pattern correctly.
// - Your `choices` loop is a valid and clear way to represent “try ( and )”.
// - You correctly track left and right counts.
// - Your conditions prevent invalid strings before they are built.
//
// Fixed version:
// - Keeps your two-choice loop.
// - `left == n` prevents too many "(".
// - `left == right` prevents ")" when there is no unmatched "(".
//
// Upgrade version:
// - Replaces the choices loop with two direct `if` branches.
// - `left < n` means "(" is allowed.
// - `right < left` means ")" is allowed.
// - Same algorithm and same complexity; it is just more compact.
//
// Complexity:
// - Time: O(C(n) * n), where C(n) is the n-th Catalan number.
// - Extra space: O(n), excluding output.