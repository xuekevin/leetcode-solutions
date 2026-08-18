// Your original solution:
//
// class Solution {
//     func numIslands(_ grid: [[Character]]) -> Int {
//         
//         var oneLocation = [(x: Int, y: Int)]()
//         var visitColumn = Array(repeating: false, count: grid[0].count)
//         // should be wrong, this is swift synatx
//         var visitGrid = Array(repeating: visitColumn, count:grid.count)
//         
//         for i in 0..<grid.count {
//             for j in 0..<grid[0].count {
//                 if grid[i][j] == "1" {
//                     oneLocation.append((x:i,y:j))
//                 }
//             }
//         }
//         var islandCount = 0
//
//         while !oneLocation.isEmpty() {
//             let one = oneLocation.first()
//             helper(grid, visitGrid, one.x, one.y)
//             isLandCount += 1
//         }
//         // call heper in here
//     }
//
//     func helper (_ gird: [[Character]], _ visitGrid: [[Bool]] _ x: Int, _ y: Int) {
//         // start this is 1
//         // then start to visit its top, down,left right, if it is 1, then mark as visited
//         // and also remove from oneLocation if it visited
//         // once we don't have no action, we return this helper
//         // how to define the island
//         // this can be recursive
//         // all use a for loop to change the coordinate
//     }
// }
//
//
// // Pattern: traverse, map
// // Card shape:
// // State needed:
// // Contract:      what is TRUE when one call returns?
// // Recall:        landed / half / blank
// // Thinking
// // it is about count the island
// // find an 1 then go through top down left right, until to boundary or 0
// // then we go to the island's boundary
// // before we go to next direction we check if it is 0, if 0, abort, find another direction
// // until there is no other option for all t he index, then we think we found 1 island
// // how to find other island?
// // and how to define a location has been visited, so we need a visited map
// // start from top left, if it is 1, then we start to search island boundary
// // what's exit of found the boundary of island?
// // for the start point 1, we marked all the visited 1
// // then we check grid's next 1. which is unvisited, which is another search, seems not efficient
// // basically do a mxn search, if visited map mark it as false, then we choose it as the new 1 start
// // what's end if all existed 1 be marked as visited, then we go through all the 1
// // so we can has a count to reprseented the visited
// // all I can used a dictionary to represented all the 1 with's coordinate
// // we visited, if we visited one, we removed it from map, so to define we find it in map
// // we can compare with visited x, y cooridated,
// // can has two map, one for 1's x, one for 1's y
// // 17 mins, think I can start to write
//
// // give up at 36 mins, will ask gpt to help for remaining stuff


// Fixed version:
class Solution {
    func numIslands(_ grid: [[Character]]) -> Int {
        guard !grid.isEmpty, !grid[0].isEmpty else {
            return 0
        }

        let rows = grid.count
        let columns = grid[0].count

        // Good: your nested visited-array initialization was valid Swift.
        var visited = Array(
            repeating: Array(repeating: false, count: columns),
            count: rows
        )

        var islandCount = 0

        for row in 0..<rows {
            for column in 0..<columns {
                if grid[row][column] == "1" &&
                    visited[row][column] == false {

                    // This unvisited land belongs to a new island.
                    islandCount += 1

                    // Mark its entire connected island as visited.
                    visitIsland(
                        grid,
                        &visited,
                        row,
                        column
                    )
                }
            }
        }

        return islandCount
    }

    func visitIsland(
        _ grid: [[Character]],
        _ visited: inout [[Bool]],
        _ row: Int,
        _ column: Int
    ) {
        // Stop when the coordinate is outside the grid.
        guard row >= 0,
              row < grid.count,
              column >= 0,
              column < grid[0].count else {
            return
        }

        // Stop at water or land that this DFS already visited.
        guard grid[row][column] == "1",
              visited[row][column] == false else {
            return
        }

        visited[row][column] = true

        // Visit the four connected directions.
        visitIsland(grid, &visited, row - 1, column)
        visitIsland(grid, &visited, row + 1, column)
        visitIsland(grid, &visited, row, column - 1)
        visitIsland(grid, &visited, row, column + 1)
    }
}


// GPT's summary:
//
// Key idea:
// - The outer loops find the start of each new island.
// - One DFS marks every connected land cell in that island.
// - Later outer-loop iterations skip those visited cells.
// - Therefore, increment islandCount once before each new DFS.
//
// Why oneLocation is unnecessary:
// - The outer matrix traversal already finds every "1".
// - Removing coordinates from another array adds more state and work.
// - We only need grid, visited, and islandCount.
//
// Recursive contract:
// - After `visitIsland` returns, every land cell connected to
//   grid[row][column] has been marked visited.
//
// Swift mistakes:
// - `isEmpty` is a property: `array.isEmpty`, not `array.isEmpty()`.
// - `first` is a property returning an optional.
// - Your helper parameter list was missing a comma.
// - `visited` must be `inout` because recursion modifies it.
// - Pass an inout argument using `&visited`.
// - `isLandCount` was a typo for `islandCount`.
// - numIslands must return islandCount.
//
// What you did well:
// - You correctly identified DFS and a visited matrix.
// - You correctly chose the four directions: up, down, left, and right.
// - Your nested Boolean-array initialization was valid Swift.
//
// Complexity:
// - Let m be rows and n be columns.
// - Time: O(m * n), because every cell is processed a constant number of times.
// - Space: O(m * n) for visited and up to O(m * n) recursion depth.