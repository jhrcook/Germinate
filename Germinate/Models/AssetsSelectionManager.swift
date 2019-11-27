//
//  AssetsSelectionManager.swift
//  Germinate
//
//  Created by Joshua on 11/24/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import Photos


/// A simple data structure to hold all of the information for an asset.
struct AssetInformation {
    /// The index path of the asset in the collection view.
    let indexPath: IndexPath
    /// The asset.
    var asset: PHAsset
    /// The name of the file of the image on disk.
    var fileName: String? = nil
    /// The request ID returned by a `PHImageManager` when `requestImage()` is used.
    var requestID: PHImageRequestID? = nil
}



/// A manager object for managing the rather complex process of getting images from the user's Photos library.
class AssetsSelectionManager {
    
    /// An array of all of the asset information.
    private var assetInfo = [AssetInformation]()
    
    /// An array of the asset information for the assets that are intended to be deleted.
    /// This is useful for double-checking that all image deletions have been completed at the end.
    private var intendedDeletions = [AssetInformation]()
    
    /// Add a new asset to the manager.
    /// - Parameters:
    ///   - asset: The new asset.
    ///   - indexPath: The index path of the asset in the collection view being used to display the photos.
    ///   - requestID: The request ID returned after reuqesting an image.
    ///   - fileName: The name of the file (usually not available when adding a new asset).
    func add(asset: PHAsset, withIndexPath indexPath: IndexPath, withRequestID requestID: PHImageRequestID?, withFileName fileName: String?) {
        assetInfo.append(AssetInformation(indexPath: indexPath, asset: asset, fileName: fileName, requestID: requestID))
    }
    
    
    /// Get the information for an asset.
    /// - Parameter asset: The `PHAsset` to get all of the information for.
    func information(forAsset asset: PHAsset) -> AssetInformation? {
        if let ai = assetInfo.first(where: { $0.asset == asset }) {
            return ai
        }
        return nil
    }
    
    
    /// Get the information for an asset specified by it's index path.
    /// - Parameter indexPath: The index path of the asset in the collection view.
    func information(forAssetWithIndexPath indexPath: IndexPath) -> AssetInformation? {
        if let ai = assetInfo.first(where: { $0.indexPath == indexPath }) {
            return ai
        }
        return nil
    }
    
    
    /// Get the information for an asset specified by it's request ID.
    /// - Parameter requestID: The request ID of the asset.
    func information(forAssetWithRequestID requestID: PHImageRequestID) -> AssetInformation? {
        if let ai = assetInfo.first(where: { $0.requestID == requestID }) {
            return ai
        }
        return nil
    }
    
    
    /// The filename for an asset.
    /// - Parameter asset: The asset to get the file name for.
    func filename(of asset: PHAsset) -> String? {
        if let ai = information(forAsset: asset) {
            return ai.fileName
        }
        return nil
    }
    
    
    /// The file name for an asset specified by its index path in the collection view.
    /// - Parameter indexPath: The index path of the asset in the collection view.
    func filename(with indexPath: IndexPath) -> String? {
        if let ai = information(forAssetWithIndexPath: indexPath) {
            return ai.fileName
        }
        return nil
    }
    
    
    /// Add an asset to the list of assets that should be deleted.
    /// - Parameter asset: The asset to add.
    func addToDeleteList(_ asset: PHAsset) {
        if let ai = information(forAsset: asset) {
            intendedDeletions.append(ai)
        }
    }
    
    
    /// Add an asset specified by the index path to the list of assets that should be deleted.
    /// - Parameter indexPath: The index path of the asset in the collection view.
    func addToDeleteList(_ indexPath: IndexPath) {
        if let ai = information(forAssetWithIndexPath: indexPath) {
            intendedDeletions.append(ai)
        }
    }
    
    
    /// Include the file name in the information for an asset. Often, this information is not available when
    /// the asset was added to the manager. This method is used to add it when it is known.
    /// - Parameters:
    ///   - fileName: The file name to add.
    ///   - asset: The asset whose information should be modified.
    func include(fileName: String, forAsset asset: PHAsset) {
        if let idx = assetInfo.firstIndex(where: { $0.asset == asset }) {
            var ai = assetInfo[idx]
            ai.fileName = fileName
            assetInfo[idx] = ai
        }
    }
}
