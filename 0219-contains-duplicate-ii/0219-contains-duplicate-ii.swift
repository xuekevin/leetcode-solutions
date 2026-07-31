// Your original solution:
//
// class Solution {
//     func containsNearbyDuplicate(_ nums: [Int], _ k: Int) -> Bool {
//         var dict = [Int:Int]()
//          for (index, value) in nums.enumerated() {
//             if let i = dict[value] {
//                 if abs(i-index) <= k {
//                     return true
//                 }
//             }
//
//             dict[value] = index
//
//         }
//         return false
//     }
// }
//
// // run loop to check this nums
// // we store the value and the indices in key value dictionary
// // if we found same value, we compare the abs(i-j) with k
// // if it is smaller, then we return true
// // if it is not, we update the dictionary, with the latest index
// // after the loop, will will find the result
//
// // Input: nums = [1,2,3,1], k = 3
// // numsDict:[Int:Int]
// // for loop
//
// // index 0: [(1:0)]
// // 1: [(1:0),(2,1)]
// // 2: [(1:0),(2,1),(3,2)]
// // 3: we found 1 in dict, so compare index abs(0-3) <=3, we found it ,return true
//
// // use almost 9 mins to figure out above solution
//
// // total time is 17 mins
//
// // made some synatx mistakes, figure out by asking chatgpt
//
// // enumerated() is a method, so it needs parentheses.
// // Dictionaries are accessed with subscript syntax: dict[key].
// // dict[key] returns an optional value, like Int?, because the key might not exist.
// // Use optional binding to safely unwrap:

class Solution {
    func containsNearbyDuplicate(_ nums: [Int], _ k: Int) -> Bool {
        var dict = [Int: Int]()

        for (index, value) in nums.enumerated() {
            if let previousIndex = dict[value] {
                // Good: `previousIndex` is always before `index`,
                // so `index - previousIndex` is enough; `abs` is not needed.
                if index - previousIndex <= k {
                    return true
                }
            }

            // Good: keep the latest index for this value.
            // Why: it is the closest possible previous duplicate, so it gives
            // the best chance of being within k for future indices.
            dict[value] = index
        }

        return false
    }
}

// GPT's summary:
// What you did well:
// - Your algorithm is correct and optimal.
// - You correctly store each number's latest index.
// - You used `enumerated()` correctly to get both the index and value.
// - You used optional binding because a dictionary lookup can be nil.
//
// Key idea:
// - At each index, check whether this value appeared recently enough.
// - Then update the value's stored index to the current, latest index.
//
// Swift syntax to remember:
// - `nums.enumerated()` gives `(index, value)` pairs.
// - `dict[key]` returns an optional because the key may not exist.
// - `if let previousIndex = dict[value]` safely unwraps that optional.
//
// Complexity:
// - Time: O(n), where n is `nums.count`.
// - Space: O(n) in the worst case for the dictionary.