//
//  NotesTableViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/23/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import ChameleonFramework

protocol NotesTableViewControllerContainerDelegate {
    func didSelectNoteToEdit(atIndex index: Int)
    func didDeleteNote(atIndex index: Int)
}

class NotesTableViewController: UITableViewController {
    
    let reuseIdentifier = "notesCell"
    
    var notes = [SeedNote]()
    var plantsManager: PlantsArrayManager?
    var delegate: NotesTableViewControllerContainerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        makeTestNotes()
        
        setupTableView()
    }

    // MARK: - Table view data source
    
    func reloadData() {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        
        let note = notes[indexPath.row]
        cell.configureCell(forNote: note)
        
        return cell
    }
    
    
    func setupTableView() {
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = FlatWatermelon().lighten(byPercentage: 0.2)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate { delegate.didSelectNoteToEdit(atIndex: indexPath.row) }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.didDeleteNote(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}


extension NotesTableViewController {
    func makeTestNotes() {
        notes = [
            SeedNote(title: "Test note 1", detail: "Here is some notes detail text."),
            SeedNote(title: "Test note 2", detail: "Wow, some more test detail text!")
        ]
    }
}
