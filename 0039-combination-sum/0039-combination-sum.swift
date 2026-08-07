// Your original solution:
//
// class Solution {
//     var result = [[Int]]()
//
//     func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
//         result = []
//         var path = [Int]()
//         let sortedArr = Array.sorted(candidates)
//
//         helper(sortedArr, 0, &path, target)
//         return result
//
//     }
//
//     func helper(_ nums: [Int], _ start: Int, _ path: inout [Int],  _ target: Int) {
//         if target == 0 {
//             result.append(path)
//             return
//         }
//
//         if target < 0 {
//             return
//         }
//
//         for i in start..<nums.count {
//             path.append(nums[i])
//             helper(nums, i, &path, target - nums[i])
//             path.removeLast()
//         }
//     }
// }
//
// // Pattern: Backtracking
// // Card shape: if the candidate sum == target then add to resultArr and return
// // for loop the chooice,
// // make the choice, because of we allow duplicate, so no need to track if it used or not
// // then do recursive call
// // the unmake the choice
// // State needed: path, resultArr
// // Contract:      append current choice to the path, the go to next to choice another one in next level, until sum = target
// // Recall:         half
// // think not sure is  there is duplication?
// // let me think
// // 2, 2, 3
// // 3, 2, 2
// // this is a duplication, think how to avoid this? might can remove duplicate in the final resultArr
// // or think how to avoid when I add the choice?
// // think we can also limit the next choice, to be equal or bigger than curennt choice, so which means we need to sort the candicate first
// //  ready to write the code
// // 19 mins finish writing, now checking
// // 21 mins seems good, start to run, oops, synatx issue, error: cannot reference 'mutating' method as function value
// // try to fix
// // turns out I should use Array.sorted instead
// // I think all I miss is swift synatx, will ask gpt to fix

// Fixed version: your backtracking approach.
class Solution {
    var result = [[Int]]()

    func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
        result = []

        var path = [Int]()

        // Wrong: `Array.sorted(candidates)`
        // Why: `sorted()` is called on the array value.
        // Correct: call `candidates.sorted()`.
        let sortedArr = candidates.sorted()

        helper(sortedArr, 0, &path, target)
        return result
    }

    // Contract: find all valid combinations using candidates from `start`
    // onward, while `path` contains the choices already made.
    func helper(
        _ nums: [Int],
        _ start: Int,
        _ path: inout [Int],
        _ target: Int
    ) {
        if target == 0 {
            // Good: the chosen values add up exactly to the original target.
            result.append(path)
            return
        }

        if target < 0 {
            return
        }

        for i in start..<nums.count {
            path.append(nums[i])

            // Good: reuse `i`, not `i + 1`, because one candidate
            // may be used multiple times.
            helper(nums, i, &path, target - nums[i])

            path.removeLast()
        }
    }
}

// Upgrade version: rename UpgradeSolution to Solution before submitting.
// Since nums is sorted, stop as soon as a candidate exceeds the remaining target.
class UpgradeSolution {
    var result = [[Int]]()

    func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
        result = []

        var path = [Int]()
        helper(candidates.sorted(), 0, &path, target)

        return result
    }

    func helper(
        _ nums: [Int],
        _ start: Int,
        _ path: inout [Int],
        _ target: Int
    ) {
        if target == 0 {
            result.append(path)
            return
        }

        for i in start..<nums.count {
            if nums[i] > target {
                // All later candidates are also too large because nums is sorted.
                break
            }

            path.append(nums[i])
            helper(nums, i, &path, target - nums[i])
            path.removeLast()
        }
    }
}

// GPT's summary:
// What you did well:
// - Your backtracking approach is correct.
// - You correctly realized that you need sorted candidates and a `start` index.
// - Passing `i` again allows repeated use of the same candidate.
// - Starting from `i` prevents reordered duplicates:
//   [2, 2, 3] is generated, but [3, 2, 2] is not.
//
// Swift syntax to remember:
// - Sort an array with `candidates.sorted()`.
// - `sorted()` returns a new array; it does not mutate `candidates`.
// - Use `helper(nums, i, ...)` when reuse is allowed.
// - Use `helper(nums, i + 1, ...)` when each choice can be used only once.
//
// Fixed version complexity:
// - Time: exponential in the worst case because it explores combinations.
// - Extra space: O(target / minimumCandidate) for the recursion path,
//   excluding output.
//
// Upgrade version:
// - Same worst-case complexity.
// - Stops immediately when a sorted candidate is too large, avoiding
//   unnecessary recursive calls with negative targets.