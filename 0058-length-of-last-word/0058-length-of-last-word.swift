class Solution {
    func lengthOfLastWord(_ s: String) -> Int {
        let charArr = Array(s)
        var curCount = 0
        var wordCount = 0
        
        for i in 0..<charArr.count {
            if charArr[i] == " " {
                if curCount != 0 {
                    wordCount = curCount
                    curCount = 0
                }
            } else {
                curCount += 1
            }
        }
        if curCount != 0 {
            wordCount = curCount
        }
        return wordCount
    }
}

// Pattern: Array
// Card shape:
// State needed:
// Contract:      what is TRUE when one call returns?
// Recall:        landed / half / blank
// Thinking
// for loop
// recording the start of the word by default, got a space, means a end, reset the start
// encounter a space, skip
// last word is the last start to the end of string, skip empty space
// ready to write code 
// done in 10 mins, use example to verify. LGTM
// ready to run, pass
// ready to submit, 

