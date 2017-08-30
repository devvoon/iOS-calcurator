//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by DAMA on 2017. 8. 22..
//  Copyright © 2017년 iamdawoonjeong. All rights reserved.
//

import Foundation


/* closeure 사용으로 사용 안함
 func multiply(op1:Double, op2:Double) -> Double {
 return op1 * op2
 }
 */

class CalculatorBrain
    
{
    
    private var accumulator  = 0.0
    private var internalProgram = [AnyObject]()
    
    func setOperand (operand : Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    private var operations : Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI), //M_PI,
        "e" : Operation.Constant(M_E), //M_E,
        "±" : Operation.UnaryOperation({ -$0 } ),
        "√" : Operation.UnaryOperation(sqrt), //sqrt,
        "cos" : Operation.UnaryOperation(cos), //cos
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "/" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "-" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation (symbol : String) {
        internalProgram.append(symbol)
        /* Operation 생성 후 사용하지 않음
         if let constant = operations [symbol] {
         accumulator  = constant
         }
         */
        
        /* operation : Dictionary로 사용
         switch symbol {
         case "π":
         accumulator = M_PI
         case "√":
         accumulator = sqrt(accumulator)
         default:
         break
         }
         */
        
        
        if let operation  = operations[symbol]{
            switch operation {
            //연관값을 가져오기 위해패턴 매칭가능
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction : function, firstOperand : accumulator)
            case .Equals:
                executePendingBinaryOperation()
                
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand,accumulator)
            pending = nil
        }
    }
    private var pending : PendingBinaryOperationInfo?
    
    //struct ; enum처럼 값으로 전달(copy) class ; 참조로 전달.
    private struct PendingBinaryOperationInfo{
        var binaryFunction : (Double, Double) -> Double
        var firstOperand : Double
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList{
        get{
            //return internalProgram
        }
        
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand (operand)
                    }else if let operation = op as? String{
                        performOperation (operation)
                    }
                }
            }
        }
    }
    
    func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result : Double {
        get {
            return accumulator
        }
    }
}
