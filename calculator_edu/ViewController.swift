//
//  ViewController.swift
//  calculator_edu
//
//  Created by Павел Широкий on 20.05.2025.
//

import UIKit

class ViewController: UIViewController {

    enum CalculationError: Error {
        case divideByZero
    }
    
    enum Operation: String {
        case devide = "/"
        case multiplication = "X"
        case subtraction = "-"
        case plus = "+"
        
        func calculate(number1: Double, number2: Double) throws -> Double {
            switch self {
            case .devide:
                if number2 == 0 {
                    throw CalculationError.divideByZero
                }
                return number1 / number2
                
            case .multiplication:
                return number1 * number2
            case .subtraction:
                return number1 - number2
            case .plus:
                return number1 + number2
            }
        }
    }
    
    enum CalculationHistoryItem {
        case operation(Operation)
        case number(Double)
    }
    
    var calculationHistory: [CalculationHistoryItem] = []
    
    @IBOutlet var buttonCancel: UIButton!
    @IBOutlet var buutonDevide: UIButton!
    @IBOutlet var buttonSeven: UIButton!
    @IBOutlet var buttonEight: UIButton!
    @IBOutlet var buttonNine: UIButton!
    @IBOutlet var butonMulti: UIButton!
    @IBOutlet var buttonThree: UIButton!
    @IBOutlet var buttonTwo: UIButton!
    @IBOutlet var buttonOne: UIButton!
    @IBOutlet var buttonSubtraction: UIButton!
    @IBOutlet var buttonSix: UIButton!
    @IBOutlet var buttonFive: UIButton!
    @IBOutlet var buttonFour: UIButton!
    @IBOutlet var buttonEquel: UIButton!
    @IBOutlet var buttonZero: UIButton!
    @IBOutlet var buttonPoint: UIButton!
    @IBOutlet var buttonPlus: UIButton!
    
    @IBOutlet var resultLabel: UILabel!
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }()
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else { return }
        print(buttonText)
        
        if buttonText == "," && resultLabel.text?.contains(",") == true {return}
        
        if resultLabel.text == "0" {
            resultLabel.text = buttonText
        } else {
            resultLabel.text?.append(buttonText)
        }
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard
            let buttonText = sender.titleLabel?.text,
            let buttonOperation = Operation(rawValue: buttonText)
        else { return }
       
        guard
            let labelText = resultLabel.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else {return}
        
        calculationHistory.append(.number(labelNumber))
        calculationHistory.append(.operation(buttonOperation))
        
        resetResultLabel()
    }
    
    @IBAction func clearButtonPressed() {
        calculationHistory.removeAll()
        
        resetResultLabel()
    }
    @IBAction func calculateButtonPressed() {
        guard
            let labelText = resultLabel.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else {return}
        
        calculationHistory.append(.number(labelNumber))
        
        do {
            let result = try calculate()
            
            resultLabel.text = numberFormatter.string(from: NSNumber(value: result))
        } catch {
            resultLabel.text = "Ошибка"
        }
        
        calculationHistory.removeAll()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetResultLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func showCalculationList(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let calculationListVC = sb.instantiateViewController(identifier: "CalculationListViewController")
        if let vc = calculationListVC as? CalculationListViewController {
            vc.result = resultLabel.text
        }
        
        navigationController?.pushViewController(calculationListVC, animated: true)
    }
    
    func resetResultLabel() {
        resultLabel.text = "0"
    }
    
    func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculationHistory[0] else {return 0}
        
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2) {
            guard
                case .operation(let operation) = calculationHistory[index],
                    case .number(let number) = calculationHistory[index+1]
            else { break }
            
            currentResult = try operation.calculate(number1: currentResult, number2: number)
        }
        
        return currentResult
    }

}

