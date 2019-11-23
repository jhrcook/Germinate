//
//  AppTheme.swift
//  Germination Tracker
//
//  Created by Joshua on 9/29/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit

extension UIColor {
    struct MyTheme {
        
        // MARK: Standard Colors
        static let lightGreen = UIColor(red: 212/255, green: 255/255, blue: 214/255, alpha: 1.0)
        static let green = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
        static let darkGreen = UIColor(red: 0/255, green: 150/255, blue: 9/255, alpha: 1.0)
        
        
        // MARK: Dynamic Colors
        @available(iOS 13.0, *)
        static let dynamicGreenColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return darkGreen
            } else {
                return green
            }
        }
        
        @available(iOS 13.0, *)
        static let dynamicLightLabelColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return .black
            } else {
                return .white
            }
        }
    }
}
