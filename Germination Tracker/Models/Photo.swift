//
//  Photo.swift
//  Germination Tracker
//
//  Created by Joshua on 11/16/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import Foundation

struct Photo : Codable, Equatable {
    
    /// Name of the file for the photo,
    var fileName: String
    
    var fullFilePath: String {
        get {
            getFilePathWith(id: fileName)
        }
    }
    
    var fullFileURL: URL {
        get {
            getFileURLWith(id: fileName)
        }
    }
    
    /// When the photo *instance* was created (not when the photo was captured).
    var dateCreated: Date
    
    /// The date when the photo was *captured*.
    var datePhotoWasCaptured: Date
    
    /// Has this photo been favorited by the user?
    var isFavorite: Bool = false
    
    
    init(fileName: String, datePhotoWasCaptured: Date) {
        self.dateCreated = Date()
        self.fileName = fileName
        self.datePhotoWasCaptured = datePhotoWasCaptured
    }
    
    
    init(fileName: String, datePhotoWasCaptured: Date, dateCreated: Date) {
        self.dateCreated = dateCreated
        self.fileName = fileName
        self.datePhotoWasCaptured = datePhotoWasCaptured
    }
    
    
    /// Remove the image file from disk. Only call this when deleting the photo.
    func removeImageFromDisk() throws {
        do {
            let fileManager = FileManager()
            try fileManager.removeItem(atPath: fullFilePath)
        } catch {
            throw error
        }
    }
    
    
    /// Equality for a photo is if they share the same file name.
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.fileName == rhs.fileName
    }
    
}
