class Solution {
    var result = [[Int]]()
    func permuteUnique(_ nums: [Int]) -> [[Int]] {
        var sortedNums = nums.sorted()
        var used = Array(repeating: false, count: nums.count)
        var paths = [Int]()
        helper(sortedNums, &used, &paths)
        return result
    }

    func helper(_ nums: [Int], _ used: inout [Bool], _ paths: inout [Int]) {
        if paths.count == nums.count {
            result.append(paths)
            return
        }

        for i in 0..<nums.count {
            if used[i] { continue }
            if i >= 1 && nums[i-1] == nums[i] && used[i-1] == false { continue }
            used[i] = true
            paths.append(nums[i])
            helper(nums,&used,&paths)
            paths.removeLast()
            used[i] = false
        }
    }
}