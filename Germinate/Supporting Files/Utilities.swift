//
//  Utilities.swift
//  Germination Tracker
//
//  Created by Joshua on 11/16/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import Foundation

import Foundation
import UIKit

// handling file paths
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return(paths[0])
}

func getFileURLWith(id imageUUID: String) -> URL {
    let filePath = getDocumentsDirectory().appendingPathComponent(imageUUID)
    return(filePath)
}

func getFilePathWith(id imageUUID: String) -> String {
    return(getFileURLWith(id: imageUUID).path)
}



extension UIColor {

    
    /// Make a color lighter by a given percent.
    /// - Parameter percentage: The percent by which to make the color lighter.
    func lighten(by percentage: CGFloat = 25.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    /// Make a color darker by a given percent.
    /// - Parameter percentage: The percent by which to make the color darker.
    func darken(by percentage: CGFloat = 25.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    
    /// Adjust a color by a given percent.
    /// - Parameter percentage: The percent by which to increase or decrease a colors brightness.
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}


func resize(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

