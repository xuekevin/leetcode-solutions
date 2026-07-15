class Solution {
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        var dict = [String: [String]]()

        for item in strs {
            // Wrong: String.sort(item)
            // Why: String does not have a static sort method.
            // Correct: item.sorted() returns [Character], then String(...) converts it back.
            let sortedItem = String(item.sorted())

            // Wrong longer version problem:
            // if let valueArr = dict[sortedItem] {
            //     var newValueArr = valueArr
            //     newValueArr.append(item)
            //     dict[sortedItem] = newValueArr
            // }
            //
            // var valueArr = [String]()
            // valueArr.append(item)
            // dict[sortedItem] = valueArr
            //
            // Why: after appending to an existing group, you overwrite it with [item].
            // Correct: use dictionary default value and append directly.
            dict[sortedItem, default: []].append(item)
        }

        // Wrong:
        // for item in dict {
        //     outputArr.append(item)
        // }
        //
        // Why: item is a (key: String, value: [String]) pair, not [String].
        // Correct: use dict.values, then convert to Array.
        return Array(dict.values)
    }
}

