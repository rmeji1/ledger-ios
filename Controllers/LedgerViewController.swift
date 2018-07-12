//
//  LedgerViewController.swift
//  ledge
//
//  Created by robert on 6/11/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

class LedgerViewController: UIViewController {
  
  var ledger: Ledger?
  var image : UIImage?
  
  @IBOutlet weak var imageView: UIImageView!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    // Set up landscape mode
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    appDelegate.myOrientation = .landscape
//    let value = UIInterfaceOrientation.landscapeRight.rawValue
//    UIDevice.current.setValue(value, forKey: "orientation")
    
    imageView.image = image!
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
