//
//  C8HOverlayViews.swift
//  ledge
//
//  Created by robert on 3/27/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation
import UIKit

class C8HOverlayViews{
    class func indicatorViewWithMessage(_ message: String,for view: UIView ){
        let overlayView = UIView(frame: view.frame)
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.6
        overlayView.tag = 10
        overlayView.pleaseWait(message)
        view.addSubview(overlayView)
    }
    
    class func disableOverlayView( view:UIView ){
        view.viewWithTag(10)?.clearAllNotice()
        view.viewWithTag(10)?.removeFromSuperview()
    }
}
