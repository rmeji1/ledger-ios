////
////  C8HLoginValidator.swift
////  ledge
////
////  Created by robert on 1/15/18.
////  Copyright © 2018 com.cre8ivehouse. All rights reserved.
////
//
//import UIKit
//import OktaAuth.Swift
//
//protocol C8HLoginValidatorDelegate : class {
//    func successfulTokenRecievedChangeView()
//}
//
//class C8HLoginValidator: NSObject{
//    var username: String
//    var password: String
//    weak var delegate: C8HLoginValidatorDelegate?
//    
//    override init(){
//        username = ""
//        password = ""
//    }
//    
//    init(fromUsernameAndPassword username:String, password:String){
//        self.username = username
//        self.password = password
//    }
//    
////    initWithUsernameAndPassword( username: String, password: String ){
////        this.username = username
////        this.password = password
////    }
//    
//    
//    func login( username: String, password: String, viewController:UIViewController )->Bool{
//        var sucess: Bool = true
//        OktaAuth
//            .login(username, password: password)
////            .login()
//            .start(viewController) {
//                response, error in
//
//                if error != nil { print(error!); sucess = false }
//
//                // Success
//                if let authResponse = response {
//                    // authResponse.accessToken
//                    // authResponse.idToken
//                    self.delegate?.successfulTokenRecievedChangeView()
//                    print("Got a token\n \(String(describing: authResponse.accessToken))")
//                    
////                    OktaAuth.userinfo() {
////                        response, error in
////
////                        if error != nil { print("Error: \(error!)") }
////
////                        if let userinfo = response {
////                            userinfo.forEach { print("\($0): \($1)") }
////                        }
////                    }
//                }
//        }
//        return sucess
//    }
//}

