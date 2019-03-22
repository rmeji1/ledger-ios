//
//  C8HAddCasinoTableView.swift
//  ledge
//
//  Created by robert on 9/6/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

class C8HTwoLabelModalView: UIView {

  /*
   Outlets
   */
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var gegaTextField: UITextField!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var navBar: UINavigationBar!
  
 /**
   Computed properties for easy access.
  */
  var name : String?{
    get { return nameTextField.text }
    set { nameTextField.text = newValue }
  }
  
  var gega : String?{
    get { return gegaTextField.text }
    set { gegaTextField.text = newValue }
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    initSubviews()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initSubviews()
  }
  
  func initSubviews() {
    // standard initialization logic
    let nib = UINib(nibName: "C8HAddCasinoGameView", bundle: nil)
    nib.instantiate(withOwner: self, options: nil)
    contentView.frame = bounds
    addSubview(contentView)
    
      // custom initialization logic
    let bottomBorder = CALayer()
    bottomBorder.frame = CGRect(x: 0.0, y: nameTextField.frame.size.height, width: nameTextField.frame.size.width, height: 1.0)
    bottomBorder.backgroundColor = UIColor(white: 0.8, alpha: 1.0).cgColor
    gegaTextField.layer.addSublayer(bottomBorder)
    
    setLeftPadding(for: nameTextField)
    setLeftPadding(for: gegaTextField)
  }

  func roundCorners(by radius: Int){
    layer.cornerRadius = 10
    layer.masksToBounds = true
  }
  
  private func setLeftPadding(for textField: UITextField){
    let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
    textField.leftView = paddingView
    textField.leftViewMode = .always
  }
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
}
