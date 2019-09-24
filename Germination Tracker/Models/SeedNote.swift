//
//  SeedNote.swift
//  Germination Tracker
//
//  Created by Joshua on 9/23/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import Foundation

struct SeedNote: Codable {
    
    var title: String
    var detail: String
    var dateCreated: Date
    
    init(title: String, detail: String, dateCreated: Date) {
        self.title = title
        self.detail = detail
        self.dateCreated = dateCreated
    }
    
    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
        self.dateCreated = Date()
    }
}
