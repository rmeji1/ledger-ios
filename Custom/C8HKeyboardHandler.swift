//
//  C8HKeyboardHandler.swift
//  ledge
//
//  Created by robert on 3/27/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation

import UIKit

@available(iOS 9.0, *)
class C8HKeyboardHandler{
    var activeField : UITextField!
    var stackView : UIStackView!
    var scrollView : UIScrollView!
    var view : UIView!
    
    init(stackView: UIStackView!, scrollView: UIScrollView!, view: UIView!){
        self.stackView = stackView
        self.scrollView = scrollView
        self.view = view
    }
    func enableKeyboardNotification(){
        let notificationCenter = NotificationCenter.default
        let keyboardWillShow = NSNotification.Name.UIKeyboardWillShow
        let keyboardWillHide = NSNotification.Name.UIKeyboardWillHide
        
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWasShown), name: keyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: keyboardWillHide, object: nil)
        
    }
    
    func removeObserveNoticationForKeyboard(){
        let notificationCenter = NotificationCenter.default
        let keyboardWillShow = NSNotification.Name.UIKeyboardWillShow
        let keyboardWillHide = NSNotification.Name.UIKeyboardWillHide
        
        notificationCenter.removeObserver(self, name: keyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: keyboardWillHide, object: nil)
    }
    
    @objc
    func keyboardWasShown(_ notification: Notification) {
        guard let activeField = activeField else { return }
        let info = notification.userInfo
        let kbSize = (info?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbSize?.height)!, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        var aRect = self.view.frame
        aRect.size.height -= (kbSize?.height)!
        
        let x = stackView.frame.origin.x + activeField.frame.maxX
        let y = stackView.frame.origin.y + activeField.frame.maxY
        let point = CGPoint(x: x , y: y)
        
        if !aRect.contains(point){
            self.scrollView.scrollRectToVisible(stackView.frame, animated: true)
        }
    }
    
    @objc
    func keyboardWillBeHidden(_ notification: Notification){
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
}
