
//
//  GerminationDatesTableViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 10/4/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit


protocol EventDatesTableViewControllerDelegate {
    func DatesManagerWasChanged(_ dateCounterManager: DateCounterManager)
}


class EventDatesTableViewController: UITableViewController {

    private let reuseIdentifier = "GerminationDateCell"
    
    var datesManager = DateCounterManager()
    
    var indexOfDateBeingEdited: Int? = nil
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone.current
        return df
    }()
    
    enum EventType {
        case germinations, deaths
    }
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
    
    var parentDelegate: EventDatesTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        tableView.register(EventDatesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
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
        let date = datesManager.orderedDates[indexPath.row]
        let count = datesManager.dateCounts[date] ?? 0
        cell.configureCell(forDate: date, withNumberOfGerminations: count, withTag: indexPath.row)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped(sender:)))
        cell.dateLabel.addGestureRecognizer(tap)
        
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



extension EventDatesTableViewController {
    
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
    
    @objc private func addButtonTapped(sender: UIButton) {
        let date = datesManager.orderedDates[sender.tag]
        datesManager.addEvent(on: date)
        if let delegate = parentDelegate { delegate.DatesManagerWasChanged(datesManager) }
        tableView.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .none)
    }
    
    
    @objc private func subtractButtonTapped(sender: UIButton) {
        let date = datesManager.orderedDates[sender.tag]
                
        if datesManager.dateCounts[date]! == 1 {
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
        
        if let delegate = parentDelegate { delegate.DatesManagerWasChanged(datesManager) }
   }
}



extension EventDatesTableViewController: DatePickerViewControllerDelegate {
    func dateSubmitted(_ date: Date) {
        guard let indexOfDateBeingEdited = indexOfDateBeingEdited else { return }
        
        let oldDate = datesManager.orderedDates[indexOfDateBeingEdited]
        datesManager.moveEvents(fromDate: oldDate, toDate: date)
        
        tableView.reloadData()
    }
    
    
}
