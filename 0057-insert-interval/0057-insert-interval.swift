// Your original solution:
//
// class Solution {
//     func insert(_ intervals: [[Int]], _ newInterval: [Int]) -> [[Int]] {
//         if intervals.count == 0 {
//             return [newInterval]
//         }
//
//         for i in 0..<intervals.count {
//             let curInterval = intervals[i]
//             if newInterval[0] <= curInterval[1] {
//                 let combineInterval = [Int]()
//                 let left = min(newInterval[0], curInterval[0]))
//                 var right = max(newInterval[1], curInterval[1])
//                 var j = i + 1
//                 while j < interval.count && right >= intervals[j][0] {
//                     right = max(right, intervals[j][1])
//                     j += 1
//                 }
//
//                 
//                 combineInterval.append(left)
//                 combineInterval.append(right)
//                 // insert new combine at i, which I want to before current i but not sure the synatx
//                 
//                 // remove the i and j if exist
//                 for k in i..<j {
//                     intervals.remove(k)
//                 }
//                 return intervals
//             }
//         }
//
//         intervals.append(newInterval)
//         return intervals
//     }
// }
//
// // Thinking
// // 1. find the newInterval's location
// // new.left, new.right, old.left, old.right
// // using example to figure out the pattern
// // first check
// // n.left with old.right, n.left <= old.right means we have overlap
// // then if create.left = min(n.left,o.left), create.right = max(n.right, o.right)
// // after create if create.right > next.left, means we have new overlap
// // so we need to update the new right, until, their is no overlap
// // spend 12 mins so far,
// // will try to write. fill in below
//
// // Pattern: array, traverse, pointers
// // Card shape: as I mentioned above
// // State needed: new.left, new.right,
// // Contract:     compare with current.left, and right, after one comare, we can now whether insert or change current interval
// // Recall:        half
// // will try to write in 10 mins
// // finish logic write in 33 mins
// // aware there is some synatx error, will let gpt fix


// Fixed version:
class Solution {
    func insert(
        _ intervals: [[Int]],
        _ newInterval: [Int]
    ) -> [[Int]] {
        var result = [[Int]]()
        var index = 0

        var mergedStart = newInterval[0]
        var mergedEnd = newInterval[1]

        // Phase 1:
        // Append intervals completely before the new interval.
        while index < intervals.count &&
              intervals[index][1] < mergedStart {
            result.append(intervals[index])
            index += 1
        }

        // Phase 2:
        // Merge every interval that overlaps the growing interval.
        while index < intervals.count &&
              intervals[index][0] <= mergedEnd {
            mergedStart = min(mergedStart, intervals[index][0])
            mergedEnd = max(mergedEnd, intervals[index][1])
            index += 1
        }

        result.append([mergedStart, mergedEnd])

        // Phase 3:
        // Append intervals completely after the merged interval.
        while index < intervals.count {
            result.append(intervals[index])
            index += 1
        }

        return result
    }
}


// GPT's summary:
//
// Main logic issue:
// - `newInterval[0] <= currentInterval[1]` alone does not prove overlap.
//
// Failing example:
// - Current interval: [3, 5]
// - New interval: [1, 2]
// - 1 <= 5 is true, but the intervals do not overlap.
// - The new interval belongs before [3, 5].
//
// Complete interval relationship:
//
// 1. Current interval is before the new interval:
//    currentEnd < newStart
//
// 2. Current interval is after the new interval:
//    currentStart > newEnd
//
// 3. Otherwise, they overlap.
//
// Why three phases work:
// - The existing intervals are already sorted and non-overlapping.
// - First append everything before the new interval.
// - Then merge every overlapping interval.
// - After the first non-overlapping interval on the right, all remaining
//   intervals can be appended directly.
//
// Swift syntax mistakes:
// - Extra parenthesis:
//   `min(newInterval[0], curInterval[0]))`
// - Correct:
//   `min(newInterval[0], curInterval[0])`
//
// - Typo:
//   `interval.count`
// - Correct:
//   `intervals.count`
//
// - `let combineInterval = [Int]()` cannot be changed.
// - Use `var` if you need to append:
//   `var combineInterval = [Int]()`
// - Or create it directly:
//   `let combineInterval = [left, right]`
//
// - Array removal by index is:
//   `intervals.remove(at: index)`
// - However, `intervals` is a function parameter and cannot be mutated
//   unless copied into a `var`.
// - Removing while moving forward also shifts later indices, so building a
//   new result array is safer.
//
// Insertion syntax:
// - Insert at a specific index:
//   `array.insert(value, at: index)`
// - Append to the end:
//   `array.append(value)`
// - This solution only needs append because it builds result in order.
//
// What you did well:
// - You correctly decided to merge forward through chained overlaps.
// - You correctly used min for the merged start and max for the merged end.
// - You correctly recognized that sorting/order is important.
// - This problem guarantees the existing intervals are already sorted, so
//   no additional sorting is required.
//
// Complexity:
// - Time: O(n)
// - Extra space: O(n) for the returned array.