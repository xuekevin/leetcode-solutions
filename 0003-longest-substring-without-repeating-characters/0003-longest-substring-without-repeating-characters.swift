class Solution {
    func lengthOfLongestSubstring(_ s: String) -> Int {
        // var left = 0
        // var right = 0

        if s.count == 1 {
            return 1
        }

        var arr = [Character]()
        
        var maxLength = 0

        for item in s {
            if !arr.contains(item) {
                arr.append(item)
            } else {
                // update the length
                maxLength = max(maxLength, arr.count)

                // decide to move the left
                // delete all the items include current duplicate in the arr
                // so how to do that?
                // maybe I can just get the index of duplicate one
                var updateIndex = 0
                for (index, value) in arr.enumerated() {
                    if value == item {
                        updateIndex = index
                    }
                }

                var i = 0

                while i <= updateIndex {
                    arr.removeFirst()
                    i += 1
                }

                arr.append(item)
                // seems I don't need the left and right
            }   
        }

        // update the length
        maxLength = max(maxLength, arr.count)

        return maxLength
    }
}

//# Thoughts
// to find the longest sub string, thinking use slide window to get the longest one
// basically, increasing window size if there is no duplicate
// other wise, we found the substring and then we compare with the longest also shrink the window
// that's the plan

// 2 mins so far, ready to write code
// 14 mins finish the code, now use example to verify
// 2 mins check, seems good to me 
// ready to run and submit
// got synatx, because I typo the enumarated 

// try again
// got Program crashed: Illegal instruction at 0x000055dfbb577fed ***

// because I foget to update i, in the while loop, so it runs forever
// after that it pass
// TC O(n)
// SC O(n)
// submit , got wrong answer for empty string case,
// it should return 1,instead of 0
// and this corner case,
// still wrong answer, must something wrong
// seems like I need do // update the length
                // maxLength = max(maxLength, arr.count) after go out of the loop
                



