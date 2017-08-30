//
//  ViewController.swift
//  Calculator
//
//  Created by DAMA on 2017. 8. 21..
//  Copyright © 2017년 iamdawoonjeong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //UILabel에서?로 선언한다면 밑에 모든 display!로 선언해서 명시해주어야함
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {

            //print("touched \(digit) digit") //console창에 출력
        
            let currentlyInDisplay = display.text!
            // display를 optional로 선언한 상태에서 display를 text로 받을 수 없기 때문에 display!.text!로 사용
        
            display.text = currentlyInDisplay + digit
            
        }else{
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        
    }
    
    //계산기화면은 string으로 출력되나 실제로는 double로 계산되어야하기때문에 프로퍼티로 사용
    private var displayValue : Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    var savedProgram : CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
        
    }
    
    @IBAction func restore() {
        if savedProgram != nil{
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    private var brain = CalculatorBrain()

    @IBAction private func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
   
        if let mathmaticalSymbol = sender.currentTitle {
            
            /* controller에 계산과 관련된 것을 model로 빼주기
             if mathmaticalSymbol == "π"{
             displayValue = M_PI
             //display.text = String(M_PI) //displayValue property를 사용하기 때문에 굳이 변화 해 줄 필요가 없음
             }else if mathmaticalSymbol == "√"{
             displayValue = sqrt(displayValue)
             }
             */
            
             brain.performOperation(symbol: mathmaticalSymbol)
        }
       // displayValue = brain.result
    }
}

