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
    
    var titleTextView: UITextView = {
        var textView = UITextView()
        textView.textAlignment = .left
        return textView
    }()
    
    var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        return dp
    }()
    
    var detailTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        return textView
    }()
    
    
    func configureEditView(withNote note: SeedNote?) {
        
        titleTextView.text = note?.title ?? "Title"
        datePicker.setDate(note?.dateCreated ?? Date(), animated: false)
        detailTextView.text = note?.detail ?? "Detail"
        
        titleTextView.font = UIFont.preferredFont(forTextStyle: .body)
        detailTextView.font = UIFont.preferredFont(forTextStyle: .body)
        
        addSubview(titleTextView)
        addSubview(datePicker)
        addSubview(detailTextView)
        
        titleTextView.backgroundColor = .red
        datePicker.backgroundColor = .green
        detailTextView.backgroundColor = .blue
        
        titleTextView.snp.makeConstraints({ make in
            make.top.equalTo(self.safeAreaLayoutGuide).priorityHigh()
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(60).priorityMedium()
        })
        datePicker.snp.makeConstraints({ make in
            make.top.equalTo(titleTextView.snp.bottom).offset(20)
            make.centerX.equalTo(self)
        })
        detailTextView.snp.makeConstraints({ make in
            make.top.equalTo(datePicker.snp.bottom).offset(20)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        })
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
