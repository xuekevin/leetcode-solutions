class Solution {
    var count = [Int]()

    func countSmaller(_ nums: [Int]) -> [Int] {
        count = Array(repeating: 0, count: nums.count)

        guard !nums.isEmpty else {
            return []
        }

        _ = sort(nums, 0, nums.count - 1)
        return count
    }

    // Returns pairs sorted from large to small.
    // Each pair keeps: (value, original index).
    func sort(
        _ nums: [Int],
        _ low: Int,
        _ high: Int
    ) -> [(value: Int, index: Int)] {
        // One number is already sorted.
        if low == high {
            return [(nums[low], low)]
        }

        let middle = low + (high - low) / 2

        let leftNums = sort(nums, low, middle)
        let rightNums = sort(nums, middle + 1, high)

        var merged = [(value: Int, index: Int)]()
        var i = 0
        var j = 0

        // Merge from large to small.
        while i < leftNums.count && j < rightNums.count {
            if leftNums[i].value > rightNums[j].value {
                // Every remaining right value is smaller than leftNums[i].
                count[leftNums[i].index] += rightNums.count - j

                merged.append(leftNums[i])
                i += 1
            } else {
                // Equal values are not smaller, so take right first.
                merged.append(rightNums[j])
                j += 1
            }
        }

        // Add remaining items.
        while i < leftNums.count {
            merged.append(leftNums[i])
            i += 1
        }

        while j < rightNums.count {
            merged.append(rightNums[j])
            j += 1
        }

        return merged
    }
}

/*
GPT's summary

Your main insight was good:
- Use merge sort.
- Store each number together with its original index.
- During merge, count how many right-side numbers are smaller.

Mistake 1: Base case

Wrong:
    guard low <= high else { return [] }

Why:
- When low == high, you must stop recursion and return that one item.
- Otherwise:
    sort(nums, low, middle)
becomes:
    sort(nums, low, low)
forever.

Correct:
    if low == high {
        return [(nums[low], low)]
    }

Mistake 2: Loop condition

Wrong:
    while i < leftCount || j < rightCount

Why:
- If one side is finished, accessing leftNums[i] or rightNums[j]
  can crash.

Correct:
    while i < leftNums.count && j < rightNums.count

Mistake 3: Merge must return sorted data.

Wrong:
    return leftNums + rightNums

Correct:
    return merged

Key counting rule:

When:
    leftNums[i].value > rightNums[j].value

The right array is sorted descending.

So every unprocessed right-side item is smaller than leftNums[i]:

    count[leftNums[i].index] += rightNums.count - j

Time Complexity: O(n log n)
Space Complexity: O(n)
*/