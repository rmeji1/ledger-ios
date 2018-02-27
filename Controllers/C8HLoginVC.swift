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

class C8HLoginVC: UIViewController {
    var activeField: UITextField!
    var manager: C8HGeoRegionManager!
    var username = ""
    var password = ""
    
    // =========================================================================
    //MARK: Properties
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noAccountLabel: UILabel!
    weak var overlayView: UIView!
    weak var indicator: UIActivityIndicatorView!
    
    // =========================================================================
    // MARK: UIView overrides
   
    override func viewDidLoad() {
        super.viewDidLoad()
        enableKeyboardNotification()
        manager = C8HGeoRegionManager(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        retrieveCasinoList()
//        let repo = C8HCasinoRepository()
//        let casinos = repo.getAllCasinos()
//        print("Trying to print the casinos outside\(casinos)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObserveNoticationForKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // =========================================================================
    // Users enters wrong credintials 
    func loginFailure(){
        overlayView.removeFromSuperview()
        self.noticeError("Error!", autoClear: true, autoClearTime: 3)
        self.passwordTextField.text = "password"
        self.usernameTextField.text = "Username"
    }
    
    // =========================================================================
    // MARK: Actions
    @IBAction func oktaLogin(_ sender: UIButton){
        sender.isEnabled = false
        self.performSegue(withIdentifier: "conditionSegue", sender: nil)
//        OktaAuth
////            .login(username, password: password)
//            .login("rm@cre8ivehouse.com", password:"Youtube1996")
//            .start(self) {
//                response, error in
//                if error != nil {
//                    DispatchQueue.main.async {
//                        sender.isEnabled = true
//                        self.loginFailure()
//                    }
//                }
//                // Success
//                if let authResponse = response {
//                    OktaAuth.tokens?.set(value: authResponse.accessToken!, forKey: "accessToken")
//                    OktaAuth.tokens?.set(value: authResponse.idToken!, forKey: "idToken")
//                    DispatchQueue.main.async{
//                        self.performSegue(withIdentifier: "conditionSegue", sender: nil)
//                    }
//                }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? C8HSetGegaBalAndTableVC{
            manager.findInWhichRegion()
            print("Sucessful performaing segue.")
            vc.manager = manager
        }
    }
    
    func updateViewToCheckCredientialsOrGetLocation(_ message: String ){
        // Create view to add shadow
        let overlayView = UIView(frame: view.frame)
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.6
        overlayView.tag = 10
        // Create activity indicator
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicator.center = overlayView.center
        overlayView.addSubview(indicator)
        view.addSubview(overlayView)
        indicator.startAnimating()
    }
    
}


