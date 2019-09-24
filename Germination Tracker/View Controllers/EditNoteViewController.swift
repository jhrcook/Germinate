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
    
    var note: SeedNote?
    var editNoteView = EditNoteView()
    
    var delegate: EditNoteViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
                
        view.addSubview(editNoteView)
        editNoteView.snp.makeConstraints({ make in make.edges.equalTo(view) })
        
        if note == nil { note = SeedNote(title: "Title", detail: "Detail") }
        editNoteView.configureEditView(withNote: note)
        
    }
    
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        
        note?.title = editNoteView.titleTextView.text
        note?.dateCreated = editNoteView.datePicker.date
        note?.detail = editNoteView.detailTextView.text
        
        if let delegate = delegate { delegate.noteWasEdited(note!) }
        dismiss(animated: true, completion: nil)
        
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
