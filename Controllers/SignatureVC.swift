//
//  SignatureVC.swift
//  ledge
//
//  Created by robert on 6/6/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

protocol SignatureVCDelegate: class {
  func saveEmployeeSignature(signatureImage: UIImage, isManager: Bool)
}

class SignatureVC: UIViewController, SignatureDrawingViewControllerDelegate {
  // MARK: Delegate
  weak var delegate : SignatureVCDelegate?
  
  // MARK: UIViewController
//  @Override
  @IBOutlet weak var secondaryView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Setting signature view
    signatureViewController.delegate = self
    secondaryView.addSubview(signatureViewController.view)
    signatureViewController.didMove(toParent: self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    
    // Nav bar configuration
    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    navigationController?.navigationBar.titleTextAttributes = textAttributes
    navigationController?.navigationBar.tintColor = UIColor.white
    navigationController?.navigationBar.backgroundColor = UIColor(hex: 0x93278F)
    navigationItem.title = "Employee Signature"
    navigationItem.backBarButtonItem?.setTitleTextAttributes(textAttributes, for: .normal)
    
    // Force landscape mode
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.myOrientation = .landscape
    let value = UIInterfaceOrientation.landscapeRight.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    if isMovingFromParent {
      // Force portrait mode
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.myOrientation = .portrait
      let value = UIInterfaceOrientation.portrait.rawValue
      UIDevice.current.setValue(value, forKey: "orientation")
      
      navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Action
  
  // FIXME: - Need to add this action
  /**
   When apply is pressed, save image then return to view that called this one.
   That view then opens new segue to same view as this calls but with  different controller.
   
   That view will be for the a manager signature.
   */
  
  @IBAction func submitSignature(_ sender: UIButton){
    guard let delegate = delegate,
          let signature = signatureViewController.fullSignatureImage else {return}
//    // Force portrait mode
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    appDelegate.myOrientation = .portrait
//
//    let value = UIInterfaceOrientation.portrait.rawValue
//    UIDevice.current.setValue(value, forKey: "orientation")
//    navigationController?.navigationBar.backgroundColor = UIColor.clear

    delegate.saveEmployeeSignature(signatureImage: signature, isManager: false)
    navigationController?.popViewController(animated: true)
    //    self.performSegue(withIdentifier: "segueForManagerViewController", sender: nil)
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  // MARK: SignatureDrawingViewControllerDelegate
  func signatureDrawingViewControllerIsEmptyDidChange(controller: SignatureDrawingViewController, isEmpty: Bool) {
    //resetButton.isHidden = isEmpty
  }
  
  @IBAction func reset(_ sender: Any) {
    signatureViewController.reset()
  }
  
  // MARK: Private
  
 private let signatureViewController = SignatureDrawingViewController()
 
  
}
