//
//  PlantMigrationManager.swift
//  Germination Tracker
//
//  Created by Joshua on 11/9/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import Foundation
import os

class PlantMigrationManager {
    
    /// The current version fot `Plant`
    var currentVersion: Int
    
    /// Initialize with the expected current version for `Plant`.
    init(currentVersion: Int) {
        self.currentVersion = currentVersion
    }
    
    
    /// Update an array of plants to the current version.
    /// - Parameter plants: A plant object.
    func update(_ plants: [Plant]) {
        os_log("Updating %d plants to the current version.", log: Log.plantMM, type: .info, plants.count)
        for plant in plants {
            if plant.plantVersion < currentVersion { update(plant) }
        }
    }
    
    func update(_ plant: Plant) {
        os_log("Updating plant from version %d to %d.", log: Log.plantMM, type: .info, plant.plantVersion, currentVersion)
        let updateFunctions = [
            updateZeroToOne
        ]
        while (plant.plantVersion < currentVersion) {
            updateFunctions[plant.plantVersion](plant)
        }
        
    }
    
    private func updateZeroToOne(plant: Plant) {
        os_log("Updating a plant from nil to 1.", log: Log.plantMM, type: .info)
        plant.plantVersion = 1
    }
}
