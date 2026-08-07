// Your original solution:
//
// class Solution {
//     var result = [[Int]]()
//     var used = [Bool]()
//     func permute(_ nums: [Int]) -> [[Int]] {
//         var path = [Int]()
//         used = Array(repeating: false, count: nums.count)
//         helper(nums, &path)
//         return result
//     }
//
//     func helper(_ nums: [Int], _ path: inout [Int]) {
//         if path.count == nums.count {
//             result.append(path)
//             return
//         }
//
//         for i in 0..<nums.count {
//             if used[i] == true {
//                 continue
//             }
//             path.append(nums[i])
//             used[i] = true
//             helper(nums, &path)
//             path.removeLast()
//             used[i] = false
//         }
//     }
// }
//
// // Pattern:        backtracking
// // Card shape:     exit the recursive in the top, for loop the choice list, make a choice, then do recursive to next, then unmake the choice
// // State needed:   the path, the candidate
// // Contract:      do you mean what recursive function I should write in hre
// // Recall:         half 
//
// // 2 mins so far, start to wrte code
// // now recalled this is permutations I should have a used array, to decide whether or not can use
// // no need to pass the index in the helper method, remove it
// // TC is O(n!) maybe? that's the thing I am not sure
// // SC I think is O(n) which is the stack we use
// // 10 mins so far, checking the code, forgot to update used[i], add it now
// // also forgot to return final result, update
// // 12 mins so far after fixing, now ready to run -> pass, submit -> pass

class Solution {
    var result = [[Int]]()
    var used = [Bool]()

    func permute(_ nums: [Int]) -> [[Int]] {
        // Reset state in case the Solution object is reused.
        result = []
        used = Array(repeating: false, count: nums.count)

        var path = [Int]()
        helper(nums, &path)

        return result
    }

    // Contract: add every permutation that can be formed by choosing
    // from the nums indices that are not marked as used.
    func helper(_ nums: [Int], _ path: inout [Int]) {
        if path.count == nums.count {
            // Good: every number has been chosen exactly once.
            result.append(path)
            return
        }

        for i in 0..<nums.count {
            // Good: a permutation cannot reuse the same index.
            if used[i] {
                continue
            }

            path.append(nums[i])       // Choose.
            used[i] = true

            helper(nums, &path)        // Recurse.

            path.removeLast()          // Unchoose.
            used[i] = false
        }
    }
}

// GPT's summary:
// What you did well:
// - Your solution is correct and passed.
// - You correctly recognized that permutations need a `used` array.
// - You correctly removed the start index because every unused number
//   remains a possible next choice.
// - Your choose -> recurse -> unchoose structure is exactly right.
//
// Key idea:
// - At each recursion level, choose any number whose index is unused.
// - Mark it used so it cannot appear again in the same permutation.
// - After recursion, restore both `path` and `used` for the next choice.
//
// Swift syntax to remember:
// - `Array(repeating: false, count: nums.count)` creates the used array.
// - `if used[i]` is shorthand for `if used[i] == true`.
// - `inout` allows the helper to mutate the same `path` array.
//
// Complexity:
// - There are n! permutations.
// - Time: O(n * n!) because each of the n! output arrays has length n.
// - Extra space: O(n) for `path`, `used`, and recursion, excluding output.
// - Output space: O(n * n!).