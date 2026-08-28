/**
 * Definition for a QuadTree node.
 * public class Node {
 *     public var val: Bool
 *     public var isLeaf: Bool
 *     public var topLeft: Node?
 *     public var topRight: Node?
 *     public var bottomLeft: Node?
 *     public var bottomRight: Node?
 *     public init(_ val: Bool, _ isLeaf: Bool) {
 *         self.val = val
 *         self.isLeaf = isLeaf
 *         self.topLeft = nil
 *         self.topRight = nil
 *         self.bottomLeft = nil
 *         self.bottomRight = nil
 *     }
 * }
 */


class Solution {
    func construct(_ grid: [[Int]]) -> Node? {
        // Begin with the entire grid:
        // top-left coordinate = (0, 0)
        // region size = grid.count
        return build(grid, 0, 0, grid.count)
    }

    // Builds a Quad-Tree node for one square region of the grid.
    //
    // row, column: top-left coordinate of this region.
    // size: width and height of this square.
    func build(_ grid: [[Int]], _ row: Int, _ column: Int, _ size: Int) -> Node {
        // Use the first cell as the value to compare against.
        let firstValue = grid[row][column]

        // Check whether the whole current square is all 0s or all 1s.
        var isUniform = true

        for r in row..<(row + size) {
            for c in column..<(column + size) {
                if grid[r][c] != firstValue {
                    isUniform = false
                    break
                }
            }

            // Stop scanning as soon as we find different values.
            if !isUniform {
                break
            }
        }

        // Base case:
        // A uniform square becomes one leaf node.
        if isUniform {
            return Node(firstValue == 1, true)
        }

        // Recursive case:
        // A mixed square must be divided into four equal squares.
        let half = size / 2

        let topLeft = build(grid, row, column, half)

        let topRight = build(
            grid,
            row,
            column + half,
            half
        )

        let bottomLeft = build(
            grid,
            row + half,
            column,
            half
        )

        let bottomRight = build(
            grid,
            row + half,
            column + half,
            half
        )

        // Your LeetCode Node initializer accepts only:
        // Node(val, isLeaf)
        //
        // For an internal node, val can be true or false.
        let node = Node(true, false)

        // Attach the four child regions after creating the node.
        node.topLeft = topLeft
        node.topRight = topRight
        node.bottomLeft = bottomLeft
        node.bottomRight = bottomRight

        return node
    }
}

/*
 GPT'S SUMMARY

 Recursive contract:
 build(grid, row, column, size) returns a Quad-Tree node representing
 the size x size square beginning at (row, column).

 Base case:
 If all cells in the current region are identical, return:
 Node(firstValue == 1, true)

 Recursive case:
 If the region contains both 0 and 1:
 1. Split it into four equal squares.
 2. Build each child recursively.
 3. Create a non-leaf node.
 4. Attach its topLeft, topRight, bottomLeft, and bottomRight children.

 Swift syntax you missed:
 Your provided Node class has only this initializer:
 Node(_ val: Bool, _ isLeaf: Bool)

 Therefore, this does NOT compile:
 Node(true, false, topLeft, topRight, bottomLeft, bottomRight)

 Instead:
 let node = Node(true, false)
 node.topLeft = topLeft
 node.topRight = topRight
 node.bottomLeft = bottomLeft
 node.bottomRight = bottomRight

 Time complexity: O(n^2 * log n) worst case.
 Space complexity: O(log n) recursion stack, excluding the returned tree.
*/