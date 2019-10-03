//
//  EditNoteViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/23/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit

protocol EditNoteViewControllerDelegate {
    func noteWasEdited(_ note: SeedNote)
}

class EditNoteViewController: UIViewController {
    
    var note: SeedNote
    
    var editNoteView = EditNoteView()
    
    var delegate: EditNoteViewControllerDelegate?
    
    
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
    }
    
    
    private func setupUIConnections() {
        editNoteView.datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        editNoteView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        editNoteView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
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
    
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        note.dateCreated = picker.date
        editNoteView.setDatePickerLabel(toDate: picker.date)
    }

}
