//
//  Photo.swift
//  Germination Tracker
//
//  Created by Joshua on 11/16/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import Photos

struct Photo : Codable, Equatable {
        
    /// Name of the file for the photo,
    var fileName: String
    
    /// The string path to the file for the photo.
    var fullFilePath: String {
        get { getFilePathWith(id: fileName) }
    }
    
    /// The URL to the file for the photo.
    var fullFileURL: URL {
        get { getFileURLWith(id: fileName) }
    }
    
    /// When the photo *instance* was created (not when the photo was captured).
    var dateCreated: Date
    
    /// The date when the photo was *captured*.
    var datePhotoWasCaptured: Date
    
    /// Has this photo been favorited by the user?
    var isFavorite: Bool = false
    
    
    /// Initialize a new photo
    /// - Parameters:
    ///   - fileName: The name of the file (usually some UUID).
    ///   - datePhotoWasCaptured: Date that the photo was captured.
    init(fileName: String, datePhotoWasCaptured: Date) {
        self.fileName = fileName
        self.datePhotoWasCaptured = datePhotoWasCaptured
        self.dateCreated = Date()
    }
    
    
    /// Initialize a new photo
    /// - Parameters:
    ///   - fileName: The name of the file (usually some UUID).
    ///   - datePhotoWasCaptured: Date that the photo was captured.
    ///   - dateAdded: The date the photo was added to the photos  library.
    init(fileName: String, datePhotoWasCaptured: Date, dateAdded: Date) {
        self.fileName = fileName
        self.datePhotoWasCaptured = datePhotoWasCaptured
        self.dateCreated = dateAdded
    }
    
    
    /// Remove the image file from disk. Only call this when deleting the photo.
    func removeImageFromDisk() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let fileManager = FileManager()
                try fileManager.removeItem(atPath: self.fullFilePath)
            } catch {
                /// TODO: handle error unable to delete file.
                print("Unable to delete image.")
            }
        }
    }
    
    
    /// Write image to disk for the photo.
    /// - Parameter image: The image to write.
    func writeImageToDisk(_ image: UIImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let jpegData = image.jpegData(compressionQuality: 1.0) {
                try? jpegData.write(to: self.fullFileURL)
            }
        }
    }
    
    
    /// Equality for a photo is if they share the same file name.
    /// - Parameters:
    ///   - lhs: The first  photo being compared.
    ///   - rhs: The second photo being compared.
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.fileName == rhs.fileName
    }
    
}
