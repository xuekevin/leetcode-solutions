// Your original solution:
//
// class Solution {
//     func hIndex(_ citations: [Int]) -> Int {
//         
//     }
// }
//
//
// // Thinking
// // so it is to count the value >= h, which h, about user at least have h paper and each paper has cited >= h
// // so for example
// // at 1 paper >= 1 citation
// // 2 paper >= 2 citation
// // ....
// // and we need to find. the maximum value
// // start from beginning
// // think if I can match the count and value when do the for loop
// // use exmaple to find the pattern
//
// // example [3,0,6,1,5]
// // h should >= 0
// // for loop
// // i = 0
// // count = 1
// //  3 citation,
// // count = 1, maxCitation = 3, so minCitation = 3,
// // i = 1, value = 0, 0 < minCitation. and 0 < count, which means we already has at least 1 count that >= minCitation, since 0 < both, then we should ignore this, and continue
// // i = 2, value: 6, 6 > minCitation, count +=1 , minCitation = 3, we have 2 count that >= minCitation
// // i = 3, value: 1, 1 < minCitation and 1 < count, continue as i = 1 case
// // i = 4, value: 5, 5 >= minCitation, count +=1, minCitation = 3, so we have 3 count that > = 3
// // since count in here is 3, and minCitation is also 3, so h = 3 is what we want
// // what if we have 3 count >= 5, then we should just return h = 3
//
// // already use 20 mins,above shoul more close the real interview time spend
// // now use example 2 to check
// // i = 0, count = 1, min = 1
// // i = 1, 3 >= min, count += 1, min = 1
// // i = 2 1 >= min, count += 1, min = 1
// // so count = 3, and min = 1, choose the min(count, min) as the h
// // don't have time to write the code, but here is what I plan
// // will let gpt to finish, already 23 mins
//
//
//
//
// // Pattern:
// // Card shape:
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank


// Fixed version: sort citations from largest to smallest.
class Solution {
    func hIndex(_ citations: [Int]) -> Int {
        let sortedCitations = citations.sorted(by: >)
        var hIndex = 0

        for (index, citation) in sortedCitations.enumerated() {
            // index is zero-based, so this is the number of papers
            // considered so far.
            let paperCount = index + 1

            if citation >= paperCount {
                // At least paperCount papers each have at least
                // paperCount citations.
                hIndex = paperCount
            } else {
                // Later citations are no larger, so no larger h can work.
                break
            }
        }

        return hIndex
    }
}


// Upgrade version: counting buckets without sorting.
// Rename UpgradeSolution to Solution before submitting.
class UpgradeSolution {
    func hIndex(_ citations: [Int]) -> Int {
        let paperCount = citations.count
        var counts = Array(repeating: 0, count: paperCount + 1)

        for citation in citations {
            // h cannot exceed the number of papers.
            // Therefore, all citations >= paperCount share one bucket.
            let bucket = min(citation, paperCount)
            counts[bucket] += 1
        }

        var papersWithAtLeastHCitations = 0

        for h in stride(from: paperCount, through: 0, by: -1) {
            papersWithAtLeastHCitations += counts[h]

            if papersWithAtLeastHCitations >= h {
                return h
            }
        }

        return 0
    }
}


// GPT's summary:
//
// What you understood correctly:
// - h means there are at least h papers with at least h citations each.
// - We need the maximum valid h.
// - If three papers each have at least five citations, h can be 3.
// - The citation count itself does not need to equal h.
//
// Problem with the running-minimum plan:
// - The input is unsorted.
// - An early small citation can make minCitation too small and prevent the
//   algorithm from discovering a larger valid h.
//
// Failing example: [1, 100, 100]
// - Your running minimum begins at 1 and stays at 1.
// - min(count, minCitation) would return 1.
// - But two papers have at least two citations, so the correct h-index is 2.
//
// Why sorting solves it:
// - Sorted descending: [6, 5, 3, 1, 0]
// - Position 1: 1 paper has at least 1 citation.
// - Position 2: 2 papers have at least 2 citations.
// - Position 3: 3 papers have at least 3 citations.
// - Position 4: citation 1 is less than 4, so h = 4 does not work.
// - The maximum valid h is 3.
//
// Loop contract:
// - After each successful iteration, hIndex is the largest paper count
//   checked so far where every included paper has at least that many
//   citations.
//
// Swift syntax to remember:
// - Sort descending:
//   `citations.sorted(by: >)`
// - Get index and value:
//   `for (index, citation) in array.enumerated()`
// - A function returning Int must return an Int on every path.
//
// Complexity:
// - Sorting version: O(n log n) time and O(n) space for the sorted array.
// - Bucket version: O(n) time and O(n) space.



// FIXED VERSION: Follows your original count + minimum citation idea in above thinking part

class FixedSolution {
    func hIndex(_ citations: [Int]) -> Int {
        let sortedCitations = citations.sorted(by: >)

        var count = 0
        var minCitation = Int.max
        var result = 0

        for citation in sortedCitations {
            count += 1
            minCitation = min(minCitation, citation)

            let currentH = min(count, minCitation)
            result = max(result, currentH)
        }

        return result
    }
}

/*
GPT'S SUMMARY

Your original idea works after sorting:

- count: number of papers considered
- minCitation: minimum citations among those papers
- min(count, minCitation): h-index supported by the current group

Time: O(n log n)
Space: O(n)
*/