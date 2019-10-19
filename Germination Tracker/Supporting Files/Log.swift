//
//  Log.swift
//  Germination Tracker
//
//  Created by Joshua on 10/17/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import Foundation
import os.log

fileprivate let subsystem = "com.joshdoesathing.Germination-Tracker"

/**
 A custom structure to use Unified Logging.
 */
struct Log {
    // ---- View Controllers ---- //
    /// Logging object for `LibraryViewController`.
    static let libraryVC = OSLog(subsystem: subsystem, category: "LibraryViewController")
    /// Logging object for `PagingViewController`.
    static let pagingVC = OSLog(subsystem: subsystem, category: "PagingViewController")
    /// Logging object for `InformationViewController`.
    static let informationVC = OSLog(subsystem: subsystem, category: "InformationViewController")
    /// Logging object for `NotesTableViewController`.
    static let notesTableVC = OSLog(subsystem: subsystem, category: "NotesTableViewController")
    /// Logging object for `ChartViewController`.
    static let chartVC = OSLog(subsystem: subsystem, category: "ChartViewController")
    /// Logging object for `DatePickerViewController`.
    static let datePickerVC = OSLog(subsystem: subsystem, category: "DatePickerViewController")
    /// Logging object for `EditNoteViewControllerDelegate`.
    static let editNoteVC = OSLog(subsystem: subsystem, category: "EditNoteViewControllerDelegate")
    /// Logging object for `EventDatesTableViewController`.
    static let eventDatesTableVC = OSLog(subsystem: subsystem, category: "EventDatesTableViewController")
    
    
    // ---- Models ---- //
    /// Logging object for `PlantsArrayManager`.
    static let plantsManager = OSLog(subsystem: subsystem, category: "PlantsArrayManager")
    /// Logging object for `Plant`.
    static let plant = OSLog(subsystem: subsystem, category: "Plant")
    /// Logging object for `SeedNote`.
    static let seedNote = OSLog(subsystem: subsystem, category: "SeedNote")
    /// Logging object for `DateCounterManager`.
    static let dateCounterManager = OSLog(subsystem: subsystem, category: "DateCounterManager")
    
    
    // ---- Views ---- //
    /// Logging object for `LibraryTableViewCell`.
    static let libraryTVC = OSLog(subsystem: subsystem, category: "LibraryTableViewCell")
    /// Logging object for `EventDatesTableViewCell`.
    static let eventDatesTVC = OSLog(subsystem: subsystem, category: "EventDatesTableViewCell")
    /// Logging object for `InformationView`.
    static let informationV = OSLog(subsystem: subsystem, category: "InformationView")
    /// Logging object for `EditNoteView`.
    static let editNoteV = OSLog(subsystem: subsystem, category: "EditNoteView")
}
