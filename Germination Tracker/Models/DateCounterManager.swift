//
//  DateCounterManager.swift
//  Germination Tracker
//
//  Created by Joshua on 10/8/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit

class DateCounterManager: Codable {
    
    /// A dictionary of `Date` to `Int` key-value pairs.
    var dateCounts = [Date: Int]()
    
    /// Array of all dates in ascending ordered (oldest to newest)
    var orderedDates: [Date] {
        get {
            Array(Set(dateCounts.keys)).sorted(by: { $0 < $1 })
        }
    }
    
    /// Total number of events over all dates
    var totalCount: Int {
        get {
            var counter = 0
            for val in dateCounts.values {
                counter += val
            }
            return counter
        }
    }
    
    
    /// Initialization of a new `DateCounterManager` object.
    init() {
        
    }
    
    /// Add one event to a specific date.
    /// - parameter date: The date to increment.
    func addEvent(on date: Date) {
        dateCounts[date] = 1 + (dateCounts[date] ?? 0)
    }
    
    
    /// Remove the most recent event.
    func removeMostRecentEvent() {
        if let mostRecentDate = orderedDates.last {
            remove(numberOfEvents: 1, fromDate: mostRecentDate)
        }
    }
    
    
    /// Remove a specific number of events from a date.
    /// - parameter num: Number of events to remove.
    /// - parameter date: The date to remove the events from.
    /// - Note: If the number of events to remove from a date is greater than the number of events available to remove, the value will be set to 0 (not a negative value).
    func remove(numberOfEvents num: Int, fromDate date: Date) {
        if let currentNumberOfEvents = dateCounts[date] {
            dateCounts[date] = max(currentNumberOfEvents - num, 0)
        }
        clearZeroValues()
    }
    
    
    /// Remove all events on a date.
    /// - parameter date: The date to remove all events from.
    func removeAllEvents(on date: Date) {
        dateCounts.removeValue(forKey: date)
    }
    
    /// Move events from one date to another.
    /// - parameter fromDate: Date to move values from.
    /// - parameter toDate: Date to move values to.
    func moveEvents(fromDate: Date, toDate: Date) {
        guard let fromVals = dateCounts[fromDate] else { return }
        let toVals = dateCounts[toDate] ?? 0
        let newVals = fromVals + toVals
        dateCounts[fromDate] = 0
        dateCounts[toDate] = newVals
        
        clearZeroValues()
    }
    
    /// Clear all zero values from the `dateCounts` dictionary.
    private func clearZeroValues() {
        for date in dateCounts.keys {
            if dateCounts[date]! == 0 {
                dateCounts.removeValue(forKey: date)
            }
        }
    }
}
