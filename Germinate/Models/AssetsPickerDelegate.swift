//
//  AssetPickerDelegate.swift
//  Germinate
//
//  Created by Joshua on 11/24/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import os
import AssetsPickerViewController
import Photos

class AssetsPickerDelegate: AssetsPickerViewControllerDelegate {
    
    /// If access is not granted to the Photos library, an alert controller is presented to tell the user.
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {
        let ac = UIAlertController(title: "Unable to access photos.", message: "Be sure to provide Germinate with access to your photos library in Settings.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        controller.present(ac, animated: true)
    }
    
    
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {
        // Must delete all of the downloaded images.
        print("Did cancel with cancel button.")
    }
    
    
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        // Make sure all of the selected assets have been downloaded.
        print("Selected \(assets.count) assets.")
    }
    
    
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {
        // Download an image.
        print("Did select asset:")
        print("asset created on \(asset.creationDate ?? Date())")
    }
    
    
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {
        // Delete an image.
        print("Did deselect asset:")
        print(asset)
        print("asset created on \(asset.creationDate ?? Date())")
    }
}
