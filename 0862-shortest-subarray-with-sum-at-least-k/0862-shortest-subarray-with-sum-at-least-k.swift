/*
My original code:

class Solution {
    func shortestSubarray(_ nums: [Int], _ k: Int) -> Int {
        var pArr = Array(repeating: 0, count: nums.count + 1)
        var sum = 0
        for i in 0..<(nums.count) {
            pArr[i] = sum
            sum += nums[i]
        }
        pArr[nums.count] = sum

        var deque = [Int]()
        var head = 0

        var best = Int.max

        for j in 0...nums.count {
            while head < deque.count, pArr[j] - pArr[deque[head]] >= k {
                best = min(best, j - deque[head])
                head += 1
            }

            while head < deque.count, pArr[j] >= pArr[deque[deque.count - 1]] {
                deque.removeLast()
            }
            deque.append(j)
        }

        if best == Int.max {
            return -1
        } else {
            return best
        }
    }
}
*/

class Solution {
    func shortestSubarray(_ nums: [Int], _ k: Int) -> Int {
        var prefixSum = Array(repeating: 0, count: nums.count + 1)

        // prefixSum[i] = sum of nums[0..<i].
        for i in 0..<nums.count {
            prefixSum[i + 1] = prefixSum[i] + nums[i]
        }

        // Stores indexes whose prefix sums are increasing.
        var deque = [Int]()
        var head = 0
        var best = Int.max

        for end in 0...nums.count {
            // The front gives the earliest possible start.
            // Remove valid starts to make the subarray shorter.
            while head < deque.count,
                  prefixSum[end] - prefixSum[deque[head]] >= k {
                best = min(best, end - deque[head])
                head += 1
            }

            // Remove worse prefix sums from the back.
            while head < deque.count,
                  prefixSum[end] <= prefixSum[deque.last!] {
                deque.removeLast()
            }

            deque.append(end)
        }

        return best == Int.max ? -1 : best
    }
}

/*
GPT's summary

Your approach was correct:
1. Use prefix sums to calculate every subarray sum quickly.
2. Use a deque to store possible starting indexes.
3. Pop from the front after finding a valid subarray.
4. Keep prefix sums increasing in the deque.

Main correction:

Wrong:
    pArr[j] >= pArr[deque[deque.count - 1]]

Correct:
    pArr[j] <= pArr[deque.last!]

Why:
- A later prefix sum that is smaller or equal is better.
- It creates a larger future subarray sum.
- It also creates a shorter future subarray.

Time Complexity: O(n)
Space Complexity: O(n)
*/