// ============================================================
// FIX VERSION: Follows your manual traversal + stack idea
// The stack stores complete path components, not characters.
// ============================================================

class fixSolution {
    func simplifyPath(_ path: String) -> String {
        var stack = [String]()
        var component = ""

        // Add a final slash so the last component is processed too.
        for character in path + "/" {
            if character == "/" {
                if component.isEmpty || component == "." {
                    // Ignore repeated slashes and the current directory.
                } else if component == ".." {
                    // Move to the parent directory when possible.
                    stack.popLast()
                } else {
                    // Normal directory name, including "...", "a.b", or "123".
                    stack.append(component)
                }

                // Begin collecting the next component.
                component = ""
            } else {
                component.append(character)
            }
        }

        return "/" + stack.joined(separator: "/")
    }
}

// ============================================================
// GPT'S UPGRADE SOLUTION
// Recommended: split the path into components first.
// ============================================================

class Solution {
    func simplifyPath(_ path: String) -> String {
        var stack = [Substring]()

        // split() automatically ignores repeated "/" characters.
        for component in path.split(separator: "/") {
            if component == "." {
                // Stay in the current directory.
                continue
            }

            if component == ".." {
                // Move to the parent directory.
                stack.popLast()
            } else {
                // Everything else is a normal directory name.
                stack.append(component)
            }
        }

        return "/" + stack.joined(separator: "/")
    }
}

// ============================================================
// YOUR ORIGINAL CODE AND THINKING COMMENTS
// ============================================================

/*
class Solution {
    func simplifyPath(_ path: String) -> String {
        var stack = [Character]()
        var pathArr = Array(path)
        var dotCount = 0

        for item in pathArr {
            // search online, that isLetter is the property to check
            if item.isLetter {
                stack.append(item)
            }
            if item == "/" {
                let top = stack.last
                if top == "/" {
                    continue
                } else if top == "." {
                    dotCount = 0
                    if dotCount >= 3 {
                        stack.append(item)
                    } else if dotCount == 1 {
                        // pop one dot
                        stack.popLast()
                    } else {
                        // pop two dots
                        stack.popLast()
                        stack.popLast()
                        // pop slash
                        stack.popLast()
                        while !stack.isEmpty && stack.last != "/" {
                            stack.popLast()
                        }
                    }
                } else {
                    stack.append(item)
                }
            }
            if item == "." {
                let top = stack.last
                if top == "/" {
                    dotCount += 1
                } else if top == "." {
                    dotCount += 1
                } else {
                    dotCount = 0
                }
                stack.append(item)
            }
        }

        if stack.last == "/" && stack.count != 1 {
            stack.popLast()
        }

        if stack.isEmpty {
            stack.append("/")
        }

        return String(stack)
    }
}

// Thinking
// seems can use stack
// if it is alphbet, the push into stack
// if it is / change stack top, if it is already / then don't push
// for . kind of tricky, might can use a count to track
// if it is consecutive and and start with / or end / then we can handle them different
// 6 mins start to write code

// Pattern: stack
// State needed: traverse the input path array, check the item and the decide whether push or pop, and has a variable dotCount to track consecutive dot count
// Contract: the exit condition is after finish visiting all the input
// Recall: half

// finsih wrting in around 30 mins
// let's do a quick check
// start to run, got wrong answer
// need to remove the last /
// need to consider the case, only one root path, then need to keep /
// add a fall back check, still has case not pass example 5
// time up, will let gpt to fix
*/

// ============================================================
// GPT'S DETAILED EXPLANATION
// ============================================================

/*
WHAT YOU GOT RIGHT:

1. This is a stack problem.
2. ".." should remove the most recent valid directory.
3. "." should be ignored.
4. Repeated "/" characters should behave like one slash.
5. The final result should not end with "/" unless it is the root.


MAIN LOGIC MISTAKE: WRONG STACK UNIT

You used:

    var stack = [Character]()

But the path rules apply to complete components:

    "."
    ".."
    "..."
    "home"
    "a.b"

The better stack is:

    var stack = [String]()

or:

    var stack = [Substring]()

Then each stack item represents one complete directory.


DOT RULES:

Only these complete components are special:

    "."  -> current directory, ignore it
    ".." -> parent directory, remove one stack item

These are normal directory names:

    "..."
    "...."
    "a.b"

Therefore, counting individual dots makes the logic harder and can
incorrectly treat normal directory names as navigation.


BUG IN dotCount:

You wrote:

    dotCount = 0

immediately before:

    if dotCount >= 3
    else if dotCount == 1

After setting it to zero, neither condition can be true.


PROBLEM WITH isLetter:

You only appended characters when:

    item.isLetter

But valid directory names are not limited to letters.

Examples:

    "/123/"
    "/a_b/"
    "/a.b/"
    "/.../"

A component-based solution preserves these names automatically.


WHY split() HELPS:

For:

    "/home//foo/"

this code:

    path.split(separator: "/")

produces:

    ["home", "foo"]

Leading, trailing, and repeated slashes are automatically omitted.


EXAMPLE TRACE:

Input:

    "/a/./b/../../c/"

Components:

    ["a", ".", "b", "..", "..", "c"]

Process "a":

    stack = ["a"]

Process ".":

    stack = ["a"]

Process "b":

    stack = ["a", "b"]

Process "..":

    stack = ["a"]

Process "..":

    stack = []

Process "c":

    stack = ["c"]

Build the result:

    "/" + stack.joined(separator: "/")
    = "/c"


WHAT IF ".." APPEARS AT THE ROOT?

Input:

    "/../../a"

When the stack is empty:

    stack.popLast()

safely returns nil and changes nothing.

We cannot move above the root, so the result becomes:

    "/a"


UPGRADED LOOP CONTRACT:

At the start of every iteration:

- stack contains the simplified valid directories processed so far.
- "." components have been ignored.
- ".." components have already removed the previous directory when one
  existed.
- The root itself is represented by an empty stack.


PATTERN:

    Stack + string components

STATE:

    stack of directory names

COMPLEXITY:

Time:
    O(n)

Every character is processed a constant number of times.

Space:
    O(n)

The stack may contain all path components.
*/