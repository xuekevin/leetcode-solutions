// Your original solution:
//
// class Solution {
//     func majorityElement(_ nums: [Int]) -> Int {
//         var maxCount = 0
//         var majority = 0
//         var map = [Int:Int]()
//
//         for item in nums {
//             if let count = map[item] {
//                 map[item] = count + 1
//                 if count + 1 > maxCount {
//                     maxCount = count + 1
//                     majority = item
//                 }
//             } else {
//                 map[item] = 1
//                 if maxCount == 0 {
//                     maxCount = 1
//                     majority = item
//                 }
//             }
//         }
//         return majority
//     }
// }
//
// // Pattern: hashmap
// // Card shape: for loop the nums, count the number of the item
// // State needed: count for most one in hashMap
// // Contract:      what is TRUE when one call returns?
// // check current item in nums, if it is in hashmap, count + 1, if the count > maxCount, update the maxValue
// // Recall:        half
// // unsorted array
// // can use hashMap to count all show up element
// // but it asked for O(1) space and linear time to get the answer
// // since it meantoned the majority is > n/2 and it always exist
// // I will use the basic way to solove this
// // start writing in 5 mins
// //finish in 10 mins
// // quick exam with example
// // fix and ready to run, pass
// // 12 mins ready to submit, pass


// Reviewed version: your hash-map approach
class Solution {
    func majorityElement(_ nums: [Int]) -> Int {
        var counts = [Int: Int]()

        for number in nums {
            // Good: dictionary default syntax removes the separate
            // existing-key and missing-key cases.
            counts[number, default: 0] += 1

            // The problem guarantees a majority exists, so we can
            // return as soon as its count exceeds half the array.
            if counts[number, default: 0] > nums.count / 2 {
                return number
            }
        }

        // Unreachable under the problem's guarantee.
        return 0
    }
}


// Upgrade version: Boyer-Moore Voting Algorithm
// Rename UpgradeSolution to Solution before submitting.
class UpgradeSolution {
    func majorityElement(_ nums: [Int]) -> Int {
        var candidate = 0
        var count = 0

        for number in nums {
            if count == 0 {
                // All previous votes have canceled each other.
                // Start with a new candidate.
                candidate = number
            }

            if number == candidate {
                count += 1
            } else {
                // Cancel one candidate occurrence with one different value.
                count -= 1
            }
        }

        // Because the majority element is guaranteed to appear more
        // than n / 2 times, it cannot be completely canceled.
        return candidate
    }
}


// GPT's summary:
//
// What you did well:
// - Your original hash-map solution is correct and passed.
// - You correctly counted each element in one traversal.
// - You correctly tracked the element with the highest count.
// - You noticed that the follow-up asks for O(1) extra space.
//
// Small Swift improvement:
// - Instead of optional binding and separate cases, use:
//   `counts[number, default: 0] += 1`
// - Dictionary type spacing is conventionally written `[Int: Int]`.
//
// Why Boyer-Moore works:
// - Matching the candidate adds one vote.
// - A different number removes one vote.
// - This pairs one majority occurrence with one non-majority occurrence.
// - Because the majority appears more than all other elements combined,
//   some majority occurrences must remain after every possible cancellation.
// - Therefore, the final candidate must be the majority element.
//
// Example: [2, 2, 1, 1, 1, 2, 2]
// - candidate 2: count becomes 2
// - Two 1s cancel the two 2s: count becomes 0
// - Candidate changes to 1
// - A later 2 cancels that 1
// - Candidate changes to 2
// - Final candidate is 2
//
// Important condition:
// - Returning the candidate directly is safe because the problem guarantees
//   that a majority element exists.
// - Without that guarantee, a second pass would be required to verify that
//   the candidate appears more than n / 2 times.
//
// Complexity:
// - Hash-map version: O(n) time and O(n) space in the worst case.
// - Boyer-Moore version: O(n) time and O(1) space.