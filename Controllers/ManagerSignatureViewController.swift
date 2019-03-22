//
//  ManagerSignatureViewController.swift
//  ledge
//
//  Created by robert on 6/8/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

protocol ManagerSignatureViewControllerDelegate: class {
  func saveManagerSignature(signature: UIImage)
}
class ManagerSignatureViewController: UIViewController, SignatureDrawingViewControllerDelegate {
  
  @IBOutlet weak var secondaryView: UIView!
  weak var delegate : ManagerSignatureViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    signatureViewController.delegate = self
    secondaryView.addSubview(signatureViewController.view)
    signatureViewController.didMove(toParent: self)
    
    // Force landscape mode
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.myOrientation = .landscape
    let value = UIInterfaceOrientation.landscapeRight.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")

    navigationController?.navigationBar.backgroundColor = UIColor(hex: 0x93278F)
    navigationItem.title = "Manager Signature"
    navigationItem.hidesBackButton = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    // Force portrait mode
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.myOrientation = .portrait
    
    let value = UIInterfaceOrientation.portrait.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
    
    // Remove color added to navigation bar.
    navigationController?.navigationBar.backgroundColor = UIColor.clear
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
//
    delegate.saveManagerSignature(signature: signature)
    navigationController?.popViewController(animated: true)
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
