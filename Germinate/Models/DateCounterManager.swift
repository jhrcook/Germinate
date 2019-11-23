//
//  DateCounterManager.swift
//  Germination Tracker
//
//  Created by Joshua on 10/8/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import os

/**
 A manager of events on dates.
 
 It keeps track of how many events happened on a day.
 It safely abstracts a lot of the hassle away from the other view controllers and presents a simple API to store and retrieve information.
 */
class DateCounterManager: Codable {
    
    /// A dictionary of `Date` to `Int` key-value pairs.
    private var dateCounts = [Date: Int]()
    
    /// Array of all dates in ascending ordered (oldest to newest).
    var orderedDates: [Date] {
        get {
            Array(Set(dateCounts.keys)).sorted(by: { $0 < $1 })
        }
    }
    
    
    /// Total number of events over all dates.
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
        // empty
        os_log("Initializing a new `DateCounterManager`.", log: Log.dateCounterManager, type: .info)
    }
    
    
    /// Get the number of events on a date.
    func numberOfEvents(onDate date: Date) -> Int? {
        os_log("Retrieving the number of events on a day.", log: Log.dateCounterManager, type: .info)
        let newDate = getMidnightDate(forDate: date)
        return dateCounts[newDate]
    }
    
    
    /// Add one event to a specific date.
    /// - parameter date: The date to increment.
    func addEvent(on date: Date) {
        os_log("Adding an event.", log: Log.dateCounterManager, type: .info)
        let newDate = getMidnightDate(forDate: date)
        dateCounts[newDate] = 1 + (dateCounts[newDate] ?? 0)
    }
    
    
    /// Remove the most recent event.
    func removeMostRecentEvent() {
        os_log("Requesting the removal of the most recent event.", log: Log.dateCounterManager, type: .info)
        if let mostRecentDate = orderedDates.last {
            os_log("Removing the most recent event.", log: Log.dateCounterManager, type: .info)
            remove(numberOfEvents: 1, fromDate: mostRecentDate)
        }
    }
    
    
    /// Remove a specific number of events from a date.
    /// - parameter num: Number of events to remove.
    /// - parameter date: The date to remove the events from.
    /// - Note: If the number of events to remove from a date is greater than the number of events
    ///   available to remove, the value will be set to 0 (not a negative value).
    func remove(numberOfEvents num: Int, fromDate date: Date) {
        os_log("Removing events from a date.", log: Log.dateCounterManager, type: .info)
        let newDate = getMidnightDate(forDate: date)
        if let currentNumberOfEvents = dateCounts[newDate] {
            dateCounts[newDate] = max(currentNumberOfEvents - num, 0)
        }
        clearZeroValues()
    }
    
    
    /// Remove all events on a date.
    /// - parameter date: The date to remove all events from.
    func removeAllEvents(on date: Date) {
        os_log("Removing all values.", log: Log.dateCounterManager, type: .info)
        dateCounts.removeValue(forKey: getMidnightDate(forDate: date))
    }
    
    
    /// Move events from one date to another.
    /// - parameter fromDate: Date to move values from.
    /// - parameter toDate: Date to move values to.
    func moveEvents(fromDate: Date, toDate: Date) {
        os_log("Moving events to a new date.", log: Log.dateCounterManager, type: .info)
        let newFromDate = getMidnightDate(forDate: fromDate)
        let newToDate = getMidnightDate(forDate: toDate)
        
        guard let fromVals = dateCounts[newFromDate] else { return }
        let toVals = dateCounts[newToDate] ?? 0
        let newVals = fromVals + toVals
        dateCounts[newFromDate] = 0
        dateCounts[newToDate] = newVals
        
        clearZeroValues()
    }
    
    
    /// Clear all zero values from the `dateCounts` dictionary.
    private func clearZeroValues() {
        os_log("Removing dates with 0 events.", log: Log.dateCounterManager, type: .info)
        for date in dateCounts.keys {
            if dateCounts[date]! == 0 {
                dateCounts.removeValue(forKey: date)
            }
        }
    }
    
    
    /// Get the current date to the percision of day and at midnight.
    /// - returns: The current date to the precision of day at midnight.
    private func getCurrentDate() -> Date {
        os_log("Retrieving the current date at midnight.", log: Log.dateCounterManager, type: .info)
        return getMidnightDate(forDate: Date())
    }
    
    
    /// Get the date to the precision of day at midnight.
    /// - Parameter date: The date to transform.
    private func getMidnightDate(forDate date: Date) -> Date {
        os_log("Convert a date to the midnight date.", log: Log.dateCounterManager, type: .info)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        return dateFrom(year: components.year!, month: components.month!, day: components.day!)
    }
    
    
    /// Get the date to the percision of day at midnight.
    /// - Parameter year: Year of the date.
    /// - Parameter month: Month of the date.
    /// - Parameter day: Day of the date.
    /// - returns: A date to the percision of day at midnight.
    private func dateFrom(year:Int, month:Int, day:Int) -> Date {
        os_log("Getting the date from components to the precision of midnight.", log: Log.dateCounterManager, type: .info)
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        let gregorian = Calendar(identifier: .gregorian)
        return gregorian.date(from: components)!
    }
}
