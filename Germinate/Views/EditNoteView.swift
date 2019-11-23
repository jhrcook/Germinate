//
//  EditNoteView.swift
//  Germination Tracker
//
//  Created by Joshua on 9/23/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import os
import SnapKit
import SwiftyButton


/**
 A view for editing a note.
 
 It contains buttons for saving or canceling changes, a date picker for changing the date,  and a text view for interacting with the note.
 See `EditNoteViewController` for how to control the view.
 */
class EditNoteView: UIView {
    
    /// The main stack view responsible for organizing all of the subviews.
    var mainStackView = UIStackView()
    
    /// A container for the buttons.
    let buttonContainerView = UIView()
    /// A stack view for organizing the buttons.
    let buttonStackView = UIStackView()
    /// The height of a button.
    private let buttonHeight = 50
    /// The save button.
    let saveButton: FlatButton = {
        let button = FlatButton()
        if #available(iOS 13, *) {
            button.color = .systemGreen
        } else {
            button.color = ColorPalette.FlatGreen
        }
        button.highlightedColor = button.color.darken(by: 25.0) ?? button.color
        button.cornerRadius = 8
        button.titleLabel?.text = "Save"
        button.setTitle("Save", for: [.normal])
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        return button
    }()
    /// The cancel button.
    let cancelButton: FlatButton = {
        let button = FlatButton()
        if #available(iOS 13, *) {
            button.color = .systemRed
        } else {
            button.color = ColorPalette.FlatRed
        }
        button.highlightedColor = button.color.darken(by: 25.0) ?? button.color
        button.cornerRadius = 8
        button.titleLabel?.text = "Cancel"
        button.setTitle("Cancel", for: [.normal])
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        return button
    }()
    
    /// A container for the "Done" typing button.
    let doneTypingbuttonContainerView = UIView()
    /// The "Done" typing button.
    let doneTypingButton: FlatButton = {
        let button = FlatButton()
        if #available(iOS 13, *) {
            button.color = .systemPurple
        } else {
            button.color = ColorPalette.FlatPurple
        }
        button.highlightedColor = button.color.darken(by: 25.0) ?? button.color
        button.cornerRadius = 8
        button.titleLabel?.text = "Done Typing"
        button.setTitle("Done Typing", for: [.normal])
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        return button
    }()
    
    /// A container for the date picker label.
    var datePickerLabelContainer = UIView()
    /// The date picker label that shows the current date of the picker.
    /// It sits between the buttons and the date picker.
    var datePickerLabel = UILabel()
    
    /// A container for the date picker.
    var datePickerContainer: UIView = {
        let v = UIView()
        if #available(iOS 13, *) {
            v.backgroundColor = .secondarySystemBackground
        } else {
            v.backgroundColor = .lightGray
        }
        return v
    }()
    
    /// The date picker using a standard iOS `UIDatePicker`.
    var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.maximumDate = Date()
        return dp
    }()
    
    /// A container for the label above the text view.
    var textViewLabelContainer = UIView()
    /// The label above the text view. It just says "Notes".
    var textViewLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = " Notes"
        return lbl
    }()
    
    /// A container for the text view.
    var textViewContainer = UIView()
    /// The text vew where the note text is held and can be edited.
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
        tv.showsVerticalScrollIndicator = true
        tv.showsHorizontalScrollIndicator = false
        return tv
    }()
    
    /// A boolean value for whether the view has been set up or not.
    private var viewIsSetup = false
    
    
    
    /// Configure the view with the information from a note.
    /// - Parameter note: The note to pull information from.
    func configureEditView(withNote note: SeedNote) {
        os_log("Configuring the edit note view with a note.", log: Log.editNoteV, type: .info)
        // If the view has yet to be set up, do that first.
        if !viewIsSetup { setupView() }
        
        setDatePickerLabel(toDate: note.dateCreated)
        datePicker.setDate(note.dateCreated, animated: false)
        textView.text = note.text
        
        textView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    /// Set the date picker label the the format: "Date: Month Day, Year"
    /// - Parameter date: The date to set the label to.
    func setDatePickerLabel(toDate date: Date) {
        os_log("Setting date picker label.", log: Log.editNoteV, type: .info)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let text = dateFormatter.string(from: date)
        datePickerLabel.text = " Date: \(text)"
    }
}



// MARK: Setup Views

extension EditNoteView {
    
    /// A function that calls all of the subviews to be set up.
    private func setupView() {
        setupMainStackView()
        setupButtons()
        setupDoneTypingView()
        setupDatePickerLabelView()
        setupDatePickerView()
        setupTextView()
    }
    
    /// Organize the main stack view.
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
        mainStackView.addArrangedSubview(doneTypingbuttonContainerView)
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
        doneTypingbuttonContainerView.snp.makeConstraints({ make in
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
    
    
    /// Set up the "Save" and "Cancel" buttons.
    private func setupButtons() {
        buttonContainerView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(saveButton)
        buttonStackView.addArrangedSubview(cancelButton)
        
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .center
        buttonStackView.spacing = 10
        
        buttonStackView.snp.makeConstraints({ make in make.edges.equalTo(buttonContainerView).inset(10)})
        saveButton.snp.makeConstraints({ make in
            make.height.equalTo(buttonHeight)
            make.leading.equalTo(buttonStackView)
        })
        cancelButton.snp.makeConstraints({ make in
            make.width.equalTo(saveButton)
            make.height.equalTo(saveButton)
            make.trailing.equalTo(buttonHeight)
        })
    }
    
    
    /// Set up the "Done" typing button.
    private func setupDoneTypingView() {
        doneTypingbuttonContainerView.addSubview(doneTypingButton)
        doneTypingButton.snp.makeConstraints({ make in
            make.centerY.equalTo(doneTypingbuttonContainerView)
            make.leading.equalTo(doneTypingbuttonContainerView).inset(40)
            make.trailing.equalTo(doneTypingbuttonContainerView).inset(40)
            make.height.equalTo(buttonHeight)
        })
        doneTypingbuttonContainerView.isHidden = true
    }
    
    
    /// Set up the date picker label.
    private func setupDatePickerLabelView() {
        datePickerLabelContainer.addSubview(datePickerLabel)
        datePickerLabel.snp.makeConstraints({ make in
            make.top.equalTo(datePickerLabelContainer)
            make.bottom.equalTo(datePickerLabelContainer)
            make.leading.equalTo(datePickerLabelContainer).inset(15)
            make.trailing.equalTo(datePickerLabelContainer).inset(15)
        })
    }
    
    
    /// Set up the date picker.
    private func setupDatePickerView() {
        datePickerContainer.addSubview(datePicker)
        datePicker.snp.makeConstraints({ make in
            make.top.equalTo(datePickerContainer)
            make.bottom.equalTo(datePickerContainer)
            make.leading.equalTo(datePickerContainer).inset(15)
            make.trailing.equalTo(datePickerContainer).inset(15)
        })
    }
    
    
    /// Set up the text view.
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



// MARK: Hiding and Showing SubViews

extension EditNoteView {
    
    
    /// Enter the mode for editing the text of the note.
    /// - Parameter newBottom: The new bottom of the frame with the keyboard in view.
    func hideDatePickerViewsAndChangeButtons(withTopOfKeyboardAt newBottom: CGFloat) {
        os_log("Entering text editing mode.", log: Log.editNoteV, type: .info)
        showViewsInvolvedInTextEditing(true)
        textView.contentInset.bottom = newBottom
    }
    
    /// Return to the normal view with the keyboard out of the way.
    func showAllSubViews() {
        os_log("Leaving text editing mode.", log: Log.editNoteV, type: .info)
        showViewsInvolvedInTextEditing(false)
        textView.contentInset = .zero
    }
    
    
    /// Turn the view into the mode for editing the text. This is an animated transition.
    /// - Parameter state: A boolean for whether the view should be in the mode for editing the text of the note.
    private func showViewsInvolvedInTextEditing(_ state: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.datePickerLabelContainer.isHidden = state
            self.datePickerContainer.isHidden = state
            self.buttonContainerView.isHidden = state
            self.doneTypingbuttonContainerView.isHidden = !state
            
            let viewAlpha: CGFloat = state ? 0.0 : 1.0
            self.saveButton.alpha = viewAlpha
            self.cancelButton.alpha = viewAlpha
            self.datePickerLabel.alpha = viewAlpha
            self.datePicker.alpha = viewAlpha

            self.doneTypingButton.alpha = state ? 1.0 : 0.0
        })
    }
}
