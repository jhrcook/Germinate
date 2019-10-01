//
//  EditNoteView.swift
//  Germination Tracker
//
//  Created by Joshua on 9/23/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit
import ChameleonFramework
import SwiftyButton


class EditNoteView: UIView {
    
    let buttonContainerView = UIView()
    let buttonStackView = UIStackView()
    let saveButton: FlatButton = {
        let button = FlatButton()
        if #available(iOS 13, *) {
            button.color = .systemGreen
        } else {
            button.color = FlatGreen()
        }
        button.highlightedColor = button.color.darken(byPercentage: 0.25)
        button.cornerRadius = 8
        button.titleLabel?.text = "Save"
        button.setTitle("Save", for: [.normal])
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = FlatButton()
        if #available(iOS 13, *) {
            button.color = .systemRed
        } else {
            button.color = FlatRed()
        }
        button.highlightedColor = button.color.darken(byPercentage: 0.25)
        button.cornerRadius = 8
        button.titleLabel?.text = "Cancel"
        button.setTitle("Cancel", for: [.normal])
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        return button
    }()
    
    var datePickerLabel = UILabel()
    
    var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        return dp
    }()
    
    var textViewLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "  Notes"
        return lbl
    }()
    
    var textView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        return textView
    }()
    
    var mainStackView = UIStackView()
    
    var viewIsSetup = false
    
    
    func configureEditView(withNote note: SeedNote) {
        
        if !viewIsSetup { setupView() }
        
        setDatePickerLabel(toDate: note.dateCreated)
        datePicker.setDate(note.dateCreated, animated: false)
        textView.text = note.text
        
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        
        buttonContainerView.backgroundColor = .magenta
        datePickerLabel.backgroundColor = .orange
        datePicker.backgroundColor = .green
        textViewLabel.backgroundColor = .yellow
        textView.backgroundColor = .red
    }
    
    /// Set the date picker label the the format: "Date: Month Day, Year"
    private func setDatePickerLabel(toDate date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let text = dateFormatter.string(from: date)
        datePickerLabel.text = "  Date: \(text)"
    }
}



// MARK: Setup Views
extension EditNoteView {
    
    private func setupView() {
        setupMainStackView()
        setupButtons()
    }
    
    private func setupMainStackView() {
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints({ make in make.edges.equalTo(safeAreaLayoutGuide) })
        
        mainStackView.spacing = 5
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        mainStackView.addArrangedSubview(buttonContainerView)
        mainStackView.addArrangedSubview(datePickerLabel)
        mainStackView.addArrangedSubview(datePicker)
        mainStackView.addArrangedSubview(textViewLabel)
        mainStackView.addArrangedSubview(textView)
        
        buttonContainerView.snp.makeConstraints({ make in
            make.top.equalTo(mainStackView)
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
            make.height.equalTo(100)
        })
        datePickerLabel.snp.makeConstraints({ make in
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
            make.height.greaterThanOrEqualTo(44)
        })
        datePicker.snp.makeConstraints({ make in
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
            make.centerX.equalTo(mainStackView)
        })
        textViewLabel.snp.makeConstraints({ make in
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
            make.height.equalTo(datePickerLabel)
        })
        textView.snp.makeConstraints({ make in
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
            make.bottom.equalTo(mainStackView)
        })
    }
    
    
    private func setupButtons() {
        buttonContainerView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(saveButton)
        buttonStackView.addArrangedSubview(cancelButton)
        
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .center
        buttonStackView.spacing = 10
        
        buttonStackView.snp.makeConstraints({ make in make.edges.equalTo(buttonContainerView).inset(10)})
        saveButton.snp.makeConstraints({ make in
            make.height.equalTo(50)
            make.leading.equalTo(buttonStackView)
        })
        cancelButton.snp.makeConstraints({ make in
            make.width.equalTo(saveButton)
            make.height.equalTo(saveButton)
            make.trailing.equalTo(buttonStackView)
        })
    }
}
