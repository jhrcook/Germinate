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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
                
        view.addSubview(editNoteView)
        editNoteView.snp.makeConstraints({ make in make.edges.equalTo(view.safeAreaLayoutGuide) })
        
        editNoteView.datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
        editNoteView.configureEditView(withNote: note)
        
    }
    
    
    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        note.text = editNoteView.textView.text
        
        if let delegate = delegate { delegate.noteWasEdited(note) }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        note.dateCreated = picker.date
    }

}
