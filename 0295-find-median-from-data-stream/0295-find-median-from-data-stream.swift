// Your original solution:
// class MedianFinder {
//
//    init() {
//    }
//    func addNum(_ num: Int) {
//    }
//    func findMedian() -> Double {
//    }
// }
//
// /**
//  * Your MedianFinder object will be instantiated and called as such:
//  * let obj = MedianFinder()
//  * obj.addNum(num)
//  * let ret_2: Double = obj.findMedian()
//  */
//
// // Thinking
// // At most 5 * 104 calls will be made to addNum and findMedian.
// // first thought
// // when add a num, then we can sort the add number into to list
// // so when do median, we can just return the middle index of list
// // when we add the number, does the num also follow the order
// // since this is in queue, should we sort it in a binary tree?


class MedianFinder {
    // Max heap: stores the smaller half of all numbers.
    // Its top is the largest number in the smaller half.
    private var lower = Heap { first, second in
        first > second
    }

    // Min heap: stores the larger half of all numbers.
    // Its top is the smallest number in the larger half.
    private var upper = Heap { first, second in
        first < second
    }

    init() {
    }

    func addNum(_ num: Int) {
        // Put the number into the appropriate half.
        if let lowerTop = lower.peek, num <= lowerTop {
            lower.push(num)
        } else {
            upper.push(num)
        }

        // Keep lower the same size as upper,
        // or allow lower to have exactly one extra number.
        if lower.count > upper.count + 1 {
            upper.push(lower.pop()!)
        } else if upper.count > lower.count {
            lower.push(upper.pop()!)
        }
    }

    func findMedian() -> Double {
        // Odd total count:
        // lower has one extra item, so its top is the median.
        if lower.count > upper.count {
            return Double(lower.peek!)
        }

        // Even total count:
        // median is the average of the two middle values.
        return (Double(lower.peek!) + Double(upper.peek!)) / 2.0
    }

    private struct Heap {
        // Array representation of a binary heap.
        private var values = [Int]()

        // Defines whether the first value should be above the second.
        // `>` creates a max heap; `<` creates a min heap.
        private let hasHigherPriority: (Int, Int) -> Bool

        init(_ hasHigherPriority: @escaping (Int, Int) -> Bool) {
            self.hasHigherPriority = hasHigherPriority
        }

        var count: Int {
            return values.count
        }

        var peek: Int? {
            return values.first
        }

        mutating func push(_ value: Int) {
            values.append(value)

            // New values start at the end, then move upward if needed.
            var child = values.count - 1

            while child > 0 {
                let parent = (child - 1) / 2

                if hasHigherPriority(values[parent], values[child]) {
                    break
                }

                values.swapAt(parent, child)
                child = parent
            }
        }

        mutating func pop() -> Int? {
            guard !values.isEmpty else {
                return nil
            }

            if values.count == 1 {
                return values.removeLast()
            }

            // The root is the max or min value, depending on heap type.
            let top = values[0]

            // Move the final value to the root.
            let last = values.removeLast()
            values[0] = last

            // Restore heap order by moving the root downward.
            var parent = 0

            while true {
                let leftChild = parent * 2 + 1
                let rightChild = parent * 2 + 2
                var best = parent

                if leftChild < values.count &&
                    hasHigherPriority(values[leftChild], values[best]) {
                    best = leftChild
                }

                if rightChild < values.count &&
                    hasHigherPriority(values[rightChild], values[best]) {
                    best = rightChild
                }

                if best == parent {
                    break
                }

                values.swapAt(parent, best)
                parent = best
            }

            return top
        }
    }
}

/*
 GPT's summary

 Key idea:
 - Split all values into two halves.

 lower max heap:
 - Contains the smaller half.
 - Top = largest value in the smaller half.

 upper min heap:
 - Contains the larger half.
 - Top = smallest value in the larger half.

 Balance rule:
 - lower.count == upper.count
   OR
 - lower.count == upper.count + 1

 Example:
 Add: 1, 2, 3

 After 1:
 lower = [1]
 upper = []
 median = 1

 After 2:
 lower = [1]
 upper = [2]
 median = (1 + 2) / 2 = 1.5

 After 3:
 lower = [2, 1]
 upper = [3]
 median = 2

 Why not keep one sorted array:
 - Finding the middle would be O(1).
 - But inserting a number into the correct array position is O(n).
 - With two heaps:
   addNum = O(log n)
   findMedian = O(1)

 Complexity:
 - addNum: O(log n)
 - findMedian: O(1)
 - Space: O(n)
*/


// TBD, need to have knowledge card to learn how to generate max or min heap
