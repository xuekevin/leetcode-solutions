// Your original solution:
//
// class Solution {
//     func merge(_ intervals: [[Int]]) -> [[Int]] {
//         
//     }
// }
//
// // Pattern:
// // Card shape:
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:         blank
// // Thinking
// // How to find the overlap
// // compare two interval
//
//
// // sorted case below
// // [1,3] [2, 6]
// // 3 >= 2, which means overlap
// // [2,6],[8,10]
// // 6 < 8, no overlap
//
// // unsorted case
// // [4,7],[1,4]
// // first check 7 >= 1,
// // then check 4 >= 4, then it is overlapping
// // if it is 1,3, then 3 < 4, so no overlapping
// // we can do with first 2, gradually to find, but we can miss some
// // so we should sort first
// // how to sort, compare all left
// // 7 mins so far, ready to write code
// // while how to write the sort
// // quick sort ? or bubble sort
// // if we don't do the sort
// // just compare, how can I know when to do the overlap check
// // so should do the sort first
// // thoughts I can wite an equitable,
// // then use default sort method in swift language
// // but how to write equatable in swift
// // assume we figure out sort, then I will use above logic to check overlapping


// Fixed version:
class Solution {
    func merge(_ intervals: [[Int]]) -> [[Int]] {
        guard !intervals.isEmpty else {
            return []
        }

        // Correct: sort intervals by their starting values.
        // Equatable is not needed because we are ordering, not checking equality.
        let sortedIntervals = intervals.sorted {
            $0[0] < $1[0]
        }

        var result = [[Int]]()
        var currentInterval = sortedIntervals[0]

        for nextInterval in sortedIntervals.dropFirst() {
            let currentEnd = currentInterval[1]
            let nextStart = nextInterval[0]

            if nextStart <= currentEnd {
                // The intervals overlap.
                // Keep the current start and extend its end if necessary.
                currentInterval[1] = max(
                    currentInterval[1],
                    nextInterval[1]
                )
            } else {
                // There is a gap, so the current interval is complete.
                result.append(currentInterval)
                currentInterval = nextInterval
            }
        }

        // The final interval has no later gap to trigger its append.
        result.append(currentInterval)

        return result
    }
}


// GPT's summary:
//
// What you did well:
// - You correctly identified the overlap condition:
//   nextStart <= currentEnd.
// - You correctly realized that unsorted intervals should be sorted first.
// - Sorting by each interval's left boundary is the key step.
// - After sorting, only the current merged interval and next interval need
//   to be compared.
//
// Swift sorting syntax:
// - Use a comparison closure:
//   `let sorted = intervals.sorted { $0[0] < $1[0] }`
//
// Closure meaning:
// - `$0` is the first interval.
// - `$1` is the second interval.
// - `$0[0]` and `$1[0]` are their starting values.
// - Return true when the first interval should come before the second.
//
// Why Equatable is not needed:
// - Equatable answers whether two values are equal using `==`.
// - Sorting needs an ordering rule: which value should come first.
// - `sorted { ... }` accepts that ordering rule directly.
//
// Merge rule:
// - If nextStart <= currentEnd, they overlap.
// - The merged interval becomes:
//   [currentStart, max(currentEnd, nextEnd)]
//
// Example:
// - Current: [1, 3]
// - Next:    [2, 6]
// - Since 2 <= 3, merge them into [1, 6].
//
// Why sorting prevents missed overlaps:
// - Once sorted by start, every later interval starts at the same point or
//   farther right.
// - Extending currentEnd preserves chained overlaps.
//
// Example:
// - [1, 4], [2, 5], [4, 8]
// - Merge first two: [1, 5]
// - Then compare [1, 5] with [4, 8]
// - Final result: [1, 8]
//
// Loop contract:
// - At the top of each iteration, currentInterval contains the merged result
//   of the active overlapping group.
// - Every completed group before it is already stored in result.
//
// Complexity:
// - Sorting: O(n log n)
// - Merging: O(n)
// - Total time: O(n log n)
// - Extra space: O(n), including the sorted and returned arrays.