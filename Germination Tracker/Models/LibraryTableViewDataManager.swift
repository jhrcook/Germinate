//
//  LibraryTableViewDatasource.swift
//  Germination Tracker
//
//  Created by Joshua on 10/20/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit



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


struct GroupedSection {

    var sectionName : String
    var rows : [Plant]

    mutating func sortByName() {
        rows.sort { $0.name < $1.name }
    }
    
    
    mutating func sortPlantsByDate(_ direction: OrderDirection) {
        switch direction {
        case .ascending:
            rows.sort { $0.dateOfSeedSowing < $1.dateOfSeedSowing}
        case .descending:
            rows.sort { $0.dateOfSeedSowing > $1.dateOfSeedSowing}
        }
    }
}



class LibraryTableViewDataManager {
    
    var plantsManager: PlantsArrayManager
    
    var sections = [GroupedSection]()
    
    var sortOption: SortOption {
        didSet {
            organizeSections()
        }
    }
    
    init(plantsManager: PlantsArrayManager, sortOption: SortOption) {
        self.plantsManager = plantsManager
        self.sortOption = sortOption
        organizeSections()
    }
    
    
    func organizeSections() {
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
        var group = GroupedSection(sectionName: "", rows: plantsManager.plants)
        group.sortPlantsByDate(direction)
        sections = [group]
    }
    
    
    private func sortPlantsIntoActiveAndArchived() {
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
        return sections[indexPath.section].rows[indexPath.row]
    }
    
    
    func indexPathForPlant(_ plant: Plant) -> IndexPath {
        switch sortOption {
        case .byDateDescending, .byDateAscending:
            let row = sections[0].rows.firstIndex { $0 == plant } ?? sections[0].rows.count
            return IndexPath(row: row, section: 0)
        case .byActive:
            let section = plant.isActive! ? 0 : 1
            let row = sections[section].rows.firstIndex { $0 == plant } ?? sections[section].rows.count
            return IndexPath(row: row, section: section)
        case .byPlantName:
            let section = sections.map { $0.sectionName }.firstIndex { $0 == plant.name }
            let row = sections[section!].rows.firstIndex { $0 == plant }
            return IndexPath(row: row!, section: section!)
        }
    }
}
