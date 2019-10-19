//
//  EditNoteViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/23/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import os
import SnapKit
import KeyboardObserver


/// A protocol for communicating that a note was edited to the parent controller.
protocol EditNoteViewControllerDelegate {
    /// The note was edited by the user.
    /// - parameter note: The note that was edited.
    func noteWasEdited(_ note: SeedNote)
}


/**
 A view controller for editing a note.
 
 There are three main regions: the buttons along the top, a date picker in the middle, and a text view at the bottom.
 The two buttons at the top are "Save" and "Cancel."
 When the text view is tapped on, it is moved to the middle and a new button, "Done," is animated in place of the original two.
 Tapping the "Done" button brings back the original view.
 */
class EditNoteViewController: UIViewController {
    
    /// The note to pull information from and change when the user changes information.
    var note: SeedNote
    
    /// The main view that displays all of the interaciton components.
    /// It is made a subview of the default `view` and snapped to the edges.
    var editNoteView = EditNoteView()
    
    /// The  delegate to tell when information has been changed and saved.
    var delegate: EditNoteViewControllerDelegate?
    
    /// An observer of the keyboard that alert the controller when the keyboard appears.
    /// - Note: This class is from the library [`KeyboardObserver`](https://github.com/morizotter/KeyboardObserver)
    private let keyboard = KeyboardObserver()
    
    /// A boolean for if the app is in text editing mode of not.
    private var isInNoteTextEditingMode = false
    
    /// Initialize the view controller with a note.
    /// - parameter note: The note to present to the user.
    init(note: SeedNote) {
        os_log("A note editing view was initialized with a note.", log: Log.editNoteVC, type: .info)
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        os_log("The 'NSCoder' initializer was used and caused a crash.", log: Log.editNoteVC, type: .fault)
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        os_log("View did load.", log: Log.editNoteVC, type: .info)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        // Make the editing note view the main view for the app.
        view.addSubview(editNoteView)
        editNoteView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // Configure the view for the note.
        editNoteView.configureEditView(withNote: note)
        
        // Setup interactions with view objects
        setupUIConnections()
        
        // Begin monitoring the keyboard.
        setupKeyboardObserver()
    }
    
    
    /// Setup the interactions with the buttons, date picker, and text view. This method need only be called
    /// once upon set up. It is automatically called when the view is loaded.
    private func setupUIConnections() {
        os_log("UI connections are being set up.", log: Log.editNoteVC, type: .info)
        editNoteView.datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        editNoteView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        editNoteView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        editNoteView.doneTypingButton.addTarget(self, action: #selector(doneTypingButtonTapped), for: .touchUpInside)
    }
    
    
    /// Dismiss the view controller when the "Cancel" button is tapped.
    @objc private func cancelButtonTapped() {
        os_log("The 'Cancel' button was tapped.", log: Log.editNoteVC, type: .info)
        dismiss(animated: true, completion: nil)
    }
    
    
    /// Send the note to the delegate and dismiss the view controller with the "Save" button is tapped.
    @objc private func saveButtonTapped() {
        os_log("The 'Save' button was tapped.", log: Log.editNoteVC, type: .info)
        // Get the text from the text view.
        note.text = editNoteView.textView.text
        
        // Send the note to the delegate to replace the original.
        if let delegate = delegate { delegate.noteWasEdited(note) }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /// Called when the "Done" button is tapped when in editing mode.
    @objc private func doneTypingButtonTapped() {
        os_log("The 'Done' typing button was tapped.", log: Log.editNoteVC, type: .info)
        view.endEditing(true)
    }
    
    
    /// Called when the date picker value changes.
    /// - parameter picker: The `UIDatePicker` object that has changed value.
    @objc func datePickerChanged(picker: UIDatePicker) {
        os_log("The value fo the date picker changed.", log: Log.editNoteVC, type: .info)
        // Store the new date  and set as the current date in the label.
        note.dateCreated = picker.date
        editNoteView.setDatePickerLabel(toDate: picker.date)
    }

}



// MARK: Keyboard Observer

extension EditNoteViewController {
    
    private func setupKeyboardObserver() {
        os_log("Keyboard observer was notified.", log: Log.editNoteVC, type: .info)
        keyboard.observe { [weak self] event -> Void in
            guard let self = self else { return }
            
            switch event.type {
            case .willShow:
                os_log("Keyboard will show.", log: Log.editNoteVC, type: .info)
                self.activateTextEditingMode(withKeyboardHeight: event.keyboardFrameEnd)
            case .willHide:
                os_log("Keyboard will hide.", log: Log.editNoteVC, type: .info)
                self.deactivateTextEditingMode()
            default:
                break
            }
        }
    }
    
    
    
    /// Begin text editing mode.
    /// - parameter keyboardFrameEnd: The frame at the end of the keyboard. The bottom is
    /// used as the new bottom  of the view.
    private func activateTextEditingMode(withKeyboardHeight keyboardFrameEnd: CGRect) {
        os_log("Activating text editing mode.", log: Log.editNoteVC, type: .info)
        if !isInNoteTextEditingMode {
            let bottom = keyboardFrameEnd.height - view.alignmentRectInsets.bottom + 8
            editNoteView.hideDatePickerViewsAndChangeButtons(withTopOfKeyboardAt: bottom)
            isInNoteTextEditingMode = true
        }
    }
    
    
    /// End text editing mode.
    /// The  view is returned to normal.
    private func deactivateTextEditingMode() {
        os_log("Deactivating text editing mode.", log: Log.editNoteVC, type: .info)
        if isInNoteTextEditingMode {
            editNoteView.showAllSubViews()
            isInNoteTextEditingMode = false
        }
    }
}
