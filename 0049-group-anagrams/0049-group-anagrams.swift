// Your original solution:
// class Solution {
//     func groupAnagrams(_ strs: [String]) -> [[String]] {
//         if strs.count <= 1 {
//             return [strs]
//         }
//
//         var dict = [String: [String]]()
//
//         for item in strs {
//             let sortedItem = String.sort(item)
//
//             if let valueArr = dict[sortedItem] {
//                 var newValueArr = valueArr
//                 newValueArr.append(item)
//                 dict[sortedItem] = newValueArr
//             }
//
//             var valueArr = [String]()
//             valueArr.append(item)
//             dict[sortedItem] = valueArr
//         }
//
//         // convert dict to 2 level array
//         var outputArr = [[String]]()
//         for item in dict {
//             outputArr.append(item)
//         }
//
//         return outputArr
//     }
// }
//
// // so for each string I need to check if there a dictionary which the keys is the element it has
// // how to store the key, maybe I can store the new string as the key with alphebet increasing order
// // the basically before I check the dictionary I reorder the string, then compare with the dictionary
// // so the dictionary value is an array
//
// // use exmaple 1 to verify
// // saw eat, re-order -> aet, string it in dict: [("aet": ["eat"])]
// // tea, -> aet, so append the tea in the existing array [("aet": ["eat", "tea"]])
// // ...
//
// // use 5:47 mins figured out above, now try to write the code
//
// // question: "Does strs has duplicate str item? seems doesn't matter, I will just output it
//
// //  use 13 mins to write down above, I think my swift synatx is not right, but I don't know how to fix, but I assume the logic is correct
//
// // TC: O(n)
// // SC: O(n)

class Solution {
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        var dict = [String: [String]]()

        for item in strs {
            // Wrong: String.sort(item)
            // Why: String does not have a static method `sort` like this.
            // Correct: `item.sorted()` returns sorted characters, then `String(...)` rebuilds the String.
            let sortedItem = String(item.sorted())

            // Wrong: append inside `if`, then create a new array and overwrite the dictionary every time.
            // Why: even when the key already exists, your later assignment resets it to only `[item]`.
            // Correct: use dictionary default syntax to append into the existing group or create a new one.
            dict[sortedItem, default: []].append(item)
        }

        // Wrong: looping over `dict` gives `(key: String, value: [String])` pairs.
        // Why: `outputArr` expects `[String]`, not a dictionary key-value tuple.
        // Correct: collect only the dictionary values.
        return Array(dict.values)
    }
}

// GPT's summary:
// Mistakes you made:
// - You used `String.sort(item)`, but sorting a String is done from the string value: `item.sorted()`.
// - You updated the dictionary correctly inside `if`, but then overwrote that result right after.
// - You tried to append a dictionary key-value pair into `[[String]]`; you only need the dictionary values.
//
// Swift syntax to remember:
// - `String(item.sorted())` means sort characters, then rebuild a String.
// - `dict[key, default: []].append(value)` is the clean way to append into an array stored in a dictionary.
// - `Array(dict.values)` converts dictionary values into a normal array.
//
// Complexity:
// - Time: O(n * k log k), where n is number of strings and k is average string length.
// - Space: O(n * k) for storing groups and sorted keys.