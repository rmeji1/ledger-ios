//
//  C8HNumberPadView.swift
//  ledge
//
//  Created by robert on 2/2/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit
protocol C8HNumberPadDelegate : class {
    func updateTable(_ data: [String: String])
}


class C8HNumberPadView: UIViewController {
    weak var delegate: C8HNumberPadDelegate?

//  MARK - PROPERTIES
    @IBOutlet weak var numberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberLabel.text = "$0" ;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK - ACTIONS
    
    @IBAction func dismissPlusVC(_ sender: Any) {
        delegate?.updateTable(["title" : numberLabel.text! , "type":"+"])
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissMinusVC(_ sender: Any) {
        delegate?.updateTable(["title" : numberLabel.text! , "type":"-"])
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func numberOnePressed(_ sender: UIButton) {
        guard let text = numberLabel.text, let buttonText = sender.titleLabel?.text else{
            return
        }
        if text == "$0" {
            numberLabel.text = "$" + buttonText
        } else {
            numberLabel.text = text + buttonText
        }
    }
    
    @IBAction func backSpacePressed(_ sender: Any) {
        guard let text = numberLabel.text else{
            return
        }
        if (sender as! UIButton).titleLabel != nil {
            if text != "$"{
                numberLabel.text?.remove(at: text.index(before: text.endIndex))
                if numberLabel.text == "$"{
                    numberLabel.text = "$0"
                }
            }
        }
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
