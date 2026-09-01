// Your original solution:
// class Solution {
//    func snakesAndLadders(_ board: [[Int]]) -> Int {
//    }
// }
//
// // Thinking
// // spend 2 mins to read the issue
// // so start from left bottom corner
// // every time can move [curr + 1, min(curr + 6, n2)], 1-6 steps
// // so the issue is to get least number
// // seems for board[i][j] I can know the furtherest place to go for this [i][j]
// // seems can be dp issue
// // dp[n][n] is the least dice count to go [n][n]
// // but what's convertion
// // give a board[i][j] I can know how further it can go
// // example so one dice, I will find I can go to the 15 value place
// // but does it mean for 1 dice, I 1-2-15 is the best route to arrive final [n][n]
// // that's the thing I am not sure
// // unless I do brute force to list all choice
// // time is up
// // will let gpt help


class Solution {
    func snakesAndLadders(_ board: [[Int]]) -> Int {
        let n = board.count
        let target = n * n

        // BFS queue stores square labels: 1, 2, 3, ..., n * n.
        var queue = [1]

        // Index 0 is unused so visited[label] matches the board label.
        var visited = Array(repeating: false, count: target + 1)
        visited[1] = true

        var front = 0
        var diceRolls = 0

        while front < queue.count {
            // Every square in this level uses exactly `diceRolls` moves.
            let levelSize = queue.count - front

            for _ in 0..<levelSize {
                let current = queue[front]
                front += 1

                // Try every possible dice roll: 1 through 6.
                for next in (current + 1)...min(current + 6, target) {
                    // Convert a square label, such as 15, to board[row][column].
                    let (row, column) = getCoordinate(next, n)

                    // Take a snake or ladder once if it exists.
                    let destination = board[row][column] == -1
                        ? next
                        : board[row][column]

                    // We reached the final square with this one extra roll.
                    if destination == target {
                        return diceRolls + 1
                    }

                    if !visited[destination] {
                        visited[destination] = true
                        queue.append(destination)
                    }
                }
            }

            // The next BFS level requires one more dice roll.
            diceRolls += 1
        }

        return -1
    }

    // Converts a 1-based square label into board coordinates.
    func getCoordinate(_ square: Int, _ n: Int) -> (Int, Int) {
        let index = square - 1

        // Count the row from the bottom of the board.
        let rowFromBottom = index / n

        // Position inside that row.
        var column = index % n

        // Every other row runs in the opposite direction.
        if rowFromBottom % 2 == 1 {
            column = n - 1 - column
        }

        // Swift row 0 is at the top, so flip the bottom-based row.
        let row = n - 1 - rowFromBottom

        return (row, column)
    }
}

/*
 GPT's summary

 Why BFS instead of DP:
 - A snake may move backward.
 - That can create cycles, so there is no simple "previous cells" DP relation.
 - Every dice roll costs exactly 1 move.
 - BFS finds the minimum number of equal-cost moves.

 Important correction:
 - `1 -> 2 -> 15` can mean one dice roll, not two.
 - Roll a 1 from square 1 and land on square 2.
 - If square 2 has a ladder to 15, you immediately move to 15.
 - The ladder does not cost another dice roll.

 In graph language:
 - Every square label is a node.
 - From square `current`, there are up to six choices:
   current + 1 through current + 6.
 - A snake or ladder changes that chosen landing square into its destination.

 Complexity:
 - Time: O(n^2)
 - Space: O(n^2)
*/