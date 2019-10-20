//
//  Plant.swift
//  Germination Tracker
//
//  Created by Joshua on 9/20/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import os


/// A plant trying to be grown from seed.
class Plant: Codable {

    /// The name of the plant.
    var name: String
    
    /// The number of seeds sown for the plant.
    var numberOfSeedsSown: Int = 0
    
    /// The date the seeds were sown.
    var dateOfSeedSowing: Date
    
    /// A manager for the germination events.
    var germinationDatesManager = DateCounterManager()
    
    /// A manager for the death events.
    var deathDatesManager = DateCounterManager()
    
    /// An array of type `SeedNote` containing notes about the germination process.
    var notes = [SeedNote]()
    
    /// Is the plant currently being cultivated.
    var isActive: Bool? = true
    
    /// Initialize a plant by name.
    init(name: String) {
        os_log("Initializing a plant with a name.", log: Log.plant, type: .info)
        self.name = name
        self.dateOfSeedSowing = Date()
    }
    
    /// Inialize a plant by name and number of seeds sown.
    convenience init(name: String, numberOfSeedsSown: Int) {
        os_log("Initializing a plant with a name and date.", log: Log.plant, type: .info)
        self.init(name: name)
        self.numberOfSeedsSown = numberOfSeedsSown
    }
    
    
    /// Add a `SeedNote` to the `notes` array.
    /// - parameter note: A `SeedNote` object to add to the plant's array of notes.
    func add(_ note: SeedNote) {
        os_log("Making a new note.", log: Log.plant, type: .info)
        notes.append(note)
        orderNotes()
    }
    
    /// Replace a note in the `notes` array.
    /// - parameter index: Where in the array of notes to replace with a new note.
    /// - parameter note: A new `SeedNote`
    func replaceNote(atIndex index: Int, with note: SeedNote) {
        os_log("Replacing a note with a new one.", log: Log.plant, type: .info)
        notes[index] = note
        orderNotes()
    }
    
    /// Reorder the notes by date created: oldest to newest
    private func orderNotes() {
        os_log("Ordering the notes by date.", log: Log.plant, type: .info)
        notes = notes.sorted(by: { $0.dateCreated < $1.dateCreated })
    }

}
