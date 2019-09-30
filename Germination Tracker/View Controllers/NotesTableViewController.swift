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
        
//        makeTestNotes()
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
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
            configureView(ofCell: &cell!)
        }
        
        let note = notes[indexPath.row]
        configure(&cell!, forNote: note)
        
        return cell!
    }
    
    
    func configureView(ofCell cell: inout UITableViewCell) {
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        cell.detailTextLabel?.numberOfLines = 0
    }
    
    
    func configure(_ cell: inout UITableViewCell, forNote note: SeedNote) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let text = dateFormatter.string(from: note.dateCreated)
        cell.textLabel?.text = text
        
        cell.detailTextLabel?.text = note.text
    }
    
    
    func setupTableView() {
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Edit note", style: .default, handler: { [weak self] _ in
            if let delegate = self?.delegate {
                delegate.didSelectNoteToEdit(atIndex: indexPath.row)
            }
        }))
        ac.addAction(UIAlertAction(title: "Delete note", style: .destructive, handler: { [weak self] _ in
            if let delegate = self?.delegate, let tableView = self?.tableView {
                delegate.didDeleteNote(atIndex: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }))
        present(ac, animated: true)
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
            SeedNote(text: "Here is some notes detail text.This one is very long. So long in fact, that there is no way (whey) it will fit on a single line. Hopefully the text is wrapped, not truncated with some stupid ellipses!"),
            SeedNote(text: "Wow, some more test detail text!")
        ]
    }
}
