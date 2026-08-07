class Solution {
    var result = [[Int]]()
    var used = [Bool]()
    func permute(_ nums: [Int]) -> [[Int]] {
        var path = [Int]()
        used = Array(repeating: false, count: nums.count)
        helper(nums, &path)
        return result
    }

    func helper(_ nums: [Int], _ path: inout [Int]) {
        if path.count == nums.count {
            result.append(path)
            return
        }

        for i in 0..<nums.count {
            if used[i] == true {
                continue
            }
            path.append(nums[i])
            used[i] = true
            helper(nums, &path)
            path.removeLast()
            used[i] = false
        }
    }
}

// Pattern:        backtracking
// Card shape:     exit the recursive in the top, for loop the choice list, make a choice, then do recursive to next, then unmake the choice
// State needed:   the path, the candidate
// Contract:      do you mean what recursive function I should write in hre
// Recall:         half 

// 2 mins so far, start to wrte code
// now recalled this is permutations I should have a used array, to decide whether or not can use
// no need to pass the index in the helper method, remove it
// TC is O(n!) maybe? that's the thing I am not sure
// SC I think is O(n) which is the stack we use
// 10 mins so far, checking the code, forgot to update used[i], add it now
// also forgot to return final result, update
// 12 mins so far after fixing, now ready to run -> pass, submit 


