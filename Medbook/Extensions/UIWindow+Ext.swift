//
//  UIWindow+Ext.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import UIKit
import netfox

extension UIWindow {
    //Perform some action when the device is shook!
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NFX.sharedInstance().show()
        }
    }
}
