class Solution {
    func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
        var left = 0
        var right = numbers.count - 1

        while (left < right) {
            var sum = numbers[left] + numbers[right] 

            if sum == target {
                return [left+1, right+1]
            }

            if sum < target {
                left += 1
            }

            if sum > target {
                right -= 1
            }
        }

        return []
    }
}

//# Thoughts
// because it is sorted
// think we can go by two pointers to spend up the find
// kind of like binary search

// use 2 mins so far, going to write the code

// find coding in 6 mins

// find a synatx error which number has no length, but should use count

// while the answer is wrong, I should use example to check

// the reason is this is 1 -indexed array
// but I still think it is starting from 0 index




