//
//  SeedNote.swift
//  Germination Tracker
//
//  Created by Joshua on 9/23/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import Foundation


/// A simple structure for notes for seeds.
struct SeedNote: Codable {
    
    /// Date the note was created.
    var dateCreated: Date
    
    /// Text of the note.
    var text: String
    
    /// Initialize the note with text and a date created.
    init(text: String, dateCreated: Date) {
        self.text = text
        self.dateCreated = dateCreated
    }
    
    /// Initialize the note with only the text and the date defaults to the current day.
    init(text: String) {
        self.text = text
        self.dateCreated = Date()
    }
    
    /// Initialize an empty note and the date defaults to the current day.
    init() {
        self.text = ""
        self.dateCreated = Date()
    }
}
