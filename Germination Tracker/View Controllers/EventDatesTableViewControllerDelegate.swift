
//
//  GerminationDatesTableViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 10/4/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit


/// A protocol for for communicating with the parent view controller that the user has changed the date.
protocol EventDatesTableViewControllerDelegate {
    /// The date of the dates manager was changed.
    /// - parameter dateCounterManager: The `DateCounterManager` that was edited.
    func DatesManagerWasChanged(_ dateCounterManager: DateCounterManager)
}


/**
 The view controller for manually editing events handled by a `DateCounterManager`.
 
 A table view where each cell is a date with the number of events shown between an increment and decrement button.
 The user can change the number of events on a specific date using the incrementing and decrementing buttons or by swiping to delete all of the values.
 */
class EventDatesTableViewController: UITableViewController {

    /// String to reference reusbale cells.
    private let reuseIdentifier = "GerminationDateCell"
    
    /// The dates manager object with all of the information in the table view.
    var datesManager = DateCounterManager()
    
    /// The index of the date being edited.
    private var indexOfDateBeingEdited: Int? = nil
    
    /// A `DateFormatter` object with the format "yyyy-MM-dd" in the current time zone.
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone.current
        return df
    }()
    
    /// The types of event that could be presented.
    enum EventType {
        case germinations, deaths
    }
    
    /// The event type being displayed. Dictates the title fof the view. Default (`nil`) is just "Dates."
    var eventType: EventType? {
        didSet {
            switch eventType {
            case .germinations:
                title = "Germination Dates"
            case .deaths:
                title = "Death Dates"
            default:
                title = "Dates"
            }
        }
    }
    
    /// The delegate is alerted every time any data is changed.
    var parentDelegate: EventDatesTableViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(EventDatesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // Add a navigation button to add a new date.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewDate))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesManager.orderedDates.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EventDatesTableViewCell
        
        // The date to use for the cell.
        let date = datesManager.orderedDates[indexPath.row]
        let count = datesManager.numberOfEvents(onDate: date) ?? 0
        
        // Configure the cell with the data.
        // The tag is for the increment and decrement buttons.
        cell.configureCell(forDate: date, withNumber: count, withTag: indexPath.row)
        
        // Register a tap gesture on the label to edit the date.
        let tap = UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped(sender:)))
        cell.dateLabel.addGestureRecognizer(tap)
        
        // Add targets to the increment and decrement buttons on the cell.
        cell.addButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        cell.subtractButton.addTarget(self, action: #selector(subtractButtonTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let date = datesManager.orderedDates[indexPath.row]
            datesManager.removeAllEvents(on: date)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let delegate = parentDelegate { delegate.DatesManagerWasChanged(datesManager) }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    
    /// Add a new date when the user taps on the "+" button in the navigation bar.
    /// This function just adds the
    /// - todo: Use `Calendar` to get the day before.
    @objc private func addNewDate() {
        var newDate = Date()
        if datesManager.totalCount != 0 {
            newDate = datesManager.orderedDates.first! - (24 * 60 * 60)
        }
        datesManager.addEvent(on: newDate)
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .top)
        }, completion: { [weak self] _ in
            self?.tableView.reloadData()
        })
        
        if let delegate = parentDelegate { delegate.DatesManagerWasChanged(datesManager) }
    }
    
}


/// Respond to gestures.

extension EventDatesTableViewController {
    
    /// Respond to the date label of a cell being tapped by showing a view controller with a date picker.
    /// - parameter sender: The gesture calling the function.
    @objc private func dateLabelTapped(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        
        let currentDate = datesManager.orderedDates[tag]
        indexOfDateBeingEdited = tag
        
        let datePickerVC = DatePickerViewController()
        datePickerVC.delegate = self
        datePickerVC.datePicker.setDate(currentDate, animated: false)
        datePickerVC.modalPresentationStyle = .formSheet
        datePickerVC.modalTransitionStyle = .coverVertical
        present(datePickerVC, animated: true, completion: nil)
    }
    
    
    /// Respond to the increment button beig tapped on the cell by adding one to the date at the index.
    /// - parameter sender: The button that was tapped.
    /// - todo: There may be a bug here after swiping to delete a cell 
    @objc private func addButtonTapped(sender: UIButton) {
        let date = datesManager.orderedDates[sender.tag]
        datesManager.addEvent(on: date)
        if let delegate = parentDelegate { delegate.DatesManagerWasChanged(datesManager) }
        tableView.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .none)
    }
    
    
    /// Respond to the decrement button beig tapped on the cell by subtracting one from the date at the index.
    /// - parameter sender: The button that was tapped.
    /// - todo: There may be a bug here after swiping to delete a cell
    @objc private func subtractButtonTapped(sender: UIButton) {
        let date = datesManager.orderedDates[sender.tag]
                
        if datesManager.numberOfEvents(onDate: date) == 1 {
            datesManager.remove(numberOfEvents: 1, fromDate: date)
            
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.tableView.deleteRows(at: [IndexPath(item: sender.tag, section: 0)], with: .fade)
            }, completion: { [weak self] _ in
                self?.tableView.reloadData()
            })
        } else {
            datesManager.remove(numberOfEvents: 1, fromDate: date)
            tableView.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .none)
        }
        
        // Let delegate know that some data was changed
        if let delegate = parentDelegate { delegate.DatesManagerWasChanged(datesManager) }
   }
}



extension EventDatesTableViewController: DatePickerViewControllerDelegate {
    
    /// Responds to a change in the date of a cell using the picker view.
    /// - parameter date: The new date for the cell.
    func dateSubmitted(_ date: Date) {
        guard let indexOfDateBeingEdited = indexOfDateBeingEdited else { return }
        
        let oldDate = datesManager.orderedDates[indexOfDateBeingEdited]
        datesManager.moveEvents(fromDate: oldDate, toDate: date)
        
        tableView.reloadData()
    }
    
    
}
