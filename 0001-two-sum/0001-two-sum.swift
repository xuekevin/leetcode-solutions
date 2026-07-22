class Solution {
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var dict = [Int:Int]()

        for (index, item) in nums.enumerated() {
            if let value = dict[target - item] {
                return [value, index]
            } else {
                dict[item] = index
            }
        }
        return []
    }
}

// # Thoughts
// for loop
// the check each item
// and use a dict to store this item, with index

// and every time do the iteration, will check if the dict contains: target - item already
// if it is, we find the answer

// TC: O(n)
// SC: O(n)
// 2 mins to figure out above

// spend some time think if we have duplicate item in array



