class Solution {
    func majorityElement(_ nums: [Int]) -> Int {
        var maxCount = 0
        var majority = 0
        var map = [Int:Int]()

        for item in nums {
            if let count = map[item] {
                map[item] = count + 1
                if count + 1 > maxCount {
                    maxCount = count + 1
                    majority = item
                }
            } else {
                map[item] = 1
                if maxCount == 0 {
                    maxCount = 1
                    majority = item
                }
            }
        }
        return majority
    }
}

// Pattern: hashmap
// Card shape: for loop the nums, count the number of the item
// State needed: count for most one in hashMap
// Contract:      what is TRUE when one call returns?
// check current item in nums, if it is in hashmap, count + 1, if the count > maxCount, update the maxValue
// Recall:        half 
// unsorted array
// can use hashMap to count all show up element
// but it asked for O(1) space and linear time to get the answer
// since it meantoned the majority is > n/2 and it always exist
// I will use the basic way to solove this
// start writing in 5 mins 
//finish in 10 mins 
// quick exam with example
// fix and ready to run, pass
// 12 mins ready to submit 
