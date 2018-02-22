//
//  C8HTextField.swift
//  ledge
//
//  Created by robert on 1/26/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

class C8HTextField: UITextField {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.contentVerticalAlignment = UIControlContentVerticalAlignment.center
    }
}
