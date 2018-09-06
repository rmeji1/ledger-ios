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

// Want to have this only in the open table view controller
import ActionSheetPicker_3_0

import Kingfisher
import SideMenu

protocol OpenTableProtocol{
  var delegate : C8HMainMenuVC? {get set}
  func showPickerViewToSelectTables(_ sender: UITextField)
}

class C8HMainMenuVC: UIViewController {
  //============================================================================
  //  MARK: - Errors
  enum TokenError : Error{
    case TokenIsNotValid
  }
  
  //============================================================================
  // MARK: - Data memebers
  // var tableDetailsUpdated = false
  // var activeField: UITextField?
  var casinoStore = C8HCasinoRepository()
  var casino  : Casino?
  var preview = false
  
  var tableStore = C8HTableDetailStore()
  var employeeDetails: EmpDetails?
  var ledger: Ledger?
  var table: TableNew?
  var game : Game?
  
  var ledgerStore = C8HLedgerStore()
  var locationManager: CLLocationManager?
  
  @IBOutlet weak var activeLedgersView: UIView!
  //============================================================================
  //  MARK: - Properties
  @IBOutlet weak var addSubtractButton: UIButton!
  @IBOutlet weak var setTableParametersView: UIView!
  @IBOutlet weak var secondView: UIView!
  
  @IBOutlet weak var overlayView: UIView!
  @IBOutlet weak var statusBar: UIView!
  @IBOutlet weak var startLedgerButton: UIButton!
  //  @IBOutlet weak var openTableButton: UIButton!
  @IBOutlet weak var overlayForFirstStack: UIView!
  @IBOutlet weak var nameLabel:UILabel!
  @IBOutlet weak var employeeNumberLabel:UILabel!
  @IBOutlet weak var tableNumberLabel:UILabel!
  @IBOutlet weak var gegaNumberLabel:UILabel!
  
  @IBOutlet weak var createLedgerView: UIView!
  //@IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet var swipeDownGesture: UISwipeGestureRecognizer!
  
//  let manager = CoreLocation.CLLocationManager()
  //============================================================================
  //  MARK: - View Controller funcs
  override func viewDidLoad() {
    super.viewDidLoad()
    debugPrint("Accesstoken \(OktaAuth.tokens?.accessToken ?? "")")
    // Customize
    addLogo()
    makeNavigationBarTransparent()
    // FIXME -: THIS HAS TO BE ADDED TO OPEN TABLE.
    // addDoneButtonOnKeyboard()
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
    CLLocationManager.requestLocation(authorizationType: .always).lastValue.then{
      self.casinoStore.getAllCasinosAndFind(loc: $0.coordinate)
      }.done{ casino  in
        guard let casino  = casino  else{ throw C8HCasinoRepository.C8HCasinoRepository.casinoNotValid }
        self.casino  = casino

        let url = URL(string: casino .casinoImageURL)!
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
  
  func getAnamation() -> CATransition{
    let animation = CATransition()
    animation.type = kCATransitionPush
    animation.duration = 0.25
    return animation
  }
  
  func changeStartLedgerButton(){
    overlayForFirstStack.layer.add(getAnamation(), forKey: nil)
    overlayForFirstStack.isHidden = true
    
    statusBar.isHidden = false
    
    startLedgerButton.backgroundColor = UIColor(hexString: "00CC00")
    startLedgerButton.titleLabel?.font = UIFont(name: "LatoLatin-Bold", size: 16.0)
    startLedgerButton.setTitle("", for: .disabled) // Removes current text.
  }
  //==============================================================================
  //  MARK: - Customization helpers
  
  func updateMidBarView(){
    self.startLedgerButton.setTitle(self.ledger!.ledgerId!, for: .disabled )
    self.tableNumberLabel.text = String(format: "Table %02d" ,
                                        (self.ledger?.tableDetails!.number)!)
    self.gegaNumberLabel.text = self.ledger!.tableDetails!.gega
  }
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
    activeLedgersView.isHidden = true
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
  
  //  MARK: - View ACTIONS
  
  @IBAction func startLedgerButtonPressed(_ sender: UIButton) {
    sender.isEnabled = false
    dismissOverlayInThirdView();
  }
  
  @IBAction func swipeDownAction(_ sender: Any) {
    //activeField?.resignFirstResponder()
  }
  
  // MARK: - Ledger Actions
  func pushLedger(){
    // Call table store to push ledger.
    //FIXME: - fix this
    let alert = UIAlertController(style: UIAlertControllerStyle.alert,
                                  title: "End Balance",
                                  message: "Please enter end balance")
    
    let textField: TextField.Config = { textField in
      //textField.left(image: #imageLiteral(resourceName: "pen"), color: .black)
      textField.leftViewPadding = 12
      textField.becomeFirstResponder()
      textField.borderWidth = 1
      textField.cornerRadius = 8
      textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
      textField.backgroundColor = nil
      textField.textColor = .black
      textField.placeholder = "Balance"
      textField.keyboardAppearance = .default
      textField.keyboardType = .decimalPad
      //textField.isSecureTextEntry = true
      textField.returnKeyType = .done
      textField.action { textField in
        debugPrint("textField = \(String(describing: textField.text))")
        self.ledger?.endingBalance = Decimal(string: String(describing: textField.text))
        
      }
    }
    
    alert.addOneTextField(configuration: textField)
    alert.addAction(title: "OK", style: .default){ _ in
      self.ledgerStore.pushLedger(ledger: self.ledger!).done{ ledger in
        self.ledger = ledger
        // should a call new view and send this ledger to it
        self.performSegue(withIdentifier: "toPresentLedger", sender: nil)
        }.catch{
          error in
          debugPrint("Push ledger error: \(error)")
      }
    }
    alert.show()
  }
  
  func remove(child: UIViewController){
    createLedgerView.isHidden = true
    child.willMove(toParentViewController: nil)
    child.view.removeFromSuperview()
    child.removeFromParentViewController()
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
      vc.preview = preview
      preview = false 
    }else if let vc = segue.destination as? C8HOpenTableVCViewController{
      vc.delegate = self
      vc.ledgerStore = self.ledgerStore
      vc.tableStore = self.tableStore
    }else if let vc = segue.destination as? UISideMenuNavigationController{
      if let root = vc.topViewController as? ViewController{
        root.delegate = self
      }
    }else if let vc = segue.destination as? C8HMainMenuButtonsViewController{
      vc.delegate = self
    }else if let vc = segue.destination as? C8HLedgersOpenedTableViewController{
      //TODO: - Should be the casino id.
      vc.casinoId = 1
    }
  }
}

extension C8HMainMenuVC : C8HMainMenuButtonsProtocol{
  func performSegueForNumberPadView(){
    performSegue(withIdentifier: "numberPadViewSegue", sender: nil)
  }
  
  func moveToSignatureView(){
    self.performSegue(withIdentifier: "segueForSignatureView", sender: nil)
  }
}

extension C8HMainMenuVC: C8HNumberPadDelegate{
  func updateLedger(with transaction: Transaction) {
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

extension C8HMainMenuVC: SideMenuProtocol{
  func printPreview() {
    if let _ = self.ledger{
      preview = true
      self.performSegue(withIdentifier: "toPresentLedger", sender: nil)
    }else{
      self.errorNotice("No active ledger")
    }
  }
  
  func logout() {
    guard let accessToken = tokens?.accessToken else{return}
    OktaAuth.revoke(accessToken) { (response, error) in
      if error != nil { print("Error: \(error!)") }
      if let _ = response {
        print("Token was revoked")
        OktaAuth.clear()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
          appDelegate.showLogin()
        }
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
