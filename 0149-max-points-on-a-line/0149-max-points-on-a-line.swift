
// Your original solution:
// class Solution {
//    func maxPoints(_ points: [[Int]]) -> Int {
//    }
// }
//
// // Thinking
// // this issue mentioned this is a math related issue
// // so there is must be some tricky part
// // but usually what we care most about
// // will ask directly in gpt


class Solution {
    func maxPoints(_ points: [[Int]]) -> Int {
        guard points.count > 2 else {
            return points.count
        }

        var answer = 0

        // Choose every point as the anchor point of a possible line.
        for i in 0..<points.count {
            // key = normalized slope
            // value = how many other points have this slope from points[i]
            var slopeCount = [String: Int]()

            // Counts copies of the anchor point.
            // Start at 1 because points[i] itself is on every line from it.
            var duplicates = 1

            var mostPointsWithSameSlope = 0

            for j in (i + 1)..<points.count {
                var deltaX = points[j][0] - points[i][0]
                var deltaY = points[j][1] - points[i][1]

                // Same coordinate as the anchor point.
                if deltaX == 0 && deltaY == 0 {
                    duplicates += 1
                    continue
                }

                // Reduce the slope fraction:
                // deltaY / deltaX
                //
                // Example:
                // 4 / 2 becomes 2 / 1
                let divisor = gcd(abs(deltaX), abs(deltaY))
                deltaX /= divisor
                deltaY /= divisor

                // Make one standard sign format.
                //
                // 1 / -2 and -1 / 2 are the same slope.
                // Keep deltaX positive whenever possible.
                if deltaX < 0 {
                    deltaX = -deltaX
                    deltaY = -deltaY
                }

                // Normalize all vertical lines to 1 / 0.
                if deltaX == 0 {
                    deltaY = 1
                }

                // Normalize all horizontal lines to 0 / 1.
                if deltaY == 0 {
                    deltaX = 1
                }

                let slope = "\(deltaY)/\(deltaX)"

                slopeCount[slope, default: 0] += 1

                mostPointsWithSameSlope = max(
                    mostPointsWithSameSlope,
                    slopeCount[slope]!
                )
            }

            // Add duplicate anchor points to every possible line.
            answer = max(answer, mostPointsWithSameSlope + duplicates)
        }

        return answer
    }

    // Greatest common divisor.
    func gcd(_ first: Int, _ second: Int) -> Int {
        var first = first
        var second = second

        while second != 0 {
            let remainder = first % second
            first = second
            second = remainder
        }

        return first
    }
}

/*
 GPT's summary

 Key idea:
 - Pick one point as an anchor.
 - Calculate the slope from that anchor to every later point.
 - Points with the same slope are on the same line with the anchor.
 - Repeat for every anchor.

 Why not use Double slopes:
 - 1 / 3 and 2 / 6 represent the same slope.
 - Floating-point calculations can be imprecise.
 - Use reduced integer fractions instead.

 Example:
 anchor = [1, 1]

 points:
 [2, 2] -> deltaY/deltaX = 1/1
 [3, 3] -> deltaY/deltaX = 2/2 -> reduce to 1/1
 [4, 5] -> deltaY/deltaX = 4/3

 slopeCount:
 "1/1": 2
 "4/3": 1

 The "1/1" line has:
 anchor + 2 matching points = 3 points.

 Why normalization is needed:
 - Vertical lines:
   3/0, -2/0, 1/0
   all mean the same vertical line.
   Normalize them as 1/0.

 - Horizontal lines:
   0/2, 0/-5
   all mean the same horizontal line.
   Normalize them as 0/1.

 - Negative signs:
   1/-2 and -1/2 are the same slope.
   Keep deltaX positive.

 Complexity:
 - Time: O(n^2 * log C), where C is the coordinate range for gcd.
 - Space: O(n) for the slope dictionary of one anchor point.
*/

// this might need to review again, but low priority