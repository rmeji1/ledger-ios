//
//  extUiView.swift
//  ledge
//
//  Created by robert on 1/17/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
      let renderer = UIGraphicsImageRenderer(bounds: bounds)
      return renderer.image { rendererContext in
        layer.render(in: rendererContext.cgContext)
      }
    }
  
  // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
  
  enum ViewSide {
    case Left, Right, Top, Bottom
  }
  
  func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
    
    let border = CALayer()
    border.backgroundColor = color
    
    switch side {
    case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
    case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
    case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
    case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
    }
    
    layer.addSublayer(border)
  }
  
  //    @IBInspectable var cornerRadius: CGFloat {
  //        get {
  //            return layer.cornerRadius
  //        }
  //        set {
  //            layer.cornerRadius = newValue
  //            layer.masksToBounds = newValue > 0
  //        }
  //    }
  //
  //    @IBInspectable var borderWidth: CGFloat {
  //        get {
  //            return layer.borderWidth
  //        }
  //        set {
  //            layer.borderWidth = newValue
  //        }
  //    }
  //
  //    @IBInspectable var borderColor: UIColor? {
  //        get {
  //            return UIColor(cgColor: layer.borderColor!)
  //        }
  //        set {
  //            layer.borderColor = newValue?.cgColor
  //        }
  //    }
}
