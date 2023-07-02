//
//  BonusAndLogicalTest.swift
//  BitcoinConverter
//
//  Created by TasitS on 2/7/2566 BE.
//

import Foundation

class BonusAndLogicalTest {
    
    func testBonusAndLogicalTest() {
        // Validate Pincode
        print(validatePincode(inputText: "887712"))
        
        // Fibonacci
        print(generateFibonacciList(seedNumber: 10))
        
        // Prime Number
        print(generatePrimeNumber(seedNumber: 10))
        
        // Filter First Array
        print(filterArray(firstArray: [1, 2, 3, 4, 5], secondArray: [0, 2, 3, 4, 5, 6, 7, 8]))
    }
    
    // MARK: - Pincode Validation
    func validatePincode(inputText: String) -> Bool {
        
        // Check pincode must longer or equal 6
        if inputText.count < 6 {
            return false
        }
        
        var doubleDuplicateCount = 0
        for (index, element) in inputText.enumerated() {
            
            if index + 2 < inputText.count {
                let firstText = element
                let secondText = inputText[inputText.index(inputText.startIndex, offsetBy: index + 1)]
                let thirdText = inputText[inputText.index(inputText.startIndex, offsetBy: index + 2)]
                
                // Check pincode must not duplicate more than two postions
                if firstText == secondText && firstText == thirdText {
                    print("Found three duplicate pincode!")
                    return false
                }
                
                // Check pincode must not in order more than two postions
                if let firstNum = firstText.wholeNumberValue,
                   let secondNum = secondText.wholeNumberValue,
                   let thirdNum = thirdText.wholeNumberValue {
                    if (firstNum + 1 == secondNum && secondNum + 1 == thirdNum)
                        || (firstNum - 1 == secondNum && secondNum - 1 == thirdNum) {
                        print("Found three in order number!")
                        return false
                    }
                }
                
            }
            
            // Check pincode must not have more than two duplicate pincode set
            if index + 1 < inputText.count {
                let firstText = element
                let secondText = inputText[inputText.index(inputText.startIndex, offsetBy: index + 1)]
                
                if firstText == secondText {
                    // Found double duplicate pincode
                    doubleDuplicateCount += 1
                    
                    if doubleDuplicateCount > 2 {
                        print("Found more than two double duplicate pincode set!")
                        return false
                    }
                }
            }
        }
        return true
    }
    
    // MARK: - Fibonacci

    func generateFibonacciList(seedNumber: Int) -> Array<Int> {
        var fibonacciList: Array<Int> = []
        
        if seedNumber < 1 {
        // Can not generate FibonacciList
            return fibonacciList
        }
        
        for index in 0..<seedNumber {
            if index == 0 {
                fibonacciList.append(0)
            } else if index == 1 {
                fibonacciList.append(1)
            } else {
                let lastNum = fibonacciList[index-1]
                let previousNum = fibonacciList[index-2]
                let nextNum = lastNum + previousNum
                fibonacciList.append(nextNum)
            }
        }
            
        return fibonacciList
    }
    
    // MARK: - Prime number
    func generatePrimeNumber(seedNumber: Int) -> Array<Int> {
        
        var primeNumberList: [Int] = []
        
        if seedNumber < 1 {
            return primeNumberList
        }

        for index in 0..<seedNumber {
            
            if index == 0 {
                primeNumberList.append(2)
            } else {
                if var lastPrimeNumber = primeNumberList.last {
                    
                    var isPrimeNumber = true
                    repeat {
                        lastPrimeNumber += 1
                        isPrimeNumber = true
                        
                        for j in 2..<lastPrimeNumber {
                            if lastPrimeNumber % j == 0 {
                                isPrimeNumber = false
                            }
                        }
                    } while !isPrimeNumber
                    
                    if isPrimeNumber {
                        primeNumberList.append(lastPrimeNumber)
                    }
                }
            }
        }
        
        return primeNumberList
    }
    
    // MARK: - Array Filter
    func filterArray(firstArray: [Int], secondArray: [Int]) -> Array<Int> {
        var secondArrayTemp = secondArray
        var tempArray: [Int] = []

        for number in firstArray {
            for (index, secondNumber) in secondArrayTemp.enumerated() {
                if number == secondNumber {
                    tempArray.append(secondNumber)
                    secondArrayTemp.remove(at: index)
                    break
                }
            }
        }
        return tempArray
    }
}
