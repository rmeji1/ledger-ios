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
    
    enum TokenError : Error{
        case TokenIsNotValid
    }
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
        tokensOnOkta()
        checkUserToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
    
    // =========================================================================
    // Users enters wrong credintials 
    func loginFailure(){
        self.noticeError("Error!", autoClear: true, autoClearTime: 3)
        self.usernameTextField.text = "Username"
        self.passwordTextField.text = "Password"
    }
    
    // =========================================================================
    // MARK: Actions
    @IBAction func oktaLogin(_ sender: UIButton){
        sender.isEnabled = false
        if  activeField != nil{
            activeField?.resignFirstResponder()
        }
//        self.performSegue(withIdentifier: "conditionSegue", sender: nil)
        OktaAuth
            .login(username, password: password)
//            .login("rm@cre8ivehouse.com", password:"Youtube1996")
            .start(self) {
                response, error in
                if error != nil {
                    DispatchQueue.main.async {
                        sender.isEnabled = true
                        self.loginFailure()
                    }
                }
                // Success
                if let authResponse = response {
                    OktaAuth.tokens?.set(value: authResponse.accessToken!, forKey: "accessToken")
                    OktaAuth.tokens?.set(value: authResponse.idToken!, forKey: "idToken")
                    OktaAuth.tokens?.set(value: authResponse.refreshToken!, forKey: "refreshToken")
                    DispatchQueue.main.async{
                        self.performSegue(withIdentifier: "conditionSegue", sender: nil)
                    }
             }
        }
    }
    
    func introspectToken(token: String) -> Promise<Bool>{
        return Promise{ seal in
            OktaAuth
                .introspect()
                .validate(token) { response, error in
                    if error != nil {
                        seal.reject(error!)
                    }
                    if let isActive = response {
                        if isActive{
                            seal.fulfill(true)
                        }
                        seal.reject(TokenError.TokenIsNotValid)
                        print("Is token valid? \(isActive)")
                    }else{
                        seal.reject(TokenError.TokenIsNotValid)
                    }
            }
        }
    }
//    
//    func updateViewToCheckCredientialsOrGetLocation(_ message: String ){
//        // Create view to add shadow
//        let overlayView = UIView(frame: view.frame)
//        overlayView.backgroundColor = UIColor.black
//        overlayView.alpha = 0.6
//        overlayView.tag = 10
//        // Create activity indicator
//        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
//        indicator.center = overlayView.center
//        overlayView.addSubview(indicator)
//        view.addSubview(overlayView)
//        indicator.startAnimating()
//    }
    
    func tokensOnOkta(){
        OktaAuth.tokens = OktaTokenManager(authState: nil)
        OktaAuth.tokens?.accessToken = OktaAuth.tokens?.get(forKey: "accessToken")
        OktaAuth.tokens?.idToken = OktaAuth.tokens?.get(forKey: "idToken")
        OktaAuth.tokens?.refreshToken = OktaAuth.tokens?.get(forKey: "refreshToken")
    }
    
    func checkUserToken(){
        OktaAuth.configuration = Utils().getPlistConfiguration()
        //        OktaAuth.tokens?.get(forKey: "accessToken")
        if let token = OktaAuth.tokens?.accessToken{
            firstly{
                introspectToken(token: token)
                }.done{ _ in
                    DispatchQueue.main.async{
                        self.performSegue(withIdentifier: "conditionSegue", sender: nil)
                    }
                }.catch{ error in
                    debugPrint(error)
            }
        }
    }
}


