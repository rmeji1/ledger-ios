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
        guard let overlayView = self.view.viewWithTag(10) else {
            return
        }
        overlayView.removeFromSuperview()
        self.noticeError("Error!", autoClear: true, autoClearTime: 3)
        self.passwordTextField.text = ""
        self.usernameTextField.text = ""
        self.textFieldDidEndEditing(self.usernameTextField)
        self.textFieldDidEndEditing(self.passwordTextField)
    }
    
    // =========================================================================
    // MARK: Actions
    @IBAction func oktaLogin(_ sender: Any){
//        updateViewToCheckCredientialsOrGetLocation( "" )
        OktaAuth
            .login(username, password: password)
            .start(self) {
                response, error in
                if error != nil {
                    DispatchQueue.main.async {
                        self.loginFailure()
                    }
                }
                // Success
                if let authResponse = response {
                    OktaAuth.tokens?.set(value: authResponse.accessToken!, forKey: "accessToken")
                    OktaAuth.tokens?.set(value: authResponse.idToken!, forKey: "idToken")
                    DispatchQueue.main.async{
                        self.performSegue(withIdentifier: "conditionSegue", sender: nil)
                    }
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? C8HSetGegaBalAndTableVC{
            print("Sucessful performaing segue.")
            vc.manager = manager
            
        }
        //        let navVC = segue.destination as? UINavigationController
        //        if let vc = navVC?.viewControllers.first as? C8HSetGegaBalAndTableVC
        //        {
        //            print("Sucessful performaing segue.")
        //            vc.manager = manager
        //        }
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


