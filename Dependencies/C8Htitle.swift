//
//  C8Htitle.swift
//  ledge
//
//  Created by robert on 4/12/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

class C8Htitle: UINavigationItem {
  private let fixedImage : UIImage = UIImage(named: "header-logo")!
  private let imageView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 24.151))
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    imageView.contentMode = .scaleAspectFit
    imageView.image = fixedImage
    self.titleView = imageView
    
  }
}
