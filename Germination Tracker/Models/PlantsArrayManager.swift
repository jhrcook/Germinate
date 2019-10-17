//
//  PlantsArrayManager.swift
//  Germination Tracker
//
//  Created by Joshua on 9/20/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import Foundation


/// A manager object responsible for caring for the array of plants in the app.
class PlantsArrayManager {
    
    /// Array of plants.
    var plants = [Plant]()
    
    /// Initialize the object and automatically load the plants from file.
    init() {
        loadPlants()
//        makeTestPlantsArray()
    }
    
    /// Lead the plants from file.
    func loadPlants() {
        let defaults = UserDefaults.standard
        if let savedPlants = defaults.object(forKey: "plants") as? Data{
            let jsonDecoder = JSONDecoder()
            do {
                plants = try jsonDecoder.decode([Plant].self, from: savedPlants)
                print("Loading \(plants.count) plants.")
            } catch {
                print("Data type has changed and we lost your plants... sad.")
            }
        }
    }
    
    
    /// Save plants to file.
    func savePlants() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(plants) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "plants")
        } else {
            fatalError("Failed to save plants.")
        }
    }
    
    
    /// Add a new plant.
    /// - parameter name: The name of the new plant.
    func newPlant(named name: String) {
        plants.append(Plant(name: name))
        savePlants()
    }
    
    
    /// Make fake plants and append to `plants` array.
    /// - note: This is for testing purposes only and willl not be used in production.
    private func makeTestPlantsArray() {
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


