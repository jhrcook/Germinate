//
//  Plant.swift
//  Germination Tracker
//
//  Created by Joshua on 9/20/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit


/// A plant trying to be grown from seed.
class Plant: NSObject, Codable {

    /// The name of the plant.
    var name: String
    
    /// The number of seeds sown for the plant.
    var numberOfSeedsSown: Int = 0
    
    /// The date the seeds were sown
    var dateOfSeedSowing: Date
    
    /// An array of dates of germinations.
    var seedsSproutDates = [Date]()
    /// The number of germinations.
    var numberOfSproutedSeeds: Int {
        get {
            return seedsSproutDates.count
        }
    }
    
    /// An array of dates of plant deaths.
    var plantsDeathDates = [Date]()
    /// The number of plants that have died.
    var numberOfDeaths: Int {
        get {
            return plantsDeathDates.count
        }
    }
    
    init(name: String) {
        self.name = name
        self.dateOfSeedSowing = Date()
    }
    
    convenience init(name: String, numberOfSeedsSown: Int) {
        self.init(name: name)
        self.numberOfSeedsSown = numberOfSeedsSown
    }
}
