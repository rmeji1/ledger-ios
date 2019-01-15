//
//  ViewController.swift
//  
//
//  Created by robert on 7/17/18.
//

import UIKit

class C8HSideMenuParent: UIViewController {
  var delegate : SideMenuProtocol?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let vc = segue.destination as? C8HSideMenuTableViewController{
        vc.delegate = delegate
      }
    }
  

}
