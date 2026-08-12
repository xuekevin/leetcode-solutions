class Solution {
    func searchInsert(_ nums: [Int], _ target: Int) -> Int {
        var left = 0
        var right = nums.count - 1

        while left <= right {
            var middle = left + (right - left) / 2
            if nums[middle] == target {
                return middle
            } else if nums[middle] < target {
                left = middle + 1
            } else {
                right = middle - 1
            }
        }
        // left can only updated be middle + 1, so when exit while, left > right, left should be the final index we need to insert
        return left
    }
}

// 4 mins
