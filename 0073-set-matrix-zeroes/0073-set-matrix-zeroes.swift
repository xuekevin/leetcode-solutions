// ============================================================
// FIX VERSION: Follows your row-set and column-set approach
// ============================================================

class fixSolution {
    func setZeroes(_ matrix: inout [[Int]]) {
        if matrix.isEmpty || matrix[0].isEmpty {
            return
        }

        var zeroRows = Set<Int>()
        var zeroColumns = Set<Int>()

        let rowCount = matrix.count
        let columnCount = matrix[0].count

        // First pass: record the locations of original zeros.
        for row in 0..<rowCount {
            for column in 0..<columnCount {
                if matrix[row][column] == 0 {
                    // Swift Set uses insert(), not add().
                    zeroRows.insert(row)
                    zeroColumns.insert(column)
                }
            }
        }

        // Second pass: update all recorded rows and columns.
        for row in 0..<rowCount {
            for column in 0..<columnCount {
                if zeroRows.contains(row)
                    || zeroColumns.contains(column) {
                    matrix[row][column] = 0
                }
            }
        }
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Uses the first row and first column as marker storage.
// Extra space: O(1)
// ============================================================

class Solution {
    func setZeroes(_ matrix: inout [[Int]]) {
        if matrix.isEmpty || matrix[0].isEmpty {
            return
        }

        let rowCount = matrix.count
        let columnCount = matrix[0].count

        // matrix[0][0] belongs to both the first row and first column,
        // so two separate Boolean values are needed.
        var firstRowHasZero = false
        var firstColumnHasZero = false

        // Check whether the original first row contains a zero.
        for column in 0..<columnCount {
            if matrix[0][column] == 0 {
                firstRowHasZero = true
            }
        }

        // Check whether the original first column contains a zero.
        for row in 0..<rowCount {
            if matrix[row][0] == 0 {
                firstColumnHasZero = true
            }
        }

        // Use the first cell of each row and column as markers.
        for row in 1..<rowCount {
            for column in 1..<columnCount {
                if matrix[row][column] == 0 {
                    matrix[row][0] = 0
                    matrix[0][column] = 0
                }
            }
        }

        // Update the interior cells using the markers.
        for row in 1..<rowCount {
            for column in 1..<columnCount {
                if matrix[row][0] == 0
                    || matrix[0][column] == 0 {
                    matrix[row][column] = 0
                }
            }
        }

        // Update the first row after its markers are no longer needed.
        if firstRowHasZero {
            for column in 0..<columnCount {
                matrix[0][column] = 0
            }
        }

        // Update the first column after its markers are no longer needed.
        if firstColumnHasZero {
            for row in 0..<rowCount {
                matrix[row][0] = 0
            }
        }
    }
}

// ============================================================
// ORIGINAL SOLUTION
// ============================================================

/*
class Solution {
    func setZeroes(_ matrix: inout [[Int]]) {
        // think to create a Set

        var zeroRow = Set<Int>()
        var zeroCol = Set<Int>()

        var row = matrix.count
        var col = matrix[0].count

        for i in 0..<row {
            for j in 0..<col {
                if matrix[i][j] == 0 {
                    zeroRow.add(i)
                    zeroCol.add(j)
                }
            }
        }

        for i in 0..<row {
            for j in 0..<col {
                if zeroRow.contains(i) || zeroCol.contains(j) {
                    matrix[i][j] = 0
                }
            }
        }
    }
}

// Thinking
// read the description
// find a 0, then update its same row and col to 0
// seems straight forward
// traverse the grid, find the first 0,
// the change the same row and same col
// challenge
// how to find next 0
// how can I know this is the changed 0, or original 0
// create a memory array to represent if it is the 0 generated cell or not
// how to make sure I visit all the origin 0, as low as I visit all the cell
// I can use a map to store the zero existing row or col for first traverse
// then second time I change all these row or col's data to zero

// also it mentioned that need to be in place change

// Pattern: graph, traverse
// Card shape: two for loop
// State needed: maintain the map for zero's row and col
// Contract: for each cell, if it is 0, record the row and col;
//           then use a second traversal to update the matrix
// Recall: half

// 11 mins so far
// ready to write
// done in 17 mins
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
WHAT YOU GOT RIGHT:

1. Do not immediately change rows and columns during the first pass.
2. First record which rows and columns contain original zeros.
3. Use a second pass to modify the matrix.
4. This prevents newly generated zeros from being mistaken for original
   zeros.

SWIFT MISTAKES:

1. Set does not have add():

       zeroRows.add(row)

   Use:

       zeroRows.insert(row)

2. row and col do not change, so declare them with let:

       let rowCount = matrix.count
       let columnCount = matrix[0].count

PATTERN:

This is primarily:

    Matrix traversal + marking

It is not a graph problem because there is no search through connected
neighbors, such as DFS or BFS.


FIX-VERSION COMPLEXITY:

Time:
    O(rows * columns)

Space:
    O(rows + columns)

The sets may contain every row and every column.


UPGRADE IDEA:

Instead of separate sets, use:

    matrix[row][0]

to record whether an entire row should become zero, and:

    matrix[0][column]

to record whether an entire column should become zero.

Example:

    1 1 1
    1 0 1
    1 1 1

When the zero at (1,1) is found, mark:

    matrix[1][0] = 0
    matrix[0][1] = 0

Markers become:

    1 0 1
    0 0 1
    1 1 1

Later, those markers tell us to zero row 1 and column 1.


WHY TWO BOOLEAN VALUES ARE NEEDED:

matrix[0][0] cannot separately represent both:

    "The first row originally contained a zero"

and:

    "The first column originally contained a zero"

Therefore, store those facts in:

    firstRowHasZero
    firstColumnHasZero


WHY UPDATE THE FIRST ROW AND COLUMN LAST:

Their cells are being used as markers. If they were zeroed too early,
the marker information could be changed before the interior was updated.


UPGRADE COMPLEXITY:

Time:
    O(rows * columns)

Extra space:
    O(1)
*/