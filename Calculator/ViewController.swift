//
//  ViewController.swift
//  Calculator
//
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var buttonZero: UIButton!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var buttonFour: UIButton!
    @IBOutlet weak var buttonFive: UIButton!
    @IBOutlet weak var buttonSix: UIButton!
    @IBOutlet weak var buttonSeven: UIButton!
    @IBOutlet weak var buttonEight: UIButton!
    @IBOutlet weak var buttonNine: UIButton!
    
    @IBOutlet weak var operatorAddition: UIButton!
    @IBOutlet weak var operatorSubstruction: UIButton!
    @IBOutlet weak var operatorDivision: UIButton!
    @IBOutlet weak var operatorMultiplication: UIButton!
    
    @IBOutlet weak var operatorPercent: UIButton!
    @IBOutlet weak var operatorDecimal: UIButton!
    
    @IBOutlet weak var operatorResult: UIButton!
    @IBOutlet weak var operatorAllClear: UIButton!
    
    
    // MARK: Constants and Variables
    private let decimalSeparator: String = "."
    private let maxNumberOfDigits = 8 // iPhone SE portrait limit
    
    private var totalValue: Double = 0
    private var tempValue: Double = 0
    private var isOperating: Bool = false
    private var isDouble: Bool = false
    private var operationType: OperationType = .NONE
    
    // MARK: Enums
    private enum OperationType {
        case NONE, ADDITION, SUBSTRACTION, MULTIPLICATION, DIVISION, PERCENT
    }
    
    //MARK: - Actions
    @IBAction func digitAction(_ sender: UIButton) {
        var currentTemp = tempValue.isZero ? "" : format(value: tempValue)
        
        if (!isOperating && currentTemp.count >= maxNumberOfDigits) {
            return
        }
                
        if (isOperating) {
            totalValue = totalValue.isZero ? tempValue : totalValue
            resultLabel.text = ""
            currentTemp = ""
            isOperating = false
        }

        if (isDouble) {
            currentTemp = "\(currentTemp)\(decimalSeparator)"
            isDouble = false
        }
        
        let number = String(sender.currentTitle!)
        
        tempValue = Double(currentTemp + number)!
        resultLabel.text = format(value: tempValue)
    }
    
    @IBAction func operatorPlusAction(_ sender: UIButton) {
        if (operationType != .NONE) {
            result()
        }
        isOperating = true
        operationType = .ADDITION
    }
    
    @IBAction func operatorMinusAction(_ sender: UIButton) {
        if (operationType != .NONE) {
            result()
        }
        
        isOperating = true
        operationType = .SUBSTRACTION
    }
    
    @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
        if (operationType != .NONE) {
            result()
        }
        isOperating = true
        operationType = .MULTIPLICATION
    }
    
    @IBAction func operatorDivisionAction(_ sender: UIButton) {
        if (operationType != .NONE) {
            result()
        }
        isOperating = true
        operationType = .DIVISION
    }
    
    @IBAction func operatorPorcentAction(_ sender: UIButton) {
        if(operationType != .PERCENT){
            result()
        }
        isOperating = true
        operationType = .PERCENT
        result()
    }
        
    @IBAction func numberDecimalAction(_ sender: UIButton) {
        // MARK: TODO Improve decimal handling
        let currentTemp = String(tempValue)
        
        if (isOperating || currentTemp.count >= maxNumberOfDigits) {
            return
        }
        
        if (!resultLabel.text!.contains(Character(decimalSeparator))) {
            resultLabel.text = resultLabel.text! + decimalSeparator
        }
        
        isDouble = true
    }
    
    @IBAction func operatorResultAction(_ sender: UIButton) {
        result()
    }
    
    @IBAction func allClearAction(_ sender: UIButton) {
        clear()
    }
    
    // MARK: - function
    private func format(value: Double) -> String {
        let stringedValue = String(value)
        
        if (value == Double(Int(value))) {
            // The value doesn't have decimal part
            let index = stringedValue.firstIndex(of: ".")!
            let intValue = stringedValue[..<index]
            return String(intValue)
        } else {
            return stringedValue
        }
    }
    
    // Clear label and total value
    private func clear() {
        operationType = .NONE
        if (tempValue != 0) {
            tempValue = 0
            resultLabel.text = "0"
        } else {
            totalValue = 0
            result()
        }
    }
    
    // Calculation of a result
    private func result() {
        switch operationType {
            case .NONE:
                break
            case .ADDITION:
                totalValue = totalValue + tempValue
                break
            case .SUBSTRACTION:
                totalValue = totalValue - tempValue
                break
            case .MULTIPLICATION:
                totalValue = totalValue * tempValue
                break
            case .DIVISION:
                if tempValue.isZero {
                    // MARK: TODO: Improve error handling
                    break
                }
                totalValue = totalValue / tempValue
                break
            case .PERCENT:
                // MARK: TODO: Improve operation versatility
                totalValue = tempValue / 100
                break
        }
        
        resultLabel.text = format(value: totalValue)
        operationType = .NONE
    }
}
