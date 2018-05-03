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
import Hydra
import PromiseKit


protocol C8HNumberPadDelegate : class {
  func updateLedger(with: Transaction)
}

class C8HNumberPadView: UIViewController {
  
  enum AuthenticationError : Error{
    case invalidCredentials
    case cannotFindEmpEmail
    case notAManager
    case needAnotherManager
    case unableToGetProfile
  }
  //==============================================================================
  //  MARK: - DATAMEMEBERS
  //==============================================================================
  var picker = UIPickerView()
  weak var delegate: C8HNumberPadDelegate?
  
  var ledger : Ledger?
  var type: Transaction.Transaction_Type?
  var managerInitals: String?
  var employeeInitals: String?
  var amount : Decimal?
  
  var decimal : Bool = false
  var decimalCount = 0
  var casino: C8HCasino?
  var table : C8HTable?
  var tables: [C8HTable]?
  var username: String = ""
  var password: String = ""
  
  
  //    var transactionBalanace : Decimal = Decimal(0)
  //  var transaction : Transaction = Transaction()
  
  //==============================================================================
  //  MARK: - PROPERTIES
  //==============================================================================
  @IBOutlet weak var numberLabel: UILabel!
  //  @IBOutlet weak var plusButton: UIButton!
  //@IBOutlet weak var minusButton: UIButton!
  
  //==============================================================================
  //  MARK: - VIEW MANAGEMENT
  //==============================================================================
  override func viewDidLoad() {
    editViewOnLoad()
    editPickerViewForView(on: picker)
    
    let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 24.151))
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 24.151))
    imageView.contentMode = .scaleAspectFit
    let image = UIImage(named: "blackstone-logo-white.png")
    imageView.image = image
    logoContainer.addSubview(imageView)
    navigationItem.titleView = logoContainer
    self.navigationController?.navigationBar.tintColor = UIColor.white;
    //self.navigationController?.navigationBar.tintColor = UIColor.white;
    //    minusButton.layer.cornerRadius = 10
    //    minusButton.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
    //    minusButton.backgroundColor = UIColor.white.withAlphaComponent(0.05)
    //    self.navigationItem.setHidesBackButton(true, animated:true);
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //============================================================================
  //    MARK: - HELPERS
  //============================================================================
  /**
   Inputs text to numberLabel.
   
   Function first checks if the text in the numberLabel is 0. Then performes the
   insertation approipately.
   
   - parameters:
   - text: Text already in label
   - buttonText: Text to be added to label
   */
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
  
  /**
   Makes changes to view in view did load.
   */
  func editViewOnLoad(){
    //    editButtonImageView(on: plusButton)
    //    editButtonImageView(on: minusButton)
    numberLabel.text = "$0"
  }
  
  /**
   Change button edge insets to make image fit better in the button.
   
   - parameters:
   - button: insets will be changed on this given button
   */
  func editButtonImageView(on button: UIButton){
    button.imageView?.contentMode = .scaleAspectFit
    button.imageEdgeInsets = UIEdgeInsetsMake(15,15,15,15)
  }
  
  /**
   Creates picker to be used as input when you need to edit transfering to.
   
   Not being used.
   
   - parameters:
   -picker: UIPicker used by controller.
   */
  func editPickerViewForView(on picker: UIPickerView){
    picker.frame = CGRect(x: 0, y: self.view.bounds.height - 280, width: self.view.bounds.width, height: 280.0)
    picker.backgroundColor = UIColor.darkGray
    picker.delegate = self
    picker.dataSource = self
  }
  
  /**
   Config for username textfield in modal used for authentication when
   plus/minus pressed.
   */
  func textFieldOneForModal() -> TextField.Config {
    return { textField in
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
        self.username = textField.text!
      }
    }
  }
  
  /**
   Config for password textfield in modal used for authentication when
   plus/minus pressed.
   */
  func textFieldTwoForModal() -> TextField.Config{
    return { textField in
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
        self.password = textField.text!
      }
    }
  }
  /**
   Logs in the creditenials entered in the modal in hopes to
   authenticate an additon.
   
   - parameters:
   - username: textField one parameter
   - password: textField two parameter
   */
  func logInManager(username: String, password: String) -> PromiseKit.Promise<String> {
    return Promise{
      seal in
      OktaAuth
        //                .login(username, password: password)
        .login("robertmejia30@gmail.com", password:"Ro264874033!")
        //                .login("rm@cre8ivehouse.com", password:"Youtube1996")
        .start(self).then{ tokenManager in
          seal.fulfill(tokenManager.accessToken!)
        }.catch{error in
          seal.reject(error)
      }
    }
  }
  
  
  /**
   Retrieves profile of the manager.
   */
  func retrieveProfile() -> PromiseKit.Promise<Bool>{
    return Promise{ seal in
      OktaAuth.getUser{ response, error in
        if error != nil {
          print("Error: \(error!)")
          seal.reject(AuthenticationError.unableToGetProfile)
        }
        if (response?["isManager"] as? Bool) == true {
          if let initials = response?["initials"] as? String{
            self.managerInitals = initials
            seal.fulfill(true)
          }
        }
        else{
          seal.reject(AuthenticationError.notAManager)
        }
      }
    }
  }
  
  
  /**
   Shows the alert so a manager can approve a transaction.
   */
  func createAlertToAuthenitcateManager(_ handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertController{
    let alert = UIAlertController(style: .actionSheet)
    let configOne: TextField.Config = textFieldOneForModal()
    let configTwo: TextField.Config = textFieldTwoForModal()
    
    alert.addTwoTextFields(vInset: 0, textFieldOne: configOne, textFieldTwo: configTwo)
    alert.addAction(title: "Enter manager's credientals", style: .default, handler: handler)
    alert.addAction(title: "Cancel", style: .cancel)
    
    return alert
  }
  
  /**
   Action performed when manager enters credentials
   */
  func actionToAuthenticateManager() -> PromiseKit.Promise<Bool>{
    // this is to check to see if I am getting the manager initals correctly.
    return self.logInManager(username: self.username, password: self.password).then{ _ in
      self.retrieveProfile()
      }.map{ success in
        return success
    }
  }
  
  /**
   Performs the transaction, called from IBAction plus or minus.
   
   - parameters:
   - type: plus or minus
   - dec: Decimal with the amount of the transaction.
   */
  func performTransaction(_ type: Transaction.Transaction_Type, dec: Decimal ){
    guard let delegate = delegate,
          let empInitials = UserDefaults.standard.string(forKey: "initials") else
      { return }
    
    // Create alert to authenticate manager
    let alert = createAlertToAuthenitcateManager{ action in
      // Action on success.
      let color = UIColor.init(hexString: "663399")
      C8HOverlayViews.indicatorViewWithMessage("Loading", for: self.view, with: color, and: 0.5)
      
      self.actionToAuthenticateManager()
        .map{ success -> Transaction in
          // if success logging manager and getting his details
          if success{
            // Create transaction
            
            let trans = Transaction(type: type,
                                    managerInitals: self.managerInitals!,
                                    employeeInitals: empInitials,
                                    amount: dec)
            return trans
          }else{
            throw AuthenticationError.unableToGetProfile
          }
        }.done{ trans in
          // main menu adds transaction to ledger and updates server. 
          delegate.updateLedger(with: trans)
          //finally go back
          _ =  self.navigationController?.popViewController(animated: true)
        }.catch{ error in
          self.errorNotice(error.localizedDescription)
          debugPrint(error)
          // Should not allow user to change views at this point.
        }.finally {
          C8HOverlayViews.disableOverlayView(for: self.view)
      }
    }
    
    //  Present alert in nav controller.
    navigationController?.present(alert, animated:true)
  }
  
  //==========================================================================
  //  MARK: - ACTIONS
  //==========================================================================
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
  
  @IBAction func dismissPlusVC(_ sender: Any) {
    //        delegate?.updateTable(["title" : numberLabel.text! , "type":"+"])
    // dismiss(animated: true, completion: nil)
    guard  var text = numberLabel.text else{ return }
    text.removeFirst()
    if let dec = Decimal(string: text){
      if dec > Decimal(0) && dec < Decimal (999.99){
        performTransaction(Transaction.Transaction_Type.ADDITION,
                           dec: dec)
      }
    }
  }
  
  @IBAction func dismissMinusVC(_ sender: Any) {
    guard  var text = numberLabel.text else{ return }
    text.removeFirst()
    if let dec = Decimal(string: text){
      if dec > Decimal(0) && dec < Decimal (999.99){
        performTransaction(Transaction.Transaction_Type.SUBTRACTION,
                           dec: dec)
      }
    }
  }
  
  @IBAction func numberOnePressed(_ sender: UIButton) {
    guard
      let text = numberLabel.text,
      let buttonText = sender.titleLabel?.text else{
        debugPrint("An error happened trying to get the number one.")
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
