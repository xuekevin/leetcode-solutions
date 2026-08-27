/*
YOUR ORIGINAL SOLUTION:

class Solution {
    func kSmallestPairs(_ nums1: [Int], _ nums2: [Int], _ k: Int) -> [[Int]] {
        var heap = [Int]()

        let count1 = nums1.count
        let count2 = nums2.count
        var start1 = 0
        var start2 = 0

        while start1 < count1 || start2 < count2 {
            if nums1[start1] <= nums2[start2] {
                if heap.isEmpty {
                    heap.append(nums1[start1])
                } else {
                    if nums1[start1] <= heap[0] {
                        heap.insert(nums1[start1] at: 0)
                    } else if heap.count == k+1 {
                        let last = heap.last
                        if last > nums1[start1] {
                            heap[k] = nums1[start1]
                        }
                    } else {
                        heap.append(nums1[start1])
                    }
                }
            } else {
                if heap.isEmpty {
                    heap.append(nums2[start2])
                } else {
                    .....
                    // same as I did in previous if
                }
            }
        }

        let first = heap[0]
        var result = [[Int]]()
        for i in 1..<k {
            result.append([first, heap[i]])
        }
        return result
    }
}

// Thinking
// check the example
// so the result is
// minimum 1 pair with second, or third minium
// based on k
// we allow the same
// so we can gereate a sorted heap
// and the result is to return first k + 1 element
// to have k pair

// Pattern: Heap
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank

// around 5 mins so far
// start to write
// actually we just need to have first k minimum, no need to sort everything
// and for heap, I just need to have the minimum in the top
// the I need to find the k -1 minimum one that's fine
// so I can have the heap's top to keep the minium
// head's bottom to keep the maxinum, if heap count is less than k
// the just update the minimum at top and maximum one at the bottom
// already 18 mins, a little slow to write
// will let gpt to fix the remaining
*/


// FIX VERSION:
// The heap stores pair indexes, not individual values.

class Solution {
    private struct Pair {
        let firstIndex: Int
        let secondIndex: Int
        let sum: Int
    }

    func kSmallestPairs(
        _ nums1: [Int],
        _ nums2: [Int],
        _ k: Int
    ) -> [[Int]] {
        guard !nums1.isEmpty, !nums2.isEmpty, k > 0 else {
            return []
        }

        var result = [[Int]]()
        var heap = [Pair]()

        // Start with the first pair in each nums1 row:
        //
        // (0, 0), (1, 0), (2, 0), ...
        //
        // Only the first k rows can possibly contribute to the first
        // k smallest pairs.
        for firstIndex in 0..<min(k, nums1.count) {
            push(
                Pair(
                    firstIndex: firstIndex,
                    secondIndex: 0,
                    sum: nums1[firstIndex] + nums2[0]
                ),
                into: &heap
            )
        }

        while !heap.isEmpty && result.count < k {
            let smallest = pop(from: &heap)!

            result.append([
                nums1[smallest.firstIndex],
                nums2[smallest.secondIndex]
            ])

            let nextSecondIndex = smallest.secondIndex + 1

            // After using (i, j), the next possible pair in this row
            // is (i, j + 1).
            if nextSecondIndex < nums2.count {
                push(
                    Pair(
                        firstIndex: smallest.firstIndex,
                        secondIndex: nextSecondIndex,
                        sum: nums1[smallest.firstIndex] +
                             nums2[nextSecondIndex]
                    ),
                    into: &heap
                )
            }
        }

        return result
    }

    private func push(_ pair: Pair, into heap: inout [Pair]) {
        heap.append(pair)
        var child = heap.count - 1

        while child > 0 {
            let parent = (child - 1) / 2

            if heap[parent].sum <= heap[child].sum {
                break
            }

            heap.swapAt(parent, child)
            child = parent
        }
    }

    private func pop(from heap: inout [Pair]) -> Pair? {
        guard !heap.isEmpty else {
            return nil
        }

        if heap.count == 1 {
            return heap.removeLast()
        }

        let minimum = heap[0]
        let last = heap.removeLast()
        heap[0] = last

        var parent = 0

        while true {
            let leftChild = parent * 2 + 1
            let rightChild = parent * 2 + 2
            var smallest = parent

            if leftChild < heap.count &&
                heap[leftChild].sum < heap[smallest].sum {
                smallest = leftChild
            }

            if rightChild < heap.count &&
                heap[rightChild].sum < heap[smallest].sum {
                smallest = rightChild
            }

            if smallest == parent {
                break
            }

            heap.swapAt(parent, smallest)
            parent = smallest
        }

        return minimum
    }
}


/*
GPT'S SUMMARY

Your good instinct:
- This is a min-heap problem.
- We only need the first k pairs, so sorting every possible pair would
  do unnecessary work.
- The heap top should represent the next smallest pair sum.

Main concept you missed:
- The heap cannot store individual values.
- It must store a pair, or indexes representing a pair.

For example:

    nums1 = [1, 7, 11]
    nums2 = [2, 4, 6]

A heap element needs enough information to represent:

    [1, 2], sum 3
    [1, 4], sum 5
    [7, 2], sum 9

A single number like `7` does not tell us whether the pair is:

    [7, 2]
    [7, 4]
    [7, 6]


WHY START WITH (i, 0)?

Think of every `nums1[i]` as one sorted row of possible pairs:

    nums1[0] = 1:
    [1, 2], [1, 4], [1, 6]

    nums1[1] = 7:
    [7, 2], [7, 4], [7, 6]

    nums1[2] = 11:
    [11, 2], [11, 4], [11, 6]

Each row is sorted because nums2 is sorted.

Initially, only the first item in every row can be the global minimum:

    [1, 2]
    [7, 2]
    [11, 2]

After we remove [1, 2], only its next neighbor can become relevant:

    [1, 4]

We do not need to immediately add [1, 6], because [1, 4] is always
smaller or equal.


EXAMPLE

    nums1 = [1, 7, 11]
    nums2 = [2, 4, 6]
    k = 3

Initial heap candidates:

    [1, 2], sum 3
    [7, 2], sum 9
    [11, 2], sum 13

Pop [1, 2]:

    result = [[1, 2]]

Push its next row pair:

    [1, 4], sum 5

Heap now contains:

    [1, 4], sum 5
    [7, 2], sum 9
    [11, 2], sum 13

Pop [1, 4], then push [1, 6].

The first three popped pairs are:

    [[1, 2], [1, 4], [1, 6]]


Mistakes in the original approach:

- `while start1 < count1 || start2 < count2` can access an index after
  one array is exhausted.
- A heap is not a fully sorted array. `heap.last` is not guaranteed to
  be the maximum value.
- `heap.insert(..., at: 0)` is O(n), and does not perform heap logic.
- The correct Swift syntax is:

      heap.insert(value, at: index)

- Pairing `heap[0]` with all other values cannot produce all possible
  valid pairs.
- You need to compare pair sums, not individual numbers.

Pattern:
- Min heap
- Sorted matrix / k-way merge

State needed:
- `Pair(firstIndex, secondIndex, sum)`
- Heap of the next candidate pair from each nums1 row.
- `result` containing pairs already removed from the heap.

Loop contract:
- The heap contains the smallest unchosen pair from every active row.
- Popping the heap produces the next globally smallest pair.

Complexity:
- Let m = nums1.count.
- Heap size: at most min(k, m).
- Time: O(k log(min(k, m))).
- Space: O(min(k, m)), excluding the required output.
*/