
//
//  GerminationDatesTableViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 10/4/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit


protocol GerminationDatesTableViewControllerDelegate {
    func DatesManagerWasChanged(_ dateCounterManager: DateCounterManager)
}


class GerminationDatesTableViewController: UITableViewController {

    private let reuseIdentifier = "GerminationDateCell"
    
    var datesManager = DateCounterManager()
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone.current
        return df
    }()
    
    var parentDelegate: GerminationDatesTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        tableView.register(GerminationDatesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        title = "Germination Dates"
    }

    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesManager.orderedDates.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GerminationDatesTableViewCell
        let date = datesManager.orderedDates[indexPath.row]
        let count = datesManager.dateCounts[date] ?? 0
        cell.configureCell(forDate: date, withNumberOfGerminations: count, withTag: indexPath.row)
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
    
}



extension GerminationDatesTableViewController {
    
    @objc private func addButtonTapped(sender: UIButton) {
        let date = datesManager.orderedDates[sender.tag]
    }
    
    @objc private func subtractButtonTapped(sender: UIButton) {
        let date = datesManager.orderedDates[sender.tag]
   }
}
