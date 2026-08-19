// ============================================================
// FIX VERSION: Follows your coordinate-mapping thought
// Move four cells together to avoid overwriting their values.
// ============================================================

class fixSolution {
    func rotate(_ matrix: inout [[Int]]) {
        let n = matrix.count

        // Process the matrix one square layer at a time.
        for layer in 0..<(n / 2) {
            let first = layer
            let last = n - 1 - layer

            // Rotate each position along the top edge of this layer.
            for i in first..<last {
                let offset = i - first

                // Save top because it will be overwritten first.
                let top = matrix[first][i]

                // Left -> top
                matrix[first][i] = matrix[last - offset][first]

                // Bottom -> left
                matrix[last - offset][first] =
                    matrix[last][last - offset]

                // Right -> bottom
                matrix[last][last - offset] = matrix[i][last]

                // Saved top -> right
                matrix[i][last] = top
            }
        }
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Transpose the matrix, then reverse every row.
// ============================================================

class Solution {
    func rotate(_ matrix: inout [[Int]]) {
        let n = matrix.count

        // Step 1: Transpose across the main diagonal.
        // Swap matrix[row][column] with matrix[column][row].
        for row in 0..<n {
            for column in (row + 1)..<n {
                let temporary = matrix[row][column]
                matrix[row][column] = matrix[column][row]
                matrix[column][row] = temporary
            }
        }

        // Step 2: Reverse every row.
        for row in 0..<n {
            matrix[row].reverse()
        }
    }
}

// ============================================================
// ORIGINAL THINKING
// ============================================================

/*
Thinking:
- Rotate the matrix 90 degrees clockwise.
- A horizontal row becomes a vertical column.
- Row 0 becomes column n - 1.
- Row 1 becomes column n - 2.
- Row 2 becomes column n - 3.
- A temporary value is needed because this must be done in place.

Coordinate rule discovered:

    old: (row, column)
    new: (column, n - 1 - row)

Examples for a 3 x 3 matrix:

    (0, 0) -> (0, 2)
    (0, 1) -> (1, 2)
    (0, 2) -> (2, 2)

Pattern: Matrix traversal
Card shape: Move values according to the rotation coordinate rule.
State needed: Temporary value and current layer boundaries.
Contract: After one layer finishes, that outer square is rotated.
Recall: blank
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
YOUR COORDINATE IDEA WAS CORRECT:

For clockwise rotation:

    newRow = oldColumn
    newColumn = n - 1 - oldRow

Therefore:

    (row, column) -> (column, n - 1 - row)

The earlier formula was missing `oldRow`:

    newColumn = n - 1 - oldRow

It is not always simply n - 1.


WHY DIRECT ASSIGNMENT DOES NOT WORK:

If we write:

    matrix[column][n - 1 - row] = matrix[row][column]

the destination's old value is overwritten before it can be moved.

The fix version saves one value and rotates four related cells together:

    top <- left <- bottom <- right <- saved top


WHY TRANSPOSE + REVERSE WORKS:

Original:

    1 2 3
    4 5 6
    7 8 9

After transpose:

    1 4 7
    2 5 8
    3 6 9

After reversing every row:

    7 4 1
    8 5 2
    9 6 3

That is exactly a 90-degree clockwise rotation.


WHY ONLY SWAP ABOVE THE DIAGONAL:

During transpose, swapping every cell would swap each pair twice and
undo the work. Starting column at row + 1 visits each pair once:

    for column in (row + 1)..<n


COMPLEXITY:

Time: O(n²)
Space: O(1)

Both versions modify the matrix in place without creating another matrix.
*/