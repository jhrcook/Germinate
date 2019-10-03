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
    
    var datePickerLabelContainer = UIView()
    var datePickerLabel = UILabel()
    
    var datePickerContainer: UIView = {
        let v = UIView()
        if #available(iOS 13, *) {
            v.backgroundColor = .secondarySystemBackground
        } else {
            v.backgroundColor = .lightGray
        }
        return v
    }()
    
    var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        return dp
    }()
    
    var textViewLabelContainer = UIView()
    var textViewLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = " Notes"
        return lbl
    }()
    
    var textViewContainer = UIView()
    var textView: UITextView = {
        let tv = UITextView()
        tv.textAlignment = .left
        tv.layer.cornerRadius = 8
        tv.layer.masksToBounds = true
        if #available(iOS 13, *) {
            tv.backgroundColor = .secondarySystemBackground
        } else {
            tv.backgroundColor = .lightGray
        }
        return tv
    }()
    
    var mainStackView = UIStackView()
    
    var viewIsSetup = false
    
    
    func configureEditView(withNote note: SeedNote) {
        
        if !viewIsSetup { setupView() }
        
        setDatePickerLabel(toDate: note.dateCreated)
        datePicker.setDate(note.dateCreated, animated: false)
        textView.text = note.text
        
        textView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    /// Set the date picker label the the format: "Date: Month Day, Year"
    func setDatePickerLabel(toDate date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let text = dateFormatter.string(from: date)
        datePickerLabel.text = " Date: \(text)"
    }
}



// MARK: Setup Views
extension EditNoteView {
    
    private func setupView() {
        setupMainStackView()
        setupButtons()
        setupDatePickerLabelView()
        setupDatePickerView()
        setupTextView()
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
        mainStackView.addArrangedSubview(datePickerLabelContainer)
        mainStackView.addArrangedSubview(datePickerContainer)
        mainStackView.addArrangedSubview(textViewLabelContainer)
        mainStackView.addArrangedSubview(textViewContainer)
        
        buttonContainerView.snp.makeConstraints({ make in
            make.top.equalTo(mainStackView)
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
            make.height.equalTo(100)
        })
        datePickerLabelContainer.snp.makeConstraints({ make in
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
            make.height.greaterThanOrEqualTo(44)
        })
        datePickerContainer.snp.makeConstraints({ make in
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
            make.centerX.equalTo(mainStackView)
        })
        textViewLabelContainer.snp.makeConstraints({ make in
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
            make.height.greaterThanOrEqualTo(44)
        })
        textViewContainer.snp.makeConstraints({ make in
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
    
    
    private func setupDatePickerLabelView() {
        datePickerLabelContainer.addSubview(datePickerLabel)
        datePickerLabel.snp.makeConstraints({ make in
            make.top.equalTo(datePickerLabelContainer)
            make.bottom.equalTo(datePickerLabelContainer)
            make.leading.equalTo(datePickerLabelContainer).inset(15)
            make.trailing.equalTo(datePickerLabelContainer).inset(15)
        })
    }
    
    private func setupDatePickerView() {
        datePickerContainer.addSubview(datePicker)
        datePicker.snp.makeConstraints({ make in
            make.top.equalTo(datePickerContainer)
            make.bottom.equalTo(datePickerContainer)
            make.leading.equalTo(datePickerContainer).inset(15)
            make.trailing.equalTo(datePickerContainer).inset(15)
        })
    }
    
    private func setupTextView() {
        textViewLabelContainer.addSubview(textViewLabel)
        textViewLabel.snp.makeConstraints({ make in
            make.top.equalTo(textViewLabelContainer)
            make.bottom.equalTo(textViewLabelContainer)
            make.leading.equalTo(textViewLabelContainer).inset(15)
            make.trailing.equalTo(textViewLabelContainer).inset(15)
        })
        
        textViewContainer.addSubview(textView)
        textView.snp.makeConstraints({ make in
            make.top.equalTo(textViewContainer)
            make.bottom.equalTo(textViewContainer)
            make.leading.equalTo(textViewContainer).inset(15)
            make.trailing.equalTo(textViewContainer).inset(15)
        })
    }
}

