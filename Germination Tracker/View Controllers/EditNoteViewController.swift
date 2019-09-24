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
    
    var note: SeedNote? {
        didSet {
            editNoteView.configureEditView(withNote: note)
        }
    }
    
    var editNoteView = EditNoteView()
    
    var delegate: EditNoteViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
                
        view.addSubview(editNoteView)
        editNoteView.snp.makeConstraints({ make in make.edges.equalTo(view) })
        
        editNoteView.datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
        if note == nil {
            note = SeedNote(title: "Title", detail: "Detail")
        }
        editNoteView.configureEditView(withNote: note)
        
    }
    
    
    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        note?.title = editNoteView.titleTextView.text
        note?.detail = editNoteView.detailTextView.text
        
        if let delegate = delegate { delegate.noteWasEdited(note!) }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        note?.dateCreated = picker.date
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
