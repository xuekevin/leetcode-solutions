// ============================================================
// FIX VERSION By GPT: Maintain a min-heap containing the k largest values
// Time: O(n log k)
// ============================================================

class Solution {
    func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
        var minHeap = [Int]()

        for number in nums {
            if minHeap.count < k {
                // Fill the heap until it contains k values.
                push(number, into: &minHeap)
            } else if number > minHeap[0] {
                // number belongs among the k largest values.
                minHeap[0] = number
                siftDown(&minHeap, from: 0)
            }
        }

        // The smallest of the k largest values is the kth largest.
        return minHeap[0]
    }

    func push(_ value: Int, into heap: inout [Int]) {
        heap.append(value)

        var child = heap.count - 1

        while child > 0 {
            let parent = (child - 1) / 2

            if heap[parent] <= heap[child] {
                break
            }

            heap.swapAt(parent, child)
            child = parent
        }
    }

    func siftDown(_ heap: inout [Int], from start: Int) {
        var parent = start

        while true {
            let leftChild = parent * 2 + 1
            let rightChild = parent * 2 + 2
            var smallest = parent

            if leftChild < heap.count
                && heap[leftChild] < heap[smallest] {
                smallest = leftChild
            }

            if rightChild < heap.count
                && heap[rightChild] < heap[smallest] {
                smallest = rightChild
            }

            if smallest == parent {
                break
            }

            heap.swapAt(parent, smallest)
            parent = smallest
        }
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION, but it didn't pass the time limit 
// Quickselect: average O(n) time
// ============================================================

class GPTSolution {
    func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
        var values = nums

        // In ascending order, kth largest is at index count - k.
        let targetIndex = values.count - k

        var left = 0
        var right = values.count - 1

        while left <= right {
            let pivotIndex = partition(
                &values,
                left,
                right
            )

            if pivotIndex == targetIndex {
                return values[pivotIndex]
            } else if pivotIndex < targetIndex {
                left = pivotIndex + 1
            } else {
                right = pivotIndex - 1
            }
        }

        return -1
    }

    func partition(
        _ values: inout [Int],
        _ left: Int,
        _ right: Int
    ) -> Int {
        // Use the middle value as the pivot.
        let selectedPivot = left + (right - left) / 2
        values.swapAt(selectedPivot, right)

        let pivotValue = values[right]
        var insertionIndex = left

        for index in left..<right {
            if values[index] <= pivotValue {
                values.swapAt(index, insertionIndex)
                insertionIndex += 1
            }
        }

        values.swapAt(insertionIndex, right)

        return insertionIndex
    }
}

// ============================================================
// YOUR ORIGINAL CODE AND THINKING COMMENTS
// Normalized from the pasted HTML/escape formatting.
// ============================================================

/*
class Solution {
    func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
    }
}

// Thinking
// without sorting
// this in stack section
// so towards this direction
// can maintain a k size stack
// top is the largest, every time
// try with example 1 for more detail
// first put in k stack
// 9 mins, not quite figure out
// give up

// Pattern:
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
YOUR "KEEP K VALUES" IDEA WAS CORRECT.

The adjustment is:

    Use a min-heap of size k.

Do not keep the largest value at the top.

Instead, keep the smallest of the current k largest values at the top.


WHY A MIN-HEAP?

Example:

    nums = [3, 2, 1, 5, 6, 4]
    k = 2

We need to maintain the two largest numbers.

After processing 3 and 2, the heap contains:

    [2, 3]

The root is 2, the smaller of the two candidates.

Process 1:

    1 <= root 2

Ignore it because it cannot belong to the largest two.

Process 5:

    5 > root 2

Replace 2 with 5:

    [3, 5]

Process 6:

    6 > root 3

Replace 3 with 6:

    [5, 6]

Process 4:

    4 <= root 5

Ignore it.

Final heap:

    [5, 6]

The smallest of the two largest values is:

    5

Therefore, 5 is the second-largest value.


WHY NOT A MAX-HEAP?

If we maintained a max-heap of k elements, the root would be the largest
candidate.

When a new number arrives, we need to decide whether it is larger than
the smallest candidate, not the largest candidate.

A min-heap exposes exactly the value we may need to remove.


WHY NOT A STACK?

A stack provides access only to the most recently added item.

It does not automatically tell us:

    the smallest value
    the largest value
    which value should be removed

A heap maintains that ordering relationship efficiently.


MIN-HEAP CONTRACT:

After processing each number:

    minHeap contains the largest min(processedCount, k) values seen
    so far.

When heap.count == k:

    minHeap[0] is the kth-largest value among the processed numbers.


HEAP INDEX RULES:

For a node at index:

    index

Its parent is:

    (index - 1) / 2

Its children are:

    index * 2 + 1
    index * 2 + 2


QUICKSELECT IDEA:

Quickselect does not fully sort the array.

It partitions values around a pivot:

    values <= pivot | pivot | values > pivot

After partitioning, the pivot is in its final sorted position.

If that position is the target index, return it.

Otherwise, search only one side.


WHY targetIndex = count - k?

Example:

    values = [1, 2, 3, 4, 5, 6]
    count = 6
    k = 2

The second-largest value is 5.

Its ascending index is:

    6 - 2 = 4

And:

    values[4] = 5


QUICKSELECT TRACE:

Input:

    [3, 2, 1, 5, 6, 4]
    k = 2

Target ascending index:

    6 - 2 = 4

Suppose partition places a pivot at index 2.

Because:

    2 < 4

the target must be on the right, so:

    left = 3

If the next pivot lands at index 4:

    pivotIndex == targetIndex

Return that value.


PATTERN:

Heap version:

    Priority queue / top-k

Quickselect version:

    Partition / selection algorithm


STATE:

Heap:

    A min-heap containing at most k values

Quickselect:

    Current left and right search boundaries
    Target sorted index


COMPLEXITY:

Min-heap:

    Time:  O(n log k)
    Space: O(k)

Quickselect:

    Average time: O(n)
    Worst time:   O(n²)
    Space:        O(n) in this Swift implementation because nums is
                  copied before being modified

Quickselect does not fully sort the array.
*/