//
//  SeedNote.swift
//  Germination Tracker
//
//  Created by Joshua on 9/23/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import Foundation

struct SeedNote: Codable {
    
    var dateCreated: Date
    var text: String
    
    init(text: String, dateCreated: Date) {
        self.text = text
        self.dateCreated = dateCreated
    }
    
    init(text: String) {
        self.text = text
        self.dateCreated = Date()
    }
    
    init() {
        self.text = ""
        self.dateCreated = Date()
    }
}
