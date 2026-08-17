// Your original solution:
//
// class Solution {
//     func summaryRanges(_ nums: [Int]) -> [String] {
//         if nums.count == 0 {
//             return []
//         }
//
//         var result = [String]()
//         var start = nums[0]
//         var end = nums[0]
//
//         for j in 1..<nums.count {
//             if nums[j] == end + 1 {
//                 end += 1
//             } else {
//                 let curStr: String
//                 if start == end {
//                     curStr = "\(end)"
//                 } else {
//                     curStr = "\(start)->\(end)"
//                 }
//                 result.append(curStr)
//                 start = nums[j]
//                 end = nums[j]
//             }
//         }
//
//         let curStr: String
//             if start == end {
//                 curStr = "\(end)"
//             } else {
//                 curStr = "\(start)->\(end)"
//             }
//
//         result.append(curStr)
//
//         return result
//     }
// }
//
// // Pattern: Array
// // Card shape: for loop nums, check if current nums[i] is the end + 1
// // State needed:maintain the start and end of every sub range
// // Contract:      every iternation, get new end or get new sub range, and reset new start and end
// // Recall:        half
// // Thinking
// // for loop start for nums[0] add 1, every time
// // if it exist, keep moving
// // if not find the end, and create one output
// // then restart from current nums[i] as new start
// // corner case for last element in the array
// // start to writing
// // finish in 9 mins
// // now use example to verify
// // find something, now try to fix
// // 15 mins so far
// // ready to run
// // ["0->2","4->5","7->7"] got wrong answer
// // the issue need only output one if start == end
// // this is careless
// // now fix


// Reviewed version:
class Solution {
    func summaryRanges(_ nums: [Int]) -> [String] {
        guard !nums.isEmpty else {
            return []
        }

        var result = [String]()
        var start = nums[0]
        var end = nums[0]

        for current in nums.dropFirst() {
            if current == end + 1 {
                // Good: the current range remains consecutive.
                end = current
            } else {
                // The previous range has ended, so save it.
                result.append(formatRange(start, end))

                // Begin a new range at the current number.
                start = current
                end = current
            }
        }

        // Good: the loop only saves a range when the next range begins.
        // Therefore, the final range must be saved after the loop.
        result.append(formatRange(start, end))

        return result
    }

    func formatRange(_ start: Int, _ end: Int) -> String {
        if start == end {
            // A single number should be "7", not "7->7".
            return "\(start)"
        }

        return "\(start)->\(end)"
    }
}


// GPT's summary:
//
// What you did well:
// - Your corrected solution is valid.
// - You correctly tracked the start and end of the current range.
// - You correctly detected consecutive values using `end + 1`.
// - You correctly reset both boundaries when a new range began.
// - You remembered to append the final range after the loop.
//
// Earlier mistake:
// - A single-number range must be formatted as "7", not "7->7".
// - Your final code correctly handles this with `start == end`.
//
// Small improvements:
// - `nums.isEmpty` communicates intent more clearly than `nums.count == 0`.
// - `nums.dropFirst()` lets us traverse every value after nums[0] without
//   manually managing an index.
// - Moving the formatting into `formatRange` avoids duplicating the same
//   `if start == end` logic.
//
// Loop contract:
// - At the top of every iteration, start...end describes the consecutive
//   range currently being built.
// - Every earlier completed range has already been added to result.
//
// Why the final append is necessary:
// - A range is appended only when a non-consecutive value appears.
// - After the final element, no next value exists to trigger that action.
// - Therefore, the remaining range must be appended after the loop.
//
// Complexity:
// - Time: O(n)
// - Extra space: O(1), excluding the returned strings.