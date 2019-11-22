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
