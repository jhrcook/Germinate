//
//  EditNoteViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/23/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit
import KeyboardObserver


protocol EditNoteViewControllerDelegate {
    func noteWasEdited(_ note: SeedNote)
}



class EditNoteViewController: UIViewController {
    
    var note: SeedNote
    
    var editNoteView = EditNoteView()
    
    var delegate: EditNoteViewControllerDelegate?
    
    private let keyboard = KeyboardObserver()
    private var isInNoteTextEditingMode = false
    
    init(note: SeedNote) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
                
        view.addSubview(editNoteView)
        editNoteView.snp.makeConstraints({ make in make.edges.equalTo(view.safeAreaLayoutGuide) })
        
        editNoteView.configureEditView(withNote: note)
        setupUIConnections()
        
        setupKeyboardObserver()
    }
    
    
    private func setupUIConnections() {
        editNoteView.datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        editNoteView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        editNoteView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        editNoteView.doneTypingButton.addTarget(self, action: #selector(doneTypingButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func cancelButtonTapped() {
        print("user tapped 'Cancel'.")
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        print("user tapped 'Save'.")
        note.text = editNoteView.textView.text
        
        if let delegate = delegate { delegate.noteWasEdited(note) }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneTypingButtonTapped() {
        view.endEditing(true)
    }
    
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        note.dateCreated = picker.date
        editNoteView.setDatePickerLabel(toDate: picker.date)
    }

}



// MARK: Keyboard Observer

extension EditNoteViewController {
    private func setupKeyboardObserver() {
        keyboard.observe { [weak self] event -> Void in
            
            guard let self = self else { return }
            
            switch event.type {
            case .willShow:
                print("keyboard will hide")
                self.activateTextEditingMode(withKeyboardHeight: event.keyboardFrameEnd)
            case .willHide:
                print("keyboard will hide")
                self.deactivateTextEditingMode()
            default:
                break
            }
        }
    }
    
    
    private func activateTextEditingMode(withKeyboardHeight keyboardFrameEnd: CGRect) {
        if !isInNoteTextEditingMode {
            let bottom = keyboardFrameEnd.height - view.alignmentRectInsets.bottom + 8
            editNoteView.hideDatePickerViewsAndChangeButtons(withTopOfKeyboardAt: bottom)
            isInNoteTextEditingMode = true
        }
    }
    
    
    private func deactivateTextEditingMode() {
        if isInNoteTextEditingMode {
            editNoteView.showAllSubViews()
            isInNoteTextEditingMode = false
        }
    }
}
