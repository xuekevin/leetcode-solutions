// Your original solution:
// class Solution {
//     func findOrder(_ numCourses: Int, _ prerequisites: [[Int]]) -> [Int] {
//         var resultPath = Int
//
//         // graph[course] = courses unlocked after taking `course`.
//         var graph = Array(
//             repeating: Int,
//             count: numCourses
//         )
//
//         for prerequisite in prerequisites {
//             let course = prerequisite[0]
//             let requiredCourse = prerequisite[1]
//
//             // [1, 0] means "take 0 before 1".
//             //
//             // Draw the direction:
//             //
//             // 0 -> 1
//             graph[requiredCourse].append(course)
//         }
//
//         // state[course]:
//         //
//         // 0 = this course has not been explored yet
//         // 1 = this course is on the CURRENT DFS path
//         // 2 = this course and every dependency path below it were checked
//         var state = Array(
//             repeating: 0,
//             count: numCourses
//         )
//
//         func takeCourse(_ course: Int, _ coursePath: inout [Int]) {
//             if state[course] == 1 {
//                 return false
//             }
//             if state[course] == 2 {
//                 return true
//             }
//             state[course] = 1
//
//             for nextCourse in graph[course] {
//                 if !takeCourse(nextCourse) {
//                     return false
//                 }
//             }
//
//             state[course] = 2
//             return true
//         }
//
//         for course in 0..<numCourses {
//             var coursePath = [course]
//             takeCourse(course, &coursePath)
//             if coursePath.count != 0 {
//                 if resultPath.count == 0 {
//                     resultPath = coursePath
//                 } else {
//                     // but how to sort the result?
//                 }
//             }
//         }
//     }
// }
//
// // Thinking
// // compare with Course Schedule
// // this is also need to return the path
// // so when I do the check for the hasCycle
// // everytime I visit a course, I store it in the path
// // try to upgrade from previous issue, time out
// // ask gpt


class Solution {
    func findOrder(_ numCourses: Int, _ prerequisites: [[Int]]) -> [Int] {
        // Wrong: `Int` is a type, not an empty integer array.
        // Correct:
        var resultPath = [Int]()

        // Wrong: `repeating: Int` is also a type, not an array value.
        // graph[course] stores courses unlocked after taking `course`.
        var graph = Array(
            repeating: [Int](),
            count: numCourses
        )

        for prerequisite in prerequisites {
            let course = prerequisite[0]
            let requiredCourse = prerequisite[1]

            // [1, 0] means take 0 before 1:
            // requiredCourse -> course
            // 0 -> 1
            graph[requiredCourse].append(course)
        }

        // 0 = unvisited
        // 1 = currently on the DFS path
        // 2 = completely explored
        var state = Array(repeating: 0, count: numCourses)

        // Returns false if a cycle is found.
        func takeCourse(_ course: Int) -> Bool {
            // We returned to a node on the current DFS path.
            // That means there is a cycle.
            if state[course] == 1 {
                return false
            }

            // This course was already checked and is safe.
            if state[course] == 2 {
                return true
            }

            // Mark as currently being explored.
            state[course] = 1

            for nextCourse in graph[course] {
                if !takeCourse(nextCourse) {
                    return false
                }
            }

            // Good: append only after all next courses are finished.
            // This is DFS postorder.
            state[course] = 2
            resultPath.append(course)

            return true
        }

        // The graph can have disconnected groups, so start DFS everywhere.
        for course in 0..<numCourses {
            if !takeCourse(course) {
                return []
            }
        }

        // With edges prerequisite -> unlocked course,
        // postorder is backwards, so reverse it.
        resultPath.reverse()

        return resultPath
    }
}

/*
 GPT's summary

 Good:
 - You correctly reused the three-state DFS cycle detection pattern.
 - Your graph direction was valid:
   prerequisite -> course that becomes available afterward.

 Key idea:
 - You do not need `coursePath` or sorting.
 - Append a course only when DFS finishes it.
 - This guarantees it comes after every course reachable from it.
 - Because your edges point prerequisite -> course, reverse the final
   postorder list to get prerequisite before course.

 Example:
 prerequisites = [[1, 0]]

 graph:
 0 -> 1

 DFS finish order:
 visit 0 -> visit 1 -> append 1 -> append 0
 resultPath = [1, 0]

 Reverse:
 [0, 1]

 Swift syntax to remember:
 - Empty Int array: `[Int]()`
 - Array of adjacency lists:
   `Array(repeating: [Int](), count: numCourses)`
 - A function returning Bool needs:
   `func takeCourse(_ course: Int) -> Bool`
 - Reverse an array in place:
   `resultPath.reverse()`

 Complexity:
 - Time: O(V + E)
 - Space: O(V + E)
 - V = number of courses, E = number of prerequisite pairs.
*/