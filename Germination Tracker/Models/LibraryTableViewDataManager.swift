//
//  LibraryTableViewDatasource.swift
//  Germination Tracker
//
//  Created by Joshua on 10/20/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import os



/**
 Options by which to sort the plants.
 */
enum SortOption: String {
    /// Order by date (descending).
    case byDateDescending
    /// Order by date (ascending).
    case byDateAscending
    /// Order by plant name (alphabetically)
    case byPlantName
    /// Have the active plants at the top and the archived plants at the bottom.
    case byActive
}


/**
 The direction to sort vertically.
 */
enum OrderDirection {
    case ascending, descending
}

/**
 A single group for the library table view. Each has a title and an array of the plants that make up the
 rows for the section. Everything is passed by reference. Therefore, the changes are propogated to the
 other locations of the plant.
 */
struct GroupedSection {

    /// Title of the section.
    var sectionName : String
    /// The plants that make up the rows of the section.
    var rows : [Plant]

    /// Sort the plants by name.
    mutating func sortByName() {
        rows.sort { $0.name < $1.name }
    }
    
    
    /// Sort the plants by date.
    /// - Parameter direction: Should the plants be sorted in ascending or descending order?
    mutating func sortPlantsByDate(_ direction: OrderDirection) {
        switch direction {
        case .ascending:
            rows.sort { $0.dateOfSeedSowing < $1.dateOfSeedSowing}
        case .descending:
            rows.sort { $0.dateOfSeedSowing > $1.dateOfSeedSowing}
        }
    }
}



/**
 A special data manager for the library table view, controlled by `LibraryViewController`.
 It adjusts the sections for the different sorting options (enumerated in `SortOption`). The options to sort
 by date are all in one section, but the options for  sorting by name or active and inactive are in different sections.
 There are a bunch of helper functions for queiring the sections. For instance, the index for a plant or the plant
 for an index can be requested.
 */
class LibraryTableViewDataManager {
    
    /// The plants manager handling the core array of plants for the app.
    var plantsManager: PlantsArrayManager
    
    /// The sorted array of sections. Each section has a title and rows. The rows can be sorted by
    /// date, too.
    var sections = [GroupedSection]()
    
    /// The method to use for sorting. Setting this variable automatically triggers a reorganization. Therefore,
    /// it is recommended to make sure the user has actually requested a different sorting option before
    /// setting this value.
    var sortOption: SortOption {
        didSet {
            organizeSections()
        }
    }
    
    
    /// Initialize the data manager.
    /// - Parameter plantsManager: The central plants manager for the app.
    /// - Parameter sortOption: The method for sorting.
    init(plantsManager: PlantsArrayManager, sortOption: SortOption) {
        os_log("Initializing a library data manager", log: Log.libraryDM, type: .info)
        self.plantsManager = plantsManager
        self.sortOption = sortOption
        organizeSections()
    }
    
    
    /// 
    func organizeSections() {
        os_log("Organizing sections.", log: Log.libraryDM, type: .info)
        switch sortOption {
        case .byDateAscending:
            sortPlantsByDate(.ascending)
        case .byDateDescending:
            sortPlantsByDate(.descending)
        case .byActive:
            sortPlantsIntoActiveAndArchived()
        case .byPlantName:
            sortPlantsByName()
        }
    }
    
    
    private func sortPlantsByDate(_ direction: OrderDirection) {
        os_log("Sorting plants by data.", log: Log.libraryDM, type: .info)
        var group = GroupedSection(sectionName: "", rows: plantsManager.plants)
        group.sortPlantsByDate(direction)
        sections = [group]
    }
    
    
    private func sortPlantsIntoActiveAndArchived() {
        os_log("Sorting plants into active and inactive.", log: Log.libraryDM, type: .info)
        
        let groups = Dictionary(grouping: plantsManager.plants) { (plant) in
            return plant.isActive! ? "Active" : "Archived"
        }
        
        sections = groups.map { (key, values) in
            var group = GroupedSection(sectionName: key, rows: values)
            group.sortByName()
            group.sortPlantsByDate(.descending)
            return group
        }
    }
    
    
    private func sortPlantsByName() {
        os_log("Sorting plants by name.", log: Log.libraryDM, type: .info)
        
        let groups = Dictionary(grouping: plantsManager.plants) { (plant) in
            return plant.name
        }
        
        sections = groups.map { (key, values) in
            var group = GroupedSection(sectionName: key, rows: values)
            group.sortPlantsByDate(.descending)
            return group
        }
        sections.sort { $0.sectionName < $1.sectionName }
    }
    
    
    
    func plantForRowAt(indexPath: IndexPath) -> Plant {
        os_log("Retrieving plant for a specific index path.", log: Log.libraryDM, type: .info)
        let plant = sections[indexPath.section].rows[indexPath.row]
        return plant
    }
    
    
    func indexPathForPlant(_ plant: Plant) -> IndexPath {
        os_log("Retrieving index for a plant.", log: Log.libraryDM, type: .info)
        switch sortOption {
        case .byDateDescending, .byDateAscending:
            let row = sections[0].rows.firstIndex { $0 === plant } ?? sections[0].rows.count
            return IndexPath(row: row, section: 0)
        case .byActive:
            let section = plant.isActive! ? 0 : 1
            let row = sections[section].rows.firstIndex { $0 === plant } ?? sections[section].rows.count
            return IndexPath(row: row, section: section)
        case .byPlantName:
            let section = sections.map { $0.sectionName }.firstIndex { $0 == plant.name }
            let row = sections[section!].rows.firstIndex { $0 === plant }
            return IndexPath(row: row!, section: section!)
        }
    }
    
    
    func numberOfPlants(inSection sectionIndex: Int) -> Int {
        os_log("Retrieving number of rows in section %d.", log: Log.libraryDM, type: .info, sectionIndex)
        if sectionIndex >= sections.count { return 0 }
        return sections[sectionIndex].rows.count
    }
}
