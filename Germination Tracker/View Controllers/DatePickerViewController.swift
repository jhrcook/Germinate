//
//  DatePickerViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/22/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit
import ChameleonFramework
import SwiftyButton


protocol DatePickerViewControllerDelegate {
    func dateSubmitted(_ date: Date)
}


class DatePickerViewController: UIViewController {

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
    
    let datePicker = UIDatePicker()
    let containerView = UIView()
    
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
    
    
    var selectedDate: Date?
    
    var delegate: DatePickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        // set up the picker and buttons
        setupView()
    }

    
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
    
    
    @objc private func tapEnter() {
        if let delegate = delegate { delegate.dateSubmitted(selectedDate ?? datePicker.date) }
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc private func tapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        selectedDate = picker.date
    }

}
