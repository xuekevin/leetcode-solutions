// Your original solution:
// class Solution {
//    func trap(_ height: [Int]) -> Int {
//    }
// }
//
// // thinking
// // the trapping water, is adjacent height area
// // so I can do a for loop, from left to right
// // have two pointers, one is left, one is right
// // to caculate current trapped water
// // use example to figure out the detail solution
// // when to update the left and right
// // left and right
// // left = -1, right = -1
// // think why height[0] doesn't have water, because left side has no wall to trap, which means
// // left side wall is nil
// // so range's left side and right side at least need to be > 0, otherwise can't trap the water
// // so move both to left = right = 0
// // then move left and right both to 1
// // then since left > 0 , current height[i], possible to trap the water
// // so possible area, cur area = 1 - 0 * (2-1)
// // for next height[i] = 2, >= left, so the possible area become real, so toal += 1
// // then reset left = (height:2, index:3),move next, 2 > 1, current height(i), possible area = (2-1) * (4-3)
// // next height[i] = 0, left > 0, so possible area +=  (2-0) * 1
// // move to next, possible area += (2-1) * 1
// // move to next, height[i] = 3 > 2, can trap the water, so total += possible area water
// // reset left = current height[i] = 3, reset possible area = 0
// // the continue
// // possible += (3-2) * 1
// // possible += (3-1) * 1
// // possible += (3-2) * 1
// // possible += (3-1) * 1
// // to the end, still not see the new wall bigger than previous left
// // what should I do
// // move the left to choose new left boundary
// // which is height[8] = 2, then do it again, found the trapped water
// // then add to total
// // reset left to height[10] = 2
// // next height = 1, still possible area is 2-1 * 1
// // so left should < height.count - 2, otherwise can't generate trap water
// // also left should >= 1,
// // time is up, will let gpt to wirte code with my logic
//
// // Pattern:
// // Card shape:
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank


// Fix version: directly records the tallest wall on both sides.
class fixSolution {
    func trap(_ height: [Int]) -> Int {
        guard height.count >= 3 else {
            return 0
        }

        let n = height.count

        // leftMax[i] = tallest wall from index 0 through i.
        var leftMax = Array(repeating: 0, count: n)
        leftMax[0] = height[0]

        for i in 1..<n {
            leftMax[i] = max(leftMax[i - 1], height[i])
        }

        // rightMax[i] = tallest wall from index n - 1 through i.
        var rightMax = Array(repeating: 0, count: n)
        rightMax[n - 1] = height[n - 1]

        for i in stride(from: n - 2, through: 0, by: -1) {
            rightMax[i] = max(rightMax[i + 1], height[i])
        }

        var totalWater = 0

        for i in 0..<n {
            // Water is limited by the shorter of the two walls.
            let waterLevel = min(leftMax[i], rightMax[i])

            // Each index represents one column with width 1.
            totalWater += waterLevel - height[i]
        }

        return totalWater
    }
}


// Upgrade version: same wall idea, but uses O(1) extra space.
class Solution {
    func trap(_ height: [Int]) -> Int {
        var left = 0
        var right = height.count - 1

        // Tallest walls seen from each side so far.
        var leftMax = 0
        var rightMax = 0

        var totalWater = 0

        while left < right {
            // The shorter current side determines which side is safe to process.
            if height[left] <= height[right] {
                if height[left] >= leftMax {
                    // New left boundary wall.
                    leftMax = height[left]
                } else {
                    // A right wall is guaranteed because height[right]
                    // is at least as tall as height[left].
                    totalWater += leftMax - height[left]
                }

                left += 1
            } else {
                if height[right] >= rightMax {
                    // New right boundary wall.
                    rightMax = height[right]
                } else {
                    // A left wall is guaranteed because height[left]
                    // is taller than height[right].
                    totalWater += rightMax - height[right]
                }

                right -= 1
            }
        }

        return totalWater
    }
}

/*
 GPT's summary

 Good:
 - You correctly identified that water needs a left wall and a right wall.
 - You also noticed the difficult case: you may not find a taller right wall
   before reaching the end.

 Key formula:
 water at index i =
 min(tallest wall on the left, tallest wall on the right) - height[i]

 Important correction:
 - Do not calculate one large rectangle and save "possible water."
 - Calculate water column by column.
 - Every column has width 1.

 Example:
 height = [4, 2, 0, 3, 2, 5]

 At index 2:
 leftMax = 4
 rightMax = 5
 water = min(4, 5) - 0 = 4

 Why the upgrade can move the shorter side:
 - If height[left] <= height[right], the right side already guarantees
   a boundary for the current left position.
 - Therefore, the current left position is limited only by leftMax.
 - The same logic applies symmetrically for the right side.

 Complexity:
 - Fix version:
   Time O(n), Space O(n)
 - Upgrade version:
   Time O(n), Space O(1)
*/