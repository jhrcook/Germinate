//
//  PhotosManager.swift
//  Germination Tracker
//
//  Created by Joshua on 11/16/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import os

class PhotosManager : Codable {
    
    /// An array of the names of the photos being managed.
    private(set) var photos = [Photo]()
    
    /// The number of photos.
    var numberOfPhotos: Int {
        get {
            photos.count
        }
    }
    
    
    /// Add a photo to the array
    func addPhoto(_ image: UIImage, capturedOn dateCaptured: Date, createdOn dateCreated: Date?) {
        
        // Create a new Photo object and save to Photos.
        let photo = Photo(fileName: UUID().uuidString, datePhotoWasCaptured: dateCaptured, dateCreated: dateCreated ?? Date())
        photos.append(photo)
        
        // Save the image to disk on a background thread.
        DispatchQueue.global(qos: .userInitiated).async {
            if let jpegData = image.jpegData(compressionQuality: 1.0) {
                try? jpegData.write(to: photo.fullFileURL)
            }
        }
    }
    
    
    /// Delete the image file from disk for a photo.
    /// - parameter Photo: Photo for which to delete image.
    func deletePhoto(_ photo: Photo) {
        photo.removeImageFromDisk()
        photos = photos.filter { $0 != photo }
        os_log("Deleted image file.", log: Log.photosManager, type: .info)
    }
    
    
    /// Sort the photos by date they were created.
    private func sortPhotosByDateCreated() {
        photos.sort { $0.datePhotoWasCaptured < $1.datePhotoWasCaptured}
    }
    
}
