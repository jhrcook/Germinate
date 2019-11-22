//
//  PlantsArrayManager.swift
//  Germination Tracker
//
//  Created by Joshua on 9/20/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import Foundation
import os


/// A manager object responsible for caring for the array of plants in the app.
class PlantsArrayManager {
    
    /// The current version of `Plant`.
    private let currentPlantVersion = 1
    
    /// Array of plants.
    var plants = [Plant]()
    
    /// Initialize the object and automatically load the plants from file.
    init() {
//        loadPlants()
        makeTestPlantsArray()
    }
    
    /// Lead the plants from file.
    func loadPlants() {
        os_log("Trying to load plants.", log: Log.plantsManager, type: .info)
        let defaults = UserDefaults.standard
        if let savedPlants = defaults.object(forKey: "plants") as? Data{
            let jsonDecoder = JSONDecoder()
            do {
                plants = try jsonDecoder.decode([Plant].self, from: savedPlants)
                os_log("Loading %d plants.", log: Log.plantsManager, type: .info, plants.count)
                
                
                // Temporary fix for lack of migrations.
                let plantMigrationManager = PlantMigrationManager(currentVersion: currentPlantVersion)
                plantMigrationManager.update(plants)
                
                
            } catch {
                os_log("Unable to load data from file.", log: Log.plantsManager, type: .error)
            }
        }
    }
    
    
    /// Save plants to file.
    func savePlants() {
        os_log("Trying to save plants.", log: Log.plantsManager, type: .info)
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(plants) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "plants")
            os_log("Successfully saved plants", log: Log.plantsManager, type: .info)
        } else {
            os_log("Failed to save plants.", log: Log.plantsManager, type: .fault)
        }
    }
    
    
    /// Add a new plant.
    /// - parameter name: The name of the new plant.
    func newPlant(named name: String) {
        os_log("Making a new plant.", log: Log.plantsManager, type: .info)
        plants.append(Plant(name: name))
        savePlants()
    }
    
    /// Add a new plant and it is returned, too.
    /// - parameter name: The name of the new plant.
    func getNewPlant(named name: String) -> Plant {
        os_log("Making a new plant.", log: Log.plantsManager, type: .info)
        let plant = Plant(name: name)
        plants.append(plant)
        savePlants()
        return(plant)
    }
    
    
    func remove(_ plant: Plant) {
        if let idx = plants.firstIndex(where: { $0 === plant }) {
            os_log("Removing plant at index %d", log: Log.plantsManager, type: .info, idx)
            os_log("Removing plant named %{public}s.", log: Log.plantsManager, type: .info, plant.name)
            plants.remove(at: idx)
            savePlants()
        }
    }
    
    
    /// Make fake plants and append to `plants` array.
    /// - note: This is for testing purposes only and willl not be used in production.
    private func makeTestPlantsArray() {
        os_log("Making test plants.", log: Log.plantsManager, type: .info)
        plants = [
            Plant(name: "Lithops julli"),
            Plant(name: "Euphorbia obesa"),
            Plant(name: "Haworthia truncata")
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let anotherPlant = Plant(name: "Plant withseeds", numberOfSeedsSown: 20)
        anotherPlant.dateOfSeedSowing = dateFormatter.date(from: "09/01/2019")!
        let datesToAdd = [
            "09/02/2019", "09/02/2019", "09/02/2019",
            "09/04/2019", "09/04/2019", "09/04/2019", "09/04/2019",
            "09/08/2019",
            "09/12/2019", "09/12/2019", "09/12/2019",
            "09/15/2019", "09/15/2019", "09/15/2019", "09/15/2019"
        ]
        for date in datesToAdd {
            anotherPlant.germinationDatesManager.addEvent(on: dateFormatter.date(from: date)!)
        }
        plants.append(anotherPlant)
        
    }
    
}


