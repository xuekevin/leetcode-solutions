class Solution {
    var min = Int.min
    func findMin(_ nums: [Int]) -> Int {
        // helper(nums, 0, nums.count - 1)


        var left = 0
        var right = nums.count - 1

        while left < right {
            let mid = (left + right) / 2

            if nums[mid] > nums[right] {
                left = mid + 1
            } else if nums[mid] < nums[right] {
                right = mid
            } else {
                right -= 1
            }
        }

        return nums[left]
    }

    // func helper(_ nums: [Int], _ start: Int, _ end: Int) {
    //     if start > end {
    //         return
    //     }

    //     var mid = (start + end) / 2

        

    // }
}