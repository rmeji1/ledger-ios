//
//  C8HOpenTableVCViewController.swift
//  ledge
//
//  Created by robert on 7/13/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit
import PromiseKit
import ActionSheetPicker_3_0

class C8HOpenTableVCViewController: UIViewController, OpenTableProtocol {
  var delegate: C8HMainMenuVC?
  var activeField : UITextField?
  var ledger: Ledger?
  var ledgerStore : C8HLedgerStore?
  var employeeDetails: EmpDetails?
  var tableStore : C8HTableDetailStore?
  var beginningBalance : Decimal?
  
  var table: TableNew?
  var game : Game?
  
  @IBOutlet weak var selectTableTextField: C8HTextField!
  @IBOutlet weak var selectGameTextField: C8HTextField!
  @IBOutlet weak var selectGegaTextField: C8HTextField!
  @IBOutlet weak var balanceTextField: C8HTextField!
  @IBOutlet weak var openTableButton : UIButton!
  /**
   Setting PickerView for select table.
   */
  @IBAction func showPickerViewToSelectTables(_ sender: UITextField) {
    //guard let delegate = delegate else {return}
    sender.isEnabled = false
    
    //C8HOverlayViews.indicatorViewWithMessage("", for: self.view, with: UIColor.purple, and: 0.5)
    activeField?.resignFirstResponder()
    tableStore!.findAllBy(casinoId: 0).done{ tableDetails in
      C8HOverlayViews.disableOverlayView(for: self.view)
      sender.isEnabled = true
      guard let tableDetails = tableDetails else { return }
      var rows : [String] = []
      for table in tableDetails{
        rows.append("Table: \(table.number)")
      }
      let action = ActionSheetStringPicker(
        title: "Select table", rows: rows, initialSelection: 0,
        doneBlock: {picker, indexes, value in
          if let text = value as? String{ sender.text = text }
          self.table = tableDetails[indexes]
          
          // have to get these methods from the main menu
          
          // good that all these are being put together here.
          self.enableTextFieldsOnTableSelection()
          self.openTableButton.isEnabled = true
      }, cancel: {ActionStringCancelBlock in return}, origin: sender)
      
      action?.tapDismissAction = .cancel
      action?.show()
      }.catch{ error in
        sender.isEnabled = true
        // fixme:- display proper error to user.
        print(error)
    }
  }
  
  func enableTextFieldsOnTableSelection(){
    self.selectGameTextField.isEnabled = true
    self.selectGegaTextField.isEnabled = true
    self.balanceTextField.isEnabled = true
    
    self.selectGameTextField.text = ""
    self.selectGegaTextField.text = ""
    self.balanceTextField.text = ""
  }
  
  func setTextForTextFieldsOnTableSelection(){
    guard let game = game,
      let table = table else {
        debugPrint("C8HMainMenu.setTextForTextFieldsOnTableSelection() -- Game not set.")
        return
    }
    self.selectGegaTextField.text = game.gega
    self.selectGameTextField.text = game.description
  
    if table.balances.keys.contains("game:\(String(describing: game.id))"){
      self.beginningBalance = Decimal(string: (table.balances["game:\(game.id)"]?.description)!)
      self.balanceTextField.text = "Beg Bal: \((table.balances["game:\(game.id)"]?.description)!)"
    }else{
      self.beginningBalance = Decimal(0)
      self.balanceTextField.text = "Beg Bal: 0"
    }
  }
  
  func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
    
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
    
        doneToolbar.items = items
        doneToolbar.sizeToFit()
    
        self.balanceTextField.inputAccessoryView = doneToolbar
  }
  
  /**
   Check the textfields and open the table.
   Should also start the ledger.
   Need to call the server in order to get ledger id and
   store the ledger in the database.
   */
  @IBAction func openTable(_ sender: UIButton) {
    self.view.layer.add(delegate!.getAnamation(), forKey:nil)
//    self.view.isHidden = true
    delegate!.changeStartLedgerButton()
    // Check if we need to update the table information
    guard var table = table,
      let game = game else{ return }
    
    let hasGame = table.games.contains{ element in
      if case game.id = element.id{ return true } else{ return false }
    }
    var update = false
    // If we have the game check to see if we have a different balance then set by the user
    if hasGame {
      if !(table.balances["game:\(game.id)"] == beginningBalance){
        table.balances["game:\(game.id)"] = beginningBalance
        update = true
      }
    }else{
      table.balances["game:\(game.id)"] = beginningBalance
      table.activeGames = table.activeGames + 1
      update = true
    }
    
    if update {
      updateTable(table).done{ id in table.id = id }.catch{ error in }
    }
    
    let tableDetails = TableDetails(gega: game.gega.description, game: game.description, id: table.id, number: Int64(table.number))
    // create ledger
    
    // FIXME: This needs to be fixed. Problem is i am creating a new casion details and I dont need that.
    let casinoDetails = CasinoDetails(casinoCode: "FH", casinoName: "Flex Casino")
    self.ledger = Ledger(casinoDetails: casinoDetails, empDetails: delegate!.employeeDetails! ,tableDetails: tableDetails, active: true, transactions: nil, beginningBalance: table.balances["game:\(game.id)"]!)

    //save ledger
    ledgerStore!.save(ledger: ledger!).done{ id in
      self.ledger?.id = id
      self.ledger?.ledgerId = String(format: "\(self.ledger?.casinoDetails.casinoCode ?? "LC")%05d", id)

      self.delegate?.ledger = self.ledger
      self.delegate?.table = self.table
      self.delegate?.game = self.game

      self.delegate?.updateMidBarView() ; // ambivlance
      // remove the view from the super view
      self.delegate?.remove(child: self)
//      self.willMove(toParentViewController: nil)
//      self.view.removeFromSuperview()
//      self.removeFromParentViewController()
      }.catch{
        error in
        debugPrint("\(self.title?.description ?? "C8HMainMenuVC"):ledgerStore.save : \(error.localizedDescription)")
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
  
  @objc func doneButtonAction() {
    self.balanceTextField.resignFirstResponder()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    addDoneButtonOnKeyboard()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  /**
   Update table by calling Table Store if necessary.
   
   Return a promise to update the table. So you can change them.
   */
  func updateTable(_ table: TableNew) -> PromiseKit.Promise<Int64>{
    return tableStore!.save(table).map{ id in
      guard let id = id else { throw DataStoreProtocolError.unableToSave }
      return Int64(id)
    }
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

extension C8HOpenTableVCViewController: UITextFieldDelegate{
  func enableKeyboardNotification(){
    let notificationCenter = NotificationCenter.default
    let keyboardWillShow = UIResponder.keyboardWillShowNotification
    let keyboardWillHide = UIResponder.keyboardWillHideNotification
    
    notificationCenter.addObserver(self, selector: #selector(self.keyboardWasShown), name: keyboardWillShow, object: nil)
    notificationCenter.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: keyboardWillHide, object: nil)
    
  }
  
  func removeObserveNoticationForKeyboard(){
    let notificationCenter = NotificationCenter.default
    let keyboardWillShow = UIResponder.keyboardWillShowNotification
    let keyboardWillHide = UIResponder.keyboardWillHideNotification
    
    notificationCenter.removeObserver(self, name: keyboardWillShow, object: nil)
    notificationCenter.removeObserver(self, name: keyboardWillHide, object: nil)
  }
  
  @objc
  func keyboardWasShown(_ notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      if self.view.frame.origin.y == 0{
        self.view.frame.origin.y -= keyboardSize.height
      }
    }
  }
  
  @objc
  func keyboardWillBeHidden(_ notification: Notification){
    if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
      if self.view.frame.origin.y != 0{
        //        self.view.frame.origin.y += keyboardSize.height
        self.view.frame.origin.y = 0
      }
    }
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.activeField = textField
    //self.swipeDownGesture.isEnabled = true
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
    if textField == balanceTextField {
      if let dec = Decimal(string: balanceTextField.text!){
        beginningBalance = dec
        textField.text = "Beg Bal: \(textField.text!)"
      }
    }
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField){
    removeObserveNoticationForKeyboard()
    //self.swipeDownGesture.isEnabled = false
    self.activeField = nil
  }
}
