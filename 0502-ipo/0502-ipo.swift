// Your original solution:
// class Solution {
//    func findMaximizedCapital(_ k: Int, _ w: Int, _ profits: [Int], _ capital: [Int]) -> Int {
//    }
// }
//
// // Thinking
// // it's about the chooice
// // but there is limitation to make the choice
// // everytime when choice profits
// // need cur Capital > capital[i]
// // and no more project - 1
// // kind like backtrack
//
// // if chosedProject == k {
// // resultProfit = max(resultProfit, curProfit)
// //}
//
// // make a choice
// // for i in 0..<profits.count
// // if choose[i] == false && curCapital < capital[i] continue
// // choose[i] = true
// // curCaptial = curCapital - capital[i] + profits[i]
// // helper(k,w,profits, capital)
// // unmake choose[i]
//
// // 7 mins so far
//
// // remaining will let gpt to write


class Solution {
    func findMaximizedCapital(
        _ k: Int,
        _ w: Int,
        _ profits: [Int],
        _ capital: [Int]
    ) -> Int {
        // Each project is: (required capital, profit).
        // Sort by required capital so we can unlock projects in order.
        let projects = zip(capital, profits).sorted { first, second in
            first.0 < second.0
        }

        var currentCapital = w
        var projectIndex = 0

        // Max heap: affordable project profits.
        var maxHeap = [Int]()

        func push(_ profit: Int) {
            maxHeap.append(profit)

            var child = maxHeap.count - 1

            // Shift the new value upward until heap order is restored.
            while child > 0 {
                let parent = (child - 1) / 2

                if maxHeap[parent] >= maxHeap[child] {
                    break
                }

                maxHeap.swapAt(parent, child)
                child = parent
            }
        }

        func popMax() -> Int? {
            guard !maxHeap.isEmpty else {
                return nil
            }

            if maxHeap.count == 1 {
                return maxHeap.removeLast()
            }

            // Save the largest profit from the root.
            let maximum = maxHeap[0]

            // Move the final element to the root.
            maxHeap[0] = maxHeap.removeLast()

            var parent = 0

            // Shift the root downward until heap order is restored.
            while true {
                let leftChild = parent * 2 + 1
                let rightChild = parent * 2 + 2

                if leftChild >= maxHeap.count {
                    break
                }

                var largerChild = leftChild

                if rightChild < maxHeap.count &&
                    maxHeap[rightChild] > maxHeap[leftChild] {
                    largerChild = rightChild
                }

                if maxHeap[parent] >= maxHeap[largerChild] {
                    break
                }

                maxHeap.swapAt(parent, largerChild)
                parent = largerChild
            }

            return maximum
        }

        // Complete at most k projects.
        for _ in 0..<k {
            // Add every project we can currently afford to the max heap.
            while projectIndex < projects.count &&
                projects[projectIndex].0 <= currentCapital {
                push(projects[projectIndex].1)
                projectIndex += 1
            }

            // No project is currently affordable, so we cannot continue.
            guard let bestProfit = popMax() else {
                break
            }

            // Important:
            // Capital is NOT spent.
            // Completing a project only adds its profit.
            currentCapital += bestProfit
        }

        return currentCapital
    }
}

/*
 GPT's summary

 Important correction:
 - A project requires `capital[i]` to start.
 - You do NOT subtract `capital[i]`.
 - If currentCapital >= capital[i], you may complete it.
 - After completion:
   currentCapital += profits[i]

 Why this is greedy, not backtracking:
 - Completing a project never decreases capital.
 - More capital only unlocks more projects.
 - Therefore, among projects you can afford now, choose the one with
   the largest profit. It gives the most capital for future choices.

 How the data structures work:
 - Sort projects by required capital.
 - Move affordable projects into a max heap.
 - The heap root is the highest available profit.
 - Complete that project, increase capital, and repeat up to k times.

 Example:
 k = 2
 w = 0
 profits = [1, 2, 3]
 capital = [0, 1, 1]

 Start:
 currentCapital = 0
 affordable projects: profit 1
 choose profit 1 -> currentCapital = 1

 Now:
 affordable projects: profit 2, profit 3
 choose profit 3 -> currentCapital = 4

 Answer: 4

 Complexity:
 - Time: O(n log n + k log n)
 - Space: O(n)
*/