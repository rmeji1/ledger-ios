//
//
//  ledge
//
//  Created by robert on 1/23/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

class C8HSetGegaBalAndTableVC: UIViewController{
    private var defaultText = ["gega":"GEGA",
                               "gameTableNumber":"Game/Table Number",
                               "beginningBalance":"Beginning Balance"]

    let pickerOptions = ["Black Jack", "Craps", "Roulette"]
    var activeField: UITextField!
    var pickerView = UIPickerView()
    var tablesPickerView = UIPickerView()
    var manager: C8HGeoRegionManager?
    
    // MARK: - Properties
    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tablesPickerView.delegate = self
        tablesPickerView.accessibilityIdentifier = "tablesPicker"
        pickerView.delegate = self
        pickerTextField.inputView = pickerView
        addObserveNotificationForKeyboard()
        enableOverlayView("Loading")
        // Load tables.
    }
    
    // MARK: - Configuration
    func enableOverlayView(_ message: String ){
        // Create view to add shadow
        let overlayView = UIView(frame: view.frame)
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.6
        overlayView.tag = 10
        overlayView.pleaseWait(message)
        view.addSubview(overlayView)
    }
}












extension C8HSetGegaBalAndTableVC: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.accessibilityIdentifier == "tablesPicker"{
            return 1
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.accessibilityIdentifier == "tablesPicker"{
            return 1
        }
        return pickerOptions.count
    }
}

extension C8HSetGegaBalAndTableVC: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.textFieldShouldReturn(pickerTextField){
            pickerTextField.text = pickerOptions[row]
        }
    }
}

// =========================================================================
// MARK: Keyboard notification handlers
extension C8HSetGegaBalAndTableVC{
    func addObserveNotificationForKeyboard(){
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
//        NSDictionary* info = [aNotification userInfo];
//        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//        CGRect bkgndRect = activeField.superview.frame;
//        bkgndRect.size.height += kbSize.height;
//        [activeField.superview setFrame:bkgndRect];
//        [scrollView setContentOffset:CGPointMake(0.0, activeField.frame.origin.y-kbSize.height) animated:YES];
        
//        guard let info = notification.userInfo else {
//            return
//        }
//        let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
////        var bkgndRect = activeField.superview?.frame
//        var bkgndRect = stackView.superview?.frame
//        bkgndRect?.size.height += (kbSize?.height)!
////        activeField.superview?.frame = bkgndRect!
//        stackView.superview?.frame = bkgndRect!
//        let point = CGPoint(x: 0.0, y: stackView.frame.maxY-(kbSize?.height)!)
//        scrollView.setContentOffset(point, animated: true)
    }

    @objc
    func keyboardWillBeHidden(_ notification: Notification){

    }

}

// =========================================================================
// MARK: UITextFieldDelegate functions
extension C8HSetGegaBalAndTableVC: UITextFieldDelegate{
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
//        guard let identifier = textField.restorationIdentifier else{
//            return true
//        }
//        if textField.text == ""{
//            textField.text = defaultText[identifier]
//        }
//        textField.resignFirstResponder()
        return true
    }
    
    // Add any text validation here.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        //  Set to false if any of these conditions are not
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
}


