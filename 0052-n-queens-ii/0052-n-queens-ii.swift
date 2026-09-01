class Solution {
    func totalNQueens(_ n: Int) -> Int {
        // Counts how many valid full queen arrangements we find.
        var result = 0

        // Stores columns that already contain a queen.
        var usedColumns = Set<Int>()

        // Stores main diagonals that already contain a queen.
        // Main diagonal identity = row - column.
        var usedMainDiagonals = Set<Int>()

        // Stores anti-diagonals that already contain a queen.
        // Anti-diagonal identity = row + column.
        var usedAntiDiagonals = Set<Int>()

        // `row` means: we are now trying to place one queen in this row.
        func backtrack(_ row: Int) {
            // Base case:
            // We successfully placed queens in rows 0 through n - 1.
            if row == n {
                result += 1
                return
            }

            // Try every possible column for the queen in this row.
            for column in 0..<n {
                // Calculate the two diagonal identities for (row, column).
                let mainDiagonal = row - column
                let antiDiagonal = row + column

                // Skip this position if another queen attacks it.
                if usedColumns.contains(column) ||
                    usedMainDiagonals.contains(mainDiagonal) ||
                    usedAntiDiagonals.contains(antiDiagonal) {
                    continue
                }

                // Choose:
                // Place a queen at coordinate (row, column).
                usedColumns.insert(column)
                usedMainDiagonals.insert(mainDiagonal)
                usedAntiDiagonals.insert(antiDiagonal)

                // Move down to place a queen in the next row.
                backtrack(row + 1)

                // Unchoose:
                // Remove this queen before trying another column
                // in the current row.
                usedColumns.remove(column)
                usedMainDiagonals.remove(mainDiagonal)
                usedAntiDiagonals.remove(antiDiagonal)
            }
        }

        // Begin by placing a queen in row 0.
        backtrack(0)

        // Return the number of valid complete boards.
        return result
    }
}