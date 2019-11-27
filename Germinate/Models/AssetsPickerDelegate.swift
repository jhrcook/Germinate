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
    
    /// The manager for getting photos and data.
    let imageManager = PHImageManager.default()
    
    /// The plant to save images for.
    let plant: Plant
    
    /// The manager that organizes the downloaded and deleting of selected and deselected assets.
    let assetsManager = AssetsSelectionManager()
    
    init(plant: Plant) {
        self.plant = plant
    }
    
    /// Request options for the PHImageManager.
    private let imageOptions: PHImageRequestOptions = {
        let imgOpts = PHImageRequestOptions()
        imgOpts.isSynchronous = false
        imgOpts.deliveryMode = .highQualityFormat
        return imgOpts
    }()
    
    
    /// If access is not granted to the Photos library, an alert controller is presented to tell the user.
    /// - parameter controller: The view controller showing the images to the user.
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {
        let ac = UIAlertController(title: "Unable to access photos.",
                                   message: "Be sure to provide Germinate with access to your photos library in Settings.",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        controller.present(ac, animated: true)
    }
    
    
    /// The method called when the user cancels by tapping the "Cancel" button or swiping away a modally presented view.
    /// - Parameter controller: The view controller showing the images to the user.
    /// - Note: All of the deselected images are confirmed to have been deleted and removed from disk.
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {
        // Must delete all of the downloaded images.
        print("Did cancel with cancel button.")
    }
    
    
    /// The method called when the user taps  "Done".
    /// All of the images have already been added to the plant and writted to disk.
    /// The images intended to be deleted are properlly deleted.
    /// - Parameters:
    ///   - controller: The view controller showing the images to the user.
    ///   - assets: The assets to be saved. (Again, all assets have already be saved.)
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        // Make sure all of the selected assets have been downloaded.
        print("Selected \(assets.count) assets.")
    }
    
    
    /// The method called when an asset is selected in the collection view.
    /// - Parameters:
    ///   - controller: The view controller showing the images to the user.
    ///   - asset: The selected asset.
    ///   - indexPath: The index path of the selected asset.
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {
        // Download an image and add it the assets manager.
        let assetRequestID = getImage(forAsset: asset)
        assetsManager.add(asset: asset,
                          withIndexPath: indexPath,
                          withRequestID: assetRequestID,
                          withFileName: nil)
    }
    
    
    /// The method called when an asset is deselected in the collection view.
    /// The asset (and it's information) is added to a special list in the `assetsManager` to double check that all
    /// previously downloaded images are deleted from disk.
    /// - Parameters:
    ///   - controller: The view controller showing the images to the user.
    ///   - asset: The deselected asset.
    ///   - indexPath: The index path of the deselected asset.
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {
        // Delete an image.
        if let fileToDelete = assetsManager.filename(of: asset) {
            assetsManager.addToDeleteList(asset)
            plant.photosManager.deletePhoto(withFilename: fileToDelete)
        }
    }
    
    
    /// Retrieve an image.
    /// - Parameter asset: The asset to  retrieve the image for.
    func getImage(forAsset asset: PHAsset) -> PHImageRequestID {
        let assetSize = CGSize(width: Double(asset.pixelWidth), height: Double(asset.pixelHeight))
        let assetRequestID = imageManager.requestImage(for: asset,
                                                       targetSize: assetSize,
                                                       contentMode: .aspectFit,
                                                       options: self.imageOptions,
                                                       resultHandler: addImageToPlant)
        return(assetRequestID)
    }
    
    
    /// Add an image to a plant.
    /// - Parameters:
    ///   - image: The image to add.
    ///   - info: Information about the image. This include the request ID which is used to link the image
    /// to the other information known about the asset.
    func addImageToPlant(image: UIImage?, info: [AnyHashable: Any]?) {
        guard
            let image = image,
            let info = info,
            let requestID = info["PHImageResultRequestIDKey"] as? PHImageRequestID,
            let assetInfo = assetsManager.information(forAssetWithRequestID: requestID)
        else {
            return
        }
        
        let assetFilename = plant.photosManager.addPhoto(image,
                                                         capturedOn: assetInfo.asset.creationDate ?? Date(),
                                                         dateAdded: Date())
        assetsManager.include(fileName: assetFilename, forAsset: assetInfo.asset)
    }
}
