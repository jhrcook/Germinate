//
//  DatePickerViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/22/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import os
import SnapKit
import ChameleonFramework
import SwiftyButton

/// A protocol for communicating to the parent view controller when the date has been selected.
protocol DatePickerViewControllerDelegate {
    /// A new date is being submitted by the user.
    /// - parameter date: The new date.
    func dateSubmitted(_ date: Date)
}


/**
 A view controller for picking a date.
 
 It presents the standard iOS date picker with a "Save" and "Cancel" button.
 Tapping the button causes the controller to dismiss itself.
 If "Save" was tapped, then the new date is submitted to the parent view controller through a delegate method.
 */
class DatePickerViewController: UIViewController {

    /// Label at the head of the view saying "Date of Sowing".
    let titleLabel: UILabel = {
        let lbl = UILabel()
        
        if #available(iOS 13.0, *) {
            lbl.backgroundColor = .secondarySystemBackground
            lbl.textColor = .label
        } else {
            lbl.backgroundColor = .white
            lbl.textColor = .black
        }
        lbl.text = "Date of Sowing"
        lbl.textAlignment = .center
        lbl.font = UIFont.preferredFont(forTextStyle: .title1)
        return lbl
    }()
    
    /// A standard iOS date picker.
    let datePicker = UIDatePicker()
    
    /// A contianer view for the buttons.
    let containerView = UIView()
    
    /// The "Enter" button.
    /// - note: This button is from the [`SwiftyButton`](https://github.com/TakeScoop/SwiftyButton) library.
    let enterButton: FlatButton = {
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
    
    /// The "Cancel" button.
    /// - note: This button is from the [`SwiftyButton`](https://github.com/TakeScoop/SwiftyButton) library.
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
    
    /// The date selected  by the user.
    var selectedDate: Date?
    
    /// Delegate that will take the response from the user if they tap "Enter".
    var delegate: DatePickerViewControllerDelegate?
    
    
    override func viewDidLoad() {
        os_log("View did load.", log: Log.datePickerVC, type: .info)
        
        super.viewDidLoad()
        
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        // set up the picker and buttons
        setupView()
    }

    
    /// Organize the view. This need only be called once and is automatically called when the view has been loaded.
    func setupView() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        datePicker.maximumDate = Date()
        
        view.addSubview(titleLabel)
        view.addSubview(datePicker)
        view.addSubview(containerView)
        containerView.addSubview(enterButton)
        containerView.addSubview(cancelButton)
        
        titleLabel.snp.makeConstraints({ make in
            make.top.equalTo(view)
            make.bottom.equalTo(datePicker.snp.top)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        })
        datePicker.snp.makeConstraints({ make in
            make.center.equalTo(view)
        })
        containerView.snp.makeConstraints({ make in
            make.top.equalTo(datePicker.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(300)
            make.bottom.equalTo(view)
        })
        enterButton.snp.makeConstraints({ make in
            make.centerY.equalTo(containerView)
            make.leading.equalTo(containerView)
            make.height.equalTo(50)
        })
        cancelButton.snp.makeConstraints({ make in
            make.centerY.equalTo(containerView)
            make.width.equalTo(enterButton)
            make.leading.equalTo(enterButton.snp.trailing).offset(10)
            make.trailing.equalTo(containerView)
            make.height.equalTo(enterButton)
        })
        
        enterButton.addTarget(self, action: #selector(tapEnter), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        
    }
    
    
    /// Is called when the user taps the "Enter" button. It sends the selected date to the delegate and then dismisses the view controller.
    @objc private func tapEnter() {
        os_log("The 'Enter' button was tapped.", log: Log.datePickerVC, type: .info)
        if let delegate = delegate { delegate.dateSubmitted(selectedDate ?? datePicker.date) }
        dismiss(animated: true, completion: nil)
    }
    
    
    /// Is called when the user taps the "Cancel" button. It dismisses the view controller.
    @objc private func tapCancel() {
        os_log("The 'Cancer' button was tapped.", log: Log.datePickerVC, type: .info)
        dismiss(animated: true, completion: nil)
    }
    
    
    /// Is  called when the date picker changes value. It updates the `selectedDate` attribute.
    @objc private func datePickerChanged(picker: UIDatePicker) {
        os_log("The date picker's value changed.", log: Log.datePickerVC, type: .info)
        selectedDate = picker.date
    }

}
