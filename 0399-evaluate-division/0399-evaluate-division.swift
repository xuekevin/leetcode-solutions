// Your original solution:
// class Solution {
//    func calcEquation(_ equations: [[String]], _ values: [Double], _ queries: [[String]]) -> [Double] {
//    }
// }
//
// // Thinking
// // how to get query from the equations
// // how to convert the equation to the one query can know the answer
// // check the first and second in the query
// // use the example to figure out the solution
// // I have all the equation, now I have all the possible relation for all the items
// // so when I check query,how can I know the relation
// // how to store the relation
// // time is out,didn't figure out
// // ask gpt directly


class Solution {
    func calcEquation(
        _ equations: [[String]],
        _ values: [Double],
        _ queries: [[String]]
    ) -> [Double] {
        // Graph format:
        // graph["a"] = [("b", 2.0)] means a / b = 2.0.
        var graph = [String: [(String, Double)]]()

        for i in 0..<equations.count {
            let dividend = equations[i][0]
            let divisor = equations[i][1]
            let value = values[i]

            // a / b = 2.0
            graph[dividend, default: []].append((divisor, value))

            // b / a = 1 / 2.0
            graph[divisor, default: []].append((dividend, 1.0 / value))
        }

        var result = [Double]()

        for query in queries {
            let start = query[0]
            let target = query[1]

            // If either variable never appeared in an equation,
            // we cannot calculate the answer.
            guard graph[start] != nil, graph[target] != nil else {
                result.append(-1.0)
                continue
            }

            // A variable divided by itself is 1.
            if start == target {
                result.append(1.0)
                continue
            }

            var visited = Set<String>()

            // DFS returns:
            // - the multiplied value if it reaches target
            // - nil if this path cannot reach target
            func dfs(_ current: String, _ product: Double) -> Double? {
                if current == target {
                    return product
                }

                visited.insert(current)

                for (next, value) in graph[current, default: []] {
                    if !visited.contains(next) {
                        // Example:
                        // a / b = 2, b / c = 3
                        // Current product 2 * next edge 3 = a / c = 6.
                        if let answer = dfs(next, product * value) {
                            return answer
                        }
                    }
                }

                return nil
            }

            result.append(dfs(start, 1.0) ?? -1.0)
        }

        return result
    }
}

/*
 GPT's summary

 Key idea:
 - Treat each variable as a graph node.
 - Treat each equation as a weighted edge.
 - For `a / b = 2.0`:
   - Add a -> b with weight 2.0.
   - Add b -> a with weight 0.5.
 - DFS from the query's first variable to its second variable.
 - Multiply the edge values along that path.

 Example:
 equations = [["a", "b"], ["b", "c"]]
 values = [2.0, 3.0]

 Graph:
 a -> b: 2.0
 b -> a: 0.5
 b -> c: 3.0
 c -> b: 1.0 / 3.0

 Query: a / c
 DFS path: a -> b -> c
 Answer: 2.0 * 3.0 = 6.0

 Swift syntax to remember:
 - Append to a dictionary array:
   `graph[key, default: []].append(value)`
 - Return an optional answer or nil:
   `func dfs(...) -> Double?`
 - Provide a fallback for nil:
   `dfs(start, 1.0) ?? -1.0`

 Complexity:
 - Build graph: O(e), where e is the number of equations.
 - Each query: O(v + e) in the worst case.
 - Space: O(v + e) for the graph and visited set.
*/