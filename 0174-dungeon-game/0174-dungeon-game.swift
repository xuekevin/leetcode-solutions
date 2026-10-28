class Solution {

    var memos = [[Int]]()

    func calculateMinimumHP(_ dungeon: [[Int]]) -> Int {
        let m = dungeon.count
        let n = dungeon[0].count
        memos = Array(repeating: Array(repeating: 0, count:n), count: m)

        return dp(dungeon, 0, 0) 
    }
    

    func dp(_ dungeon: [[Int]], _ i: Int, _ j: Int) -> Int {
        let m = dungeon.count
        let n = dungeon[0].count

        guard i < m, j < n else {
            return 0
        }

        if memos[i][j] != 0 {
            return memos[i][j]
        }

        if i == m - 1 && j == n - 1 {
            memos[i][j] =  max(1, 1 - dungeon[i][j])
        } else if i == m - 1 {
            memos[i][j] = max(1, dp(dungeon, i, j+1) - dungeon[i][j])
        } else if j == n - 1 {
            memos[i][j] = max(1, dp(dungeon, i+1, j) - dungeon[i][j])
        } else {
            memos[i][j] = max(1, min(dp(dungeon, i, j+1), dp(dungeon, i+1, j)) - dungeon[i][j])
        }
        return memos[i][j]
    }
}


