//
//  DatePickerViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/22/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit


protocol DatePickerViewControllerDelegate {
    func dateSubmitted(_ date: Date)
}


class DatePickerViewController: UIViewController {

    let label = UILabel()
    let datePicker = UIDatePicker()
    let containerView = UIView()
    let enterButton = UIButton(type: .roundedRect)
    let cancelButton = UIButton(type: .roundedRect)
    
    
    var selectedDate: Date?
    
    var delegate: DatePickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        modalPresentationStyle = .pageSheet
        view.backgroundColor = .white
        
        // set up the picker and buttons
        setupView()
    }

    
    func setupView() {
        datePicker.datePickerMode = .date
        if let date = selectedDate {
            datePicker.setDate(date, animated: false)
        } else {
            datePicker.setDate(Date(), animated: false)
        }
        
        view.addSubview(label)
        view.addSubview(datePicker)
        view.addSubview(containerView)
        containerView.addSubview(enterButton)
        containerView.addSubview(cancelButton)
        
        label.snp.makeConstraints({ make in
            make.top.equalTo(view)
            make.bottom.equalTo(datePicker.snp.top)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        })
        datePicker.snp.makeConstraints({ make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        })
        containerView.snp.makeConstraints({ make in
            make.top.equalTo(datePicker.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(300)
            make.height.equalTo(50)
        })
        enterButton.snp.makeConstraints({ make in
            make.top.equalTo(containerView)
            make.bottom.equalTo(containerView)
            make.leading.equalTo(containerView)
        })
        cancelButton.snp.makeConstraints({ make in
            make.top.equalTo(containerView)
            make.bottom.equalTo(containerView)
            make.width.equalTo(enterButton)
            make.leading.equalTo(enterButton.snp.trailing).offset(10)
            make.trailing.equalTo(containerView)
        })
        
        label.text = "The date of sowing."
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        
        enterButton.setTitle("Enter", for: .normal)
        enterButton.addTarget(self, action: #selector(tapEnter), for: .touchUpInside)
        
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        
    }
    
    
    @objc private func tapEnter() {
        if let delegate = delegate { delegate.dateSubmitted(datePicker.date) }
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc private func tapCancel() {
        dismiss(animated: true, completion: nil)
    }

}
