//
//  C8HPushCloseOrTransactionVC.swift
//  ledge
//
//  Created by robert on 3/8/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

class C8HPushCloseOrTransactionVC: UIViewController {
  var casino : C8HCasino?
  var table : C8HTable?
  var tables : [C8HTable]?
  
  @IBOutlet weak var plusOrMinusButton: UIButton!
  
  @IBOutlet weak var pushButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 24.151))
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 24.151))
    imageView.contentMode = .scaleAspectFit
    let image = UIImage(named: "header-logo")
    imageView.image = image
    logoContainer.addSubview(imageView)
    navigationItem.titleView = logoContainer
    
    plusOrMinusButton.addBorder(toSide: .Bottom, withColor: UIColor.white.withAlphaComponent(0.10).cgColor, andThickness: 1.0)
    pushButton.addBorder(toSide: .Top, withColor: UIColor.white.withAlphaComponent(0.10).cgColor, andThickness: 1.0)
    
    
    self.navigationItem.setHidesBackButton(true, animated:true);
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  //    if let dnc = segue.destination as? UINavigationController{
  //        if let vc = dnc.topViewController as? C8HPushCloseOrTransactionVC{
  //            debugPrint("Sucessful segue to PushCloseOrTransactionVC segue.")
  //            guard
  //                let table = table,
  //                let casino = casino,
  //                var tables = tables,
  //                let tableIndex = tableIndex
  //                else{
  //                    return
  //            }
  //            vc.table = table
  //            vc.casino = casino
  //            tables.remove(at: tableIndex)
  //            vc.tables = tables
  //        }
  //
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if let vc = segue.destination as? C8HNumberPadView{
      debugPrint("Sucessful segue to PushCloseOrTransactionVC segue.")
      vc.tables = tables
      vc.casino = casino
      vc.table = table
    }
  }
}

