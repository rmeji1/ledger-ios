//
//  C8HMainMenuVC.swift
//  ledge
//
//  Created by robert on 4/17/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit
import OktaAuth
import PromiseKit
import CoreLocation
import ActionSheetPicker_3_0
import Kingfisher


class C8HMainMenuVC: UIViewController {
  //==============================================================================
  //  MARK: - Data memebers
  var tableDetailsUpdated = false
  var activeField: UITextField?
  var casinoStore: C8HCasinoRepository?
  var casinoDetails: CasinoDetails?
  var tableDetails: TableDetails?
  var tableStore = C8HTableDetailStore()
  var employeeDetails: EmpDetails?
  var ledger: Ledger?
//
  let ledgerStore = C8HLedgerStore()

  
  //============================================================================
  //  MARK: - Errors
  enum TokenError : Error{
    case TokenIsNotValid
  }
  //============================================================================
  //  MARK: - Properties
  @IBOutlet weak var addSubtractButton: UIButton!
  @IBOutlet weak var setTableParametersView: UIView!
  @IBOutlet weak var secondView: UIView!
  
  @IBOutlet weak var overlayView: UIView!
  @IBOutlet weak var statusBar: UIView!
  @IBOutlet weak var startLedgerButton: UIButton!
  @IBOutlet weak var openTableButton: UIButton!
  @IBOutlet weak var overlayForFirstStack: UIView!
  @IBOutlet weak var nameLabel:UILabel!
  @IBOutlet weak var employeeNumberLabel:UILabel!
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet var swipeDownGesture: UISwipeGestureRecognizer!
  
  
  @IBOutlet weak var selectTableTextField: C8HTextField!
  @IBOutlet weak var selectGameTextField: C8HTextField!
  @IBOutlet weak var selectGegaTextField: C8HTextField!
  @IBOutlet weak var balanceTF : C8HTextField!
  
  //============================================================================
  //  MARK: - View Controller funcs
  
  /*****************************************************************************
   
   */
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Customize
    addLogo()
    makeNavigationBarTransparent()
    addDoneButtonOnKeyboard()
    
    // Add user name to name label
    if let name = UserDefaults.standard.string(forKey: "firstName"),
       let number = UserDefaults.standard.string(forKey: "id"){
      employeeDetails = EmpDetails(badgeNumber: number, name: name)
      debugPrint("BadgeNumber: "+employeeDetails!.badgeNumber)
      updateNameLabel(name: name)
      updateEmployeeNumberLabel(employeeNumber: number)
    }
    
    // Find which casino user is in.
    C8HOverlayViews.indicatorViewWithMessage("Finding Locaiton", for: view)
    casinoStore = C8HCasinoRepository()
    
    // Find user current location.
    CLLocationManager.requestLocation().lastValue
      .then{location in
        self.casinoStore!.findCasino(in:location.coordinate)
      }.done{ casinoDetails in
        self.casinoDetails = casinoDetails
        
        let url = URL(string: casinoDetails.casinoImageURL)!
        self.imageView.kf.setImage(with: url)
        
        let gradient = CAGradientLayer()
        
        gradient.frame = self.imageView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        self.imageView.layer.insertSublayer(gradient, at: 0)
      }.catch{error in
        debugPrint(error)
      }.finally {
        C8HOverlayViews.disableOverlayView(for: self.view)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //==============================================================================
  //  MARK: - Customization helpers
  /**
   Add done button to top of balance textfield.
   */
  
  func dismissOverlayInThirdView(){
    let animation = CATransition()
    animation.type = kCATruncationStart
    animation.duration = 0.5
    
    overlayForFirstStack.layer.add(animation, forKey: nil)
    overlayView.layer.add(animation, forKey: nil)
    
    overlayForFirstStack.isHidden = false
    
    overlayForFirstStack.backgroundColor = .clear
    
    let blurEffect = UIBlurEffect(style: .dark)
    //    blurEffect.
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.alpha = 0.95
    
    //always fill the view
    blurEffectView.frame = self.overlayForFirstStack.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    overlayForFirstStack.addSubview(blurEffectView)
    overlayView.isHidden = true
  }
  func addDoneButtonOnKeyboard() {
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    doneToolbar.barStyle       = UIBarStyle.default
    let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
    
    var items = [UIBarButtonItem]()
    items.append(flexSpace)
    items.append(done)
    
    doneToolbar.items = items
    doneToolbar.sizeToFit()
    
    self.balanceTF.inputAccessoryView = doneToolbar
  }
  
  @objc func doneButtonAction() {
    self.balanceTF.resignFirstResponder()
  }
  
  
  /**
   Change employee number to the number of the user.
   */
  func updateEmployeeNumberLabel(employeeNumber number: String){
    employeeNumberLabel.text = number
  }
  
  /**
   Change name to the name of the user.
   */
  func updateNameLabel(name: String){
    nameLabel.text = name.uppercased()
  }
  
  /**
   Make navigation bar transparent.
   */
  func makeNavigationBarTransparent(){
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    //self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = UIColor.clear
    //self.navigationController?.navigationBar.tintColor = UIColor.white;
  }
  
  // 13BSrH3ZX$l#X#B55d
  
  /**
   Add logo to navigation bar.
   */
  func addLogo(){
    let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 24.151))
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 24.151))
    imageView.contentMode = .scaleAspectFit
    
    let image = UIImage(named: "blackstone-logo-white.png")
    imageView.image = image
    logoContainer.addSubview(imageView)
    navigationItem.titleView = logoContainer
  }
  
  
  /**
   Set right button item on navgation bar
   */
  func setRightButtonItem(){
    self.navigationItem.rightBarButtonItem = nil
    
    let button = UIButton.init(type: .custom)
    button.frame = CGRect.init(x: 0, y: 0, width: 18, height: 22)
    
    button.setImage(UIImage.init(named: "call-manager.png"), for: UIControlState.normal)
    //button.addTarget(<#T##target: Any?##Any?#>, action: Selector, for: <#T##UIControlEvents#>)
    
    let menuBarItem = UIBarButtonItem(customView: button)
    let  currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant:20)
    currWidth?.isActive = true
    
    let  currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant:24)
    currHeight?.isActive = true
    
    currHeight?.isActive = true
    
    self.navigationItem.rightBarButtonItem = menuBarItem
  }
  
  @IBAction func buttonAction(_ sender: Any){
    self.navigationController?.performSegue(withIdentifier: "presentModallyMenu", sender: nil)
  }
  
  /**
   Set right button item on navgation bar
   */
  func setLeftButtonItem(){
    self.navigationItem.leftBarButtonItem = nil
    
    let button = UIButton.init(type: .custom)
    button.frame = CGRect.init(x: 0, y: 0, width: 22, height: 22)
    
    button.setImage(UIImage.init(named: "menu-stack.png"), for: UIControlState.normal)
    button.imageView?.contentMode = .scaleAspectFill
    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    
    let barButton = UIBarButtonItem.init(customView: button)
    self.navigationItem.leftBarButtonItem = barButton
  }
  
  func enableTextFieldsOnTableSelection(){
    self.selectGameTextField.isEnabled = true
    self.selectGegaTextField.isEnabled = true
    self.balanceTF.isEnabled = true
  }
  
  func setTextForTextFieldsOnTableSelection(){
    guard let table = tableDetails else{
      debugPrint("C8HMainMenu.setTextForTextFieldsOnTableSelection() -- Table details not set.")
      return
    }
    self.selectGameTextField.text = table.game.description
    self.selectGegaTextField.text = table.gega.description
    self.balanceTF.text = table.beginningBalance?.description
  }
  
  
  // =============================================================================
  //  MARK: - ACTIONS
  /**
   Check the textfields and open the table.
   Should also start the ledger.
   Need to call the server in order to get ledger id and
   store the edger in the database.
   */
  @IBAction func openTable(_ sender: UIButton) {
    let animation = CATransition()
    animation.type = kCATransitionPush
    animation.duration = 0.25
    
    setTableParametersView.layer.add(animation, forKey: nil)
    overlayForFirstStack.layer.add(animation, forKey: nil)
    
    setTableParametersView.isHidden = true
    overlayForFirstStack.isHidden = true
    
    statusBar.isHidden = false
    
    startLedgerButton.backgroundColor = UIColor(hexString: "00CC00")
    startLedgerButton.titleLabel?.font = UIFont(name: "LatoLatin-Bold", size: 16.0)
    startLedgerButton.setTitle("KC140001", for: .disabled )
    
    if tableDetailsUpdated{
      _  = self.tableStore.save(table: &self.tableDetails!)
    }
    
    guard let tableDetails = tableDetails else{
      return
    }
    self.ledger = Ledger(casinoDetails: casinoDetails!, empDetails: employeeDetails!,tableDetails: tableDetails, ledgerDate: nil, active: true, transactions: nil)
    
    
    _ = ledgerStore.save(ledger: ledger!)
    
    
  }
  
  @IBAction func startLedgerButtonPressed(_ sender: UIButton) {
    sender.isEnabled = false
    dismissOverlayInThirdView();
  }
  
  @IBAction func swipeDownAction(_ sender: Any) {
    activeField?.resignFirstResponder()
  }
  
  /**
   Setting PickerView for select table.
   */
  @IBAction func showPickerView(_ sender: UITextField) {
    activeField?.resignFirstResponder()
    //    Get the rows from the repository.
    let tableStore = C8HTableRepository()
    
    tableStore.findTables(forCasino: 0).done{ tableDetails in
      var rows : [String] = []
      
      for table in tableDetails{
        rows.append("Table: \(table.id)")
      }
      
      let action = ActionSheetStringPicker(
        title: "Select table", rows: rows, initialSelection: 1,
        doneBlock: {picker, indexes, value in
          if let text = value as? String{
            sender.text = text
          }
          // Save the table the user selected.
          self.tableDetails = tableDetails[indexes]
          
          // Set textfields text to tabledetails descriptions.
          self.setTextForTextFieldsOnTableSelection()
          
          //Set other textfields to active.
          self.enableTextFieldsOnTableSelection()
          
          self.openTableButton.isEnabled = true
      }, cancel: {ActionStringCancelBlock in return}, origin: sender)
      
      action?.tapDismissAction = .cancel
      action?.show()
      }.catch{ error in
        debugPrint(error)
    }
  }
  
  /**
   Show Picker View for Gega
   */
  @IBAction func showPickerViewForGega(_ sender: UITextField) {
    activeField?.resignFirstResponder()
    
    //    Get the rows from the repository.
    let gegaStore = C8HGegaStore()
    
    gegaStore.findGegas(forCasino: 0).done{ gegaDetails in
      var rows : [String] = []
      
      for gega in gegaDetails{
        rows.append("\(gega.description)")
      }
      
      let action = ActionSheetStringPicker(
        title: "Change GEGA", rows: rows, initialSelection: 1,
        doneBlock: {
          picker, indexes, value in
          
          self.tableDetails?.gega = gegaDetails[indexes]
          self.tableDetailsUpdated = true
          if let text = value as? String{
            sender.text = text
          }
          
      }, cancel: {ActionStringCancelBlock in return}, origin: sender)
      
      action?.tapDismissAction = .cancel
      action?.show()
      }.catch{error in
        debugPrint(error)
    }
  }
  
  /**
   Show Picker View for Games
   */
  @IBAction func showPickerViewForGames(_ sender: UITextField) {
    activeField?.resignFirstResponder()
    
    //    Get the rows from the repository.
    let gameStore = C8HGameStore()
    
    gameStore.findGames(forCasino: 0).done{ gameDetails in
      var rows : [String] = []
      var startingIndex = 0
      for (index, game) in gameDetails.enumerated(){
        
        if self.tableDetails?.game.id == game.id{
          startingIndex = index
        }
        rows.append("\(game.description)")
      
      }
      
      let action = ActionSheetStringPicker(
        title: "Change Game", rows: rows, initialSelection: startingIndex,
        doneBlock: {picker, indexes, value in
          
          self.tableDetailsUpdated = true
          self.tableDetails?.game = gameDetails[indexes]
          
          if let text = value as? String{
            sender.text = text
          }
      }, cancel: {ActionStringCancelBlock in return}, origin: sender)
      
      action?.tapDismissAction = .cancel
      action?.show()
      }.catch{ error in
        debugPrint(error)
    }
  }
  
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
    
    if let vc = segue.destination as? C8HNumberPadView{
      vc.ledger = ledger
      vc.delegate = self
    }
   }
 
  
}

extension C8HMainMenuVC: C8HNumberPadDelegate{
  func updateLedger(with transaction: Transaction) {
    guard let ledger = ledger else {
      return
    }
    // Append transaction to our ledger.
    ledger.append(transaction)
    
    // Update ledger to the server.
    ledgerStore.update(ledger: ledger).catch{ error in
      self.errorNotice(error.localizedDescription)
    }
  }
}

extension C8HMainMenuVC: UITextFieldDelegate{
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
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      if self.view.frame.origin.y == 0{
        self.view.frame.origin.y -= keyboardSize.height
      }
    }
  }
  
  @objc
  func keyboardWillBeHidden(_ notification: Notification){
    
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      if self.view.frame.origin.y != 0{
        //        self.view.frame.origin.y += keyboardSize.height
        self.view.frame.origin.y = 0
      }
    }
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.activeField = textField
    self.swipeDownGesture.isEnabled = true
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
    enableKeyboardNotification()
    
    if textField.tag == 100 || textField.tag == 200 || textField.tag == 300  {
      return false
    }
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool{
    textField.resignFirstResponder()
    return true
  }
  
  // Add any text validation here.
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
    //    if textField.tag == 400 {
    //      openTableButton.isEnabled = true
    //    }
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField){
    removeObserveNoticationForKeyboard()
    self.swipeDownGesture.isEnabled = false
    self.activeField = nil
  }
}
