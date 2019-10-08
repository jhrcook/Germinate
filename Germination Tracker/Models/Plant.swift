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
    var seedGerminationDates = [Date: Int]()
    /// The number of germinations.
    var numberOfGerminations: Int {
        get {
            var counter = 0
            for val in seedGerminationDates.values {
                counter += val
            }
            return counter
        }
    }
    /// Sorted array of dates of seed germinations
    var orderedDatesOfGerminations: [Date] {
        get {
            Array(Set(seedGerminationDates.keys)).sorted(by: { $0 < $1 })
        }
    }
    
    /// An array of dates of plant deaths.
    var plantDeathDates = [Date: Int]()
    /// The number of plants that have died.
    var numberOfDeaths: Int {
       get {
           var counter = 0
           for val in seedGerminationDates.values {
               counter += val
           }
           return counter
       }
    }
    /// Sorted array of dates of plant deaths
    var orderedDatesOfDeaths: [Date] {
        get {
            Array(Set(plantDeathDates.keys)).sorted(by: { $0 < $1 })
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
    func addGermination(_ date: Date) {
        seedGerminationDates[date] = 1 + (seedGerminationDates[date] ?? 0)
    }
    
    /// Remove the more recent germination date
    func removeMostRecentGermination() {
        if let mostRecentDate = orderedDatesOfGerminations.last {
            remove(numGermination: 1, fromDate: mostRecentDate)
        }
    }
    
    /// Remove a specific number of germinations from a date
    func remove(numGermination num: Int, fromDate date: Date) {
        if let currentNumberOfGerminations = seedGerminationDates[date] {
            seedGerminationDates[date] = max(currentNumberOfGerminations - num, 0)
        }
        clearZeroValues(fromDict: &seedGerminationDates)
    }
    
    func removeAllGerminations(on date: Date) {
        seedGerminationDates.removeValue(forKey: date)
    }
    
    
    
    private func clearZeroValues(fromDict dict: inout [Date: Int]) {
        for date in dict.keys {
            if dict[date]! == 0 {
                dict.removeValue(forKey: date)
            }
        }
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
