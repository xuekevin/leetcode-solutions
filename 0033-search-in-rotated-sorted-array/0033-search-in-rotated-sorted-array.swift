class Solution {
    func search(_ nums: [Int], _ target: Int) -> Int {
        
        var left = 0
        var right = nums.count - 1

        while left <= right {
            var middle = (left + right) / 2
            if nums[middle] == target {
                return middle
            }
            // this part has peak
            if nums[left] > nums[middle] {
                if target < nums[middle] {
                    // must in left side
                    right = middle - 1
                } else {
                    // compare target whith right
                    if nums[right] >= target {
                        left = middle + 1
                    } else {
                        right = middle - 1
                    }
                }
            } else if nums[right] < nums[middle] {
                // this part has peak
                if target > nums[middle] {
                    left = middle + 1
                } else {
                    if nums[left] <= target {
                        right = middle - 1
                    } else {
                        left = middle + 1
                    }
                }
            } else {
                if target < nums[middle] {
                    right = middle - 1
                } else {
                    left = middle + 1
                }
            }

            

            // now need to decide to go left part or right part
            // based on what?
            // in general two parts are in ascending order
            // and one side is must be the origin ascending order, which we can convert this to the basic 
            // binary search issue
            // now how to verify which side has the peak
            // compare the middle with left or right, then we can know
            // so what's next
            // we need to see target in which part, based on the relation between target and middle
            // figure out with above write,
            // can do more simplicty
            // but assume this is what we need
            // already spend 15 mins. got wrong answer
            // give 2 mins to figure out
            // figure it out, made some silly mistake
        }

        return -1
    }
}