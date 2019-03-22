//
//  LedgerPrintView.swift
//  ledge
//
//  Created by robert on 6/12/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

class LedgerPrintView: UIView {
    
  class func instanceFromNib() -> UIView {
    return UINib(nibName: "C8HLedgerPrintView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
  }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
