/*
YOUR ORIGINAL SOLUTION:

class Solution {
    func canCompleteCircuit(_ gas: [Int], _ cost: [Int]) -> Int {
        for i in 0..<gas.count {
            if gas[i] < cost[i] {
                continue
            }

            let isFound = helper(gas, cost, gas[i] - cost[i], i, i + 1)

            if isFound {
                return i
            }
        }

        return -1
    }

    func helper(
        _ gas: [Int],
        _ cost: [Int],
        _ filledGas: Int,
        _ start: Int,
        _ cur: Int
    ) -> Bool {
        var remainingGas = filledGas
        var i = cur

        while remainingGas + gas[i] - cost[i] >= 0 {
            remainingGas = remainingGas + gas[i] - cost[i]
            i = (i + 1) % gas.count

            if i == start {
                return true
            }
        }

        return false
    }
}

// Thinking
// so the question is about start from one pointer then back the start pointer with enough gas can back
// so how to find such start
// can brute force, then need to try with every gas starter
// which at least O(n)
// use example to figure out the solution
// pregas = 0, gas[0], cost[0] = 3, pregas + gas[0] < cost[0], so fail
// move to gas[1],, same fail
// // until, gas[3], pregas + gas[3] > cost[3]
// start = 3
// pregas = pregas + gas[3] - cost[3]
// then still need to verify for gas[4] and cost[4]
// how to make circle, nextIndex = (index + 1) % count
// what's the exit, when we meet start index again
//
// Pattern: Array pointer
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
//
// 10 mins around, ready to write
// finish in 20 mins
// quick check, lgtm
// ready to run, find a typo, fix, found a crash
*/


// FIX VERSION: preserves your brute-force simulation.
// It is correct, but O(n²) in the worst case.

class fixSolution {
    func canCompleteCircuit(_ gas: [Int], _ cost: [Int]) -> Int {
        for start in 0..<gas.count {
            if canFinish(gas, cost, start) {
                return start
            }
        }

        return -1
    }

    private func canFinish(
        _ gas: [Int],
        _ cost: [Int],
        _ start: Int
    ) -> Bool {
        var remainingGas = 0
        var current = start

        while true {
            remainingGas += gas[current] - cost[current]

            if remainingGas < 0 {
                return false
            }

            current = (current + 1) % gas.count

            // Good: this is the correct circular exit condition.
            if current == start {
                return true
            }
        }
    }
}


// UPGRADE VERSION: greedy, O(n) time.

class Solution {
    func canCompleteCircuit(_ gas: [Int], _ cost: [Int]) -> Int {
        var totalGas = 0
        var currentTank = 0
        var start = 0

        for i in 0..<gas.count {
            let difference = gas[i] - cost[i]

            // Total gas decides whether any valid answer exists.
            totalGas += difference

            // Current tank tests the current candidate start.
            currentTank += difference

            if currentTank < 0 {
                // No station from `start` through `i` can be valid.
                // Try the next station instead.
                start = i + 1
                currentTank = 0
            }
        }

        // If total gas is insufficient, no starting point can work.
        return totalGas >= 0 ? start : -1
    }
}


/*
GPT'S SUMMARY

Your approach was good:
- You correctly identified the brute-force method.
- You correctly used modulo for circular movement.
- You correctly identified the exit condition: return to `start`.
- Simulating remaining gas is the right state.

Why your code crashed:

    helper(gas, cost, gas[i] - cost[i], i, i + 1)

When `i` is the final index, `i + 1 == gas.count`.

Then this accesses:

    gas[gas.count]

That index is outside the array.

Correct wrapping syntax:

    let next = (i + 1) % gas.count

There is also a small logic problem with beginning the helper after you
already processed `start`: for a one-station list, it would process the
start station twice. The fixed version starts with an empty tank and
processes every station exactly once.


WHY THE GREEDY VERSION WORKS

At every station, calculate:

    difference = gas[i] - cost[i]

If `currentTank` becomes negative at station `i`, then starting from
the current candidate start fails before or at `i`.

More importantly, none of these stations can be the answer:

    start, start + 1, ..., i

Why?

If starting at `start` cannot reach beyond `i`, starting later removes
some gas collected earlier. It cannot create more gas than the failed
attempt had.

Therefore, skip all of them at once:

    start = i + 1
    currentTank = 0


EXAMPLE

    gas  = [1, 2, 3, 4, 5]
    cost = [3, 4, 5, 1, 2]

Differences:

    [-2, -2, -2, +3, +3]

Walk through:

    i = 0:
    currentTank = -2
    Fail, so start = 1 and reset tank.

    i = 1:
    currentTank = -2
    Fail, so start = 2 and reset tank.

    i = 2:
    currentTank = -2
    Fail, so start = 3 and reset tank.

    i = 3:
    currentTank = 3

    i = 4:
    currentTank = 6

Final total:

    -2 - 2 - 2 + 3 + 3 = 0

Because totalGas >= 0, a valid start exists.

Return:

    start = 3


LOOP CONTRACT

At the top of each iteration:
- `currentTank` is the gas remaining when traveling from `start`
  through the previous station.
- Every station before `start` has already been proven impossible.
- `totalGas` is the net fuel available across all processed stations.

Complexity:

Fix version:
- Time: O(n²), because it can simulate up to n stations for each start.
- Space: O(1).

Upgrade version:
- Time: O(n).
- Space: O(1).
*/