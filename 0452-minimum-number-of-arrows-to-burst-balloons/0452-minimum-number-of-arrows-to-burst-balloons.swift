// ============================================================
// FIX VERSION: Follows your overlap-range approach
// ============================================================

class fixSolution {
    func findMinArrowShots(_ points: [[Int]]) -> Int {
        if points.isEmpty {
            return 0
        }

        // Sort by each balloon's left boundary.
        let sortedPoints = points.sorted {
            $0[0] < $1[0]
        }

        var arrows = 1

        // This is the shared intersection of all balloons that
        // can currently be burst using the same arrow.
        var overlapLeft = sortedPoints[0][0]
        var overlapRight = sortedPoints[0][1]

        for i in 1..<sortedPoints.count {
            let point = sortedPoints[i]

            if point[0] > overlapRight {
                // The current balloon starts after the shared overlap.
                // It needs a new arrow.
                arrows += 1

                // Start a new overlap range using the current balloon.
                overlapLeft = point[0]
                overlapRight = point[1]
            } else {
                // The balloon overlaps the current shared range.
                // Keep only their intersection.
                overlapLeft = max(overlapLeft, point[0])
                overlapRight = min(overlapRight, point[1])
            }
        }

        return arrows
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Sort by the right boundary and greedily shoot there.
// ============================================================

class Solution {
    func findMinArrowShots(_ points: [[Int]]) -> Int {
        if points.isEmpty {
            return 0
        }

        // Process balloons by the earliest ending position.
        let sortedPoints = points.sorted {
            $0[1] < $1[1]
        }

        var arrows = 1

        // Shoot the first arrow at the earliest possible ending point.
        var arrowPosition = sortedPoints[0][1]

        for point in sortedPoints.dropFirst() {
            // Boundaries are inclusive, so point[0] == arrowPosition
            // means the existing arrow can still burst this balloon.
            if point[0] > arrowPosition {
                arrows += 1
                arrowPosition = point[1]
            }
        }

        return arrows
    }
}

// ============================================================
// ORIGINAL SOLUTION
// ============================================================

/*
class Solution {
    func findMinArrowShots(_ points: [[Int]]) -> Int {
        if points.count == 1 {
            return 1
        }

        let sortedPoints = points.sorted { $0[0] <= $1[0] }

        var arrow = 1
        var overlapRange = sortedPoints[0]

        for i in 1..<sortedPoints.count {
            let point = sortedPoints[i]

            if overlapRange[1] < point[0] {
                arrow += 1
                overlapRange = prePoint
            } else {
                let left = point[0]
                let right = min(prePoint[1], point[1])
                overlapRange = [left, right]
            }

            // not working, hard to maintain prePoint and overlapRange
        }

        return arrow
    }
}

// Thinking
// my take away
// Basically, to see how many sub array are overlaped
// so how to define two array overlap
// then combine them
// for example 1
// points can become [[1,8] [7,16]]
// so I can first sort the subArray
// then check if upper boundary has overlap
// 7 mins so far

// Pattern: array
// Card shape: as I mentioned above
// State needed: count how many arrow, if two sub array can combine,
//               then we can only count 1
// maintained current start and end, without actual change the sub array
// Contract: compare current with previous; if cur[0] > pre[1],
//           there is no overlap and we need one more arrow
// Recall: half

// [1,6] [2,8] -> [2,6] [7,9]
// already 30 mins, give up will let gpt to figure out
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
YOUR MAIN IDEA WAS CORRECT:

If multiple balloons share at least one x-coordinate, one arrow placed
inside that shared intersection bursts all of them.

Example:

    [1,6] and [2,8]

Their intersection is:

    [2,6]

An arrow anywhere from 2 through 6 bursts both.


WHY THE SHARED INTERSECTION MUST BE UPDATED:

Consider:

    [1,10], [2,3], [4,5]

The first balloon overlaps both other balloons individually.

But after processing [1,10] and [2,3], the shared range is:

    [2,3]

The next balloon [4,5] does not overlap [2,3], so it needs another arrow.

This is why comparing only with the previous balloon is insufficient.
We must maintain the intersection shared by the entire current group.


FIX-VERSION TRACE:

Input:

    [1,6], [2,8], [7,9]

Start:

    overlap = [1,6]
    arrows = 1

Process [2,8]:

    2 <= 6, so they overlap
    overlap = [max(1,2), min(6,8)]
            = [2,6]

Process [7,9]:

    7 > 6, so there is no shared overlap
    arrows = 2
    overlap = [7,9]

Answer:

    2


MISTAKES:

1. `prePoint` was never declared.

   When there is no overlap, reset using:

       overlapRange = point

   When there is overlap, compare with `overlapRange`, not `prePoint`.

2. Swift sorting closures should use a strict comparison:

   Avoid:

       $0[0] <= $1[0]

   Use:

       $0[0] < $1[0]

3. The empty-array case should return 0.

4. Your overlap test was correct:

       point[0] > overlapRight

   If they are equal, the same arrow can hit both because interval
   boundaries are inclusive.


WHY THE UPGRADE IS SIMPLER:

Sort balloons by their ending coordinate.

For the earliest-ending balloon, shoot at its right boundary. This
position gives the arrow the best chance to hit later balloons while
still guaranteeing that it hits the current balloon.

Example after sorting by end:

    [1,6], [2,8], [7,9]

Shoot at 6:

    [1,6] is hit
    [2,8] is also hit because 2 <= 6 <= 8
    [7,9] is not hit because 7 > 6

Shoot again at 9.

Answer = 2.


COMPLEXITY:

Both versions:

    Time:  O(n log n) because of sorting
    Space: O(n) in Swift because sorted() creates a new array

The traversal after sorting is O(n).
*/