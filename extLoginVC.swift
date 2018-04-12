//
//  extLoginVC.swift
//  ledge
//
//  Created by robert on 2/19/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Alamofire

extension C8HLoginVC: C8HGeoRegionDelegate, UITextFieldDelegate{
    // =========================================================================
    // MARK: Keyboard notification handlers
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
    // =========================================================================
    // MARK: Geo Region Delegate delegate
    // Deprecated
    func successfullyRetrievedUserLocation(){
        guard let overlayView = view.viewWithTag(10) else {
            return
        }
        overlayView.removeFromSuperview()
    }
    
    func onlyAuthorizedWhenInUse() {
        let message = "Ledgers requires Always authorization for locations services. Please go to settings."
        let alertController = UIAlertController (title: "Oops", message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // =========================================================================
    // MARK: Login Validator delegate
//    func successfulTokenRecievedChangeView() {
//        self.performSegue(withIdentifier: "conditionSegue", sender: nil)
//    }
    // =========================================================================
    // MARK: UITextFieldDelegate functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        enableKeyboardNotification()
        if textField.restorationIdentifier == "password"{
//            textField.text = ""
            textField.isSecureTextEntry = true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        //textField.resignFirstResponder()
        if textField.restorationIdentifier == "employeeId"{
            self.passwordTextField.becomeFirstResponder()
        }else{
            // Update view to turn on a view with an overlay and an activity monitor
            textField.resignFirstResponder()
            //self.oktaLogin(self)
        }
        return true
    }
    
    // Add any text validation here.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        //  Set to false if any of these conditions are not
//        guard textField.hasText else{
//            if textField.restorationIdentifier == "employeeId"{
//                textField.text = "Employee Id"
//            } else {
//                textField.text = "Password"
//            }
//            return true
//        }
        if textField.restorationIdentifier == "employeeId"{
            username = textField.text!
            debugPrint("Username:" + username)
        } else {
            password = textField.text!
            debugPrint("Password:" + password)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        removeObserveNoticationForKeyboard()
        self.activeField = nil
    }
}
