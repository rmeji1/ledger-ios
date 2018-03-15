//
//  C8HNumberPadView.swift
//  ledge
//
//  Created by robert on 2/2/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit
import Foundation
import OktaAuth

protocol C8HNumberPadDelegate : class {
    func updateTable(_ data: [String: String])
}


class C8HNumberPadView: UIViewController {
    var picker = UIPickerView()
    weak var delegate: C8HNumberPadDelegate?
    var decimal : Bool = false
    var decimalCount = 0
    var tables: [C8HTable]?
    
//  MARK - PROPERTIES
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!

    override func viewDidLoad() {
        editViewOnLoad()
        editPickerViewForView(on: picker)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    ==========================================================================
//    MARK - HELPERS
//    ==========================================================================
    func inputTextToLabel(_ text: String, buttonText: String){
        if !decimal {
            if text == "$0" {
                numberLabel.text = "$" + buttonText
            } else {
                numberLabel.text = text + buttonText
            }
        }else{
            let index = text.index(of: ".")
            if decimalCount < 2{
                decimalCount = decimalCount + 1
                let font = numberLabel.font
                let fontSuper = UIFont(name: numberLabel.font.fontName, size: numberLabel.font.pointSize / 2)
                let attString = NSMutableAttributedString(string: "\(text)\(buttonText)" , attributes: [.font:font!])
                attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location: (index?.encodedOffset)! + 1,length:decimalCount))
                numberLabel.attributedText = attString
            }
        }
    }
    func editButtonImageView(on button: UIButton){
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsetsMake(15,15,15,15)
    }
    func editViewOnLoad(){
        editButtonImageView(on: plusButton)
        editButtonImageView(on: minusButton)
        numberLabel.text = "$0"
    }
    func editPickerViewForView(on picker: UIPickerView){
        picker.frame = CGRect(x: 0, y: self.view.bounds.height - 280, width: self.view.bounds.width, height: 280.0)
        picker.backgroundColor = UIColor.darkGray
        picker.delegate = self
        picker.dataSource = self
    }
//    ==========================================================================
//    MARK - ACTIONS
//    ==========================================================================
    @IBAction func inputDecimals(_ sender: UIButton) {
        if !decimal {
            decimal = true
            guard  let text = numberLabel.text else{ return }
            if text == "$0" {
                numberLabel.text = "$."
            } else {
                numberLabel.text = "\(text)."
            }
        }
    }
//    ==========================================================================
    @IBAction func dismissPlusVC(_ sender: Any) {
//        delegate?.updateTable(["title" : numberLabel.text! , "type":"+"])
        // dismiss(animated: true, completion: nil)
        // Need to validate request by manager
        
        let alert = UIAlertController(style: .actionSheet)

        let configOne: TextField.Config = { textField in
            textField.left(image: #imageLiteral(resourceName: "002-user-silhouette.png") , color: .black)
            textField.leftViewPadding = 16
            textField.leftTextPadding = 12
            textField.becomeFirstResponder()
            textField.backgroundColor = nil
            textField.textColor = .black
            textField.placeholder = "Name"
            textField.clearButtonMode = .whileEditing
            textField.keyboardAppearance = .default
            textField.keyboardType = .default
            textField.returnKeyType = .done
            textField.action { textField in
            // action with input
                }
            }
            
            let configTwo: TextField.Config = { textField in
                textField.textColor = .black
                textField.placeholder = "Password"
                textField.left(image: #imageLiteral(resourceName: "001-lock-1"), color: .black)
                textField.leftViewPadding = 16
                textField.leftTextPadding = 12
                textField.borderWidth = 1
                textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
                textField.backgroundColor = nil
                textField.clearsOnBeginEditing = true
                textField.keyboardAppearance = .default
                textField.keyboardType = .default
                textField.isSecureTextEntry = true
                textField.returnKeyType = .done
                textField.action { textField in
                    // action with input
                }
            }
            // vInset - is top and bottom margin of two textFields
        alert.addTwoTextFields(vInset: 0, textFieldOne: configOne, textFieldTwo: configTwo)
        alert.addAction(title: "Authenticate", style: .default){
            OktaAuth
                .userinfo() { response, error in
                    if error != nil {
                        print("Error: \(error!)")
                    }
                    
                    if let userinfo = response {
                        userinfo.forEach { print("\($0): \($1)") }
                    }
            }
        }
            alert.addAction(title: "Cancel", style: .cancel)
            self.navigationController?.present(alert, animated:true)
//        alert.show()
        
       // navigationController?.popViewController(animated: true)
    }
//    ==========================================================================
    @IBAction func dismissMinusVC(_ sender: Any) {
//        delegate?.updateTable(["title" : numberLabel.text! , "type":"-"])
//        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func numberOnePressed(_ sender: UIButton) {
        guard let text = numberLabel.text, let buttonText = sender.titleLabel?.text else{
            return
        }
        inputTextToLabel(text, buttonText: buttonText)
    }
    
    @IBAction func backSpacePressed(_ sender: Any) {
        guard let text = numberLabel.text else{
            return
        }
        if (sender as! UIButton).titleLabel != nil {
            if text != "$"{
                numberLabel.text?.remove(at: text.index(before: text.endIndex))
                if decimal{
                    // Input text will add one
                    if decimalCount - 1 == 0{
                        decimalCount = decimalCount - 1
                        decimal = false
                        guard let text = numberLabel.text else{ return }
                        numberLabel.text?.remove(at:text.index(before: text.endIndex))
                    } else if decimalCount == 0{
                        decimal = false
                    }else{
                        decimalCount = decimalCount - 2
                        inputTextToLabel(numberLabel.text!, buttonText: "")
                    }
                }
                if numberLabel.text == "$"{
                    numberLabel.text = "$0"
                }
            }
        }
    }
    
    @IBAction func changeTo(_ sender: UIButton) {
//        picker.becomeFirstResponder()
        view.addSubview(picker)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension C8HNumberPadView: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tables!.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if row == 0{
            return ""
        }
        return "Table \(tables![row-1].tableNumber)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        pickerView.removeFromSuperview()
    }
}
