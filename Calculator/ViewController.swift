//
//  ViewController.swift
//  Calculator
//
//  Created by Mara Gagiu on 2016-05-13.
//  Copyright © 2016 Mara Gagiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    //properties are instance variables of a class
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    //optionals automatically initialize the object as nil
    //exclamation marks unwrap the optional
    
    
    var userIsInTheMiddleOfTypingANumber = false
     var userEnteredDecimalPoint = false
    var brain = CalculatorBrain()

    
    
    @IBAction func clearAll(sender: AnyObject) {
        
        //pop everything off of the stack
        brain.deleteCalculatorHistory()
        //clear display
        display.text = "0"
        //clear history
        history.text = " "
        userEnteredDecimalPoint = false
        userIsInTheMiddleOfTypingANumber = false
        
    }
    
    @IBAction func addConstant(sender: AnyObject) {
       //if any number was pressed before it, push the operand
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        //push pi as an operand
        userIsInTheMiddleOfTypingANumber = true
        display.text = sender.currentTitle!
        
        
        
    }
    @IBAction func appendDigit(sender: UIButton) {
        
              if display.text! == "π"
        {
            enter()
        }
        //let turns the variable into a constant
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
        //to handle decimal point input
        if digit == "."{
            if !userEnteredDecimalPoint{
                display.text = display.text! + digit
                userEnteredDecimalPoint = true
            }
            
        }
        else {
            display.text = display.text! + digit
        }
        
        
        }
        else{
            if digit == "." {
                userEnteredDecimalPoint = true
            }
            //when the first digit is appended
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
    
        //before the operation is evaluated, the current value displayed must be pushed, if the user did not press enter beforehand
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        if let operation = sender.currentTitle{
            
        
            history.text = history.text! + operation + " "
            if let result = brain.performOperation(operation){
                displayValue = result
            } else {
                //temporary solution
                displayValue = 0
            }
            
        }
    }
    
    @IBAction func enter() {
        //every time an operand is entered, a space should be placed
        history.text = history.text! + display.text! + " "
        
        //append zeros if decimal point was entered
        if userEnteredDecimalPoint{
            display.text!.insert("0",atIndex: display.text!.startIndex)
            display.text!.insert("0", atIndex: display.text!.endIndex)
        }
        
        userIsInTheMiddleOfTypingANumber = false
        userEnteredDecimalPoint = false
        
        
        //everytime you enter a display value, you push the operand on the stack and update the display value
        //in assignment 2 displayValue will need to be an optional so that you can return the appropriate message when you can't evaluate what's currently on the stack
        if let result = brain.pushOperand(displayValue) {
            displayValue =  result
           
        } else {
            //temporary solution
            displayValue = 0
        }
    }
    
   
    var displayValue: Double {
        get {
            //this is where the displayed operand gets turned into a number before getting pushed onto the OpStack
            
            
            if let decimalRange = display.text!.rangeOfString("."){
                 // adds whole number part + decimal part
                return NSNumberFormatter().numberFromString(display.text![display.text!.startIndex..<decimalRange.startIndex])!.doubleValue + (NSNumberFormatter().numberFromString(display.text![decimalRange.endIndex..<display.text!.endIndex])!.doubleValue/pow(10.0,Double(display.text![decimalRange.endIndex..<display.text!.endIndex].characters.count)))
                
                
            }
            else {
               
                if display.text! == "π"
                {
                    return M_PI
                }
                else {
                    return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
                }
                
                
            }
            
            }
        set {
            display.text = "\(newValue)"
       

    
        }
    
    }
    
    
}

