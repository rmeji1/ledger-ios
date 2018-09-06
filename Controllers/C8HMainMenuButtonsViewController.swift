//
//  C8HMainMenuButtonsViewController.swift
//  ledge
//
//  Created by robert on 7/17/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

protocol C8HMainMenuButtonsProtocol{
  func performSegueForNumberPadView()
  func moveToSignatureView()
}
class C8HMainMenuButtonsViewController: UIViewController {
  var delegate : C8HMainMenuButtonsProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func pushLedger(_ sender: UIButton) {
    guard let delegate = self.delegate else {return}
    delegate.moveToSignatureView()
  }
  
  @IBAction func goToNumberPadView(_ sender: UIButton) {
    guard let delegate = self.delegate else {return}
    delegate.performSegueForNumberPadView()
  }
  @IBAction func numberPadButtonPressed(_ sender: UIButton){
    
  }
  
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
 
  
}
