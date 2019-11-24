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
    
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {}
    
    
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {
        
    }
    
    
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {

    }
    
    
    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {
        
    }
    
    
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {
        
    }

}
