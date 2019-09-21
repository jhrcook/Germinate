//
//  PlantsArrayManager.swift
//  Germination Tracker
//
//  Created by Joshua on 9/20/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import Foundation


/// A manager object responsible for caring for the array of plants in the app
class PlantsArrayManager {
    
    var plants = [Plant]()
    
    
    init() {
//        loadPlants()
        makeTestPlantsArray()
    }
    
    
    func loadPlants() {
        let defaults = UserDefaults.standard
        if let savedPlants = defaults.object(forKey: "plants") as? Data{
            let jsonDecoder = JSONDecoder()
            do {
                plants = try jsonDecoder.decode([Plant].self, from: savedPlants)
                print("Loading \(plants.count) plants.")
            } catch {
                fatalError("Unable to load plants.")
            }
        }
    }
    
    
    func savePlants() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(plants) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "plants")
            print("Saved \(plants.count) plants.")
        } else {
            fatalError("Failed to save plants.")
        }
    }
    
    
    func newPlant(named name: String) {
        print("Making new plant.")
        plants.append(Plant(name: name))
        savePlants()
    }
    
    
    func makeTestPlantsArray() {
        plants = [
            Plant(name: "Lithops julli"),
            Plant(name: "Euphorbia obesa"),
            Plant(name: "Haworthia truncata")
        ]
    }
    
}