// Your original solution:
//
// class Solution {
//     func rotate(_ nums: inout [Int], _ k: Int) {
//         var count = nums.count
//
//         for i in 0..<nums.count {
//             var movedIndex = (i + k) / count
//
//             while movedIndex
//         }
//     }
// }
//
// // Pattern: array
// // Card shape: for loop array and also exachange because of the rotation
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank
// // thinking, logic seems straightforward
// // challenge is need to do O(1) in place
// // basically.  it kind like nums[(i+k)/numtotal] = nums[i]
// // we should avoid override
// // think start for end, can avoid this?
// // need temp value
// // previous temp and prev index = (i+k)/numtotal,
// // so if i == index, need first set nums[i] = temp
// // 12 mins so far, ready to write code, will think more in the process to write the code
//
// // 20 mins so far didn't come up with O(1) in place solution
// // for other way to solve this can create a new array based on this
// // which not idea
// // will ask gpt


// Fixed version: cycle replacement
class Solution {
    func rotate(_ nums: inout [Int], _ k: Int) {
        guard !nums.isEmpty else {
            return
        }

        let count = nums.count
        let shift = k % count

        if shift == 0 {
            return
        }

        var movedCount = 0
        var start = 0

        // More than one cycle may be needed.
        while movedCount < count {
            var currentIndex = start
            var previousValue = nums[currentIndex]

            repeat {
                // Wrong: (currentIndex + k) / count
                // Why: division does not wrap an index around the array.
                // Correct: modulo gives an index in 0..<count.
                let nextIndex = (currentIndex + shift) % count

                // Save the value before overwriting it.
                let nextValue = nums[nextIndex]
                nums[nextIndex] = previousValue

                previousValue = nextValue
                currentIndex = nextIndex
                movedCount += 1
            } while currentIndex != start

            // This cycle is complete. Start another if nodes remain.
            start += 1
        }
    }
}


// Upgrade version: three reversals
// Same complexity, but generally easier to reason about.
// Rename UpgradeSolution to Solution before submitting.
class UpgradeSolution {
    func rotate(_ nums: inout [Int], _ k: Int) {
        guard !nums.isEmpty else {
            return
        }

        let shift = k % nums.count

        guard shift > 0 else {
            return
        }

        // Example: [1, 2, 3, 4, 5, 6, 7], k = 3
        // Reverse all:   [7, 6, 5, 4, 3, 2, 1]
        // Reverse first: [5, 6, 7, 4, 3, 2, 1]
        // Reverse rest:  [5, 6, 7, 1, 2, 3, 4]
        reverse(&nums, 0, nums.count - 1)
        reverse(&nums, 0, shift - 1)
        reverse(&nums, shift, nums.count - 1)
    }

    func reverse(_ nums: inout [Int], _ start: Int, _ end: Int) {
        var left = start
        var right = end

        while left < right {
            nums.swapAt(left, right)
            left += 1
            right -= 1
        }
    }
}


// GPT's summary:
//
// Mistakes you made:
// - The destination index uses modulo, not division:
//   `(index + shift) % nums.count`.
// - Writing directly into the destination overwrites a value that still
//   needs to be moved, so save it first.
// - One cycle may not visit every index.
// - Track the total number of moved elements and begin another cycle when
//   necessary.
// - Normalize k with `k % nums.count` because k may exceed the array length.
//
// What you did well:
// - Your temporary-value idea was correct.
// - You correctly recognized the overwrite problem.
// - You were heading toward the cycle-replacement algorithm.
// - Both solutions modify the original array using O(1) extra space.
//
// Why multiple cycles may be necessary:
// - For nums.count = 6 and k = 2, starting at index 0 visits:
//   0 -> 2 -> 4 -> 0
// - Indices 1, 3, and 5 still need a second cycle.
//
// Swift syntax to remember:
// - Remainder/modulo: `%`
// - Swap two array elements: `nums.swapAt(left, right)`
// - Pass an inout array: `reverse(&nums, ...)`
//
// Complexity:
// - Cycle replacement: O(n) time and O(1) space.
// - Three reversals: O(n) time and O(1) space.