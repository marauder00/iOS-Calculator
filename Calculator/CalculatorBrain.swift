//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mara Gagiu on 2016-05-30.
//  Copyright © 2016 Mara Gagiu. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    //CustomStringConvertible is a protocol, enums dont inherit (duh)
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String,Double->Double)
        case BinaryOperation(String,(Double,Double) -> Double)
        
        var description: String {
            get {
                switch self {
                //example of value binding in switch statements
                //the value of self.Operand is bound to the variable 'operand'
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol,_):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
            
        }
        
    }
    
    //either a number or an operator
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    //Dictionary<String,Op>() is the equivalent declaration
    
    init(){
      
      
        
//        func learnOp(op: Op) {
//            knownOps[op.description] = op
//        }
//defining and initializing values in the dictionary of strings and operations
        knownOps["×"] = Op.BinaryOperation("×",* )
        knownOps["÷"] = Op.BinaryOperation("÷"){ $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+",+)
        knownOps["÷"] = Op.BinaryOperation("÷"){ $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√",sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return opStack.map{$0.description}
            }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    }else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    
                    }
                    
                }
                opStack = newOpStack
            }
        }
    }
    
    //the recursion portion of this course that I don't quite understand
    //logic: process the top value of the stack and evaluate the remaining stack
    
    //an optional double is returned if the top value of the stack is an operand or if a partial product/sum is evaluated
    
    private func evaluate(ops: [Op]) ->(result: Double?,remainingOps: [Op])
    {
        if !ops.isEmpty {
            
            //current stack you're evaluating
            var remainingOps = ops
            //this is done so that you don't do var let in the parameters..all parameters have an implicit 'let' by default because functions are pass by value and thus any values being passed into the function cannot be mutable
            //remove last removes the last variable on the stack and returns it to 'op'
            let op = remainingOps.removeLast()
            //you can assign a new enum value to a variable by doing example = .EnumCase which makes example hold the value of enum
            //this switch statement essentially compares if 'op' holds the value defined by any of the enumeration cases
            
            switch op {
            //CASE OPERAND: just return the number
            case .Operand(let operand):
                return (operand, remainingOps)
                
            //CASE UNARY OP: sqrt
            //in order to input values into the 'operation' function, we need a value to use
            case .UnaryOperation(_, let operation):
                //represent the resulting number found and current op stack
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                   return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        //if you can't evaluate anything, return nil
        return (nil, ops)
        
    }
    
    
    
    
    func evaluate() -> Double? {
            let (result, remainder) = evaluate(opStack)
            print("\(opStack) = \(result) with \(remainder) left over")
            return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    func deleteCalculatorHistory(){
        //called to pop every element off of opStack when clear button is pressed
        opStack.removeAll()
        
    }
    
}