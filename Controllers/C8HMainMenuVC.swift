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

class C8HMainMenuVC: UIViewController, UITextFieldDelegate {
  
  enum TokenError : Error{
    case TokenIsNotValid
  }
  
  @IBOutlet weak var addSubtractButton: UIButton!
  @IBOutlet weak var setTableParametersView: UIView!
  @IBOutlet weak var overlayView: UIView!
  @IBOutlet weak var statusBar: UIView!
  @IBOutlet weak var startLedgerButton: UIButton!
  @IBOutlet weak var overlayForFirstStack: UIView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Customize
    addLogo()
    //setLeftButtonItem()
    //setRightButtonItem()
    makeNavigationBarTransparent()
    
    // Check Okta tokens
    //C8HOverlayViews.indicatorViewWithMessage("", for: view)
    //tokensOnOkta()
    //checkUserToken()
  }
//==============================================================================
//  MARK: - Customization helpers
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
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
// =============================================================================
// MARK: Actions
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
    
    
  }
  
  @IBAction func dismissOverlayview(_ sender: UIButton) {
    sender.isEnabled = false
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
  // =============================================================================
// MARK: Okta Helpers
  /**
   Introspect token to see if a token is valid.
   */
//  func introspectToken(token: String) -> Promise<Bool>{
//    return Promise{ seal in
//      OktaAuth
//        .introspect()
//        .validate(token) { response, error in
//          if error != nil {
//            seal.reject(error!)
//          }
//          if let isActive = response {
//            if isActive{
//              seal.fulfill(true)
//            }else {
//              seal.fulfill(false)
//            }
//            seal.reject(TokenError.TokenIsNotValid)
//            print("Is token valid? \(isActive)")
//          }else{
//            seal.reject(TokenError.TokenIsNotValid)
//          }
//      }
//    }
//  }
  /**
   Used to get tokens saved from a prior request.
   */
  func tokensOnOkta(){
//    OktaAuth.tokens = OktaTokenManager(authState: nil)
//    OktaAuth.tokens?.accessToken = OktaAuth.tokens?.get(forKey: "accessToken")
//    OktaAuth.tokens?.idToken = OktaAuth.tokens?.get(forKey: "idToken")
//    OktaAuth.tokens?.refreshToken = OktaAuth.tokens?.get(forKey: "refreshToken")
  }
  
  /**
   Check if the access token stored on file is still valid.
   */
  func checkUserToken(){
//    OktaAuth.configuration = Utils().getPlistConfiguration()
//    //        OktaAuth.tokens?.get(forKey: "accessToken")
//    if let token = OktaAuth.tokens?.accessToken{
//      firstly{
//        introspectToken(token: token)
//        }.done{ active in
//          if !active {
//            self.performSegue(withIdentifier: "conditionSegue", sender: nil)
//          }
//        }.catch{ error in
//          self.performSegue(withIdentifier: "conditionSegue", sender: nil)
//          debugPrint(error)
//        }.finally {
//          C8HOverlayViews.disableOverlayView(view: self.view)
//      }
//    }
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
