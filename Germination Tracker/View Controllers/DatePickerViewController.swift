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

    let label = UILabel()
    let datePicker = UIDatePicker()
    let containerView = UIView()
    
    let enterButton: FlatButton = {
        let button = FlatButton()
        button.color = FlatGreen()
        button.highlightedColor = FlatGreenDark()
        button.cornerRadius = 8
        button.titleLabel?.text = "Save"
        button.setTitle("Save", for: [.normal])
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = FlatButton()
        button.color = FlatRed()
        button.highlightedColor = FlatRedDark()
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
        view.backgroundColor = .white
        
        // set up the picker and buttons
        setupView()
    }

    
    func setupView() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
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




public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
