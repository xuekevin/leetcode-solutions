class Solution {
    func canFinish(
        _ numCourses: Int,
        _ prerequisites: [[Int]]
    ) -> Bool {
        // graph[course] = courses unlocked after taking `course`.
        var graph = Array(
            repeating: [Int](),
            count: numCourses
        )

        for prerequisite in prerequisites {
            let course = prerequisite[0]
            let requiredCourse = prerequisite[1]

            // [1, 0] means "take 0 before 1".
            //
            // Draw the direction:
            //
            // 0 -> 1
            graph[requiredCourse].append(course)
        }

        // state[course]:
        //
        // 0 = this course has not been explored yet
        // 1 = this course is on the CURRENT DFS path
        // 2 = this course and every dependency path below it were checked
        var state = Array(
            repeating: 0,
            count: numCourses
        )

        func hasNoCycle(_ course: Int) -> Bool {
            // We returned to a course currently being explored.
            //
            // Example current path:
            //
            // 0 -> 1 -> 2 -> 0
            //                ^
            //                state[0] is 1
            //
            // That proves a directed cycle.
            if state[course] == 1 {
                return false
            }

            // We already explored this course earlier and confirmed
            // that no cycle is reachable from it.
            if state[course] == 2 {
                return true
            }

            // This course is now part of the current DFS path.
            state[course] = 1

            // Explore every course that depends on this course.
            for nextCourse in graph[course] {
                // If any path finds a cycle, stop immediately.
                if !hasNoCycle(nextCourse) {
                    return false
                }
            }

            // We have explored every path from this course and found
            // no cycle. Mark it permanently safe.
            state[course] = 2

            return true
        }

        // The graph may have disconnected groups of courses, so start
        // DFS from every course.
        for course in 0..<numCourses {
            if !hasNoCycle(course) {
                return false
            }
        }

        return true
    }
}


/*
EXAMPLE 1: NO CYCLE

    numCourses = 4
    prerequisites = [[1, 0], [2, 1], [3, 2]]

Graph:

    0 -> 1 -> 2 -> 3

Initial states:

    [0, 0, 0, 0]

Start:

    hasNoCycle(0)

Mark 0 as currently visiting:

    [1, 0, 0, 0]

0 points to 1, so call:

    hasNoCycle(1)

Mark 1 as currently visiting:

    [1, 1, 0, 0]

1 points to 2:

    [1, 1, 1, 0]

2 points to 3:

    [1, 1, 1, 1]

3 has no next course.

Mark 3 complete:

    [1, 1, 1, 2]

Return to 2. It is also safe:

    [1, 1, 2, 2]

Return to 1:

    [1, 2, 2, 2]

Return to 0:

    [2, 2, 2, 2]

No course was revisited while state was 1.

Return:

    true


EXAMPLE 2: CYCLE

    numCourses = 2
    prerequisites = [[1, 0], [0, 1]]

Graph:

    0 -> 1
    1 -> 0

Initial states:

    [0, 0]

Start:

    hasNoCycle(0)

Mark 0 as currently visiting:

    [1, 0]

0 points to 1:

    hasNoCycle(1)

Mark 1 as currently visiting:

    [1, 1]

1 points to 0:

    hasNoCycle(0)

But:

    state[0] == 1

Course 0 is already on the current path:

    0 -> 1 -> 0

Therefore return false immediately.


WHY DO WE NEED THREE STATES?

`visited = true/false` alone is not enough.

Suppose this is not a cycle:

    0 -> 2
    1 -> 2

Start DFS from 0 and fully finish 2.

Then start DFS from 1 and reach 2 again.

This is safe. Course 2 was visited before, but it is not on the
current DFS path.

That is why we distinguish:

    state == 1:
    currently exploring, so finding it again means a cycle.

    state == 2:
    fully explored earlier, so it is safe to reuse.


ONE-LINE MEMORY VERSION

    state == 0  -> not started
    state == 1  -> current path, seeing it again means cycle
    state == 2  -> fully checked and safe


RECURSIVE CONTRACT

    hasNoCycle(course)

returns true exactly when there is no directed cycle reachable from
`course`.

Before returning true, it marks the course as state 2.

COMPLEXITY

    Time: O(V + E)

Each course and prerequisite edge is explored at most once.

    Space: O(V + E)

For the graph, state array, and recursion stack.
*/