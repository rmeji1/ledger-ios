//
//  C8HLoginVC.swift
//  ledge
//
//  Created by robert on 1/8/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit
import Foundation
import OktaAuth
import PromiseKit

class C8HLoginVC: UIViewController {
  var activeField: UITextField?
  var manager: C8HGeoRegionManager!
  var username = ""
  var password = ""
  
// =============================================================================
// MARK: Properties
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var innerView: UIView!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var noAccountLabel: UILabel!
  
// =============================================================================
//  MARK: Data members
  weak var overlayView: UIView!
  weak var indicator: UIActivityIndicatorView!
  
//==============================================================================
// MARK: View methods
  /**
   Add ledgers logos to header.
   */
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 24.151))
//    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 24.151))
//    imageView.contentMode = .scaleAspectFit
//
//    let image = UIImage(named: "header-logo")
//    imageView.image = image
//    logoContainer.addSubview(imageView)
//    navigationItem.titleView = logoContainer
    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.view.backgroundColor = UIColor.clear
  }
  
  func makeNavigationBarTransparent(){
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
//    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = UIColor.clear
    //self.navigationController?.navigationBar.tintColor = UIColor.white;
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    //self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = UIColor.clear
    //self.navigationController?.navigationBar.tintColor = UIColor.white;
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let vc = segue.destination as? C8HSetGegaBalAndTableVC{
      //manager.findInWhichRegion()
      print("Sucessful performaing segue.")
      vc.manager = manager
    }
  }
  
// =============================================================================
// MARK: HELPERS
  /**
   This method is called when the user enters the wrong method credientals.
   */
  func loginFailure(text: String){
    self.noticeError(text, autoClear: true, autoClearTime: 3)
    self.usernameTextField.text = "Username"
    self.passwordTextField.text = "Password"
  }
  
// =============================================================================
// MARK: Actions
  /**
   This called when user press login. OktaAuth is used to log in into Okta.
   */
  @IBAction func oktaLogin(_ sender: UIButton){
    
    // Check if user entered login information
    guard
      let username = usernameTextField.text,
      let password = passwordTextField.text else{
        loginFailure(text: "Enter login credentials")
        return
    }
    
    OktaAuth.login("rm@cre8ivehouse.com", password: "Youtube1996").start(withPListConfig: "okta3", view: self).then{ tokenManager in
      debugPrint(tokenManager)
//      OktaAuth.getUser{ response, error in
//        if error != nil { print("Error: \(error!)") }
//        if response != nil {
//          var userInfoText = ""
//          response?.forEach { userInfoText += ("\($0): \($1) \n") }
//          debugPrint(userInfoText)
//          //self.updateUI(updateText: userInfoText)
//        }
//      //self.performSegue(withIdentifier: "conditionSegue", sender: nil)
//      }
      }.catch{
        error in
        debugPrint(error)
    }
  }
}


