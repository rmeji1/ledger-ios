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
import SideMenu


class C8HMainMenuVC: UIViewController {
  //==============================================================================
  //  MARK: - Data memebers
  //  var tableDetailsUpdated = false
  var activeField: UITextField?
  var casinoStore: C8HCasinoRepository?
  var casinoDetailsFake: CasinoDetailsFake?
  //  var tableDetails: TableDetails?
  var tableStore = C8HTableDetailStore()
  var employeeDetails: EmpDetails?
  var ledger: Ledger?
  //
  let ledgerStore = C8HLedgerStore()
  var locationManager: CLLocationManager?
  
  var table: TableNew?
  var game : Game?
  
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
  @IBOutlet weak var tableNumberLabel:UILabel!
  @IBOutlet weak var gegaNumberLabel:UILabel!
  
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
    // FIXME: - Need to request privacy settings before requesting location
    CLLocationManager.requestLocation(authorizationType: .always).lastValue.then{location in
      self.casinoStore!.findCasino(in:location.coordinate)
      }.done{ casinoDetails in
        self.casinoDetailsFake = casinoDetails
        
        let url = URL(string: casinoDetails.casinoImageURL)!
        self.imageView.kf.setImage(with: url)
        
        let gradient = CAGradientLayer()
        
        gradient.frame = self.imageView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        self.imageView.layer.insertSublayer(gradient, at: 0)
        C8HOverlayViews.disableOverlayView(for: self.view)
      }.catch{error in
        debugPrint("\(self.title!): Error for location services: \(error)")
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
   Set right button item on navgation bar. Call manager action.
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
   Set left button item on navgation bar. Menu stack call option.
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
    
    self.selectGameTextField.text = ""
    self.selectGegaTextField.text = ""
    self.balanceTF.text = ""
  }
  
  func setTextForTextFieldsOnTableSelection(){
    //    guard let table = tableDetails else{
    //      debugPrint("C8HMainMenu.setTextForTextFieldsOnTableSelection() -- Table details not set.")
    //      return
    //    }
    //    guard let table = self.table else{
    //      debugPrint("C8HMainMenu.setTextForTextFieldsOnTableSelection() -- Table details not set.")
    //      return
    //    }
    //    self.selectGameTextField.text = table.games.first?.description
    //    self.selectGegaTextField.text = table.games.first?.gega
    ////    self.balanceTF.leftView.text
    //    self.balanceTF.text = table.balance.description
    
    guard let game = self.game,
      let table = self.table else {
        debugPrint("C8HMainMenu.setTextForTextFieldsOnTableSelection() -- Game not set.")
        return
    }
    self.selectGegaTextField.text = game.gega
    self.selectGameTextField.text = game.description
    
//    var found = false
//    for bal in table.newBalances{
//      if bal.forGame == game.description{
//        self.balanceTF.text = bal.balance.description
//        found = true
//      }
//    }
//    if !found{
//      self.balanceTF.text = "0"
//    }
    if table.balances.keys.contains("game:\(game.id)"){
      self.balanceTF.text = table.balances["game:\(game.id)"]?.description
    }else{
      self.balanceTF.text = "0"
    }
  }
  
  //  MARK: - View ACTIONS
  
  /**
   Push transactions
   
   Should take the current ledger and
   */
  
  @IBAction func pushLedger(_ sender: UIButton){
    self.performSegue(withIdentifier: "segueForSignatureView", sender: nil)
  }

  /**
   Check the textfields and open the table.
   Should also start the ledger.
   Need to call the server in order to get ledger id and
   store the ledger in the database.
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
    startLedgerButton.setTitle("", for: .disabled) // Removes current text.
    
    
    // Check if we need to update the table information
    guard var table = table,
      let game = game else{ return }
    
    let hasGame = table.games.contains{ element in
      if case game.id = element.id{ return true } else{ return false }
    }
    var update = false
    // If we have the game check to see if we have a different balance then set by the user
    if hasGame {
      if !(table.balances["game:\(game.id)"] == Decimal(string: balanceTF.text!)){
        table.balances["game:\(game.id)"] = Decimal(string: balanceTF.text!)
        update = true
      }
    }else{
      table.balances["game:\(game.id)"] = Decimal(string: balanceTF.text!)
      table.activeGames = table.activeGames + 1
      update = true
    }
    
    if update {
      updateTable(table).done{ id in table.id = id }.catch{ error in }
    }
    
    let tableDetails = TableDetails(gega: game.gega.description, game: game.description, id: table.id, number: Int64(table.number))
    // create ledger
    let casinoDetails = CasinoDetails(casinoCode: "FH", casinoName: "Flex Casino")
    self.ledger = Ledger(casinoDetails: casinoDetails, empDetails: employeeDetails!,tableDetails: tableDetails, active: true, transactions: nil, beginningBalance: table.balances["game:\(game.id)"]!)
    
    
    //save ledger
    ledgerStore.save(ledger: ledger!).done{ id in
      self.ledger?.id = id
      self.ledger?.ledgerId = String(format: "\(self.ledger?.casinoDetails.casinoCode ?? "LC")%05d", id)
      self.startLedgerButton.setTitle(self.ledger!.ledgerId!, for: .disabled )
      self.tableNumberLabel.text = String(format: "Table %02d" ,
                                          (self.ledger?.tableDetails!.number)!)
      self.gegaNumberLabel.text = self.ledger!.tableDetails!.gega
      }.catch{
        error in
        debugPrint("\(self.title?.description ?? "C8HMainMenuVC"):ledgerStore.save : \(error.localizedDescription)")
    }
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
  @IBAction func showPickerViewToSelectTables(_ sender: UITextField) {
    activeField?.resignFirstResponder()
    //    Get the rows from the repository.
    //    let tableStore = C8HTableRepository()
    let tableStore = C8HTableDetailStore()
    
    tableStore.findTables(forCasino: 0).done{ tableDetails in
      guard let tableDetails = tableDetails else { return }
      var rows : [String] = []
      for table in tableDetails{
        rows.append("Table: \(table.number)")
      }
      let action = ActionSheetStringPicker(
        title: "Select table", rows: rows, initialSelection: 0,
        doneBlock: {picker, indexes, value in
          if let text = value as? String{ sender.text = text }
          // Save the table the user selected.
          //self.tableDetails = tableDetails[indexes]
          self.table = tableDetails[indexes]
          // Set textfields text to tabledetails descriptions.
          //self.setTextForTextFieldsOnTableSelection()
          
          //Set other textfields to active.
          self.enableTextFieldsOnTableSelection()
          
          self.openTableButton.isEnabled = true
      }, cancel: {ActionStringCancelBlock in return}, origin: sender)
      
      action?.tapDismissAction = .cancel
      action?.show()
      }.catch{ error in
        print(error)
    }
  }
  
  /**
   Show Picker View for Games
   */
  @IBAction func showPickerViewForGames(_ sender: UITextField) {
    activeField?.resignFirstResponder()
    
    //    Get the rows from the repository.
    let gameStore = C8HGameStore()
    var rows = [String: Game]()
    for game in table!.games{
      rows[game.description] = game
    }
    
    gameStore.findGames(forCasino: 1).done{ gameDetails in
      //      var startingIndex = 0
      for game in gameDetails{
        if !rows.keys.contains(game.description){
          rows[game.description] = game
        }
      }
      
      let action = ActionSheetStringPicker(
        title: "Change Game", rows: [String](rows.keys), initialSelection: 1,
        doneBlock: {picker, indexes, value in
          //self.tableDetailsUpdated = true
          // Need to update the games on the table.
          //self.tableDetails?.game = gameDetails[indexes]
          if let text = value as? String{
            self.game = rows[text]
            self.setTextForTextFieldsOnTableSelection()
            
            sender.text = text
          }
          
          
          // if the table has that balance value we should set.
      }, cancel: {ActionStringCancelBlock in return}, origin: sender)
      
      action?.tapDismissAction = .cancel
      action?.show()
      }.catch{ error in
        debugPrint(error)
    }
  }
  
  // MARK: - Ledger Actions
  
  /**
   Update table by calling Table Store if necessary.
   
   Return a promise to update the table. So you can change them.
   */
  func updateTable(_ table: TableNew) -> PromiseKit.Promise<Int64>{
    return tableStore.save(table: table).map{ id in
      guard let id = id else { throw TableStoreError.UpdateTableError }
      return id
    }
  }
  
  func pushLedger(){
    // Call table store to push ledger.
    let alert = UIAlertController(style: UIAlertControllerStyle.alert,
                                  title: "End Balance",
                                  message: "Please enter end balance")
    
    let textField: TextField.Config = { textField in
      textField.left(image: #imageLiteral(resourceName: "pen"), color: .black)
      textField.leftViewPadding = 12
      textField.becomeFirstResponder()
      textField.borderWidth = 1
      textField.cornerRadius = 8
      textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
      textField.backgroundColor = nil
      textField.textColor = .black
      textField.placeholder = "Type something"
      textField.keyboardAppearance = .default
      textField.keyboardType = .default
      //textField.isSecureTextEntry = true
      textField.returnKeyType = .done
      textField.action { textField in
        Log("textField = \(String(describing: textField.text))")
        self.ledger?.endingBalance = Decimal(string: String(describing: textField.text))
      }
    }
    alert.addOneTextField(configuration: textField)
    alert.addAction(title: "OK", style: .default)
    alert.show()
    // FIXME -: Must send ending balance to server.
    
    ledgerStore.pushLedger(ledger: self.ledger!).done{ ledger in
      self.ledger = ledger 
      // should a call new view and send this ledger to it
      self.performSegue(withIdentifier: "toPresentLedger", sender: nil)
      }.catch{
        error in
        debugPrint("Push ledger error: \(error)")
    }
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? C8HNumberPadView{
      vc.ledger = ledger
      vc.delegate = self
    }else if let vc = segue.destination as? SignatureVC{
        vc.delegate = self
    }else if let vc = segue.destination as? ManagerSignatureViewController{
      vc.delegate = self
    }else if let vc = segue.destination as? PDFViewController{
      vc.ledger = self.ledger
    }else if let vc = segue.destination as? UISideMenuNavigationController{
      if let root = vc.topViewController as? C8HSideMenuTableViewController{
        root.delegate = self
      }
    }
  }
}

extension C8HMainMenuVC: C8HNumberPadDelegate{
  func updateLedger(with transaction: Transaction) {
//    guard let ledger = ledger else {
//      return
//    }
    // Append transaction to our ledger.
    let transactionStore = TransactionRepo()
    transactionStore.postTransaction(transaction: transaction).done{ updatedLedger in
      if let updatedLedger = updatedLedger {
        self.ledger = updatedLedger
      }
    }.catch{ error in
      debugPrint("C8HMainMenuVC: updateLedger: \(error)")
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
    if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
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

extension C8HMainMenuVC: SideMenuProtocol{
  func logout() {
    guard let accessToken = tokens?.accessToken else{return}
    OktaAuth.revoke(accessToken) { (response, error) in
      
      if error != nil {
        print("Error: \(error!)")
      }
      
      if let _ = response {
        print("Token was revoked")
        OktaAuth.clear()
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "C8HLoginVCNav") as! UINavigationController
        self.show(homeViewController, sender: nil);
      }
    }
  }
}

extension C8HMainMenuVC: SignatureVCDelegate, ManagerSignatureViewControllerDelegate{
  func saveEmployeeSignature(signatureImage: UIImage, isManager: Bool) {
    if let id = ledger?.id{
      ledgerStore.saveEmployeeSignature(image: signatureImage, ledgerId: id, isManager: false).done{ retValue in
        if retValue{
          self.performSegue(withIdentifier: "segueForManagerViewController", sender: nil)
        }
        }.catch{
          error in debugPrint(error)
      }
    }else{
      debugPrint("Unable to make call to save employee signature")
    }
  }
  
  func saveManagerSignature(signature: UIImage){
    guard let id = ledger?.id else{
      debugPrint("Unable to make call to save employee signature")
      return
    }
    ledgerStore.saveEmployeeSignature(image: signature, ledgerId: id, isManager: true).done{ retValue in
      if retValue{
        //self.performSegue(withIdentifier: "segueForManagerViewController", sender: nil)
        // should end the activity monitor here; should have started when push button is pressed.
        self.pushLedger()
        // next: continue the push process.
      }
      }.catch{
        error in debugPrint(error)
    }
  }
}
