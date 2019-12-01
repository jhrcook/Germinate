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
    
    /// Name of the file for the thumbnail photo.
    var thumbnailFileName: String
    
    /// The string path to the file for thethumbnail  photo.
    var fullThumbnailPath: String {
        get { getFilePathWith(id: thumbnailFileName) }
    }
    
    /// The URL to the file for the thumbnail photo.
    var fullThumbnailURL: URL {
        get { getFileURLWith(id: thumbnailFileName) }
    }
    
    /// Has the thumbnail file been made?
    private var thumbnailImageExists: Bool {
        get {
            let fm = FileManager()
            return fm.fileExists(atPath: fullThumbnailPath)
        }
    }
    
    /// The size of thumbnail images.
    private let thumbnailSize = CGSize(width: 200.0, height: 200.0)
    
    
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
    ///   - dateAdded: The date the photo was added to the photos  library.
    init(fileName: String, datePhotoWasCaptured: Date, dateAdded: Date = Date()) {
        self.fileName = fileName
        self.datePhotoWasCaptured = datePhotoWasCaptured
        self.dateCreated = dateAdded
        
        thumbnailFileName = fileName + "thumb"
    }
    
    
    /// Make the thumbnail and save it to file.
    func makeThumbnail(forFullImage image: UIImage) {
        let resizedImage = resize(image: image, targetSize: thumbnailSize)
        writeImageToDisk(resizedImage, withFileURL: fullThumbnailURL)
    }
    
    /// Make the thumbail for the image an existing instance of Photo.
    func makeThumbnailForSelf() {
        if let image = UIImage(contentsOfFile: fullFilePath) {
            makeThumbnail(forFullImage: image)
        }
    }
    
    
    /// Remove the full image and thumbnail file from disk. Only call this when deleting the photo.
    func removeImagesFromDisk() {
        _ = [fullFilePath, fullThumbnailPath].map(removeImageFromDisk)
    }
    
    /// Remove a file from disk.
    private func removeImageFromDisk(filepath: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let fileManager = FileManager()
                try fileManager.removeItem(atPath: filepath)
            } catch {
                /// TODO: handle error unable to delete file.
                print("Unable to delete image.")
            }
        }
    }
    
    
    /// Write image to disk for the photo.
    /// - Parameter image: The image to write.
    func writeImageToDisk(_ image: UIImage, withFileURL url: URL) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let jpegData = image.jpegData(compressionQuality: 1.0) {
                try? jpegData.write(to: url)
            }
        }
    }
    
    /// Retrieve the image from disk.
    func retrieveImage() -> UIImage? {
        return UIImage(contentsOfFile: fullFilePath)
    }
    
    
    /// Retrieve the thumbnail.
    func retrieveThumbnail() -> UIImage? {
        if !thumbnailImageExists { makeThumbnailForSelf() }
        return UIImage(contentsOfFile: fullThumbnailPath)
    }
    
    
    /// Equality for a photo is if they share the same file name.
    /// - Parameters:
    ///   - lhs: The first  photo being compared.
    ///   - rhs: The second photo being compared.
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.fileName == rhs.fileName
    }
    
}
