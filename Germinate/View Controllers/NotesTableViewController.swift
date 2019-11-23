//
//  NotesTableViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/23/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import os


/// A protocol for the communincation of of changes to notes to the owner of the plant
protocol NotesTableViewControllerContainerDelegate {
    func didSelectNoteToEdit(atIndex index: Int)
    func didDeleteNote(atIndex index: Int)
}

/**
 A table view of the notes for a plant.
 
 The notes are displayed in standard cells with the date of creation as the header and an exandable text view below.
 Tapping on a cell allows the user to delete or edit the note.
 A note can also be edited by tapping the "+" in the navigation bar.
 */
class NotesTableViewController: UITableViewController {
    
    /// String to reference reusbale cells.
    private let reuseIdentifier = "notesCell"
    
    /// An  array of notes to show.
    var notes = [SeedNote]()
    
    /// The object that handles the plants array.
    /// This object gets passed to several child view controllers.
    var plantsManager: PlantsArrayManager?
    
    /// The delegate for the `NotesTableViewController` that contains the original `Plant`
    /// object. This delegate is notified if the notes are edited or deleted.
    var delegate: NotesTableViewControllerContainerDelegate?
    
    /// A date formatter. Shows the date with the long format and in the current timezone.
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeZone = TimeZone.current
        return df
    }()
    
    
    override func viewDidLoad() {
        os_log("View did load.", log: Log.notesTableVC, type: .info)
        super.viewDidLoad()
        setupTableView()
    }
    
    /// A wrapper to make reloading the table data easier for the parent view controller.
    /// Just runs `tableView.reloadData()`.
    func reloadData() {
        tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        
        // Initialize a new cell if they are `nil`.
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
            configureView(ofCell: &cell!)
        }
        
        // Configure the cell for the note.
        let note = notes[indexPath.row]
        configure(&cell!, forNote: note)
        
        return cell!
    }
    
    
    /// Configure the view for a cell. This need only be run once when a cell is first instanciated.
    /// - parameter cell: The cell to format.
    private func configureView(ofCell cell: inout UITableViewCell) {
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        cell.detailTextLabel?.numberOfLines = 0
    }
    
    
    /// Configure a cell for the table with the information from a specific note.
    /// - parameter cell: Cell to be configured
    /// - parameter note: The note from which to pull the information for the cell.
    private func configure(_ cell: inout UITableViewCell, forNote note: SeedNote) {
        cell.textLabel?.text = dateFormatter.string(from: note.dateCreated)
        cell.detailTextLabel?.text = note.text
    }
    
    
    /// Set up some style attributes of the table view. This need only be run once.
    private func setupTableView() {
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        os_log("Cell %d was selected.", log: Log.notesTableVC, type: .info, indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Alert controller to edit or delete a cell.
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Edit note", style: .default) { [weak self] _ in
            if let delegate = self?.delegate {
                delegate.didSelectNoteToEdit(atIndex: indexPath.row)
            }
        })
        ac.addAction(UIAlertAction(title: "Delete note", style: .destructive) { [weak self] _ in
            if let delegate = self?.delegate, let tableView = self?.tableView {
                delegate.didDeleteNote(atIndex: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Swipe to delete a note.
        if editingStyle == .delete {
            os_log("Swipe-to-delete at row %d.", log: Log.notesTableVC, type: .info, indexPath.row)
            delegate?.didDeleteNote(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}
