//
//  Plant.swift
//  Germination Tracker
//
//  Created by Joshua on 9/20/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit


/// A plant trying to be grown from seed.
class Plant: Codable {

    /// The name of the plant.
    var name: String
    
    /// The number of seeds sown for the plant.
    var numberOfSeedsSown: Int = 0
    
    /// The date the seeds were sown
    var dateOfSeedSowing: Date
    
    /// An array of dates of germinations.
    var seedGerminationDates = [Date]()
    /// The number of germinations.
    var numberOfGerminations: Int {
        get {
            return seedGerminationDates.count
        }
    }
    
    /// An array of dates of plant deaths.
    var plantDeathDates = [Date]()
    /// The number of plants that have died.
    var numberOfDeaths: Int {
        get {
            return plantDeathDates.count
        }
    }
    
    /// An array of type `SeedNote` containing notes about the germination process.
    var notes = [SeedNote]()
    
    init(name: String) {
        self.name = name
        self.dateOfSeedSowing = Date()
    }
    
    convenience init(name: String, numberOfSeedsSown: Int) {
        self.init(name: name)
        self.numberOfSeedsSown = numberOfSeedsSown
    }
    
    /// Add a date to `seedGerminationDates`
    func addGermination(_ date: Date?) {
        seedGerminationDates.append(date ?? Date())
    }
    
    /// Remove a date from `seedGerminationDates`
    func removeGermination(atIndex index: Int) {
        seedGerminationDates.remove(at: index)
    }
    
    /// Add a date to `plantDeathDates`
    func addDeath(_ date: Date?) {
        plantDeathDates.append(date ?? Date())
    }
    
    /// Remove a date from `plantDeathDates`
    func removeDeath(atIndex index: Int) {
        plantDeathDates.remove(at: index)
    }
    
    /// Add a `SeedNote` to the `notes` array.
    func add(_ note: SeedNote) {
        notes.append(note)
        orderNotes()
    }
    
    /// Replace a note in the `notes` array
    func replaceNote(atIndex index: Int, with note: SeedNote) {
        notes[index] = note
        orderNotes()
    }
    
    /// Reorder the notes by date created: oldest to newest
    private func orderNotes() {
        notes = notes.sorted(by: { $0.dateCreated < $1.dateCreated })
    }
}
