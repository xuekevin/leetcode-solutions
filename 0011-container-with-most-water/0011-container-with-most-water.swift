class Solution {
    func maxArea(_ height: [Int]) -> Int {
        var left = 0
        var right = height.count - 1

        var maxContainer = 0

        while left < right {
            let curContainer = min(height[right], height[left]) * (right - left)
            maxContainer = max(curContainer, maxContainer)
            if height[right] > height[left] {
                left += 1
            } else {
                right -= 1
            }
        }
        return maxContainer
    }
}

// #Thoughts
// so the container size depends on t he left and right vertical's height diff and also the interval between them

// seems we can have 2 pointers
// one left and right
// then caculate the container size, and update the max when we do the for loop
// use example to verify my thoughts
// when to move, move the shorter vertical one, if we want to have a larger container

// 5 mins so far, decide to write code 

// 11 mins finish writingthe code
// now using example to verify
// find a mistake, fix it 
// now I am not sure about my logic to move left and right, should I consider move for both dirctions?
// anyway let me submit first to see the result
// will let gpt help me figure out if my worry is too much

