class Solution {
    func summaryRanges(_ nums: [Int]) -> [String] {
        if nums.count == 0 {
            return []
        }

        var result = [String]()
        var start = nums[0]
        var end = nums[0]

        for j in 1..<nums.count {
            if nums[j] == end + 1 {
                end += 1
            } else {
                let curStr: String
                if start == end {
                    curStr = "\(end)"
                } else {
                    curStr = "\(start)->\(end)"    
                }
                result.append(curStr)
                start = nums[j]
                end = nums[j]
            }
        }

        let curStr: String
            if start == end {
                curStr = "\(end)"
            } else {
                curStr = "\(start)->\(end)"    
            }

        result.append(curStr)

        return result
    }
}

// Pattern: Array 
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
// Thinking
// for loop start for nums[0] add 1, every time
// if it exist, keep moving
// if not find the end, and create one output
// then restart from current nums[i] as new start
// corner case for last element in the array
// start to writing
// finish in 9 mins
// now use example to verify
// find something, now try to fix
// 15 mins so far
// ready to run 
// ["0->2","4->5","7->7"] got wrong answer 
// the issue need only output one if start == end
// this is careless
// now fix


