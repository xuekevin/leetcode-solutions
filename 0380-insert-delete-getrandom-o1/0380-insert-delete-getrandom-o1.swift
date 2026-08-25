/*
YOUR ORIGINAL SOLUTION:

class RandomizedSet {

    // key is the val, value is the index of the val in the arr
    var dict = [Int:Int]()

    // store dict's key
    var arr = [Int]()

    init() {
        // Reset
        dict = [Int:Int]()
        arr = [Int]()
    }

    func insert(_ val: Int) -> Bool {
        if let index = dict[val], index != -1 {
            return false
        }

        dict[val] = arr.count
        arr.append(val)
        return true
    }

    func remove(_ val: Int) -> Bool {
        if let index = dict[val] {
            dict[val] = -1

            // this is not O(1), think what kind of structure,
            // deletion is O(1) ?
            arr.removeAt(index)
            return true
        }

        return false
    }

    func getRandom() -> Int {
        // assume swift has a function can get a random num between 0-n,
        // that's waht I want
        let index = random(arr.count)
        return arr[index]
    }
}

/**
 * Your RandomizedSet object will be instantiated and called as such:
 * let obj = RandomizedSet()
 * let ret_1: Bool = obj.insert(val)
 * let ret_2: Bool = obj.remove(val)
 * let ret_3: Int = obj.getRandom()
 */

// Thinking
// challenge is part
// for insert need to first check if it is present, so kind of like search
// and we need to do in O(1)
// if I use a map it is O(1) to find and insert or delete
// how to do same probability for the random
// also need O(1) to make the decision
// I use a array to store the reference for the map's key
// then when I do insert or remove I also need to update this array
// do insert can just append
// do remove, the map's key value is [Val: Index]
//
// Pattern: Array, Dict
// Card shape: N/A
// State needed: maintain array, and dict, need to update when everytime
// to insert, remove
// Contract:      not sure what to say in here
// Recall:        half

// start to writing code in 10 mins
// finish in 18 mins
// realize my current remove is not O(1) TC,
// spend 2 mins to think
// what's tc for remove element in map?
// 20 mins so far
// ready ask gpt to help
*/


// FIX VERSION:
// Your array + dictionary design is exactly the correct design.
// The missing trick is: swap the removed value with the final value,
// then remove the final array element.

class fixRandomizedSet {
    // value -> its index in values
    var dictionary = [Int: Int]()

    // Stores every current value with no empty positions.
    var values = [Int]()

    init() {
        dictionary = [Int: Int]()
        values = [Int]()
    }

    func insert(_ val: Int) -> Bool {
        // We only need to check whether the key exists.
        if dictionary[val] != nil {
            return false
        }

        dictionary[val] = values.count
        values.append(val)

        return true
    }

    func remove(_ val: Int) -> Bool {
        guard let removedIndex = dictionary[val] else {
            return false
        }

        let lastValue = values[values.count - 1]

        // Move the final value into the position being removed.
        values[removedIndex] = lastValue

        // The moved value now has a different index.
        dictionary[lastValue] = removedIndex

        // Removing the final array element is O(1).
        values.removeLast()

        // Wrong: dictionary[val] = -1
        // Why: the key would still exist in the dictionary.
        // A second remove could then try to use index -1 and crash.
        dictionary.removeValue(forKey: val)

        return true
    }

    func getRandom() -> Int {
        // Swift creates a random integer from 0 through values.count - 1.
        let index = Int.random(in: 0..<values.count)
        return values[index]
    }
}


// GPT'S UPGRADE VERSION:
// Same optimal algorithm with private storage and `randomElement()`.

class RandomizedSet {
    private var values = [Int]()
    private var indexByValue = [Int: Int]()

    init() {}

    func insert(_ val: Int) -> Bool {
        guard indexByValue[val] == nil else {
            return false
        }

        indexByValue[val] = values.count
        values.append(val)

        return true
    }

    func remove(_ val: Int) -> Bool {
        guard let removedIndex = indexByValue[val] else {
            return false
        }

        let lastIndex = values.count - 1
        let lastValue = values[lastIndex]

        if removedIndex != lastIndex {
            // Fill the removed position with the final value.
            values[removedIndex] = lastValue
            indexByValue[lastValue] = removedIndex
        }

        values.removeLast()
        indexByValue.removeValue(forKey: val)

        return true
    }

    func getRandom() -> Int {
        // The problem guarantees this is called only when the set
        // contains at least one value.
        return values.randomElement()!
    }
}


/*
GPT'S EXAMPLE

Current state:

    values = [10, 20, 30, 40]

    indexByValue = [
        10: 0,
        20: 1,
        30: 2,
        40: 3
    ]

Remove 20:

    removedIndex = 1
    lastValue = 40


STEP 1: MOVE THE LAST VALUE

Replace index 1 with 40:

    values[1] = 40

Array temporarily becomes:

    [10, 40, 30, 40]


STEP 2: UPDATE THE MOVED VALUE'S INDEX

Before:

    indexByValue[40] = 3

After:

    indexByValue[40] = 1


STEP 3: REMOVE THE FINAL ARRAY ELEMENT

    values.removeLast()

Now:

    values = [10, 40, 30]

Removing the last element is O(1), because no later elements need to
shift.


STEP 4: REMOVE 20 FROM THE DICTIONARY

    indexByValue.removeValue(forKey: 20)

Final dictionary:

    [
        10: 0,
        40: 1,
        30: 2
    ]


WHY NORMAL ARRAY REMOVAL IS O(n)

If we directly remove index 1:

    [10, 20, 30, 40]
         ^ remove

Swift must shift later elements left:

    30 moves from index 2 to index 1
    40 moves from index 3 to index 2

That can require O(n) movement.

But `removeLast()` does not shift anything, so it is O(1).


WHY GETRANDOM IS UNIFORM

The array contains each current value exactly once:

    [10, 40, 30]

Each index has the same probability:

    index 0: 1/3
    index 1: 1/3
    index 2: 1/3

Therefore each value also has the same probability.


GPT'S SUMMARY

Your main design was correct:
- Dictionary gives O(1) average lookup.
- Array gives O(1) index access.
- Dictionary stores `value -> array index`.
- The array allows uniform random selection.
- This is exactly the standard solution.

The missing removal trick:
- Move the last element into the removed element's position.
- Update the moved element's dictionary index.
- Call `removeLast()`.
- Remove the deleted key from the dictionary.

Mistakes you made:

1. Wrong Swift array API:

   Wrong:

       arr.removeAt(index)

   Correct:

       arr.remove(at: index)

   However, `remove(at:)` is O(n) for a middle position, so it does not
   satisfy this problem's requirement.

2. Keeping a deleted dictionary key with index -1 is unsafe:

   Wrong:

       dictionary[val] = -1

   The key still exists. A later remove can find -1 and attempt an
   invalid array access.

   Correct:

       dictionary.removeValue(forKey: val)

3. Swift random integer syntax:

   Wrong:

       random(arr.count)

   Correct:

       Int.random(in: 0..<arr.count)

   Or:

       arr.randomElement()!

4. `init` does not need to recreate properties that already have
   default values.

   These declarations already initialize the storage:

       var values = [Int]()
       var indexByValue = [Int: Int]()

Invariant / contract:
- Every value in `values` appears exactly once.
- For every valid array index:

      indexByValue[values[index]] == index

- The dictionary and array always describe the same collection.

State needed:
- `values`: dense storage with no deleted gaps.
- `indexByValue`: maps every value to its array position.

Complexity:
- insert: O(1) average.
- remove: O(1) average.
- getRandom: O(1).
- Space: O(n).
*/