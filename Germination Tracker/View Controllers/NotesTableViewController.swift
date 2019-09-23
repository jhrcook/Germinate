//
//  NotesTableViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/23/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    let reuseIdentifier = "notesCell"
    
    var notes = [SeedNote]()
    var plantsManager: PlantsArrayManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        makeTestNotes()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        
        setupTableView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        
        let note = notes[indexPath.section]
        cell.titleLabel.text = note.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let text = dateFormatter.string(from: note.dateCreated)
        cell.dateLabel.text = text
        
        cell.detailLabel.text = note.detail
        
        return cell
    }
    
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// TODO
        print("Selected notes cell \(indexPath.row).")
    }
    
    @objc func addNewNote() {
        /// TODO
        print("Add a new note.")
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
