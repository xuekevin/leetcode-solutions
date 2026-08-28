
// Your original solution:
// class Solution {
//    func minMutation(_ startGene: String, _ endGene: String, _ bank: [String]) -> Int {
//    }
// }
// // Thinking
// // compare the first difference with startGene and endGene
// // find difference
// // the check make then change can we find the changed item in the bank?
// // after change the use the bank item as the new start
// // but we need minimum number,
// // assume how many difference between start and end
// // thenwe will have defined number of mutation
// // ask gpt


class Solution {
    func minMutation(
        _ startGene: String,
        _ endGene: String,
        _ bank: [String]
    ) -> Int {
        // No mutation is needed.
        if startGene == endGene {
            return 0
        }

        // Set gives O(1) average lookup and also works as visited storage.
        var availableGenes = Set(bank)

        // If the target cannot be used, it cannot be reached.
        guard availableGenes.contains(endGene) else {
            return -1
        }

        // Each queue item stores:
        // (current gene, mutations used to reach it)
        var queue = [(String, Int)]()
        queue.append((startGene, 0))

        // Use an index instead of removeFirst(), which is O(n) for an Array.
        var front = 0

        let possibleLetters: [Character] = ["A", "C", "G", "T"]

        while front < queue.count {
            let (currentGene, steps) = queue[front]
            front += 1

            var characters = Array(currentGene)

            // Try mutating each of the 8 positions.
            for index in 0..<characters.count {
                let originalCharacter = characters[index]

                // Try each possible replacement letter.
                for letter in possibleLetters {
                    if letter == originalCharacter {
                        continue
                    }

                    // Make one mutation.
                    characters[index] = letter
                    let nextGene = String(characters)

                    // Only genes in the bank are valid next steps.
                    if availableGenes.contains(nextGene) {
                        // Found the target in the fewest steps because BFS.
                        if nextGene == endGene {
                            return steps + 1
                        }

                        queue.append((nextGene, steps + 1))

                        // Remove immediately, so we never visit it twice.
                        availableGenes.remove(nextGene)
                    }
                }

                // Restore this index before mutating the next index.
                characters[index] = originalCharacter
            }
        }

        return -1
    }
}

/*
 GPT's summary

 Why BFS:
 - One valid mutation changes exactly one letter.
 - Every mutation has the same cost: 1 step.
 - BFS explores all 1-step mutations before 2-step mutations,
   then all 2-step mutations before 3-step mutations.
 - Therefore, the first time BFS reaches endGene is the minimum answer.

 Why counting startGene/endGene differences is not enough:
 startGene = "AACCGGTT"
 endGene   = "AAACGGTA"

 They differ in two positions, but a two-step path exists only if
 both required intermediate genes exist in the bank.

 Sometimes you must also mutate a position away from its final value
 before changing it again. The bank determines which paths are legal.

 Swift syntax to remember:
 - String to Character array:
   `var characters = Array(currentGene)`
 - Character array back to String:
   `let nextGene = String(characters)`
 - Set lookup:
   `availableGenes.contains(nextGene)`
 - Queue with an Array index:
   `while front < queue.count { ... }`

 Complexity:
 - Let b = bank.count.
 - Each gene tries 8 positions * 4 possible letters.
 - Time: O(b * 8 * 4), effectively O(b).
 - Space: O(b) for the queue and gene set.
*/