//
//
//  ledge
//
//  Created by robert on 1/23/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit
import CoreLocation
import PromiseKit

class C8HSetGegaBalAndTableVC: UIViewController{
    private var defaultText = ["gega":"GEGA",
                               "gameTableNumber":"Game/Table Number",
                               "beginningBalance":"Beginning Balance"]

    let pickerOptions = ["Black Jack", "Craps", "Roulette"]
    var tables : [C8HTable]? = []
    var activeField: UITextField!
    var pickerView = UIPickerView()
    var tablesPickerView = UIPickerView()
    var manager: C8HGeoRegionManager?
    
    var table : C8HTable?
    var tableIndex : Int?
    var casino : C8HCasino?
    
    // MARK: - Properties
    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var selectTableTextField: C8HTextField!
    
    @IBOutlet weak var gameAndTableNumberTextField: C8HTextField!
    @IBOutlet weak var beginningBalanceTextField: C8HTextField!
  
  // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
      //self.navigationItem.setHidesBackButton(true, animated: false)
      let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 24.151))
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 24.151))
      imageView.contentMode = .scaleAspectFit
      let image = UIImage(named: "header-logo")
      imageView.image = image
      logoContainer.addSubview(imageView)
      navigationItem.titleView = logoContainer
      
      self.navigationItem.setHidesBackButton(true, animated:true);
      
        pickerView.delegate = self
        pickerView.dataSource = self
        selectTableTextField.inputView = pickerView
        selectTableTextField.accessibilityIdentifier = "TableTextField"
        enableOverlayView("Loading")
        let casinoRepo = C8HCasinoRepository()
        let tableRepo = C8HTableRepository()
        // Load tables.
        CLLocationManager.requestLocation().lastValue
            .then{ location in
                casinoRepo.findInWhichCasino(loc: location)
            }.done{ casino in
                self.casino = casino
                //self.welcomeLabel.text = casino.identifer
                tableRepo.findTablesWithCasinoId(casinoId: casino.id).done{ tables in
                    self.tables?.append(contentsOf: tables)
                    self.disableOverlayView();
                    }.catch{error in
                        debugPrint(error)
                }
            }.catch{error in
                if (error as! C8HCasinoError) == C8HCasinoError.errorFromCD  {
                    DispatchQueue.main.async { self.showAlert() }
                }
            }.finally { self.disableOverlayView() }
    }
    
    func viewWillReturnFromCreateCasino(_ casino: C8HCasino){
        self.casino = casino
        //welcomeLabel.text = casino.identifer
    }
    
    func showAlert(){
        let title = "Oops"
        let message = "Can't find casino your located in."
        let alert = UIAlertController(style: .actionSheet, title: title , message: message)
        
        // Enter casino info should present addNewCasinoSegue
        alert.addAction(title: "Enter casino info", style: .default){ action in
            self.performSegue(withIdentifier: "addNewCasinoSegue", sender: nil)
        }
        alert.addAction(title: "Cancel", style: .destructive)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool){
        addObserveNotificationForKeyboard()
    }
    
    override func viewDidDisappear(_ animated: Bool){
        removeObserveNoticationForKeyboard()
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
    func disableOverlayView(){
        view.viewWithTag(10)?.clearAllNotice()
        view.viewWithTag(10)?.removeFromSuperview()
    }
  
  @IBAction func startLedger(_ sender: UIButton) {
//    guard
//      let casinoName = casino?.identifer,
//      let gega = table?.gega,
//      let tableNumber = table?.tableNumber,
//      let gameDesc = table?.gameDesc,
//      let begBal = table?.podium
////      let endBal = table?
//      else {
//      return
//    }
//    // Add spinning wheel to view and overlay.
//    // I want to create  the ledger and send it to server.
//    // on sucess return from server perfor condtiitonal segue way
//    var ledger = Ledger()
//    ledger.casinoDetails = CasinoDetails(casinoName: casinoName)
//    ledger.tableDetails = TableDetails(gega: gega, gameTable: "\(tableNumber)/\(gameDesc)", beginningBalance:begBal as Decimal)
//
////    ledger.tableDetails = [
////      "gega" : gega,
////      "gameTable" : "\(tableNumber)/\(gameDesc)",
////      "beginningBalance" : "\(begBal)",
////    ]
//    // FIXME: - NEED TO CHANGE THIS, should get the emp name + from other source
//    // Save in userdefaults if you want when the user signs in.
//    ledger.empDetails = EmpDetails(badgeNumber: "1234", name: "Roberto Mejia")
//
//    let ledgerRepo = C8HLedgerRepository()
//
//    ledgerRepo.createLedger(ledger: ledger)?.done{_ in
//      self.performSegue(withIdentifier: "showNavControllerSegue", sender: nil)
//    }
    self.performSegue(withIdentifier: "showNavControllerSegue", sender: nil)

  }
  
  
  
  
//  MARK: - Navigation
    // This has error if user can't select a table or updates it.......
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        dnc = destinationViewController
//        if let dnc = segue.destination as? UINavigationController{
//            if let vc = dnc.topViewController as? C8HPushCloseOrTransactionVC{
//                debugPrint("Sucessful segue to PushCloseOrTransactionVC segue.")
//                guard
//                    let table = table,
//                    let casino = casino,
//                    var tables = tables,
//                    let tableIndex = tableIndex
//                else{
//                    return
//                }
//                vc.table = table
//                vc.casino = casino
//                tables.remove(at: tableIndex)
//                vc.tables = tables
//            }
      //  }
    }
}
//==============================================================================
// MARK - EXTENSIONS
//==============================================================================
extension C8HSetGegaBalAndTableVC: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeField.accessibilityIdentifier == "TableTextField"{
            guard let tables = tables else{ return 0 }
            return tables.count + 1
        }
        return pickerOptions.count + 1
    }
}

extension C8HSetGegaBalAndTableVC: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var text = " "
        if row != 0{
            guard let tables = tables else{ return "" }
            if activeField.accessibilityIdentifier == "TableTextField"{
                text =  "Table \(tables[row - 1].tableNumber)"
                table = tables[row - 1]
                tableIndex = row - 1
            }
            else {
                 text =  pickerOptions[row - 1]
            }
        }
        return text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activeField.accessibilityIdentifier == "TableTextField"{
            if self.textFieldShouldReturn(activeField){
                guard let tables = tables else{ return  }

                if row == 0{
                    selectTableTextField.text = "Select Table"
                }
                else{
//                    String(format: "Tip Amount: $%.02f", tipAmount)
                    guard
                        let gameDesc = tables[row-1].gameDesc,
                        let balance = tables[row-1].podium,
                        let gegaText = tables[row-1].gega
                    else {
                        debugPrint("Error with tables variable in C8HSetGega...")
                        return
                    }
                    
                    let formatter = NumberFormatter()
                    formatter.locale = Locale.current
                    formatter.numberStyle = .currency
                    if let formattedTipAmount = formatter.string(from: balance as NSNumber) {
                        beginningBalanceTextField.text = "Balance: \(formattedTipAmount)"
                    }
                    
                    selectTableTextField.text = "Table \(tables[row-1].tableNumber)"
                    gameAndTableNumberTextField.text = gameDesc
                    pickerTextField.text = gegaText
                }
            }
        }else{
            if self.textFieldShouldReturn(pickerTextField){
                 if row == 0{
                    pickerTextField.text = "GEGA"
                 }else{
                    pickerTextField.text = pickerOptions[row-1]

                }
            }
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
        }    }

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
        textField.resignFirstResponder()
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


