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
  func updateTable(_ data: [String: String])
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
  var decimal : Bool = false
  var decimalCount = 0
  var casino: C8HCasino?
  var table : C8HTable?
  var tables: [C8HTable]?
  var username: String = ""
  var password: String = ""
  //    var transactionBalanace : Decimal = Decimal(0)
  var transaction : Transaction = Transaction()
  
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
   Performs the transaction, called from IBAction plus or minus.
   
   - parameters:
    - type: plus or minus
    - dec: Decimal with the amount of the transaction.
   */
  func performTransaction(_ type: Transaction.Transaction_Type, dec: Decimal ){
//    debugPrint("Greater than 0. \(dec)")
//    transaction.amount = dec
//    transaction.type = type.rawValue
//    // FIXME: - Will lead to error if table is not instantistated.
//    transaction.tableId = (table?.id)!
//    transaction.casinoId = (table?.casinoId)!
//    showAlertToAuthenticateManager()
    
    _ =  self.navigationController?.popViewController(animated: true)
  }
  
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
//      OktaAuth
//        //                .login(username, password: password)
//        .login("robertmejia30@gmail.com", password:"Ro264874033!")
//        //                .login("rm@cre8ivehouse.com", password:"Youtube1996")
//        .start(self).then{ tokenManager in
//          tokenManager.accessToken!
//        }
  }
  
 
  /**
   Retrieves profile of the manager.
   */
  func retrieveProfile() -> PromiseKit.Promise<[String:Any]>{
    return Promise{ seal in
      OktaAuth.getUser{ response, error in
        if error != nil {
          print("Error: \(error!)")
          seal.reject(error!)
        }
        if let retValue = response{ seal.fulfill(retValue) }
        seal.reject(AuthenticationError.unableToGetProfile)
      }
    }
  }
  
  /**
   Checks manager profile and manager.
   */
  func compareUserDetails(_ managerDetails : [String:Any]) -> PromiseKit.Promise<Bool>{
    return Promise{ seal in
      debugPrint("Manager Details: \(managerDetails)")
      // Changed to employee token information.
//      tokens?.get(forKey: "accessToken")
//      tokens?.idToken = OktaAuth.tokens?.get(forKey: "idToken")
//      tokens?.refreshToken = OktaAuth.tokens?.get(forKey: "refreshToken")
//
      firstly{
        retrieveProfile()
        }.done{ empDetails in
          debugPrint("Employee Details: \(empDetails)")
          guard
            let employeeEmail = empDetails["email"] as? String,
            let managerEmail = managerDetails["email"] as? String else{
              throw AuthenticationError.cannotFindEmpEmail
          }
          debugPrint(employeeEmail)
          debugPrint(managerEmail)
          if employeeEmail == managerEmail{
            seal.reject(AuthenticationError.needAnotherManager)
          }
          self.transaction.employeeInitials = empDetails["initials"] as! String
          //TODO: - Add Id to employee details in okta.
          //self.transaction.employeeId = empDetails[""] as! Int64
          seal.fulfill(true)
        }.catch{ error in
          debugPrint(error)
      }
    }
  }
  
  /**
   Checks if profile sent is that of manager.
   
   - parameters:
   - userDetails: user profile retrieved from okta
   */
  func isManager(_ userDetails : [String:Any]) -> PromiseKit.Promise<[String:Any]>{
    return Promise{seal in
      if userDetails.keys.contains("isMan"){
        if let isMan = userDetails["isMan"] as? Bool{
          if isMan {
            transaction.managerInitials = userDetails["initials"] as! String
            seal.fulfill(userDetails)
          }
        }
      }
      seal.reject(AuthenticationError.notAManager)
    }
  }
  
  /**
   Shows the alert so a manager can approve a transaction.
   */
  func showAlertToAuthenticateManager(){
    let alert = UIAlertController(style: .actionSheet)
    let configOne: TextField.Config = textFieldOneForModal()
    let configTwo: TextField.Config = textFieldTwoForModal()
    
    alert.addTwoTextFields(vInset: 0, textFieldOne: configOne, textFieldTwo: configTwo)
    alert.addAction(title: "Enter manager's credientals", style: .default){ action in
      self.actionToAuthenticateManager()
    }
    alert.addAction(title: "Cancel", style: .cancel)
    navigationController?.present(alert, animated:true)
  }
  
  /**
   Action performed when manager enters credentials
   */
  func actionToAuthenticateManager(){
    C8HOverlayViews.indicatorViewWithMessage("Loading", for: self.view)
    firstly{
      self.logInManager(username: self.username, password: self.password)
      }.then{ token in
        self.retrieveProfile() // Gets manager profile
      }.then{ managerDetails in
        self.isManager(managerDetails) // Check if manager
      }.then{ managerDetails in
        //debugPrint("Manager Details: \(managerDetails)")
        self.compareUserDetails(managerDetails) // compare to emp logged
      }.done{ retValue in
        if retValue{
          debugPrint("Transaction performed.")
          // Now need to make a call about the transaction
          let repo = TransactionRepo()
          repo.postTransaction(transaction: self.transaction).done{ _ in
            _ =  self.navigationController?.popViewController(animated: true)
          }
        }
      }.catch{ error in
        debugPrint(error)
      }.finally{
        C8HOverlayViews.disableOverlayView(for: self.view)
    }
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
