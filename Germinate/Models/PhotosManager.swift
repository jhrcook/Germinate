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
    /// - Parameters:
    ///   - image: The image to write to file.
    ///   - dateCaptured: The date the photo was captured.
    ///   - dateAdded: The date the photo was added to the library.
    /// - Returns: The file name.
    func addPhoto(_ image: UIImage, capturedOn dateCaptured: Date, dateAdded: Date?) -> String {
        
        // Create a new Photo object and save to Photos.
        let photo = Photo(fileName: UUID().uuidString,
                          datePhotoWasCaptured: dateCaptured,
                          dateAdded: dateAdded ?? Date())
        photo.makeThumbnail(forFullImage: image)
        photo.writeImageToDisk(image, withFileURL: photo.fullFileURL)
        photos.append(photo)
        
        os_log("Saved photo.", log: Log.photosManager, type: .info)
        return photo.fileName
    }
    
    
    /// Delete a photo by file name.
    /// - Parameter fileName: The file name of the photo to delete.
    func deletePhoto(withFilename fileName: String) {
        if let photo = photos.first(where: { $0.fileName == fileName }) {
            deletePhoto(photo)
        }
    }
    
    
    /// Delete the image file from disk for a photo.
    /// - parameter Photo: Photo for which to delete image.
    func deletePhoto(_ photo: Photo) {
        photo.removeImagesFromDisk()
        photos = photos.filter { $0 != photo }
        os_log("Deleted image file.", log: Log.photosManager, type: .info)
    }
    
    
    /// Sort the photos by date they were created.
    private func sortPhotosByDateCreated() {
        os_log("Sorting photos by data created.", log: Log.photosManager, type: .info)
        photos.sort { $0.datePhotoWasCaptured < $1.datePhotoWasCaptured}
    }
    
    
    /// Get all of the images from all of the photos.
    func retrieveAllImages() -> [UIImage] {
        var images = [UIImage]()
        for photo in photos {
            if let img = photo.retrieveImage() { images.append(img) }
        }
        return images
    }
    
    /// Retrieve all of the thumbnails for all of the photos.
    func retrieveAllThumbnails() -> [UIImage] {
        var images = [UIImage]()
        for photo in photos {
            if let img = photo.retrieveThumbnail() { images.append(img) }
        }
        return images
    }
    
    func imageAt(index: Int) -> UIImage? {
        return photos[index].retrieveThumbnail()
    }
}
